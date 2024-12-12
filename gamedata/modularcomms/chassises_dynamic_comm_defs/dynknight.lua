
local shared=ModularCommDefsShared
local extraLevelCostFunction=shared.extraLevelCostFunction
local morphBuildPower=shared.morphBuildPower
local morphCosts=shared.morphCosts
local COST_MULT=shared.COST_MULT
local GetCloneModuleString=shared.GetCloneModuleString
local morphUnitDefFunction=shared.morphUnitDefFunction
local moduleDefNames=shared.moduleDefNames


local function GetKnightCloneModulesString(modulesByDefID)
	return (modulesByDefID[moduleDefNames.knight.commweapon_personal_shield] or 0) ..
		(modulesByDefID[moduleDefNames.knight.commweapon_areashield] or 0) ..
		(modulesByDefID[moduleDefNames.knight.module_resurrect] or 0) ..
		(modulesByDefID[moduleDefNames.knight.module_jumpjet] or 0)
end

return {
    name = "knight",
    humanName = "Knight",
    baseUnitDef = UnitDefNames and UnitDefNames["dynknight0"].id,
    extraLevelCostFunction = extraLevelCostFunction,
    maxNormalLevel = 5,
    --notSelectable = (Spring.GetModOptions().campaign_chassis ~= "1"),
    secondPeashooter = true,
    levelDefs = {
        [0] = {
            morphBuildPower = 5,
            morphBaseCost = 0,
            chassisApplicationFunction = function (modules, sharedData)
                sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 5
            end,
            morphUnitDefFunction = function(modulesByDefID)
                -- Level 1 is the same as level 0 in stats and has support for clone modules (such as shield).
                return UnitDefNames["dynknight1_" .. GetKnightCloneModulesString(modulesByDefID)].id
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
                return UnitDefNames["dynknight1_" .. GetKnightCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.knight.commweapon_beamlaser,
                    slotAllows = "basic_weapon",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
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
                return UnitDefNames["dynknight2_" .. GetKnightCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
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
                return UnitDefNames["dynknight3_" .. GetKnightCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.knight.commweapon_beamlaser_adv,
                    slotAllows = {"dual_basic_weapon", "adv_weapon"},
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
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
                return UnitDefNames["dynknight4_" .. GetKnightCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
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
                return UnitDefNames["dynknight5_" .. GetKnightCloneModulesString(modulesByDefID)].id
            end,
            upgradeSlots = {
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
                {
                    defaultModule = moduleDefNames.knight.nullmodule,
                    slotAllows = "module",
                },
            },
        },
    }
}