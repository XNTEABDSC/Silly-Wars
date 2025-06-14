VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local procUnits={
    "staticcontanky",
    "turretlaser",
    "turretriot",
    "energypylon",
    "energyfusiontanky",
    "turretheavy",
    "turretantiheavy",
}

local UDBase=utils.GetUnitLua("tacnuke")
local tbnil=utils.None


local procUnitNewUDs={}

local function MakeDeployer(ud,udname)
    local newUd=Spring.Utilities.CopyTable(UDBase,true)
    utils.table_replace({
        name="Long-Range " .. ud.name .. " Deployer",
        description="Missile to deploy " .. ud.name,
        metalCost=ud.metalCost*1.5,
        --objectName=[[clawshell.s3o]],--ud.objectName,
        buildPic=ud.buildPic,
        weaponDefs={
            WEAPON={
                name=ud.name .. "Deployer",
                areaOfEffect=tbnil,
                damage={
                    default=1,
                },
                customParams={
                    damage_vs_shield=ud.metalCost*2,
                    spawns_name=udname,
                    spawn_blocked_by_shield=1,
                },
                model=ud.objectName,
                explosionGenerator= [[custom:dirt]],
                impulseBoost=0,
                impulseFactor=0,
                soundHit                = [[weapon/cannon/badger_hit]],
                weaponAcceleration=90,
                weaponVelocity=600,
                weaponTimer=4.5,
            }
        },
        customParams={
            translations=[=[{
                en={
                    name = "Long-Range ]=] .. ud.name .. [=[ Deployer",
                    description = "Missile to deploy ]=] .. ud.name .. [=[",
                    helptext = "To deploy ]=].. ud.name ..[=[ at distance",
                }
            }]=]
        }
    })(newUd)
    return newUd
end

for key, ToUdname in pairs(procUnits) do
    local toud=utils.GetUnitLua(ToUdname)
    local res=MakeDeployer(toud,ToUdname)
    procUnitNewUDs["missiledeploy" .. ToUdname]=res
end
utils.table_replace({
    weaponVelocity=1800,
    weaponAcceleration=270,
    weaponTimer=2,
})(procUnitNewUDs["missiledeploy" .. "turretlaser"].weaponDefs.WEAPON)
utils.table_replace({
    weaponVelocity=1800,
    weaponAcceleration=270,
    weaponTimer=2,
})(procUnitNewUDs["missiledeploy" .. "turretriot"].weaponDefs.WEAPON)

for udname, ud in pairs(procUnitNewUDs) do
    utils_op.MakeAddBuild("staticmissilesilo",udname)
end

return procUnitNewUDs