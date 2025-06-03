VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweakSillyBuildMorphAuto("spiderantiheavy","spidercapture",function (ud)
    ud.metalCost=800
    ud.health=2800
    ud.speed=40
    ud.minCloakDistance=100
    ud.cloakCost              = 10
    ud.cloakCostMoving        = 30
    local wd=ud.weaponDefs.spy
    wd.name="Hack Lightning"
    wd.damage.default=5000.1
    wd.customParams.capture_scaling = 1
    wd.customParams.is_capture = 1
    ud.customParams.post_capture_reload=wd.reloadtime*30
    wd.customParams.post_capture_reload=wd.reloadtime*30
    wd.rgbColor                = [[0 0.8 0.2]]
    --wd.customParams.extra_damage = 4000
    wd.paralyzer=nil
    --wd.impactOnly=true
    wd.paralyzeTime=nil
    ud.customParams.def_scale=1.5
    ud.name="Hacker Widow"
    ud.description="Hack enemies"
    ud.minCloakDistance=100
    ud.sightDistance=300
    ud.customParams.translations=[=[{
        en={
            name="Hacker Widow",
            description="Hack enemies",
            helptext="Hacker Widow can deals 5000 capture damage instantly to make victim yours. Itself is slow but tanky, to make sure the controling. It is good at hacking extra thing at chaotic field. WARNING: You need deal unitHealth+1000 capture damage to capture it e.g. 1040 cap dmg to capture 40hp flea"
        }
    }]=]
end)