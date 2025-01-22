VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.MakeAddBuildValueWithOrder then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    
    VFS.Include("LuaRules/Utilities/to_make_op_things/tweak_fns.lua")
    local AddFnToUnitDefsTweakFns=to_make_op_things.AddFnToUnitDefsTweakFns
    
    
    local function MakeAddBuildValueWithOrder(builer,buildee)
        return{
            k="add_build(" .. builer .. ", " .. buildee .. ")",
            b={"default_add_build_begin"},
            a={"default_add_build_end"},
            v=function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=buildee
            end
        }
    end

    local function MakeAddBuild(builer,buildee)
        AddFnToUnitDefsTweakFns(MakeAddBuildValueWithOrder(builer,buildee))
    end

    to_make_op_things.MakeAddBuildValueWithOrder=MakeAddBuildValueWithOrder
    to_make_op_things.MakeAddBuild=MakeAddBuild
    Spring.Utilities.to_make_op_things=to_make_op_things
end