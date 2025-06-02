VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("turretaalaser","turretaalaserbeam",function (ud)
    utils.table_replace({
        name="Razor Beam",
        weaponDefs={
            AAGUN={
				beamTime                = 1/30,
				duration                = 2/30,
				weaponType              = "BeamLaser",
				weaponVelocity          = 880,
				leadLimit               = 0,
            }
        },
        metalCost=300,
    })(ud)
end)