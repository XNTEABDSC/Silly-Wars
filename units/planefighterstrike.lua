VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorph("planefighter","planefighterstrike",function (ud)

    utils.table_replace({
        name=[[OP Swift]],
        description            = [[Fighter, can vs ground]],
        metalCost=300,
        speed=250,
        customParams={
            tactical_ai_defs_copy="planefighter",
            oneclick_weapon_defs_copy="planefighter",
            def_scale=1.4,
            landflystate="1",
        },
        health=750,
        noChaseCategory       = [[SUB]],
        script="planefighterstrike.lua",
    })(ud)
    --ud.weapons={}
    ud.weapons[2]={
        def                = [[MISSILE]],
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    }
    --ud.weapons[1]=ud.weapons[2]
    --ud.weaponDefs.SWIFT_GUN=nil
    utils.table_replace({
        damage={
            default=12,
        },
        customparams={
            script_reload = [[4]],
            script_burst = [[15]],
        },
        reloadtime=0.0333333,
        --tolerance=8000,
        --range=400,
    })(ud.weaponDefs.SWIFT_GUN)
    utils.table_replace({
        isaa=nil,
        canattackground=nil,
        damage={
            default=ud.weaponDefs.MISSILE.damage.planes,
        },
        weaponAcceleration=350,
        startVelocity=120,
        --range=400,
    })(ud.weaponDefs.MISSILE)
    
end)