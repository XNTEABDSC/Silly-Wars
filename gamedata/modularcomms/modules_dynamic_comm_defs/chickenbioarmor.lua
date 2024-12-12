local shared=ModularCommDefsShared
local moduleImagePath=shared.moduleImagePath
local applicationFunctionApplyWeapon=shared.applicationFunctionApplyWeapon
local COST_MULT=shared.COST_MULT
local HP_MULT=shared.HP_MULT
local rep=6*HP_MULT
local hp=400*HP_MULT
return {
    name = "module_chickenbioarmor",
    humanName = "Bio Armor",
    description = "Bio Armor - Give " .. hp .. " hp and " .. rep .. " hp/s repair. Limit: 10",
    image = moduleImagePath .. "module_repair_field.png",
    limit = 10,
    cost = 150 * COST_MULT,
    requireLevel = 1,
    requireChassis = {"chicken"},
    slotType = "module",
    applicationFunction = function (modules, sharedData)
        sharedData.autorepairRate = (sharedData.autorepairRate or 0) + rep
        sharedData.healthBonus = (sharedData.healthBonus or 0) + hp
    end
}