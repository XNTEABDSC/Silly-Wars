local shared=ModularCommDefsShared
local moduleImagePath=shared.moduleImagePath
local applicationFunctionApplyWeapon=shared.applicationFunctionApplyWeapon
local COST_MULT=shared.COST_MULT
return {
    name = "commweapon_chickenshield",
    humanName = "Chicken Shield",
    description = "Chicken Shield - A medium, high regen shield.",
    image = moduleImagePath .. "module_personal_shield.png",
    limit = 1,
    cost = 300 * COST_MULT,
    prohibitingModules = {"module_personal_cloak"},
    requireLevel = 2,
    slotType = "module",
    applicationFunction = function (modules, sharedData)
        -- Do not override area shield
        sharedData.shield = sharedData.shield or "commweapon_chickenshield"
    end
}