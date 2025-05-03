VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.CopyTweak then
    local to_make_op_things=Spring.Utilities.to_make_op_things
    local utils=Spring.Utilities.wacky_utils
    --to_make_op_things.to_make_op_things_include("get_unit_lua")
    to_make_op_things.to_make_op_things_include("silly_build_morph")
    local MakeSetSillyBuildMorphBig=to_make_op_things.MakeSetSillyBuildMorphBig
    local MakeSetSillyBuildMorphSimple=to_make_op_things.MakeSetSillyBuildMorphSimple
    local GetUnitLua=utils.GetUnitLua


    ---copy a unit, tweak it, and return {[toname]=ud}
    function to_make_op_things.CopyTweak(srcname,toname,fn)
        local ud=GetUnitLua(srcname)
        fn(ud)
        return {[toname]=ud}
    end

    
    function to_make_op_things.CopyTweakSillyBuildMorphBig(srcname,toname,fn)
        MakeSetSillyBuildMorphBig(srcname,toname)
        --to_make_op_things.add_build("silly_build",builder,toname)
        --to_make_op_things.set_morph_mul("silly_morph",srcname,toname)
        return to_make_op_things.CopyTweak(srcname,toname,fn)
    end
    function to_make_op_things.CopyTweakSillyBuildMorphSimple(srcname,toname,fn)
        --MakeSetSillyMorphBig(srcname,toname)
        --MakeAddSillyBuild(toname)
        MakeSetSillyBuildMorphSimple(srcname,toname)
        --to_make_op_things.add_build("silly_build",builder,toname)
        --to_make_op_things.set_morph_mul("silly_morph",srcname,toname)
        return to_make_op_things.CopyTweak(srcname,toname,fn)
    end


    function to_make_op_things.CopyTweakSillyBuildMorphAuto(srcname,toname,fn)
        --to_make_op_things.add_build("silly_build",builder,toname)
        --to_make_op_things.set_morph_mul("silly_morph",srcname,toname)
        --
        local ud=GetUnitLua(srcname)
        local src_cost=ud.metalCost
        fn(ud)
        local new_cost=ud.metalCost
        if new_cost/src_cost >1.5 then
            MakeSetSillyBuildMorphBig(srcname,toname)
        else
            MakeSetSillyBuildMorphSimple(srcname,toname)
        end
        return {[toname]=ud}
    end

    

    Spring.Utilities.to_make_op_things=to_make_op_things
end