VFS.Include("LuaRules/Utilities/to_make_very_op_things/include.lua")
if not Spring.Utilities.to_make_very_op_things.units_level_up then

    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils

    VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local utils_op=Spring.Utilities.to_make_op_things
    
    local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

    
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
        ulutable=Spring.Utilities.CopyTable(ulutable,true)
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
                value.reloadtime=utils.round_to(value.reloadtime/ulutable.reloadMult, 1/30)
            end
            if value.range then
                value.range=value.range*ulutable.rangeMult
            end
        end

    end

    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
end