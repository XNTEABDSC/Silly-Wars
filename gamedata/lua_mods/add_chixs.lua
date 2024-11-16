VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.add_fn_to_fn_list("def_pre","add_chixs",function ()
    utils.add_build("def","sillycon","chickenbroodqueen")
    UnitDefs["chickenbroodqueen"].buildoptions={
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
    local buildoptions=UnitDefs["chickenbroodqueen"].buildoptions

    local function build_time_to_cost(udname)
        if UnitDefs[udname].buildtime then
            UnitDefs[udname].metalcost=UnitDefs[udname].buildtime
            UnitDefs[udname].buildtime=nil
        end
    end
    for key, value in pairs(buildoptions) do
        build_time_to_cost(value)
    end
    build_time_to_cost("chickenbroodqueen")
    UnitDefs["chickenbroodqueen"].canbeassisted=nil

    build_time_to_cost("chickenflyerqueen")
    build_time_to_cost("chickenlandqueen")
    utils.set_morth_mul("def","chicken_dragon","chickenlandqueen",60)
    utils.set_morth("def","chickenflyerqueen","chickenlandqueen",6)
    utils.set_morth("def","chickenlandqueen","chickenflyerqueen",6)
    UnitDefs["chicken_dragon"].description=UnitDefs["chicken_dragon"].description .. ", can morth into queen"
    build_time_to_cost("chicken_leaper")
    build_time_to_cost("chickenspire")
    build_time_to_cost("chickend")

    do
        -- from zerowar rebalanced
        local chixNewPrice={
            chicken=40,
            chicken_leaper=440,
            chickens=135, -- spiker
            chickenwurm=400, -- wurm
            chicken_dodo=100, -- dodo
            chickena=440, -- cockatrice
            chickenc=600, -- basilisk,
            chicken_roc=900, -- roc
            chickenf=250, -- talon
            chicken_blimpy=640, -- blimpy
            chicken_spidermonkey=640, -- spidermonkey
            chicken_sporeshooter=700,
            chickenr=180, -- lobber
            chicken_shield=900, -- blooper
            chicken_tiamat=1200, -- tiamat
            chickenblobber=1600, --blobber
            chicken_dragon=7000,
            chickenlandqueen=60000,
            chickenflyerqueen=60000,
            chickenspire=5000,
        }
        for key, value in pairs(chixNewPrice) do
            UnitDefs[key].metalcost=value
        end
        UnitDefs.chickenspire.health=3000--.weapondefs.slamspore.projectiles=nil
    end
    do
        local drone_ud_cp=UnitDefs["chicken_drone"].customparams
        drone_ud_cp.morphcost_2=nil--=UnitDefs["chickenspire"].metalcost-UnitDefs["chicken_drone"].metalcost
        drone_ud_cp.morphcost_1=nil--=UnitDefs["chickend"].metalcost-UnitDefs["chicken_drone"].metalcost
    end
end)

return {option_notes="Silly Con can build Chicken Blood Queen\n chickens are balanced\n White Dragon can morth to Chicken Queen"}