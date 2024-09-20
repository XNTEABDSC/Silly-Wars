VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.add_do_ud_post_fn("def_post","random_gun_xnt",function ()
    local lowerkeys=utils.lowerkeys
    local rand_range=2
    local bias=1
    local function atanh(x)
        return 1/2*math.log ((1+x)/(1-x))
    end
    -- holy math.tan( (math.random()*2-1) * math.pi/2) /(math.pi/2)
    local function get_rand_mult()
        local a=(math.random()*2-1)
        return bias*rand_range^(atanh(a) )
    end
    local wdvalues=lowerkeys(utils.list_to_set({
        "areaOfEffect","burstRate","craterBoost","craterMult","mygravity","range","reloadtime","sprayangle","weaponVelocity","accuracy",
        "shieldPower","shieldPowerRegen","shieldPowerRegenEnergy","shieldRadius",
        "laserFlareSize","leadLimit","thickness","tolerance","startVelocity","intensity",
        "turnRate","weaponAcceleration","wobble",
        "beamTime","beamttl"
    }))
    local wdcpvalues=lowerkeys(utils.list_to_set({
        "burntime","post_capture_reload","timeslow_damagefactor"
    }))
    local udvalues=lowerkeys(utils.list_to_set({
        "acceleration","brakeRate","speed","turnRate",
        "health",
        "sightDistance","radarDistance","sonarDistance","minCloakDistance","radarDistanceJam",
    }))
    local udcpvalues=lowerkeys(utils.list_to_set({
        "jump_range","jump_speed","jump_reload","area_cloak_radius","area_cloak_recloak_rate","area_cloak_upkeep","specialreloadtime"
    }))
    local function rand_gun(wd)
        for key, value in pairs(wd) do
            if wdvalues[key] then
                wd[key]=value*get_rand_mult()
            end
        end
        if wd.damage then
            for dmgkey, dmgvalue in pairs(wd.damage) do
                wd.damage[dmgkey]=dmgvalue*get_rand_mult()
            end
        end
        if wd.customparams then
            for key, value in pairs(wd.customparams) do
                if wdcpvalues[key] then
                    wd.customparams[key]= tonumber(value) * get_rand_mult()
                end
            end
        end
    end
    for name, ud in pairs(UnitDefs) do
        if ud.weapondefs then
            for _, wd in pairs(ud.weapondefs) do
                rand_gun(wd)
            end
        end
        for key, value in pairs(ud) do
            if udvalues[key] then
                ud[key]=value*get_rand_mult()
            end
        end
        if ud.customparams then
            for key, value in pairs(ud.customparams) do
                if udcpvalues[key] then
                    ud.customparams[key]=value*get_rand_mult()
                end
            end
        end
    end
end)

return {option_notes="RANDOM UNIT VALUE, UNLIMITED! "}