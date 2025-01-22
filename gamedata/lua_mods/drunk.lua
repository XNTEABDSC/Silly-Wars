-- from SmokeDragon
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things
--[=[
utils_op.AddFnToUnitDefsTweakFnsMut({
    k="drunk",
    b={"default_modify_value_begin"},
    a={"default_modify_value_end"},
    v=function ()
        for name, ud in pairs(UnitDefs) do
            if ud.weapondefs then
                for k,v in pairs(ud.weapondefs) do
                    to_make_very_op_things.make_weapon_drunk(v)
                end
            end
        end        
    end
})]=]

Spring.Utilities.OrderedList.AddMult(utils_op.weapon_defs_tweak_fns,{
    k="drunk",
    b={"modify_values_begin"},
    a={"modify_values_end"},
    v=function ()
        for key, value in pairs(WeaponDefs) do
            to_make_very_op_things.make_weapon_drunk(value)
        end
    end
})

return {
    option_notes = "Units throw alot but throw everywhere",
}