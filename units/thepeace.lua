local ud=(VFS.Include("units/zenith.lua").zenith)
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

ud.name="THE PEACE"
ud.destination="YOU LOVE PEACE RIGHT? I LOVE IT TOO"
ud.metalCost=150 * 1000
ud.health=10000
--ud.customParams.is_nuke=true -- dk, don't let antinuke work 
ud.customParams.zenith_meteor_capacity=100

local function make_meteor_into_NUKE(wd)
    utils.table_replace({
        name="NUKE",
        areaOfEffect            = 1920,
        cegTag                  = [[NUCKLEARMINI]],
        craterBoost             = 6,
        craterMult              = 6,
        customParams              = {
            light_color = [[2.92 2.64 1.76]],
            light_radius = 3000,
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
        accuracy=1500,
    })(wd)
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
utils.set_morth_mul("silly_morth","zenith","thepeace",30)

utils.add_build("silly_build","verybigsillycon","thepeace")

return {["thepeace"]=ud}