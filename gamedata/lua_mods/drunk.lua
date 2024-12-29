VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

utils_op.AddFnToUnitDefsTweakFnsMut({
    k="drunk",
    b={"default_modify_value_begin"},
    a={"default_modify_value_end"},
    v=function ()
        for name, ud in pairs(UnitDefs) do
            if ud.health then
                ud.health = ud.health * 2
            end
            if ud.weapondefs then
                for k,v in pairs(ud.weapondefs) do
                    to_make_very_op_things.make_weapon_drunk(v)
                end
            end
        end        
    end
})

return {
    option_notes = "units shoot in bursts but are drunk and cant aim",
}