VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local drp_wd_base={
    --name                    = [[Light Mine Artillery]],
    accuracy                = 1,
    areaOfEffect            = 96,
    craterBoost             = 0,
    craterMult              = 0,
    avoidFriendly           = false,
    customParams            = {
        nofriendlyfire=1,
        force_ignore_ground = [[1]],
        spawn_blocked_by_shield = 1,
        light_radius = 0,
    },
    
    damage                  = {
        default = 20,
    },

    explosionGenerator      = [[custom:dirt]],
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 0,
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
    {"energyfusion",2},
    {"turretheavy",1},
    {"turretantiheavy",1},
    {"staticarty",1}
}

local function make_wd_spam(spamed,burst,expire,model)
    expire=expire or 60
    model=model or utils.get_unit_lua(spamed).objectName
    local wd=Spring.Utilities.CopyTable(drp_wd_base,true)
    wd.customParams.spawns_name = "emppudrp" .. spamed
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
    local newname="emppudrp" .. spamed_list[i][1]
    res[newname]=utils.get_unit_lua(spamed_list[i][1])
    utils.set_free_unit(res[newname])
    --do_copy_tweak_unit(make_copy_tweak(spamed_list[i][1],"pdrp" .. spamed_list[i][1],set_dummy_unit))
    --spamed_list[i][1]=newname
end

local ud=utils.get_unit_lua("pdrp")
ud.name="Disco Rave Party Ex Max Plus Pro Ultra"
ud.description=ud.description.." Ex Max Plus Pro Ultra"
ud.metalCost=ud.metalCost*1.8
ud.health=ud.health*1.2
local spamer_wds={}
for i = 1, 6 do
    spamer_wds[i]=make_wd_spam(spamed_list[i][1],spamed_list[i][2])
    ud.weaponDefs[spamer_wds[i].name]=spamer_wds[i]
    ud.weapons[i].def=spamer_wds[i].name
end
utils.set_morth_mul("def_post","pdrp","emppudrp")
res["emppudrp"]=ud
return res
