VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

local function set_laser_capper(wd)
    utils.do_tweak({
        beamTime                = 1/30,
        beamttl                 = 3,
        --coreThickness           = 0,
        --craterBoost             = 0,
        --craterMult              = 0,
        customparams = {
            capture_scaling = 1,
            is_capture = 1,
            --post_capture_reload = 360,
    
            stats_hide_damage = 1, -- continuous laser
            stats_hide_reload = 1,
            
            --light_radius = 120,
            light_color = [[0 0.6 0.15]],
        },
        explosionGenerator      = [[custom:NONE]],
        --impactOnly              = true,
        --impulseBoost            = 0,
        --impulseFactor           = 0.0,
        largeBeamLaser          = true,
        laserFlareSize          = 0,
        minIntensity            = 1,
        sweepfire               = false,
        reloadtime              = 1/30,
        --rgbColor                = [[0.5 0 0.5]],
        --rgbColor2                = [[1 0 1]],
        scrollSpeed             = 2,
        texture1                = [[dosray]],
        texture2                = [[flare]],
        texture3                = [[flare]],
        texture4                = [[smallflare]],

    })(wd)

end

local ud=utils.get_unit_lua("mahlazer")
ud.name="Babel"
ud.description="Only My Will"
ud.metalCost=80*1000
ud.customParams.mahlazer_satellite="mahlazercap_satellite";
set_laser_capper(ud.weaponDefs.RELAYLAZER)
set_laser_capper(ud.weaponDefs.RELAYCUTTER)

local satelliteud=utils.get_unit_lua("starlight_satellite")
set_laser_capper(satelliteud.weaponDefs.LAZER)
set_laser_capper(satelliteud.weaponDefs.CUTTER)
set_laser_capper(satelliteud.weaponDefs.NON_CUTTER)
satelliteud.customParams.post_capture_reload=0
ud.customParams.post_capture_reload=0

utils.set_morth_mul("silly_morth","mahlazer","mahlazercap")

utils.add_build("silly_build","verybigsillycon","mahlazercap")

return{
    mahlazercap=ud,
    mahlazercap_satellite=satelliteud
}