local utils=Spring.Utilities.CustomUnits.utils
utils.BasicChassisMutate={
    ---@param table CustomChassisDataModify
    ---@param factor number
    armor=function (table,factor)
        table.health=table.health+factor*30
        table.cost=table.cost+factor
        return table
    end,
    add_weapon=function (table,weapon)
        
    end
}
Spring.Utilities.CustomUnits.utils=utils
