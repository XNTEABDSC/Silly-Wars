VFS.Include("LuaRules/Utilities/to_make_very_op_things/include.lua")
if not Spring.Utilities.to_make_very_op_things.good_scale_unit then

    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils

    VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local utils_op=Spring.Utilities.to_make_op_things
    
    local lowerkeys=utils.lowerkeys

    local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

    
        local lazy_scale=1/(6.5)
        local range_scale=lazy_scale
        local damage_scale=1-lazy_scale
        local reload_scale=lazy_scale
        local speed_scale=-0.1
        local util_range=0.25
        local other_small_scale=0.1
        local hp_scale=1-lazy_scale


        local wdToChange=({
            damage=damage_scale,
            areaOfEffect=range_scale,range=range_scale,
            burstRate=reload_scale,reloadtime=reload_scale,sprayAngle=0,accuracy=0,
            weaponVelocity=range_scale,startVelocity=range_scale,
            craterBoost=other_small_scale,craterMult=other_small_scale,mygravity=0,
            shieldPower=hp_scale,shieldPowerRegen=hp_scale,shieldPowerRegenEnergy=hp_scale,shieldRadius=util_range,
            laserFlareSize=other_small_scale,thickness=other_small_scale,tolerance=other_small_scale,intensity=other_small_scale,beamTime=other_small_scale,beamttl=other_small_scale,
            turnRate=0,weaponAcceleration=speed_scale,wobble=0,
        })
        local wdcpToChange=({
            burntime=0.5,
            --post_capture_reload=0,
            timeslow_damagefactor=damage_scale,
            extra_damage=damage_scale,
        })
        local udToChange=({
            acceleration=speed_scale,brakeRate=speed_scale,speed=speed_scale,turnRate=speed_scale,
            health=hp_scale,idleAutoHeal=hp_scale-reload_scale,idleTime=reload_scale,autoHeal=hp_scale-reload_scale,
            sightDistance=range_scale,radarDistance=range_scale,sonarDistance=range_scale,minCloakDistance=range_scale,radarDistanceJam=util_range,
            metalCost=1,
        })
        local udcpToChange=({
            jump_range=util_range,jump_speed=util_range,jump_reload=reload_scale,
            area_cloak_radius=util_range,area_cloak_recloak_rate=util_range,area_cloak_upkeep=util_range,specialreloadtime=reload_scale,
            def_scale=range_scale,
        })

        to_make_very_op_things.good_scale_unit_default={
            wdToChange=wdToChange,
            wdcpToChange=wdcpToChange,
            udToChange=udToChange,
            udcpToChange=udcpToChange
        }

        function to_make_very_op_things.good_scale_unit(ud,scale,scaletable)
            scaletable=scaletable or to_make_very_op_things.good_scale_unit_default
            local function scale_it(value,scale_factor,key)
                if key=="damage" then
                    for k, v in pairs(value) do
                        value[k]=v*scale^scale_factor
                    end
                    return value
                end
                if key=="def_scale" then
                    if not value then
                        value=1
                    end
                end
                if value then
                    value=tonumber(value)
                    value=value*(scale^scale_factor)
                    value=utils.round_to(value,1/30)
                end
                return value
            end
            utils_op.modify_unit_all_2({
                udToChange=scaletable.udToChange,
                udcpToChange=scaletable.udcpToChange,
                wdToChange=scaletable.wdToChange,
                wdcpToChange=scaletable.wdcpToChange,
                udfn=scale_it,
                udcpfn=scale_it,
                wdfn=scale_it,
                wdcpfn=scale_it,
            },ud)
        end
    

    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
end