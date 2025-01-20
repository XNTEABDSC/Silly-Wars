VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
--[=[
local function make_drunk(wd)
    if wd.range then
        if not wd.sprayangle then
            wd.sprayangle = 4000 - wd.range
        else
            wd.sprayangle = wd.sprayangle + 4000 - wd.range
        end
    end
    if not wd.burst then
        wd.burst = 10
    else
        wd.burst = wd.burst * 10
    end
    if wd.reloadtime then
        wd.reloadtime = wd.reloadtime * 2
    end
    if wd.areaOfEffect then
        wd.areaOfEffect = wd.areaOfEffect * 0.1
    end
end
return utils.copy_tweak("jumparty","jumpartydrunk",function (ud)
    make_drunk(ud.weaponDefs.NAPALM_SPRAYER)
    ud.name="Drunk" .. ud.name
    ud.description="Drunk" .. ud.description
    ud.metalCost=ud.metalCost*5
    ud.health=ud.health*5
    ud.customParams.def_scale=2
end)
]=]

return utils_op.CopyTweakSillyBuildMorphAuto("jumparty","jumpartydrunk",function (ud)
    to_make_very_op_things.make_unit_drunk(ud)
    utils_op.set_ded_ATOMIC_BLAST(ud)
    --ud.weaponDefs.NAPALM_SPRAYER.weaponVelocity=295
    ud.weaponDefs.NAPALM_SPRAYER.range=1100
    ud.customParams.tactical_ai_defs_copy="jumparty"
    ud.fireState=0
    ud.highTrajectory=2
    ud.iconType="jumpartydrunk"
    --ud.health=ud.health*0.6
end)