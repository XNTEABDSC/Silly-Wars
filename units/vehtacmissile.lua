VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweakSillyBuildMorphBig("vehheavyartyplus","vehtacmissile",function (ud)
    ud.metalCost=3000
    ud.health=3000
    ud.name="Eos " .. "Impaler"
    ud.description="Throws Eos (600 stokepile)"
    ud.customParams.stockpiletime  = [[30]]
    ud.customParams.stockpilecost  = [[600]]
    ud.speed=38
    ud.weaponDefs={}
    ud.weapons[1].name="subtacmissile_tacnuke"
    --ud.objectName="impalerWithEOS"
    ud.customParams.def_scale=2
    ud.fireState =0
    ud.customParams.translations=[=[
    {
        en={
            name="Eos Impaler",
            description="Throws Eos (600 stokepile)",
            helptext="Mobile Missile silo! "
        }
    }]=]
    --[==[
    utils.set_scale(ud,1.8)
    ud.collisionVolumeScales  = [[80 40 80]]
    ud.footprintX          = 3*2
    ud.footprintZ          = 3*2
    ud.trackOffset         = 15*2
    ud.trackWidth          = 44*2
    ud.trackStrength       = 8*2
    ud.trackStretch        = 1*2
    ]==]
    utils_op.set_ded_ATOMIC_BLAST(ud)
end)
