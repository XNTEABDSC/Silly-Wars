---{CustomUnitDefId, x, y, z, facing, targetID|nil}
local data = {
	name = "BUILD_CUSTOM_UNIT",
	cmdID = 40001,
	
	commandType = CMDTYPE.CUSTOM,
	isState = false, -- Hold fire etc
	isInstant = true, -- Such as Stop, Self-D etc
	humanName = "Build Custom Unit",
	actionName = "build_custom_unit",
	--cursor = "Techup",
	image = "LuaUI/Images/commands/Bold/upgrade.png", -- If a state, then this should be a list of images.
	
	onCommandMenuByDefault = false,
	--position = {pos = 9, priority = 0.1},
	stateNames = nil, -- A list of what the states are called.
	stateTooltip = nil, -- A list of tooltips to use for each state.
	tooltip = [[Build Custom Unit]],
}

return data
