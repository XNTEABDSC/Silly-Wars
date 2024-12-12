local shared=ModularCommDefsShared
local moduleImagePath=shared.moduleImagePath
local applicationFunctionApplyWeapon=shared.applicationFunctionApplyWeapon
local COST_MULT=shared.COST_MULT
local HP_MULT=shared.HP_MULT
local rep=10*HP_MULT
local hp=1700*HP_MULT
local speed=0.05
return {
    name = "module_chickenbioarmorheavy",
    humanName = "Heavy Bio Armor",
    description = "Heavy Bio Armor - Give +" .. hp .. " hp and +" .. rep .. " hp/s repair and -" .. speed*100 .. "% speed Limit: 5",
    image = moduleImagePath .. "module_repair_field.png",
    limit = 5,
    cost = 150 * COST_MULT,
    requireLevel = 1,
    requireChassis = {"chicken"},
    slotType = "module",
    applicationFunction = function (modules, sharedData)
        sharedData.autorepairRate = (sharedData.autorepairRate or 0) + rep
        sharedData.healthBonus = (sharedData.healthBonus or 0) + hp
        sharedData.speedMultPost = (sharedData.speedMultPost or 1) - speed
    end
}