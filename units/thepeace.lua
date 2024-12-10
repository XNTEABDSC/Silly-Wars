local ud=(VFS.Include("units/zenith.lua").zenith)
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

ud.name="THE PEACE"
ud.description="A simple way to bring peace to the world (can be intercepted by antinuke) (Use D to drop a single NUKE)"
ud.metalCost=100 * 1000
ud.health=10000
ud.customParams.zenith_meteor_capacity=100
ud.customParams.zenith_hover_height=3200
ud.customParams.custom_tooltip_simple="FOR THE PEACE (%[meteorsControlled|0]/%[meteorsControlledMax|100] nuke)"

local nuketable={
    name="NUKE",
    areaOfEffect            = 1920,
    cegTag                  = [[NUCKLEARMINI]],
    craterBoost             = 6,
    craterMult              = 6,
    customParams              = {
        light_color = [[2.92 2.64 1.76]],
        light_radius = 3000,
        spawns_name = utils.None,
        spawns_feature = utils.None,
        
        smoothradius     = utils.None,
        smoothmult       = utils.None,
        movestructures   = utils.None,
        
    },
    damage                  = {
        default = 11501.1,
    },
    edgeEffectiveness       = 0.3,
    explosionGenerator      = [[custom:LONDON_FLAT]],
    impulseBoost            = 0.5,
    impulseFactor           = 0.2,
    interceptedByShieldType = 65,
    model                   = [[staticnuke_projectile.s3o]],
    reloadtime              = 5,
    soundHit                = [[explosion/ex_ultra8]],
    --accuracy                =1500,
    targetable              = 1,
    interceptSolo=true,
    range                   = 72000,
    startVelocity           = 800,
    weaponVelocity          = 800,
}
local function make_meteor_into_NUKE(wd)
    utils.table_replace(nuketable)(wd)
    wd.customParams.spawns_name=nil
    wd.customParams.spawns_feature=nil
end
local maked_meteor={
    "METEOR",
    "METEOR_AIM",
    "METEOR_FLOAT",
    "METEOR_UNCONTROLLED",
}
for key, value in pairs(maked_meteor) do
    make_meteor_into_NUKE(ud.weaponDefs[value])
end
ud.weaponDefs.GRAVITY_NEG.duration=1.2
ud.weaponDefs.GRAVITY_NEG.reloadtime=1.2
ud.weaponDefs.GRAVITY_NEG.rgbColor                = [[0.5 0 0]]
ud.weaponDefs.GRAVITY_NEG.rgbColor2               = [[1 0 0]]
ud.weaponDefs.GRAVITY_NEG.thickness=96
ud.weaponDefs.GRAVITY_NEG.size=96
ud.weaponDefs.METEOR_AIM.accuracy=3000
ud.customParams.manualfire_desc="Throw a single nuke"
--ud.weaponDefs.METEOR_FLOAT.startVelocity=1500
ud.weaponDefs.METEOR_FLOAT.weaponVelocity=300
--ud.weaponDefs.METEOR_FLOAT.targetable=nil
ud.fireState=0
do
    ud.weaponDefs.METEOR_TARGETER=Spring.Utilities.CopyTable(ud.weaponDefs.METEOR,true)
    local TARGETER=ud.weaponDefs.METEOR_TARGETER
    TARGETER.commandfire=true
    TARGETER.customParams.bogus=1
    TARGETER.damage={
        default=1E-6,
        plane=1E-6,
    }
    TARGETER.reloadtime=0.033
    ud.weapons[3]={
        def                = [[METEOR_TARGETER]],
        badTargetCateogory = [[MOBILE]],
        onlyTargetCategory = [[SWIM LAND SINK TURRET FLOAT SHIP HOVER GUNSHIP]],
    }

end
ud.canManualFire          = true

utils_op.MakeSetSillyMorph("zenith","thepeace",30)

utils_op.MakeAddSillyBuild("thepeace")

return {["thepeace"]=ud}