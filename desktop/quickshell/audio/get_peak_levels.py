#!/usr/bin/env python3
"""
Monitors each sink-input (app) and source individually via pacat.
Derives sink peak = max of all apps routed to that sink.
Emits JSON lines at ~20fps. Dies with parent via PR_SET_PDEATHSIG.
"""
import subprocess, struct, json, threading, sys, math, time, signal, ctypes

try:
    ctypes.CDLL("libc.so.6").prctl(1, signal.SIGTERM)  # PR_SET_PDEATHSIG
except Exception:
    pass

RATE        = 44100
CHANNELS    = 2
CHUNK_MS    = 50
BYTES_PS    = 2
chunk_bytes = int(RATE * CHUNK_MS / 1000) * CHANNELS * BYTES_PS

levels      = {}   # key -> float 0..1
running     = {}   # key -> True
procs       = {}   # key -> Popen
app_sinks   = {}   # app_N -> sink index
lock        = threading.Lock()


def cleanup(*_):
    with lock:
        for p in procs.values():
            try: p.terminate()
            except: pass
    sys.exit(0)

signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT,  cleanup)


def db_scale(peak):
    if peak < 0.0001:
        return 0.0
    return max(0.0, min(1.0, (20.0 * math.log10(peak) + 60.0) / 60.0))


def monitor(key, cmd):
    with lock:
        running[key] = True
    try:
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        with lock:
            procs[key] = proc
        while True:
            data = proc.stdout.read(chunk_bytes)
            if not data:
                break
            with lock:
                if key not in running:
                    break
            n = len(data) // BYTES_PS
            s = struct.unpack_from(f'<{n}h', data)
            peak = max(abs(x) for x in s) / 32768.0
            with lock:
                levels[key] = db_scale(peak)
        proc.terminate()
        proc.wait()
    except Exception:
        pass
    with lock:
        running.pop(key, None)
        levels.pop(key, None)
        procs.pop(key, None)


def spawn(key, cmd):
    threading.Thread(target=monitor, args=(key, cmd), daemon=True).start()


def pactl_json(obj):
    try:
        return json.loads(subprocess.check_output(
            ['pactl', '-f', 'json', 'list', obj], stderr=subprocess.DEVNULL).decode())
    except Exception:
        return []


def scan_devices():
    sources = pactl_json('sources')
    apps    = pactl_json('sink-inputs')
    sinks   = pactl_json('sinks')
    wanted  = set()

    # Sources (microphones etc, not monitors)
    for s in sources:
        if '.monitor' in s['name']:
            continue
        key = f"source_{s['index']}"
        wanted.add(key)
        with lock:
            if key not in running:
                spawn(key, ['pacat', '-r', '-d', s['name'],
                            '--channels=2', '--format=s16le', f'--rate={RATE}'])

    # Apps — one pacat per sink-input
    for a in apps:
        key = f"app_{a['index']}"
        wanted.add(key)
        with lock:
            app_sinks[key] = a['sink']
            if key not in running:
                spawn(key, ['pacat', '-r', f'--monitor-stream={a["index"]}',
                            '--channels=2', '--format=s16le', f'--rate={RATE}'])

    # Remove stale entries
    with lock:
        for key in list(running.keys()):
            if key not in wanted:
                p = procs.get(key)
                if p:
                    try: p.terminate()
                    except: pass
                del running[key]
        for key in list(app_sinks.keys()):
            if key not in wanted:
                del app_sinks[key]

    # Ensure every sink has an entry (even if no apps)
    with lock:
        for s in sinks:
            sink_key = f"sink_{s['index']}"
            if sink_key not in levels:
                levels[sink_key] = 0.0


def emit_loop():
    while True:
        with lock:
            snapshot = dict(levels)
            # Derive sink peaks from connected app peaks
            sink_peaks = {}
            for app_key, sink_idx in app_sinks.items():
                sk = f"sink_{sink_idx}"
                v  = snapshot.get(app_key, 0.0)
                if v > sink_peaks.get(sk, 0.0):
                    sink_peaks[sk] = v
            snapshot.update(sink_peaks)
        sys.stdout.write(json.dumps(snapshot) + '\n')
        sys.stdout.flush()
        time.sleep(0.05)


def rescan_loop():
    while True:
        scan_devices()
        time.sleep(2)


threading.Thread(target=rescan_loop, daemon=True).start()
threading.Thread(target=emit_loop,   daemon=True).start()

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    cleanup()
