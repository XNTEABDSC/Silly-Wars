VFS.Include("LuaRules/Utilities/to_make_very_op_things/include.lua")
if not Spring.Utilities.to_make_very_op_things.what_I_paid_for then

    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils

    VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local utils_op=Spring.Utilities.to_make_op_things
    
    local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

    function to_make_very_op_things.what_I_paid_for(ud)
        local valuemetalcost = ud.metalCost * 0.1
        if ud.health and valuemetalcost then
            ud.health = ud.health + (valuemetalcost * 1000)
        end
        if ud.speed and valuemetalcost then
            ud.speed = ud.speed + (valuemetalcost * 0.1)
        end
        if ud.sightDistance and valuemetalcost then
            ud.sightDistance = ud.sightDistance + (valuemetalcost * 10)
        end
        if ud.customParams and ud.customParams.jump_range and valuemetalcost then
            ud.customParams.jump_range = ud.customParams.jump_range + valuemetalcost
        end
        if ud.weaponDefs then
            for _, wd in pairs(ud.weaponDefs) do
                if wd.areaOfEffect and valuemetalcost then
                    wd.areaOfEffect = wd.areaOfEffect + (valuemetalcost * 0.1)
                end
                if wd.weaponType == "Cannon" then
                    if wd.weaponVelocity and valuemetalcost then
                        wd.weaponVelocity = wd.weaponVelocity + (valuemetalcost * 10)
                    end
                end
                if wd.range and valuemetalcost then
                    wd.range = wd.range + (valuemetalcost * 10)
                end
                if wd.shieldPower and valuemetalcost then
                    wd.shieldPower = wd.shieldPower + valuemetalcost
                end
                if wd.flightTime and valuemetalcost then
                    wd.flightTime = wd.flightTime + (valuemetalcost * 10)
                end
                if wd.reloadtime and valuemetalcost then
                    if wd.reloadtime > (valuemetalcost * 0.005)+0.0333 then
                        wd.reloadtime = wd.reloadtime - (valuemetalcost * 0.005)
                    else
                        wd.reloadtime = 0.0333
                    end
                    
                end
                if wd.damage and valuemetalcost and wd.damage.default then
                    wd.damage.default = wd.damage.default + (valuemetalcost * 10)
                end
            end
        end
    end
    -- too low
    function to_make_very_op_things.what_I_paid_for_2(ud)
        
        local function round_to_ten(n)
            n = n/10
            n = math.floor(n)
            n = n*10.0
            return n
        end
        
        local function round_to_five(n)
            n = n/5
            n = math.floor(n)
            n = n*5.0
            return n
        end

        local function multiply_and_round(n, e)
            n = n * e
            if (n > 100) then
                n = round_to_ten(n)
            else
                n = round_to_five(n)
            end
            return n
        end

        local round_to_inv30=Spring.Utilities.to_make_op_things.round_to_inv30
        
        local rmultiplier = 1
        
        if ud.metalCost then
            rmultiplier = ud.metalCost
            ud.metalCost = math.pow(ud.metalCost, 1.125)
            ud.metalCost = round_to_ten(ud.metalCost)
            rmultiplier = ud.metalCost/rmultiplier

            if ud.health then
                ud.health = multiply_and_round(ud.health, rmultiplier*0.95)
            end
            if ud.speed then
                ud.speed = multiply_and_round(ud.speed, 1+(rmultiplier*0.035))
            end
            if ud.rspeed then
                ud.rspeed = multiply_and_round(ud.rspeed, 1+(rmultiplier*0.035))
            end
            if ud.buildspeed then
                ud.buildspeed = multiply_and_round(ud.buildspeed, rmultiplier)
            end
            if ud.power then
                ud.power = multiply_and_round(ud.power, rmultiplier)
            end
            if ud.energyCost then
                ud.energyCost = multiply_and_round(ud.energyCost, rmultiplier*0.9)
            end
            if ud.sightDistance then
                ud.sightDistance = multiply_and_round(ud.sightDistance, 1+(rmultiplier*0.03))
            end
            if ud.idleAutoHeal then
                ud.idleAutoHeal = multiply_and_round(ud.idleAutoHeal, rmultiplier*0.9)
            end
            --if ud.customparams and ud.customparams.armored_regen then
            --	ud.customparams.armored_regen = tostring(multiply_and_round(tonumber(ud.customparams.armored_regen), rmultiplier))
            --end tostring() tonumber() math.max() doesn't work and doesn't announce error, seems to stop the entire script from running
            
            if ud.weaponDefs then
                for weaponname, wd in pairs(ud.weaponDefs) do
                    if wd.range then
                        wd.range = multiply_and_round(wd.range, 1+(rmultiplier*0.04))
                    end
                    if wd.flightTime then
                        wd.flightTime = multiply_and_round(wd.flightTime, 1+(rmultiplier*0.06))
                    end
                    if wd.areaOfEffect then
                        wd.areaOfEffect = multiply_and_round(wd.areaOfEffect, 1+(rmultiplier*0.1))
                    end
                    if wd.duration then
                        wd.duration = multiply_and_round(wd.duration, 1+(rmultiplier*0.1))
                    end
                    if wd.reloadtime then
                        wd.reloadtime = round_to_inv30( wd.reloadtime*(0.75+((2/(1+rmultiplier))*0.25)) )
                    end
                    if wd.damage and wd.damage.default then
                        wd.damage.default = multiply_and_round(wd.damage.default, rmultiplier*0.85)
                    end
                    if wd.damage and wd.damage.planes then
                        wd.damage.planes = multiply_and_round(wd.damage.planes, rmultiplier*0.85)
                    end
                    if wd.shieldPower then
                        wd.shieldPower = multiply_and_round(wd.shieldPower, rmultiplier*0.9)
                    end
                    if wd.shieldPowerRegen and wd.shieldPowerRegen > 0 then
                        wd.shieldPowerRegen = multiply_and_round(wd.shieldPowerRegen, rmultiplier*0.9)
                    end
                    if wd.customParams then
                        local wdcp=wd.customParams
                        if  wdcp.burntime then
                            wdcp.burntime = multiply_and_round(wdcp.burntime, rmultiplier*0.65)
                        end
                        if  wdcp.light_radius then
                            wdcp.light_radius = multiply_and_round(wdcp.light_radius, rmultiplier*0.65)
                        end
                        if  wdcp.disarmtimer then
                            wdcp.disarmtimer = multiply_and_round(wdcp.disarmtimer, 1+(rmultiplier*0.5))
                        end
                        if  wdcp.extra_damage then
                            wdcp.extra_damage = multiply_and_round(wdcp.extra_damage, rmultiplier*0.85)
                        end
                        if  wdcp.timeslow_damagefactor then
                            wdcp.timeslow_damagefactor = multiply_and_round(wdcp.timeslow_damagefactor, rmultiplier*0.85)
                        end
                        if  wdcp.combatrange then
                            wdcp.combatrange = multiply_and_round(wdcp.combatrange, 1+(rmultiplier*0.03))
                        end
                        if  wdcp.shield_drain then
                            wdcp.shield_drain = multiply_and_round(wdcp.shield_drain, rmultiplier*0.9)
                        end
                        if wdcp.area_damage_dps then
                            wdcp.area_damage_dps = multiply_and_round(wdcp.area_damage_dps, rmultiplier*0.85)
                        end
                        if wdcp.area_damage then
                            wdcp.area_damage = multiply_and_round(wdcp.area_damage_damage, rmultiplier*0.85)
                        end
                        if wdcp.area_damage_radius then
                            wdcp.area_damage_radius = multiply_and_round(wdcp.area_damage_radius, 1+(rmultiplier*0.1))
                        end
                    end
                end
            end
        end
    end

    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
end