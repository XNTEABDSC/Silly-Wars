
local data = {
	name = "CHOOSE_BUILD_CUSTOM_UNIT",
	cmdID = 40002,
	
	commandType = CMDTYPE.ICON_UNIT,
	isState = false, -- Hold fire etc
	isInstant = true, -- Such as Stop, Self-D etc
	humanName = "Choose and build custom unit",
	actionName = "choose_build_custom_unit",
	--cursor = "Techup",
	image = "LuaUI/Images/commands/Bold/upgrade.png", -- If a state, then this should be a list of images.
	
	onCommandMenuByDefault = true,
	position = {pos = 7, priority = 0.1},
	stateNames = nil, -- A list of what the states are called.
	stateTooltip = nil, -- A list of tooltips to use for each state.
	tooltip = [[Choose and build custom unit]],
}

return data
