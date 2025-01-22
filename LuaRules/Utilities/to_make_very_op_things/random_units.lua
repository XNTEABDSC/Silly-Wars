VFS.Include("LuaRules/Utilities/to_make_very_op_things/include.lua")
if not Spring.Utilities.to_make_very_op_things.random_units then

    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils

    VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local utils_op=Spring.Utilities.to_make_op_things
    
    local lowerkeys=utils.lowerkeys
    
    local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
    do
        local wdvalues=lowerkeys(utils.list_to_set({
            "areaOfEffect","burstRate","craterBoost","craterMult","mygravity","range","reloadtime","sprayangle","weaponVelocity","accuracy",
            "shieldPower","shieldPowerRegen","shieldPowerRegenEnergy","shieldRadius",
            "laserFlareSize","thickness","tolerance","startVelocity","intensity",
            "turnRate","weaponAcceleration","wobble",
            "beamTime","beamttl"
        }))
        local wdcpvalues=lowerkeys(utils.list_to_set({
            "burntime","post_capture_reload","timeslow_damagefactor","extra_damage"
        }))
        local udvalues=lowerkeys(utils.list_to_set({
            "acceleration","brakeRate","speed","turnRate",
            "health",
            "sightDistance","radarDistance","sonarDistance","minCloakDistance","radarDistanceJam",
        }))
        local udcpvalues=lowerkeys(utils.list_to_set({
            "jump_range","jump_speed","jump_reload","area_cloak_radius","area_cloak_recloak_rate","area_cloak_upkeep","specialreloadtime"
        }))
        function to_make_very_op_things.random_units(get_rand_mult)
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
        end
    end

    do
        local wdvalues=lowerkeys({
            areaOfEffect={0.5,1},range={0.5,2},
            burstRate={1,-1},reloadtime={1,-1},sprayangle={0.5,-0.2},accuracy={0.5,-0.2},
            weaponVelocity={0.5,0.5},startVelocity={0.5,0.5},
            craterBoost={1,0.2},craterMult={1,0.2},mygravity={0.5,0},
            shieldPower={1,1},shieldPowerRegen={1,1},shieldPowerRegenEnergy={1,-1},shieldRadius={0.5,1},
            laserFlareSize={0.5,0},thickness={0.5,0},tolerance={1,0},intensity={1,0},beamTime={0.5,0},beamttl={0.5,0},
            turnRate={0.5,0.2},weaponAcceleration={0.5,0.2},wobble={0.5,-0.2},
        })
        local wdcpvalues=lowerkeys({
            burntime={0.5,2},
            post_capture_reload={0.5,-2},
            timeslow_damagefactor={1,1},
            extra_damage={1,1},
        })
        local udvalues=lowerkeys({
            acceleration={0.5,0.5},brakeRate={0.5,0.2},speed={0.5,1},turnRate={0.5,1},
            health={1,1},
            sightDistance={0.5,0.2},radarDistance={0.5,0.2},sonarDistance={0.5,0.2},minCloakDistance={0.5,0.2},radarDistanceJam={0.5,0.2},
        })
        local udcpvalues=lowerkeys({
            jump_range={0.5,1},jump_speed={0.5,0.2},jump_reload={1,-1},
            area_cloak_radius={0.5,0.2},area_cloak_recloak_rate={1,0.2},area_cloak_upkeep={1,-1},specialreloadtime={1,-1},
        })
        function to_make_very_op_things.random_units_balanced(get_rand_mult_given)
            local function rand_gun(wd,get_rand_mult)
                if wd.customparams and wd.customparams.bogus then
                    return;
                end
                for key, value in pairs(wd) do
                    if wdvalues[key] then
                        wd[key]=value*get_rand_mult(wdvalues[key])
                    end
                end
                if wd.damage then
                    local dmgmut=get_rand_mult({1,1})
                    for dmgkey, dmgvalue in pairs(wd.damage) do
                        wd.damage[dmgkey]=dmgvalue*dmgmut
                    end
                end
                if wd.customparams then
                    for key, value in pairs(wd.customparams) do
                        if wdcpvalues[key] then
                            wd.customparams[key]= tonumber(value) * get_rand_mult(wdcpvalues[key])
                        end
                    end
                end
            end
            for name, ud in pairs(UnitDefs) do
                if ud.metalcost then
                    local mybias=1--get_rand_mult_given()
                    local function get_rand_mult(effect)
                        local nextvalue=get_rand_mult_given()^effect[1]
                        mybias=mybias*(nextvalue^effect[2])
                        return nextvalue
                    end
                    if ud.weapondefs then
                        for _, wd in pairs(ud.weapondefs) do
                            rand_gun(wd,get_rand_mult)
                        end
                    end
                    for key, value in pairs(ud) do
                        if udvalues[key] then
                            ud[key]=value*get_rand_mult(udvalues[key])
                        end
                    end
                    if ud.customparams then
                        for key, value in pairs(ud.customparams) do
                            if udcpvalues[key] then
                                ud.customparams[key]=value*get_rand_mult(udcpvalues[key])
                            end
                        end
                    end
                    ud.metalcost=ud.metalcost*mybias
                end
            end
        end
    end

    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
end