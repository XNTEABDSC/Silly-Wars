VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.MakeSetSillyBuildMorphSimple then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    
    --VFS.Include("LuaRules/Utilities/to_make_op_things/tweak_fns.lua")
    VFS.Include("LuaRules/Utilities/to_make_op_things/set_morph.lua")
    local utils=Spring.Utilities.wacky_utils
    local AddFnToOptionalUnitDefsTweakFns=utils.AddFnToOptionalUnitDefsTweakFns
    local MakeSetMorphMutValueWithOrder=to_make_op_things.MakeSetMorphMutValueWithOrder
    
    local function MakeSetSillyMorphSimple(srcname,toname,morphtime,morphprice)
        AddFnToOptionalUnitDefsTweakFns("silly_morph_simple",MakeSetMorphMutValueWithOrder(srcname,toname,morphtime,morphprice))
    end
    
    local function MakeSetSillyMorphBig(srcname,toname,morphtime,morphprice)
        AddFnToOptionalUnitDefsTweakFns("silly_morph_big",MakeSetMorphMutValueWithOrder(srcname,toname,morphtime,morphprice))
    end

    local function MakeAddSillyBuild(name,con)
        AddFnToOptionalUnitDefsTweakFns("silly_build",to_make_op_things.MakeAddSillyBuildValueWithOrder(name,con))
    end
    to_make_op_things.MakeSetSillyMorphSimple=MakeSetSillyMorphSimple
    to_make_op_things.MakeSetSillyMorphBig=MakeSetSillyMorphBig
    to_make_op_things.MakeAddSillyBuild=MakeAddSillyBuild

    local function MakeSetSillyBuildMorphBig(srcname,toname,morthtime,morthprice)
        
        MakeSetSillyMorphBig(srcname,toname,morthtime,morthprice)
        MakeAddSillyBuild(toname)
    end
    local function MakeSetSillyBuildMorphSimple(srcname,toname,morthtime,morthprice)
        
        MakeSetSillyMorphSimple(srcname,toname,morthtime,morthprice)
    end
    to_make_op_things.MakeSetSillyBuildMorphBig=MakeSetSillyBuildMorphBig
    to_make_op_things.MakeSetSillyBuildMorphSimple=MakeSetSillyBuildMorphSimple

    Spring.Utilities.to_make_op_things=to_make_op_things
end