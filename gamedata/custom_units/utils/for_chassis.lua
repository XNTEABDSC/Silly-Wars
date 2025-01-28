local utils=GameData.CustomUnits.utils

utils.BasicChassisMutate={
    ---@param cud CustomUnitDataModify
    ---@param factor number
    armor=function (cud,factor)
        cud.health=cud.health+factor*30
        cud.cost=cud.cost+factor
        return cud
    end,
    
    ---@param cud CustomUnitDataModify
    add_weapon=function (cud,t)
        local weapon_num,weapon=t.weapon_num,t.weapon
        cud.weapons[weapon_num]=GameData.CustomUnits.weapons_defs[weapon[1]].genfn(weapon[2])
    end
}
GameData.CustomUnits.utils=utils
