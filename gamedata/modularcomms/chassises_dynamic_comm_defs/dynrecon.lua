
local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local moduleDefNames=shared.moduleDefNames

local function GetReconCloneModulesString(modulesByDefID)
	return (modulesByDefID[moduleDefNames.recon.commweapon_personal_shield] or 0)
end

return {
    name = "recon",
    humanName = "Recon",
    baseUnitDef = UnitDefNames and UnitDefNames["dynrecon0"].id,
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
                return UnitDefNames["dynrecon0"].id
            end,
            upgradeSlots = {},
        },
        [1] = {
            morphBuildPower = morphBuildPower[1],
            morphBaseCost = morphCosts[1],
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynrecon1_" .. GetReconCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.recon.commweapon_beamlaser,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [2] = {
            morphBuildPower = morphBuildPower[2],
            morphBaseCost = morphCosts[2] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynrecon2_" .. GetReconCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [3] = {
            morphBuildPower = morphBuildPower[3],
            morphBaseCost = morphCosts[3] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynrecon3_" .. GetReconCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.recon.commweapon_disruptorbomb,
                    slotAllows = "adv_weapon",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [4] = {
            morphBuildPower = morphBuildPower[4],
            morphBaseCost = morphCosts[4] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynrecon4_" .. GetReconCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
            },
        },
        [5] = {
            morphBuildPower = morphBuildPower[5],
            morphBaseCost = morphCosts[5] * COST_MULT,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                return UnitDefNames["dynrecon5_" .. GetReconCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.recon.nullmodule,
                    slotAllows = "module",
                },
            },
        },
    }
}