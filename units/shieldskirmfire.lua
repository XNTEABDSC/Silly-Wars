
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
return utils.copy_tweak_silly_build_morth("shieldskirm","shieldskirmfire","sillycon",function (ud)
    utils.table_replace({
        name="Napalm " .. ud.name,
        description=ud.description .. "(Napalm)",
        metalCost=260,
        health=950,
        customParams={
            tactical_ai_defs_copy="shieldskirm",
            def_scale=1.3,
        },
        
    })(ud)
    local wd=ud.weaponDefs.STORM_ROCKET
    utils.table_replace({
        name=[[Heavy Napalm Rocket]],
        areaOfEffect=wd.areaOfEffect*1.5,
        damage={
            default=wd.damage.default*0.75,
            planes=wd.damage.planes*0.75,
        },
        customParams={
            burntime = 450,
            burnchance = 1,
            setunitsonfire = 1,
            light_color = "0.95 0.5 0.25",
            light_radius = (wd.customParams.light_radius or (wd.areaOfEffect*1.5)) * 1.25,
            light_camera_height = wd.customParams.light_camera_height + 600,
        },
        craterBoost = 1,
        craterMult = 1,
        soundHit = "weapon/burn_mixed",
        explosionGenerator = "custom:napalm_phoenix",
    })(wd)
end)