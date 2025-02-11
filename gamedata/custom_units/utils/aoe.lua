local utils=GameData.CustomUnits.utils
utils.plasma_aoe_mutate={
    --[=[
    ---@param wpn CustomWeaponDataModify
    plasma_aoe_36=function (wpn)
        wpn.cost=wpn.cost*1.1
        wpn.mass=wpn.mass*1.1
        wpn.aoe=36
        wpn.edgeEffectiveness       = 0.5
        wpn.explosionGenerator=[[custom:MARY_SUE]]
    end,]=]
    --[=[
    ---@param wpn CustomWeaponDataModify
    plasma_aoe_84=function (wpn)
        wpn.cost=wpn.cost*1.4
        wpn.mass=wpn.mass*1.4
        wpn.aoe=84
        wpn.edgeEffectiveness       = 0.5
        wpn.explosionGenerator=[[custom:DOT_Pillager_Explo]]
    end,
    ---@param wpn CustomWeaponDataModify
    plasma_aoe_144=function (wpn)
        wpn.cost=wpn.cost*1.7
        wpn.mass=wpn.mass*1.7
        wpn.aoe=144
        wpn.edgeEffectiveness       = 0.75
        wpn.explosionGenerator      = [[custom:FLASH64]]
    end,
    ---@param wpn CustomWeaponDataModify
    plasma_aoe_176=function (wpn)
        wpn.cost=wpn.cost*2.2
        wpn.mass=wpn.mass*2.2
        wpn.aoe=176
        wpn.explosionGenerator      = [[custom:lrpc_expl]]
    end]=]

    
}
GameData.CustomUnits.utils=utils