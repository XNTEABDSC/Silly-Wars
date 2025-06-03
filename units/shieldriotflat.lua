VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
local ud=utils.GetUnitLua("shieldriot")

utils.table_replace({
    name=function (name)return "Flatting " .. name end,
    description=function (description)return description .. ", and Flat Land"end,
    metalCost=ud.metalCost+20,
    weaponDefs={BLAST={customParams={
        smoothradius     = [[140]],
        smoothmult       = [[0.1]],
    }}},
    customParams={
        tactical_ai_defs_copy="shieldriot",
        translations_copy_from="shieldriot",
        translations=[=[{
            en={
                name=function (name)return "Flatting " .. name end,
                description=function (description)return description .. ", and Flat Land"end,
                helptext=function(helptext) return helptext .. " It can also flat terran around it." end
            }
        }]=]
    }
})(ud)

utils_op.MakeSetSillyBuildMorphSimple("shieldriot","shieldriotflat",5)

return {["shieldriotflat"]=ud}