-- from SmokeDragon
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

return {
    greed = {
        fn = function(param)
            param = param or {}
            local GreedFactor = param.GreedFactor or 4

            utils.AddFnToUnitDefsTweakFns({
                k = "greed_no_wreck",
                v = function()
                    for name, ud in pairs(UnitDefs) do
                        if ud.metalcost and ud.metalcost < 1000 then
                            if ud.corpse then
                                ud.corpse = nil
                            end
                            if ud.featuredefs then
                                ud.featuredefs = nil
                            end
                        end
                    end
                end,
                b = { "default_modify_cost_end" },
                a = { "post_set_values" }
            })
            utils.AddFnToUnitDefsTweakFns({
                k = "greed_super_mult",
                v = function()
                    local super_list = {
                        "zenith",
                        "raveparty",
                        "mahlazer",
                    }
                    for key, value in pairs(super_list) do
                        UnitDefs[value].metalcost = UnitDefs[value].metalcost * GreedFactor
                    end
                end,
                b = { "default_modify_cost_begin" },
                a = { "default_modify_cost_end" },
            })



            utils.AddFnToUnitDefsTweakFns({
                k = "greed_tech",
                a = { "default_add_build_begin" },
                v = function()
                    local commBuilds = {
                        [[staticmex]],
                        [[energywind]],
                        [[staticstorage]],
                        [[energypylon]],
                        [[staticcon]],
                        [[staticrearm]],
                        [[turretlaser]],
                        [[turretmissile]],
                        [[turretriot]],
                        [[turretemp]],
                        [[turretheavylaser]],
                        [[turretaaclose]],
                        [[turretaalaser]],
                        [[turretimpulse]],
                        [[turrettorp]],
                        [[staticshield]],
                        [[staticradar]],
                        [[staticjammer]],
                        [[factorycloak]],
                        [[factoryshield]],
                        [[factoryveh]],
                        [[factoryhover]],
                        [[factorygunship]],
                        [[factoryplane]],
                        [[factoryspider]],
                        [[factoryjump]],
                        [[factorytank]],
                        [[factoryamph]],
                        [[factoryship]],
                    }
                    local t1Builds = {
                        [[staticmex]],
                        [[energywind]],
                        [[staticstorage]],
                        [[energypylon]],
                        [[staticcon]],
                        [[staticrearm]],
                        [[turretlaser]],
                        [[turretmissile]],
                        [[turretriot]],
                        [[turretemp]],
                        [[turretheavylaser]],
                        [[turretaaclose]],
                        [[turretaalaser]],
                        [[turretimpulse]],
                        [[turrettorp]],
                        [[staticshield]],
                        [[staticradar]],
                        [[staticjammer]],
                        [[factorycloak]],
                        [[factoryshield]],
                        [[factoryveh]],
                        [[factoryhover]],
                        [[factorygunship]],
                        [[factoryplane]],
                        [[factoryspider]],
                        [[factoryjump]],
                        [[factorytank]],
                        [[factoryamph]],
                        [[factoryship]],
                        [[athena]],
                    }
                    local t2Builds = {
                        [[staticnuke]],
                        [[striderfunnelweb]],
                        [[staticantinuke]],
                        [[cloakcon]],
                        [[cloakheavyraid]],
                        [[cloakaa]],
                        [[cloaksnipe]],
                        [[cloakbomb]],
                        [[cloakjammer]],
                        [[shieldbomb]],
                        [[jumpbomb]],
                        [[amphtele]],
                        [[athena]],
                        [[striderantiheavy]],
                        [[gunshipbomb]],
                        [[spiderantiheavy]],
                        [[striderscorpion]],
                        [[striderdante]],
                        [[energysolar]],
                        [[staticstorage]],
                        [[staticmex]],
                        [[energypylon]],
                        [[staticcon]],
                        [[staticrearm]],
                        [[turretlaser]],
                        [[turretmissile]],
                        [[turretriot]],
                        [[turretemp]],
                        [[turretgauss]],
                        [[turretheavylaser]],
                        [[turretaaclose]],
                        [[turretaalaser]],
                        [[turretaaflak]],
                        [[turretimpulse]],
                        [[turrettorp]],
                        [[staticshield]],
                        [[staticradar]],
                        [[staticjammer]],
                        [[factorycloak]],
                        [[factoryshield]],
                        [[factoryveh]],
                        [[factoryhover]],
                        [[factorygunship]],
                        [[factoryplane]],
                        [[factoryspider]],
                        [[factoryjump]],
                        [[factorytank]],
                        [[factoryamph]],
                        [[factoryship]],
                    }
                    local t3Builds = {
                        [[staticnuke]],
                        [[staticarty]],
                        [[striderarty]],
                        [[turretheavy]],
                        [[striderbantha]],
                        [[striderfunnelweb]],
                        [[staticmex]],
                        [[energywind]],
                        [[energysolar]],
                        [[energygeo]],
                        [[energyfusion]],
                        [[staticstorage]],
                        [[energypylon]],
                        [[staticcon]],
                        [[staticrearm]],
                        [[turretlaser]],
                        [[turretmissile]],
                        [[turretriot]],
                        [[turretemp]],
                        [[turretgauss]],
                        [[turretheavylaser]],
                        [[turretaaclose]],
                        [[turretaalaser]],
                        [[turretaaflak]],
                        [[turretaafar]],
                        [[turretimpulse]],
                        [[turrettorp]],
                        [[staticshield]],
                        [[staticradar]],
                        [[staticjammer]],
                        [[factorycloak]],
                        [[factoryshield]],
                        [[factoryveh]],
                        [[factoryhover]],
                        [[factorygunship]],
                        [[factoryplane]],
                        [[factoryspider]],
                        [[factoryjump]],
                        [[factorytank]],
                        [[factoryamph]],
                        [[factoryship]],
                        [[striderhub]],
                        [[athena]],
                        [[staticantinuke]],
                    }
                    local t4Builds = {
                        [[shipheavyarty]],
                        [[shipcarrier]],
                        [[striderfunnelweb]],
                        [[striderdetriment]],
                        [[subtacmissile]],
                        [[striderhub]],
                        [[staticheavyarty]],
                        [[zenith]],
                        [[raveparty]],
                        [[mahlazer]],
                        [[turretaaheavy]],
                        [[turretantiheavy]],
                        [[energysingu]],
                        [[staticantinuke]],
                        [[staticheavyradar]],
                        [[staticmissilesilo]],
                        [[athena]],
                    }
                    local t1Builders = utils_op.units_basic_cons
                    for _, udname in pairs(t1Builders) do
                        UnitDefs[udname].buildoptions = t1Builds
                    end
                    for udname, ud in pairs(UnitDefs) do
                        if ud.customparams.commtype then
                            ud.buildoptions = commBuilds
                        end
                    end
                    UnitDefs.athena.buildoptions = t2Builds
                    UnitDefs.striderfunnelweb.buildoptions = t3Builds
                    UnitDefs.striderhub.buildoptions = t4Builds
                end
            })

            utils.AddFnToUnitDefsTweakFns({
                k = "greed_comm_bp_x10",
                b = { "default_modify_value_begin" },
                a = { "default_modify_value_end" },
                v = function()
                    for udname, ud in pairs(UnitDefs) do
                        if ud.customparams.commtype then
                            ud.workertime = (ud.workertime or 10) * GreedFactor
                        end
                    end
                end
            })

            utils.AddFnToUnitDefsTweakFns({
                k = "greed_modify",
                b = {},
                a = { "default_modify_cost_begin", "default_modify_value_begin" },
                v = function()
                    for _, udname in pairs(utils_op.units_basic_factories) do
                        UnitDefs[udname].metalstorage = 500 * GreedFactor
                        UnitDefs[udname].energystorage = 500 * GreedFactor
                    end
                    utils_op.tweak_units({

                        staticheavyradar = {
                            metalCost = 4000,
                            customParams = {
                                area_cloak = 1,
                                area_cloak_upkeep = 0,
                                area_cloak_radius = 2000,
                                area_cloak_recloak_rate = 2000,
                            },
                        },
                        athena = {
                            initCloaked = true,
                            metalCost = 2500 * GreedFactor,
                            health = 400 * GreedFactor,
                            workerTime = 100 * GreedFactor,
                            resurrectSpeed = 10 * GreedFactor,

                        },

                        striderhub = {
                            customParams = {
                                pylonrange = 2000,
                            },
                            canPatrol = false,
                            workerTime = 2400 * GreedFactor,
                            buildDistance = 2000,
                            metalcost = 40000 * GreedFactor,
                            health = 1000 * GreedFactor,
                            weapons = {
                                {
                                    def = [[COR_SHIELD_SMALL]],
                                },
                            },
                            weaponDefs = {
                                COR_SHIELD_SMALL = {
                                    name = [[Energy Shield]],
                                    damage = {
                                        default = 10,
                                    },
                                    customParams = {
                                        unlinked = true,
                                    },
                                    exteriorShield = true,
                                    shieldAlpha = 0.001,
                                    shieldBadColor = [[0.1 0.01 0.01 0.1]],
                                    shieldGoodColor = [[0.01 0.01 0.1 0.1]],
                                    shieldInterceptType = 3,
                                    shieldPower = 1000 * GreedFactor,
                                    shieldPowerRegen = 100 * GreedFactor,
                                    shieldPowerRegenEnergy = 0,
                                    shieldRadius = 400,
                                    shieldRepulser = false,
                                    shieldStartingPower = 0,
                                    smartShield = true,
                                    visibleShield = false,
                                    visibleShieldRepulse = false,
                                    weaponType = [[Shield]],
                                },
                            },
                        },
                        striderfunnelweb = {
                            workerTime = 600 * GreedFactor,
                            buildDistance = 1000,
                            health = 1000 * GreedFactor,
                            metalcost = 10000 * GreedFactor,
                            customParams = {
                            },
                            weaponDefs = {
                                SHIELD = {
                                    customParams = {
                                        shield_recharge_delay = 0,
                                    },
                                    shieldAlpha = 0.01,
                                    shieldBadColor = [[0.1 0.01 0.01 0.1]],
                                    shieldGoodColor = [[0.01 0.01 0.1 0.1]],
                                    shieldPower = 1000 * GreedFactor,
                                    shieldPowerRegen = 100 * GreedFactor,
                                    shieldPowerRegenEnergy = 0,
                                    shieldRadius = 2000,
                                },
                            },
                        },
                        staticstorage = {
                            energyStorage = 500 * GreedFactor,
                            metalStorage = 500 * GreedFactor,
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        staticcon = {
                            workerTime = 10 * GreedFactor,
                            metalCost = 180 * GreedFactor,
                            buildDistance = 1000,
                        },
                        energywind = {
                            explodeAs = [[NOWEAPON]],
                            metalcost = 35 * GreedFactor,
                            health = 1,
                            customParams = {
                                tidal_health = 1,
                            },
                        },
                        energysolar = {
                            energyMake = 2 * 10,
                            metalCost = 700 * GreedFactor,
                            health = 800 * GreedFactor,
                            buildingGroundDecalType = [[]],
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        energysingu = {
                            metalCost = 40000 * GreedFactor,
                            energyMake = 225 * 10,
                            health = 4000 * GreedFactor,
                            buildingGroundDecalType = [[]],
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        energyfusion = {
                            metalCost = 10000 * GreedFactor,
                            energyMake = 35 * 10,
                            health = 1600 * GreedFactor,
                            buildingGroundDecalType = [[]],
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        energygeo = {
                            energyMake = 25 * 10,
                            metalCost = 5000 * GreedFactor,
                            health = 16000,
                            buildingGroundDecalType = [[]],
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        energyheavygeo = {
                            metalCost = 15000 * GreedFactor,
                            energyMake = 100 * 10,
                            health = 3200 * GreedFactor,
                            buildingGroundDecalType = [[]],
                            canCloak = 1,
                            cloakCost = 0,
                            cloakCostMoving = 0,
                            initCloaked = true,
                            minCloakDistance = 60,
                        },
                        staticmex = {
                            metalCost = 1000 * GreedFactor,
                            health = 1600 * GreedFactor,
                            customParams = {
                                metal_extractor_mult = 1 * GreedFactor,
                            },
                            sfxtypes = {
                                explosiongenerators = {
                                    [[custom:RAIDMUZZLE]],
                                    [[custom:VINDIBACK]],
                                    [[custom:RIOTBALL]],
                                },
                            },
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
                                    shieldPower = 1000 * GreedFactor,
                                    shieldPowerRegen = 10 * GreedFactor,
                                    shieldPowerRegenEnergy = 0,
                                    shieldRadius = 800,
                                    shieldRepulser = false,
                                    shieldStartingPower = 0,
                                    smartShield = true,
                                    visibleShield = false,
                                    visibleShieldRepulse = false,
                                    weaponType = [[Shield]],
                                },
                            },
                        },
                    })
                end
            })


            return {
                equalcom = "enable",
                energymult = 1 * GreedFactor,
                innateenergy = 10 * GreedFactor,
                innatemetal = 10 * GreedFactor,
                noelo = 1,
                option_notes = "Op and expensive eco. Mex cost " ..
                    GreedFactor .. "k\nlevel up with: CONSTRUCTOR -> ATHENA -> FUNNELWEB -> STRIDER HUB",
            }
        end
    },
    greed_silly_tech = {
        fn = function(param)
            param = param or {}
            local GreedFactor = param.GreedFactor or 4

            utils.AddFnToUnitDefsTweakFns({
                k = "sillycon_integral_menu_be_in_tab",
                v = function()
                    UnitDefs.sillycon.customparams.integral_menu_be_in_tab = [==[
            {
            tab="FACTORY",
            pos= {order = 14, row = 3, col = 1},
            }
            ]==]
                end
            })

            utils.AddFnToUnitDefsTweakFns({
                k = "greed_silly_tech",
                b = { "default_add_build_begin" },
                a = { "default_add_build_end" },
                v = function()
                    UnitDefs.cloakcon.buildoptions[#UnitDefs.cloakcon.buildoptions + 1] = "sillycon"
                    UnitDefs["athena"].buildoptions[#UnitDefs["athena"].buildoptions + 1] = "sillyconvery"
                    UnitDefs["striderhub"].buildoptions[#UnitDefs["striderhub"].buildoptions + 1] = "sillyconveryvery"
                end
            })
            utils.AddFnToUnitDefsTweakFns({
                k = "greed_silly_super_mult",
                v = function()
                    local super_list = {
                        "pdrp",
                        "emppudrp",
                        "mahlazercap",
                        "thepeace"
                    }
                    for key, value in pairs(super_list) do
                        UnitDefs[value].metalcost = UnitDefs[value].metalcost * 10
                    end
                end,
                b = { "default_modify_cost_begin" },
                a = { "default_modify_cost_end" },
            })

            return { option_notes = "Builder -> Silly Con; Athena -> Very Silly Con; Strider Hub -> Very Very Silly Con" }
        end
    },
    greed_silly={
        fn=function (param)
            param = param or {}
            local GreedFactor = param.GreedFactor or 4
            return {mods="silly_build() silly_morph_simple() greed{GreedFactor=".. GreedFactor ..",} greed_silly_tech{GreedFactor=".. GreedFactor ..",}"}
        end
    }
}
