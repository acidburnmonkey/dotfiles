#!/usr/bin/env bash
# Outputs { "networking": "enabled"|"disabled", "interfaces": [...] }

prefix_to_mask() {
    local p=$1
    local parts=()
    for (( i=0; i<4; i++ )); do
        local bits=$(( p > 8 ? 8 : p < 0 ? 0 : p ))
        parts+=("$(( bits == 0 ? 0 : 256 - (1 << (8 - bits)) ))")
        (( p -= 8 ))
    done
    echo "${parts[0]}.${parts[1]}.${parts[2]}.${parts[3]}"
}

broadcast_addr() {
    local ip=$1 prefix=$2
    IFS='.' read -r a b c d <<< "$ip"
    local mask=$(( 0xFFFFFFFF << (32 - prefix) & 0xFFFFFFFF ))
    local ipi=$(( (a<<24)|(b<<16)|(c<<8)|d ))
    local bc=$(( ipi | (~mask & 0xFFFFFFFF) ))
    echo "$(( (bc>>24)&0xFF )).$(( (bc>>16)&0xFF )).$(( (bc>>8)&0xFF )).$(( bc&0xFF ))"
}

json_str() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

interfaces=()

while IFS= read -r device; do
    [[ -z "$device" ]] && continue

    show=$(nmcli -t device show "$device" 2>/dev/null)

    profile=$(echo "$show" | grep "^GENERAL.CONNECTION:"  | cut -d: -f2-)
    mac=$(echo "$show"     | grep "^GENERAL.HWADDR:"      | cut -d: -f2-)
    driver=$(echo "$show"  | grep "^GENERAL.DRIVER:"      | cut -d: -f2-)
    ip_cidr=$(echo "$show" | grep "^IP4.ADDRESS\[1\]:"    | cut -d: -f2-)
    gateway=$(echo "$show" | grep "^IP4.GATEWAY:"         | cut -d: -f2-)
    dns1=$(echo "$show"    | grep "^IP4.DNS\[1\]:"        | cut -d: -f2-)
    ipv6_cidr=$(echo "$show" | grep "^IP6.ADDRESS\[1\]:"  | cut -d: -f2-)
    ipv6_gw=$(echo "$show"   | grep "^IP6.GATEWAY:"       | cut -d: -f2-)
    ipv6_dns=$(echo "$show"  | grep "^IP6.DNS\[1\]:"      | cut -d: -f2-)
    speed=$(cat /sys/class/net/"$device"/speed 2>/dev/null)

    [[ -z "$profile" || "$profile" == "--" ]] && profile="$device"
    [[ -z "$speed"   || "$speed"   == "-1" ]] && speed=""

    speed_label=""
    if [[ -n "$speed" ]]; then
        if (( speed >= 1000 )); then speed_label="$(( speed / 1000 )) Gbps"
        else speed_label="${speed} Mbps"; fi
    fi

    ip_clean="" subnet="" broadcast=""
    if [[ -n "$ip_cidr" ]]; then
        ip_clean="${ip_cidr%%/*}"
        prefix="${ip_cidr##*/}"
        subnet=$(prefix_to_mask "$prefix")
        broadcast=$(broadcast_addr "$ip_clean" "$prefix")
    fi

    is_connected=false
    [[ -n "$ip_clean" ]] && is_connected=true

    if $is_connected; then
        subtitle="Connected${speed_label:+ • $speed_label}"
        cmd_str="nmcli device disconnect $device"
        is_actionable=true
    else
        subtitle="Disconnected"
        cmd_str="nmcli device connect $device"
        is_actionable=true
    fi

    obj="{\"id\":\"$(json_str "$device")\",\"name\":\"$(json_str "$profile")\",\"icon\":\"󰈀\""
    obj+=",\"ip\":\"$(json_str "$ip_clean")\",\"subnet\":\"$(json_str "$subnet")\""
    obj+=",\"broadcast\":\"$(json_str "$broadcast")\",\"gateway\":\"$(json_str "$gateway")\",\"dns\":\"$(json_str "$dns1")\""
    obj+=",\"ipv6\":\"$(json_str "$ipv6_cidr")\",\"ipv6gw\":\"$(json_str "$ipv6_gw")\",\"ipv6dns\":\"$(json_str "$ipv6_dns")\""
    obj+=",\"mac\":\"$(json_str "$mac")\",\"driver\":\"$(json_str "$driver")\",\"speed\":\"$(json_str "$speed_label")\""
    obj+=",\"action\":\"$(json_str "$subtitle")\",\"isConnected\":$is_connected"
    obj+=",\"isInfoNode\":false,\"isActionable\":$is_actionable,\"cmdStr\":\"$(json_str "$cmd_str")\"}"
    interfaces+=("$obj")
done < <(nmcli -t -f DEVICE,TYPE device status 2>/dev/null | awk -F: '$2=="ethernet"{print $1}')

net_state=$(nmcli networking 2>/dev/null | tr -d '[:space:]')
[[ "$net_state" != "enabled" ]] && net_state="disabled"

joined=$(IFS=,; echo "${interfaces[*]}")
echo "{\"networking\":\"$net_state\",\"interfaces\":[$joined]}"
