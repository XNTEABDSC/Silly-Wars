VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

utils.set_morth_mul("silly_morth","vehheavyartyplus","vehtacmissile")
utils.add_build("silly_build","bigsillycon","vehtacmissile")

return utils.copy_tweak("vehheavyartyplus","vehtacmissile",function (ud)
    ud.metalCost=3000
    ud.health=3000
    ud.name="Eos " .. "Impaler"
    ud.description="Throws Eos (500 stokepile)"
    ud.customParams.stockpiletime  = [[30]]
    ud.customParams.stockpilecost  = [[600]]
    ud.speed=38
    ud.weaponDefs={}
    ud.weapons[1].name="subtacmissile_tacnuke"
    --ud.objectName="impalerWithEOS"
    ud.customParams.def_scale=2
    ud.fireState =0
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
    utils.set_ded_ATOMIC_BLAST(ud)
end)
