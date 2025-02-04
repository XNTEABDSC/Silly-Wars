VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

local CraterMult=CraterMult or 1

local b,a=utils_op.OrderKeyGen(utils_op.weapon_defs_tweak_fns,"craterMult")

Spring.Utilities.OrderedList.AddMult(utils_op.weapon_defs_tweak_fns,{
    k="crater_boost",
    b=b,
    a=a,
    v=function ()
        for key, value in pairs(WeaponDefs) do
            -- ---@class WeaponDef
            local value2=value
            value2.cratermult=(value.cratermult or 0)+CraterMult
        end
    end
})

return {
    option_notes = "Terra is weaker. Give all weapon " .. tostring(CraterMult) .. " craterMult",
}