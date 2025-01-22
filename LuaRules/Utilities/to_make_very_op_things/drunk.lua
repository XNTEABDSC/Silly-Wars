VFS.Include("LuaRules/Utilities/to_make_very_op_things/include.lua")
if not Spring.Utilities.to_make_very_op_things.make_weapon_drunk then
    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils
    local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

    function to_make_very_op_things.make_weapon_drunk(wd_)
        local wd=utils.may_lower_key_proxy(wd_)
        if wd.range then

            if wd.weaponType=="StarburstLauncher" and wd.weaponVelocity and wd.weaponTimer then
                
                --wd.weaponVelocity=wd.range
                local r=wd.range
                local a=wd.weaponAcceleration
                local v0=(wd.startVelocity or 0)
                local v1=wd.weaponVelocity
                local t=(v1-v0)/a
                if (v1+v0)/2*t>r then
                    -- r=1/2 a t^2 + v t
                    t=(math.sqrt(2*a*r+v0^2)-v0)/a
                end
                local vm=v0+t/2*a
                wd.startVelocity=vm
                wd.weaponAcceleration=0
                wd.weaponVelocity=350
                wd.weaponType="MissileLauncher"
                wd.trajectoryHeight=2
                wd.weaponTimer=nil
                wd.turret=true
            end

            if wd.reloadTime then
                wd.reloadTime = wd.reloadTime * 2
            end
        
            wd.sprayAngle = (wd.sprayAngle or 0) + 4000 / math.log(wd.range/350+1.75)
            --[=[if wd.areaOfEffect then
                wd.areaOfEffect = wd.areaOfEffect * 0.5
            end]=]
            if wd.weaponType=="BeamLaser" then
                wd.projectiles=(wd.projectiles or 1)*10
            else
                local burst=(wd.burst or 1)*10
                if wd.reloadTime and (wd.burstRate or (1/30))*burst>wd.reloadTime then
                    wd.projectiles=(wd.projectiles or 1)*10
                else
                    wd.burst =  burst
                end
            end
            if wd.turnRate and wd.weaponVelocity then
                if (not wd.trajectoryHeight) or (wd.trajectoryHeight<0.4) then
                    wd.trajectoryHeight=0.4
                end
                local dance=wd.range/8
                if wd.tracks then
                    dance=dance*2
                else
                    dance=dance*1
                end
                wd.dance=(wd.dance or 0)+dance
                local wobble=wd.turnRate
                if wd.tracks then
                    wobble=wobble*2
                end
                wd.wobble=(wd.wobble or 0 ) + wobble
            end
        end
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

    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
end