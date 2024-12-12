local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local mymorphUnitDefFunction=morphUnitDefFunction("dynchicken",GetCloneModuleString("chicken",{
    "commweapon_chickenshield"
}))
local moduleDefNames=shared.moduleDefNames

return {
    name = "chicken",
    humanName = "Potential Chicken",
    baseUnitDef = UnitDefNames and UnitDefNames["dynchicken0"].id,
    extraLevelCostFunction = extraLevelCostFunction,
    maxNormalLevel = 5,
    secondPeashooter = true,
    levelDefs = {
        [0] = {
            morphBuildPower = 5,
            morphBaseCost = 0,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(1),
            upgradeSlots = {},
        },
        [1] = {
            morphBuildPower = morphBuildPower[1],
            morphBaseCost = morphCosts[1],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 8
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(1),
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.chicken.commweapon_chickenspores,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [2] = {
            morphBuildPower = morphBuildPower[2],
            morphBaseCost = morphCosts[2] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 12
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(2),
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.assault.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.assault.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [3] = {
            morphBuildPower = morphBuildPower[3],
            morphBaseCost = morphCosts[3] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 16
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(3),
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.chicken.commweapon_beamlaser_adv,
                    slotAllows = {"dual_basic_weapon", "adv_weapon"},
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [4] = {
            morphBuildPower = morphBuildPower[4],
            morphBaseCost = morphCosts[4] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 20
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(4),
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [5] = {
            morphBuildPower = morphBuildPower[5],
            morphBaseCost = morphCosts[5] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 25
            end,
            morphUnitDefFunction = mymorphUnitDefFunction(5),
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.chicken.nullmodule,
                    slotAllows = "module",
                },
            },
        },
    }
}