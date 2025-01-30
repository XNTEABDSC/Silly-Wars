
local data = {
	name = "DESIGN_CUSTOM_UNIT",
	cmdID = 40001,
	
	commandType = CMDTYPE.ICON_UNIT,
	isState = false, -- Hold fire etc
	isInstant = true, -- Such as Stop, Self-D etc
	humanName = "Design Custom Units",
	actionName = "design_custom_unit",
	--cursor = "Techup",
	image = "LuaUI/Images/commands/Bold/repair.png", -- If a state, then this should be a list of images.
	
	onCommandMenuByDefault = true,
	position = {pos = 8, priority = 0.1},
	stateNames = nil, -- A list of what the states are called.
	stateTooltip = nil, -- A list of tooltips to use for each state.
	tooltip = [[Turn on a panel to design custom units]],
}

return data
