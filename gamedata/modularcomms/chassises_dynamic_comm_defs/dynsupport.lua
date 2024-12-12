
local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local moduleDefNames=shared.moduleDefNames

local function GetSupportCloneModulesString(modulesByDefID)
	return (modulesByDefID[moduleDefNames.support.commweapon_personal_shield] or 0) ..
		(modulesByDefID[moduleDefNames.support.commweapon_areashield] or 0) ..
		(modulesByDefID[moduleDefNames.support.module_resurrect] or 0)
end

return {
    name = "support",
    humanName = "Engineer",
    baseUnitDef = UnitDefNames and UnitDefNames["dynsupport0"].id,
    extraLevelCostFunction = extraLevelCostFunction,
    maxNormalLevel = 5,
    levelDefs = {
        [0] = {
            morphBuildPower = 5,
            morphBaseCost = 0,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport0"].id
            end,
            upgradeSlots = {},
        },
        [1] = {
            morphBuildPower = morphBuildPower[1],
            morphBaseCost = morphCosts[1],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 2
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport1_" .. GetSupportCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.support.commweapon_beamlaser,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [2] = {
            morphBuildPower = morphBuildPower[2],
            morphBaseCost = morphCosts[2] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 4
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport2_" .. GetSupportCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [3] = {
            morphBuildPower = morphBuildPower[3],
            morphBaseCost = morphCosts[3] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 6
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport3_" .. GetSupportCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.support.commweapon_disruptorbomb,
                    slotAllows = "adv_weapon",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [4] = {
            morphBuildPower = morphBuildPower[4],
            morphBaseCost = morphCosts[4],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 9
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport4_" .. GetSupportCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [5] = {
            morphBuildPower = morphBuildPower[5],
            morphBaseCost = morphCosts[5],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 12
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynsupport5_" .. GetSupportCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.support.nullmodule,
                    slotAllows = "module",
                },
            },
        },
    }
}