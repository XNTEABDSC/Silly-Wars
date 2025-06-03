VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("turretaalaser","turretaalaserbeam",function (ud)
    utils.table_replace({
        name="Beam Razor",
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
        customParams={
            translations=[=[{
                en={
                    name="Beam Razor",
                    description="Hardened Anti-Air Beam",
                    helptext="A beam anti-air which has good dps and hp and can hit things accurately"
                }
            }]=]
        }
    })(ud)
end)