VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

local none=utils.None
return utils_op.CopyTweakSillyBuildMorphAuto("striderscorpion","striderscorpiondrift",utils.table_replace({
    name="Scorpio Drift",
    script="striderscorpiondrift.lua",
    weapons={
        [4]={
            maxAngleDif=none
        },
        [5]={
            maxAngleDif=none
        }
    },
    weaponDefs={
        PARTICLEBEAM={
            tolerance=nil,
        },
    },
    metalCost=function (mc)
        return mc*1.05
    end
}))