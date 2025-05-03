VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things
return {
    add_chixs = {
        fn = function()
            utils.AddFnToUnitDefsTweakFns({
                k = "chix_add_build",
                b = { "default_add_build_begin" },
                a = { "default_add_build_end" },
                v = function()
                    UnitDefs["chickenbroodqueen"].buildoptions = {
                        [[chicken_drone]],
                        [[chicken]],
                        [[chickena]],
                        [[chickens]],
                        [[chickenc]],
                        [[chickenr]],
                        [[chickenblobber]],
                        [[chicken_spidermonkey]],
                        [[chicken_sporeshooter]],
                        [[chickenwurm]],
                        [[chicken_dodo]],
                        [[chicken_shield]],
                        [[chicken_tiamat]],
                        [[chicken_pigeon]],
                        [[chickenf]],
                        [[chicken_blimpy]],
                        [[chicken_roc]],
                        [[chicken_dragon]],
                    }
                end
            })
            utils_op.MakeAddSillyBuild("chickenbroodqueen")

            utils.AddFnToUnitDefsTweakFns({
                k = "chix_set_cost",
                a = { "default_modify_cost_begin" },
                v = function()
                    local function build_time_to_cost(udname)
                        if UnitDefs[udname].buildtime then
                            UnitDefs[udname].metalcost = UnitDefs[udname].buildtime
                            UnitDefs[udname].buildtime = nil
                        end
                    end
                    local buildoptions = UnitDefs["chickenbroodqueen"].buildoptions
                    for key, value in pairs(buildoptions) do
                        build_time_to_cost(value)
                    end
                    build_time_to_cost("chickenbroodqueen")
                    build_time_to_cost("chickenflyerqueen")
                    build_time_to_cost("chickenlandqueen")
                    build_time_to_cost("chicken_leaper")
                    build_time_to_cost("chickenspire")
                    build_time_to_cost("chickend")
                    do
                        local chixNewPrice = {
                            chicken = 40,
                            chicken_leaper = 440,
                            chickens = 135, -- spiker
                            chickenwurm = 400, -- wurm
                            chicken_dodo = 100, -- dodo
                            chickena = 440, -- cockatrice
                            chickenc = 600, -- basilisk,
                            chicken_roc = 900, -- roc
                            chickenf = 250, -- talon
                            chicken_blimpy = 640, -- blimpy
                            chicken_spidermonkey = 640, -- spidermonkey
                            chicken_sporeshooter = 700,
                            chickenr = 180, -- lobber
                            chicken_shield = 900, -- blooper
                            chicken_tiamat = 1200, -- tiamat
                            chickenblobber = 1600, --blobber
                            chicken_dragon = 7000,
                            chickenlandqueen = 50000,
                            chickenflyerqueen = 50000,
                            chickenspire = 5000,
                        }
                        for key, value in pairs(chixNewPrice) do
                            UnitDefs[key].metalcost = value
                        end
                        --UnitDefs.chickenspire.health=3000--.weapondefs.slamspore.projectiles=nil
                    end
                    UnitDefs["chickenbroodqueen"].canbeassisted = nil
                end
            })
            utils.AddFnToUnitDefsTweakFns({
                k = "chix_set_morph",
                b = { "default_set_morph_begin" },
                a = { "default_set_morph_end" },
                v = function()
                    utils_op.SetMorphMut("chicken_dragon", "chickenlandqueen", 60)
                    utils_op.SetMorphMut("chickenflyerqueen", "chickenlandqueen", 6)
                    utils_op.SetMorphMut("chickenlandqueen", "chickenflyerqueen", 6)
                    local drone_ud_cp = UnitDefs["chicken_drone"].customparams
                    drone_ud_cp.morphcost_2 = nil
                    drone_ud_cp.morphcost_1 = nil
                end
            })

            return { option_notes =
            "Silly Con can build Chicken Blood Queen\n Chickens are balanced by changing price\n White Dragon can morph to Chicken Queen" }
        end
    }
}
