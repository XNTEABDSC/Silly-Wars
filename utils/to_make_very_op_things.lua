
if not GG.to_make_very_op_things then
    if not GG.to_make_op_things then
        VFS.Include("utils/to_make_op_things.lua")
    else
        local utils=GG.to_make_op_things
        local to_make_very_op_things={}
        GG.to_make_very_op_things=to_make_very_op_things
        function to_make_very_op_things.make_weapon_drunk(wd)
            if wd.range then
                if not wd.sprayangle then
                    wd.sprayangle = 4000 - wd.range
                else
                    wd.sprayangle = wd.sprayangle + 4000 - wd.range
                end
            end
            if not wd.burst then
                wd.burst = 10
            else
                wd.burst = wd.burst * 10
            end
            if wd.reloadtime then
                wd.reloadtime = wd.reloadtime * 2
            end
            --[=[
            if wd.areaofeffect then
                wd.areaofeffect = wd.areaofeffect * 0.1
            end]=]
        end
        function to_make_very_op_things.make_unit_drunk(ud)
            for k,v in pairs(ud.weaponDefs) do
                to_make_very_op_things.make_weapon_drunk(v)
            end
            ud.name="Drunk " .. ud.name
            ud.description="Drunk " .. ud.description
            ud.metalCost=ud.metalCost*4
            ud.health=ud.health*3
            --utils.set_scale(ud,2)
            ud.customParams.def_scale=(ud.customParams.def_scale or 1)* 2
        end
        -- too op
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

            local round_to_inv30=GG.to_make_op_things.round_to_inv30
            
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
        to_make_very_op_things.units_level_up_table={
            scaleMult = 1.025 ,
            maxHPMult = 1.1 ,
            speedMult = 1.025 ,
            senseMult = 1.025 ,
            --econMult = 1.05 ,
            reloadMult = 1.025 ,
            rangeMult = 1.025 ,
            damageMult = 1.025 ,
        }
        function to_make_very_op_things.units_level_up(ud,ulutable,lv)
            for key, value in pairs(ulutable) do
                ulutable[key]=value^lv
            end
            ud.customParams=ud.customParams or {}
            ud.customParams.def_scale= (ud.customParams.def_scale or 1)*ulutable.scaleMult
            ud.health=ud.health*ulutable.maxHPMult
            if ud.speed then
                ud.speed=ud.speed*ulutable.speedMult
            end
            if ud.sightDistance then
                ud.sightDistance=ud.sightDistance*ulutable.senseMult
            end
            if ud.sightDistance then
                ud.sightDistance=ud.sightDistance*ulutable.senseMult
            end
            if ud.sonarDistance then
                ud.sonarDistance=ud.sonarDistance*ulutable.senseMult
            end
            if ud.radarDistance then
                ud.radarDistance=ud.radarDistance*ulutable.senseMult
            end
            for key, value in pairs(ud.weaponDefs) do
                if value.damage then
                    for dmgkey, dmgvalue in pairs(value.damage) do
                        value.damage[dmgkey]=dmgvalue*ulutable.damageMult
                    end
                end
                if value.reloadtime then
                    value.reloadtime=utils.round_to_inv30(value.reloadtime/ulutable.reloadMult)
                end
                if value.range then
                    value.range=value.range*ulutable.rangeMult
                end
            end

        end
        local lowerkeys=utils.lowerkeys
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
                areaOfEffect=0.5,range=0.5,
                burstRate=1,reloadtime=1,sprayangle=0.5,accuracy=0.5,
                weaponVelocity=0.5,startVelocity=0.5,
                craterBoost=1,craterMult=1,mygravity=1,
                shieldPower=1,shieldPowerRegen=1,shieldPowerRegenEnergy=1,shieldRadius=1,
                laserFlareSize=0.5,thickness=0.5,tolerance=1,intensity=1,beamTime=0.5,beamttl=0.5,
                turnRate=0.5,weaponAcceleration=0.5,wobble=0.5,
            })
            local wdcpvalues=lowerkeys({
                burntime=0.5,
                post_capture_reload=0.5,
                timeslow_damagefactor=1,
                extra_damage=1,
            })
            local udvalues=lowerkeys({
                acceleration=0.5,brakeRate=0.5,speed=0.5,turnRate=0.5,
                health=1,
                sightDistance=0.5,radarDistance=0.5,sonarDistance=0.5,minCloakDistance=0.5,radarDistanceJam=0.5,
            })
            local udcpvalues=lowerkeys({
                jump_range=0.5,jump_speed=0.5,jump_reload=1,
                area_cloak_radius=0.5,area_cloak_recloak_rate=1,area_cloak_upkeep=1,specialreloadtime=1,
            })
            function to_make_very_op_things.random_units_balanced_wip(get_rand_mult)
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
    end
end
return GG.to_make_very_op_things