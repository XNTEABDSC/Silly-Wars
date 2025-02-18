return function (i)
    
    local row = 1
    local col = i
    local order = i
    while col>7 do
        col=col-6
        row=row+1
    end
    return {
        name = "CHOOSE_CUSTOM_UNIT_" .. i,
        cmdID = 40100+i,
        
        commandType = CMDTYPE.ICON,
        isState = false, -- Hold fire etc
        isInstant = true, -- Such as Stop, Self-D etc
        humanName = "Choose custom unit slot " .. i,
        actionName = "choose_custom_unit_" .. i,
        --cursor = "Techup",
        image = "LuaUI/Images/dynamic_comm_menu/cross.png", -- If a state, then this should be a list of images.
        
        onCommandMenuByDefault = true,
        position = {row=row,col=col,order=order,priority=0.1},
        at_integral_menu_tab="SPECIAL",
        stateNames = nil, -- A list of what the states are called.
        stateTooltip = nil, -- A list of tooltips to use for each state.
        tooltip = "Choose custom unit slot " .. i,
    }
    
end