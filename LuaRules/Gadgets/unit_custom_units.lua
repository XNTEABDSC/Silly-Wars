

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
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal

local PUBLIC_ACCESS={public=true}


local GenCustomUnitDef=utils.GenCustomUnitDef




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
local spGetUnitRulesParam=Spring.GetUnitRulesParam
local SendToUnsynced=SendToUnsynced

local function SpawnCustomUnit(cudid,x, y, z, facing, teamID ,build,flattenGround , targetID, builderID)
    local cud=CustomUnitDefs[cudid]
    if not cud then
        Spring.MarkerAddPoint(x, y, z,"CustomUnits: SpawnCustomUnit: CustomUnitDefs[cudid]==nil. cudid:" .. cudid)
        return nil
    end
    local unitId=spCreateUnit(cud.unitDef,x, y, z, facing, teamID ,build,flattenGround , targetID, builderID)
    if not unitId then
        Spring.MarkerAddPoint(x, y, z,"CustomUnits: SpawnCustomUnit: Failed to create unit")
        --Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command: Failed to create unit")
        return nil
    end
    CustomUnitsToDefID[unitId]=cudid
    spSetUnitRulesParam(unitId,"CustomUnitDefId",cudid,PUBLIC_ACCESS)
    utils_SetCustomUnit(unitId,cud)
    return unitId
end

GG.CustomUnits.SpawnCustomUnit=SpawnCustomUnit


local targeterwdid_to_custom_weapon_num=utils.targeterwdid_to_custom_weapon_num

local spGetProjectileDefID=Spring.GetProjectileDefID

for key, value in pairs(targeterwdid_to_custom_weapon_num) do
    Script.SetWatchWeapon(key,true)
end
function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
    if not targeterwdid_to_custom_weapon_num[weaponDefID] then
        --Spring.Echo("Error: CustomUnits: ??? not watched weapon " .. weaponDefID .. " name " .. WeaponDefs[weaponDefID].name)
        -- idk why this happens
        Script.SetWatchWeapon(weaponDefID,false)
        return
    end
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
        Spring.Utilities.UnitEcho(proOwnerID,"Warning: Custom Unit with unknow cudid " .. cudid)
        return
    end

    utils_ChangeTargeterToRealProj(proID,cud.weapons[targeterwdid_to_custom_weapon_num[weaponDefID]])
end

local TryGenCustomUnitDef=utils.TryGenCustomUnitDef

local function SyncedAddCustomUnitDef(cudString)
    local cudid=#CustomUnitDefs+1
    local suc,res=TryGenCustomUnitDef(cudString)
    if suc then
        local cud=res
        CustomUnitDefs[cudid]=cud
        spSetGameRulesParam("CustomUnitDefsCount",#CustomUnitDefs)
        spSetGameRulesParam("CustomUnitDefs"..cudid,cudString)
        SendToUnsynced("UpdateCustomUnitDefs")
        return cudid
    else
        Spring.Echo("Error: CustimUnits: " .. res)
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
                reload=10,
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
                reload=1,
            }},
            add_weapon_1={"custom_particle_beam",{
                damage=10,
                range=1,
                reload=10,
            }},
        }
    }))
end


local spGetGameRulesParam=Spring.GetGameRulesParam

function gadget:Initialize()
    local cudcount=spGetGameRulesParam("CustomUnitDefsCount")
    if cudcount then
        while #CustomUnitDefs<cudcount do
            local cudid=#CustomUnitDefs+1
            local suc,res=TryGenCustomUnitDef(spGetGameRulesParam("CustomUnitDefs"..cudid))
            CustomUnitDefs[cudid]=res
        end
    end
    local allunits=Spring.GetAllUnits ( )
    for key, unitId in pairs(allunits or {}) do
        local cudid=spGetUnitRulesParam(unitId,"CustomUnitDefId")
        CustomUnitsToDefID[unitId]=cudid
    end
end

end