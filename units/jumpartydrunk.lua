VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweakSillyBuildMorphAuto("jumparty","jumpartydrunk",function (ud)
    to_make_very_op_things.make_unit_drunk(ud)
    utils_op.set_ded_ATOMIC_BLAST(ud)
    --ud.weaponDefs.NAPALM_SPRAYER.weaponVelocity=295
    ud.weaponDefs.NAPALM_SPRAYER.range=1100
    ud.customParams.tactical_ai_defs_copy="jumparty"
    ud.fireState=0
    ud.highTrajectory=2
    ud.iconType="jumpartydrunk"
    ud.customParams.translations=[=[{
        en={
            name="Drunk Firewalker",
            description="Drunk Napalm Artillery Walker",
            helptext="Firewalker that throws a lot and throws everywhere"
        }
    }]=]
    --ud.health=ud.health*0.6
end)