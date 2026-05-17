-----------------
-- WORKSPACES    --
-----------------

local mainMod = "SUPER"

-- Workspace monitor assignments
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
hl.workspace_rule({ workspace = "8", monitor = "DP-1" })
hl.workspace_rule({ workspace = "9", monitor = "DP-1" })
hl.workspace_rule({ workspace = "10", monitor = "DP-1" })

-- Switch & move workspaces with mainMod + [1-9, 0]
local workspaceKeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

for i, key in ipairs(workspaceKeys) do
	local ws = i < 10 and i or 10 -- 0 maps to workspace 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end
