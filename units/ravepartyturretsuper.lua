VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local udname='ravepartyturretsuper'

local drp_wd_base={
    --name                    = [[Light Mine Artillery]],
    accuracy                = 1,
    areaOfEffect            = 48,
    craterBoost             = 0,
    craterMult              = 0,
    avoidFriendly           = false,
    highTrajectory                = 1,
    customParams            = {
        nofriendlyfire=1,
        force_ignore_ground = [[1]],
        spawn_blocked_by_shield = 1,
        light_radius = 0,
        damage_vs_shield=9000,
    },
    
    damage                  = {
        default = 35,
    },

    explosionGenerator      = [[custom:dirt]],
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 1,
    --model                   = [[clawshell.s3o]],
    myGravity               = 0.1,
    noSelfDamage            = true,
    range                   = 9600,
    reloadtime              = 3.5,
    soundHit                = [[weapon/cannon/badger_hit]],
    soundStart              = [[weapon/cannon/badger_fire]],
    soundHitVolume          = 16,
    soundStartVolume        = 24,
    turret                  = true,
    weaponType              = [[Cannon]],
    weaponVelocity          = 1100,
    sprayangle=600,
    collidefriendly         = false,
}

local res={}

local spamed_list={
    {"turretriot",10},
    {"turretaaflak",4},
    {"energyfusiontanky",1},
    {"turretheavy",1},
    {"turretantiheavy",1},
    {"staticarty",1}
}

local function make_wd_spam(spamed,burst,expire,model)
    expire=expire or 60
    model=model or utils.GetUnitLua(spamed).objectName
    local wd=Spring.Utilities.CopyTable(drp_wd_base,true)
    wd.customParams.spawns_name = udname .. spamed
    wd.customParams.spawns_expire = expire
    wd.model=model
    wd.name=(spamed .. "_spamer"):lower()
    wd.projectiles=burst
    wd.damage={
        default=100/burst+0.1
    }
    --wd.customParams.damage_vs_shield=tostring(2000/burst+0.1)
    wd.soundHitVolume=wd.soundHitVolume/burst
    wd.soundStartVolume=wd.soundStartVolume/burst
    return wd
end

for i=1,6 do
    local newname=udname .. spamed_list[i][1]
    local newud=utils.GetUnitLua(spamed_list[i][1])
    res[newname]=newud
    utils_op.set_free_unit(res[newname])
    newud.idleTime=0
    newud.idleAutoHeal=-newud.health/60
    newud.repairable=false
    newud.reclaimable=false
    --do_copy_tweak_unit(make_copy_tweak(spamed_list[i][1],"pdrp" .. spamed_list[i][1],set_dummy_unit))
    --spamed_list[i][1]=newname
end

local ud=utils.GetUnitLua("ravepartyturret")
ud.name="Super Turret Disco Rave Party"
ud.description="Super Turret Projector"
ud.metalCost=ud.metalCost*1.8
ud.health=ud.health*1.2
ud.fireState=0
ud.highTrajectory                = 1
local spamer_wds={}
for i = 1, 6 do
    spamer_wds[i]=make_wd_spam(spamed_list[i][1],spamed_list[i][2])
    ud.weaponDefs[spamer_wds[i].name]=spamer_wds[i]
    ud.weapons[i].def=spamer_wds[i].name
end

ud.customParams.translations=[=[{
    en={
        name = "Super Turret Disco Rave Party",
        description="Super Turret Projector",
        helptext="Turret Disco Rave Party throws six different units at your enemy for a different surprise each time. Fun for the whone family!"
    }
}]=]


utils_op.MakeSetSillyBuildMorphSimple("ravepartyturret",udname)
res[udname]=ud
return res
