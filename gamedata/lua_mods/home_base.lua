local Factor = Factor or 4
local myFactor=Factor/4
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things


utils_op.AddFnToUnitDefsTweakFns({
    k = "home_base_set",
    b = { "pre_set_values" },
    a = { "default_modify_cost_begin", "default_modify_value_begin" },
    v = function()
        local modifyfn =
            utils.table_replace(utils.lowerkeys({
                customParams = {
                    pylonrange = 2000,
                    area_cloak = 1,
                    area_cloak_upkeep = 0,
                    area_cloak_radius = 2000,
                    area_cloak_recloak_rate = 2000,
                },
                radarDistanceJam = 2000,
                metalStorage = 500*myFactor,
                energyStorage = 500*myFactor,
                workerTime = 1000*myFactor,
                sightDistance = 2000,
                energyMake = 10*myFactor,
                metalMake = 10*myFactor,
                health = 100000*myFactor,
                metalCost = 10000*myFactor,
                reclaimable = true, -- to tech up wtf
                corpse = [[]],
                weapons = {
                    {
                        def = [[BIGSHIELD]],
                    },
                },
                weaponDefs = {
                    BIGSHIELD = {
                        name = [[Big Energy Shield]],
                        damage = {
                            default = 10,
                        },
                        customParams = {
                            unlinked = true,
                        },
                        exteriorShield = true,
                        shieldAlpha = 0.01,
                        shieldBadColor = [[0.1 0.01 0.01 0.1]],
                        shieldGoodColor = [[0.01 0.01 0.1 0.1]],
                        shieldInterceptType = 3,
                        shieldPower = 10000*myFactor,
                        shieldPowerRegen = 400*myFactor,
                        shieldPowerRegenEnergy = 0,
                        shieldRadius = 2000,
                        shieldRepulser = false,
                        shieldStartingPower = 0,
                        smartShield = true,
                        visibleShield = false,
                        visibleShieldRepulse = false,
                        weaponType = [[Shield]],
                    },
                },
                featureDefs = {
                    DEAD = {
                        blocking = false,
                        object = [[emptyModel.s3o]],
                    },
                    HEAP = {
                        object = [[emptyModel.s3o]],
                    },
                },
            }));

        for _, udname in pairs(utils_op.units_basic_factories) do
            modifyfn(UnitDefs[udname])
        end
    end
})
