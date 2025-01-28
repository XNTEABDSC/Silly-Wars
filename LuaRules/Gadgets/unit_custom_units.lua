

if gadgetHandler:IsSyncedCode() then

function gadget:GetInfo()
    return{
        name      = "Custom Units",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true  --  loaded by default?
    }
end


---@type {[integer]:CustomChassisDataFinal}
local CustomUnitDefs={}

VFS.Include("LuaRules/Configs/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCUD
local jsondecode=Spring.Utilities.json.decode


local function GenCustomUnitDef(cudTable)
    local cud_mod=GenCUD_mod(cudTable)
    local cud=utils.GenCustomChassisDataFinal(cud_mod)
    return cud
end




GG.CustomUnits={}

GG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local CustomUnitsToDefID={}

local spCreateUnit=Spring.CreateUnit
local utils_SetCustomUnit=utils.SetCustomUnit
local utils_ChangeTargeterToRealProj=utils.ChangeTargeterToRealProj
local spValidUnitID=Spring.ValidUnitID
local spSetGameRulesParam=Spring.SetGameRulesParam
local SendToUnsynced=SendToUnsynced

local function SpawnCustomUnit(cudid,x, y, z, facing, teamID ,build,flattenGround ,builderID)
    local cud=CustomUnitDefs[cudid]
    if not cud then
        return false
    end
    local unitId=spCreateUnit(cud.unitDef,x, y, z, facing, teamID ,build,flattenGround ,builderID)
    CustomUnitsToDefID[unitId]=cudid
    utils_SetCustomUnit(unitId,cud)
    return unitId
end

GG.CustomUnits.SpawnCustomUnit=SpawnCustomUnit

local TargeterWD={}

for i = 1, 8 do
    local wd=WeaponDefNames["fake_projectile_targeter"..tostring( i )]
    TargeterWD[ wd.id ]=i
    Script.SetWatchWeapon(wd.id,true)
end

function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
    if not spValidUnitID(proOwnerID) then
        return
    end
    local wpnnum=TargeterWD[weaponDefID]
    if not wpnnum then
        Spring.Echo("Warning: odd wpn shot")
        return
    end

    local cudid=CustomUnitsToDefID[proOwnerID]
    if not cudid then
        Spring.Utilities.UnitEcho(proOwnerID,"Warning: not Custom unit shoting targeter")
        return
    end
    local cud=CustomUnitDefs[cudid]

    if not cud then
        Spring.Utilities.UnitEcho(proOwnerID,"Warning: Custom Unit with unknow id " .. cudid)
        return
    end

    utils_ChangeTargeterToRealProj(proID,cud.weapons[wpnnum])
end
local function SyncedAddCustomUnitDef(cudString)
    local cudid=#CustomUnitDefs+1
    local suc,res=pcall (jsondecode, cudString)
    if suc then
        local cudTable= res
        local suc2,res2=pcall(GenCustomUnitDef,cudTable)
        if suc2 then
            local cud=res2
            CustomUnitDefs[cudid]=cud
            spSetGameRulesParam("CustomUnitDefsCount",#CustomUnitDefs)
            spSetGameRulesParam("CustomUnitDefs"..cudid,cudString)
            SendToUnsynced("UpdateCustomUnitDefs")
            return cudid
        else
            Spring.Echo("Error: CustimUnits: failed to gen CustomUnitDef for " .. cudString .. " with error " .. res2)

        end
    else
        Spring.Echo("Error: CustimUnits: failed to parse cudString " .. cudString .. " with error " .. res)
        return nil
    end
end

GG.CustomUnits.SyncedAddCustomUnitDef=SyncedAddCustomUnitDef

--gadgetHandler:RegisterGlobal(gadget,"SyncedAddCustomUnitDef",SyncedAddCustomUnitDef)

if true then -- test
    local jsonencode=Spring.Utilities.json.encode -- ill use loadstring if there is no safity problem
    SyncedAddCustomUnitDef(jsonencode({
        "custom_ravager",{
            motor=1000,
            armor=1000,
            add_weapon={
                weapon_num=1,
                weapon={"custom_plasma",{
                    damage=125,
                    range=2,
                    speed=2,
                    reload_time=2,
                }}
            },
        }
    }))
end

end