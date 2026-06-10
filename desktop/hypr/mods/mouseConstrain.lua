local function toggle_monitor_lock()
	local function set_monitor(pos)
		local cmd = string.format(
			'hyprctl eval \'hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "%s", scale = 2 })\'',
			pos
		)
		os.execute(cmd)
	end

	local home = os.getenv("HOME")
	local state = home .. "/.local/state/togglemonitorlock"

	os.execute("mkdir -p " .. home .. "/.local/state")

	local booleanvalue = "false"
	local f = io.open(state, "r")
	if f then
		booleanvalue = f:read("*l")
		f:close()
	end

	if booleanvalue == "true" then
		set_monitor("-1920x-950")
		booleanvalue = "false"
	else
		set_monitor("50000x50000")
		booleanvalue = "true"
	end

	local out = io.open(state, "w")
	if out then
		out:write(booleanvalue)
		out:close()
	end
end

return toggle_monitor_lock
