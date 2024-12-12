
local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local moduleDefNames=shared.moduleDefNames

local function GetAssaultCloneModulesString(modulesByDefID)
	return (modulesByDefID[moduleDefNames.assault.commweapon_personal_shield] or 0) ..
		(modulesByDefID[moduleDefNames.assault.commweapon_areashield] or 0)
end

return {
    name = "assault",
    humanName = "Guardian",
    baseUnitDef = UnitDefNames and UnitDefNames["dynassault0"].id,
    extraLevelCostFunction = extraLevelCostFunction,
    maxNormalLevel = 5,
    secondPeashooter = false,
    levelDefs = {
        [0] = {
            morphBuildPower = 5,
            morphBaseCost = 0,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 1
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault0"].id
            end,
            upgradeSlots = {},
        },
        [1] = {
            morphBuildPower = morphBuildPower[1],
            morphBaseCost = morphCosts[1],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 1
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault1_" .. GetAssaultCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.assault.commweapon_beamlaser,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.assault.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [2] = {
            morphBuildPower = morphBuildPower[2],
            morphBaseCost = morphCosts[2] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 2
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault2_" .. GetAssaultCloneModulesString(modulesByDefID)].id
            end,
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
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 2
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault3_" .. GetAssaultCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.assault.commweapon_beamlaser_adv,
                    slotAllows = {"dual_basic_weapon", "adv_weapon"},
                },
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
        [4] = {
            morphBuildPower = morphBuildPower[4],
            morphBaseCost = morphCosts[4] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 2
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault4_" .. GetAssaultCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.assault.nullmodule,
                    slotAllows = "module",
                },
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
        [5] = {
            morphBuildPower = morphBuildPower[5],
            morphBaseCost = morphCosts[5] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
                sharedData.drones = (sharedData.drones or 0) + 3
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynassault5_" .. GetAssaultCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.assault.nullmodule,
                    slotAllows = "module",
                },
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
    }
}