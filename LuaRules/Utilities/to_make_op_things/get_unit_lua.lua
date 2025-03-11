VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.GetUnitLua then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    ---get lua table of unit defined by .lua file
    local function GetUnitLua(udname)
        if not Shared then
            Shared={}
        end
        return VFS.Include("units/".. udname ..".lua")[udname]
    end
    to_make_op_things.GetUnitLua=GetUnitLua

    Spring.Utilities.to_make_op_things=to_make_op_things
end