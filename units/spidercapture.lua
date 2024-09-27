
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("silly_morth","spiderantiheavy","spidercapture")

utils.add_build("silly_build","sillycon","spidercapture")

return utils.copy_tweak("spiderantiheavy","spidercapture",function (ud)
    ud.metalCost=800
    ud.health=3200
    ud.speed=45
    ud.minCloakDistance=100
    ud.customParams.post_capture_reload=360
    local wd=ud.weaponDefs.spy
    wd.damage.default=4000.1
    wd.customParams.capture_scaling = 1
    wd.customParams.is_capture = 1
    wd.customParams.post_capture_reload=360
    wd.rgbColor                = [[0 0.8 0.2]]
    --wd.customParams.extra_damage = 4000
    wd.paralyzer=nil
    --wd.impactOnly=true
    wd.paralyzeTime=nil
    ud.customParams.def_scale=1.5
    ud.name="Hacker Widow"
    ud.description="Hack enemy. WARNING: You need deal unitHealth+1000 of capture damage to cap it e.g. 1025 cap dmg to capture flea"
end)