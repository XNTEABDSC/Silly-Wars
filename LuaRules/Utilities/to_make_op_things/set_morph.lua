VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.SetMorphMut then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    --VFS.Include("LuaRules/Utilities/to_make_op_things/tweak_fns.lua")
    
    local utils=Spring.Utilities.wacky_utils
    local AddFnToUnitDefsTweakFns=utils.AddFnToUnitDefsTweakFns
    local function SetMorphMut(srcname,copyedname,morphtime,morphprice)
        if not UnitDefs[srcname] then
            error("unit " .. srcname .. "do not exist")
        end
        local ud_cp=UnitDefs[srcname].customparams
        if ud_cp.morphto then
            ud_cp.morphto_1=ud_cp.morphto
            ud_cp.morphto=nil
            ud_cp.morphtime_1=ud_cp.morphtime
            ud_cp.morphtime=nil
            ud_cp.morphcost_1=ud_cp.morphcost
            ud_cp.morphcost=nil
        end
        --morphprice=morphprice or UnitDefs[copyedname].metalcost-UnitDefs[srcname].metalcost
        local i=1
        morphtime=morphtime or 10
        while true do
            if not ud_cp["morphto_" .. i] then
                ud_cp["morphto_" .. i]=copyedname
                ud_cp["morphtime_" .. i]=morphtime
                ud_cp["morphcost_" .. i]=morphprice
                break
            end
            i=i+1
        end
    end
    to_make_op_things.SetMorphMut=SetMorphMut

    local function MakeSetMorphMutValueWithOrder(srcname,copyedname,morphtime,morphprice)
        return{
            k=("set_morph_mul(" .. srcname .. ", " .. copyedname .. ")"),
            b={"default_set_morph_begin"},
            a={"default_set_morph_end"},
            v=function ()
                SetMorphMut(srcname,copyedname,morphtime,morphprice)
                --UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morph into " .. copyedname
            end
        }
    end
    to_make_op_things.MakeSetMorphMutValueWithOrder=MakeSetMorphMutValueWithOrder

    Spring.Utilities.to_make_op_things=to_make_op_things
end