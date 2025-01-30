

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


---@type {[integer]:CustomUnitDataFinal}
local CustomUnitDefs={}

VFS.Include("LuaRules/Configs/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCustomUnitData
local jsondecode=Spring.Utilities.json.decode

local INLOS_ACCESS={inlos=true}


local function GenCustomUnitDef(cudTable)
    local cud_mod=GenCUD_mod(cudTable)
    local cud=utils.GenCustomChassisDataFinal(cud_mod)
    return cud
end




GG.CustomUnits={}

GG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local CustomUnitsToDefID={}

GG.CustomUnits.CustomUnitsToDefID=CustomUnitsToDefID

local spCreateUnit=Spring.CreateUnit
local utils_SetCustomUnit=utils.SetCustomUnit
local utils_ChangeTargeterToRealProj=utils.ChangeTargeterToRealProj
local spValidUnitID=Spring.ValidUnitID
local spSetGameRulesParam=Spring.SetGameRulesParam
local spSetUnitRulesParam=Spring.SetUnitRulesParam
local SendToUnsynced=SendToUnsynced

local function SpawnCustomUnit(cudid,x, y, z, facing, teamID ,build,flattenGround ,builderID)
    local cud=CustomUnitDefs[cudid]
    if not cud then
        Spring.MarkerAddPoint(x, y, z,"CustomUnits: SpawnCustomUnit: CustomUnitDefs[cudid]==nil. cudid:" .. cudid)
        return nil
    end
    local unitId=spCreateUnit(cud.unitDef,x, y, z, facing, teamID ,build,flattenGround ,builderID)
    if not unitId then
        Spring.MarkerAddPoint(x, y, z,"CustomUnits: SpawnCustomUnit: Failed to create unit")
        --Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command: Failed to create unit")
        return nil
    end
    CustomUnitsToDefID[unitId]=cudid
    spSetUnitRulesParam(unitId,"custom_unit_def_id",cudid,INLOS_ACCESS)
    utils_SetCustomUnit(unitId,cud)
    return unitId
end

GG.CustomUnits.SpawnCustomUnit=SpawnCustomUnit

--[=[
for i = 1, 8 do
    Script.SetWatchWeapon(wd.id,true)
end
]=]

local targeterwdid_to_custom_weapon_num=utils.targeterwdid_to_custom_weapon_num

local spGetProjectileDefID=Spring.GetProjectileDefID

for key, value in pairs(targeterwdid_to_custom_weapon_num) do
    Script.SetWatchWeapon(key,true)
end
function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
    if not spValidUnitID(proOwnerID) then
        return
    end
    weaponDefID=weaponDefID or spGetProjectileDefID(proID)

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

    utils_ChangeTargeterToRealProj(proID,cud.weapons[targeterwdid_to_custom_weapon_num[weaponDefID]])
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
        Spring.Echo("Error: CustimUnits: failed to parse CustomUnitDef String " .. cudString .. " with error " .. res)
        return nil
    end
end

GG.CustomUnits.SyncedAddCustomUnitDef=SyncedAddCustomUnitDef


local function CreateCustomUnitscript(unitId)
    local cud=CustomUnitDefs[ CustomUnitsToDefID[unitId] ]
    local o={custom_unit_data=cud}
    local custom_weapon_num_to_unit_weapon_num=cud.custom_weapon_num_to_unit_weapon_num
    local unit_weapon_num_to_custom_weapon_num=cud.unit_weapon_num_to_custom_weapon_num
    local weapons=cud.weapons
    o.custom_weapon_num_to_unit_weapon_num=custom_weapon_num_to_unit_weapon_num
    o.unit_weapon_num_to_custom_weapon_num=unit_weapon_num_to_custom_weapon_num
    o.weapons=weapons
    return o
end

GG.CustomUnits.CreateCustomUnitscript=CreateCustomUnitscript

--gadgetHandler:RegisterGlobal(gadget,"SyncedAddCustomUnitDef",SyncedAddCustomUnitDef)
do
    local LuaMsgHead="SyncedAddCustomUnitDef:"
    local LuaMsgHeadLen=LuaMsgHead:len()
    ---@param msg string
    function gadget:RecvLuaMsg(msg)
        if msg:sub(1,LuaMsgHeadLen)==LuaMsgHead then
            local cudstr=msg:sub(LuaMsgHeadLen+1)
            Spring.Echo("CustomUnits: SyncedAddCustomUnitDef " .. cudstr)
            SyncedAddCustomUnitDef(cudstr)
        end
    end
    
end

function gadget:UnitDestroyed(unitId)
    CustomUnitsToDefID[unitId]=nil
end


if true then -- test
    local jsonencode=Spring.Utilities.json.encode -- ill use loadstring if there is no safity problem
    SyncedAddCustomUnitDef(jsonencode({
        "custom_ravager",{
            motor=100,
            armor=100,
            add_weapon_1={"custom_plasma",{
                damage=10,
                range=1,
                speed=1,
                reload_time=10,
            }},
        }
    }))
    SyncedAddCustomUnitDef(jsonencode({
        "custom_hermit",{
            motor=100,
            armor=100,
            add_weapon_2={"custom_plasma",{
                damage=100,
                range=1,
                speed=1,
                reload_time=1,
            }},
            add_weapon_1={"custom_particle_beam",{
                damage=10,
                range=1,
                reload_time=10,
            }},
        }
    }))
end

end