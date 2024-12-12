
local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local moduleDefNames=shared.moduleDefNames


local function GetStrikeCloneModulesString(modulesByDefID)
	return (modulesByDefID[moduleDefNames.strike.commweapon_personal_shield] or 0) ..
		(modulesByDefID[moduleDefNames.strike.commweapon_areashield] or 0)
end

return {
    name = "strike",
    humanName = "Strike",
    baseUnitDef = UnitDefNames and UnitDefNames["dynstrike0"].id,
    extraLevelCostFunction = extraLevelCostFunction,
    maxNormalLevel = 5,
    secondPeashooter = false,
    levelDefs = {
        [0] = {
            morphBuildPower = 5,
            morphBaseCost = 0,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike0"].id
            end,
            upgradeSlots = {},
        },
        [1] = {
            morphBuildPower = morphBuildPower[1],
            morphBaseCost = morphCosts[1],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 8
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike1_" .. GetStrikeCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.strike.commweapon_beamlaser,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
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
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike2_" .. GetStrikeCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
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
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike3_" .. GetStrikeCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.strike.commweapon_beamlaser_adv,
                    slotAllows = {"dual_basic_weapon", "adv_weapon"},
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
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
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike4_" .. GetStrikeCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
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
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynstrike5_" .. GetStrikeCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.strike.nullmodule,
                    slotAllows = "module",
                },
            },
        },
    }
}