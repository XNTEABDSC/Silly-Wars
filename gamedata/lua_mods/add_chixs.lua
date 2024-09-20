VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.add_do_ud_post_fn("def_pre","add_chixs",function ()
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

    local drone_ud_cp=UnitDefs["chicken_drone"].customparams
    drone_ud_cp.morphcost_2=2500-60
    drone_ud_cp.morphcost_1=120-60

    do
        -- from zerowar rebalanced
        local chixNewPrice={
            chicken=60,
            chicken_leaper=440,
            chickens=90,
            chickenwurm=400,
            chicken_dodo=120,
            chickena=440,
            chickenc=800,
            chicken_roc=1600,
            chickenf=300,
            chicken_blimpy=640,
            chicken_spidermonkey=640,
            chicken_sporeshooter=820,
            chickenr=180,
            chicken_shield=600,
            chicken_tiamat=2000,
            chickenblobber=2800,
            chicken_dragon=7000
        }
        for key, value in pairs(chixNewPrice) do
            UnitDefs[key].metalcost=value
        end
    end
end)

return {option_notes="You can make chickenbroodqueen by sillycon. Chickens are balanced (via zerowar)"}