local shared=ModularCommDefsShared
local moduleImagePath=shared.moduleImagePath
local applicationFunctionApplyWeapon=shared.applicationFunctionApplyWeapon

return {
    name = "commweapon_chickenspores",
    humanName = "Chicken Spore",
    description = "Chicken Spore",
    image = moduleImagePath .. "commweapon_flamethrower.png",
    limit = 2,
    cost = 0,
    requireChassis = {"chicken"},
    requireLevel = 1,
    slotType = "basic_weapon",
    applicationFunction = applicationFunctionApplyWeapon(function ()
        return "commweapon_chickenspores"
    end),
    isBasicWeapon=true,
}