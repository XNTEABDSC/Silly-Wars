
if not Spring.GetModOptions().custon_units then return end
--[=[
To Implement custom units
1. set custom units to its real state via Spring.Utilities.CustomUnits.utils.SetCustomUnit
2. on ProjectileCreated, change targeter projectile by ChangeTargeterToRealProj
don't forgot scripts/custom_units.lua

spSetGameRulesParam("CustomUnitDefsCount",#CustomUnitDefs)
spSetGameRulesParam("CustomUnitDefs"..cudid,cudString)

spSendLuaRulesMsg("SyncedAddCustomUnitDef:"..text)

]=]

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

---defs of custom units
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

local initialized=false


GG.CustomUnits={}

GG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local CustomUnitDefsToID={}

local CustomUnitsToDefID={}

---`CustomUnitsToDefID[UnitId] == cudid`
---@type {[UnitId]:integer}
GG.CustomUnits.CustomUnitsToDefID=CustomUnitsToDefID

---`CustomUnitsToDefID[cudstr] == cudid`
---@type {[string]:integer}
GG.CustomUnits.CustomUnitDefsToID=CustomUnitDefsToID

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


    local unitId=spCreateUnit(ud,x, y, z, facing, teamID ,build,flattenGround , targetID, builderID)
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

    utils_ChangeTargeterToRealProj(proID,weaponDefID,cud.weapons[targeterwdid_to_custom_weapon_num[weaponDefID]])
end

local TryGenCustomUnitDef=utils.TryGenCustomUnitDef
local function SyncedAddCustomUnitDef(cudString,playerID)
    if not initialized then
        Spring.Echo("Warning: unit_custom_units: Try SyncedAddCustomUnitDef Before Init. Blocked.")
        return
    end
    local cudid=CustomUnitDefsToID[cudString]
    if CustomUnitDefsToID[cudString] then
        return cudid
    end
    cudid=#CustomUnitDefs+1
    local suc,res=TryGenCustomUnitDef(cudString)
    if suc then
        local cud=res

        CustomUnitDefs[cudid]=cud
        CustomUnitDefsToID[cudString]=cudid

        spSetGameRulesParam("CustomUnitDefsCount",#CustomUnitDefs)
        spSetGameRulesParam("CustomUnitDefs"..cudid,cudString)
        if playerID then
            spSetGameRulesParam("CustomUnitDefs"..cudid.."FromPlayer",playerID)
        end
        SendToUnsynced("UpdateCustomUnitDefs",nil)

        return cudid
    else
        Spring.Echo("Error: CustomUnits: " .. res)
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
    function gadget:RecvLuaMsg(msg,playerID)
        if msg:sub(1,LuaMsgHeadLen)==LuaMsgHead then
            local cudstr=msg:sub(LuaMsgHeadLen+1)
            Spring.Echo("CustomUnits: SyncedAddCustomUnitDef " .. cudstr)
            SyncedAddCustomUnitDef(cudstr,playerID)
        end
    end
    
end

function gadget:UnitDestroyed(unitId)
    CustomUnitsToDefID[unitId]=nil
end


if false then -- test
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
	--gadgetHandler:AddSyncAction('UpdateCustomUnitDefs',CallUnsynced_UpdateCustomUnitDefs)
    local cudcount =spGetGameRulesParam("CustomUnitDefsCount")
    Spring.Echo("DEBUG: unit_custom_units.Initialize: Loading CUDs count: " .. tostring(cudcount))
    if cudcount~=nil then
        for cudid = 1, cudcount do
            local cudStr=spGetGameRulesParam("CustomUnitDefs"..cudid)
            local suc,res=TryGenCustomUnitDef(cudStr)
            if suc then
                CustomUnitDefs[cudid]=res
                CustomUnitDefsToID[cudStr]=cudid
            else
                Spring.Echo("Error: CustomUnits: Failed to load GameRulesParam " .. ("CustomUnitDefs"..cudid) ..
                "\ncudStr: " .. tostring(cudStr) ..
                "\nerror: " .. res)
            end
            
        end
    end
    initialized=true
    local allunits=Spring.GetAllUnits ( )
    for key, unitId in pairs(allunits or {}) do
        local cudid=spGetUnitRulesParam(unitId,"CustomUnitDefId")
        if cudid then
            CustomUnitsToDefID[unitId]=cudid
            local cud=CustomUnitDefs[cudid]
            if cud then
                utils_SetCustomUnit(unitId,cud)
            else
                Spring.Utilities.UnitEcho(unitId,"Error: CustomUnits: Unit's cudid " .. cudid .. " dont matches cud")
            end
            
        end
        --
    end
end

function gadget:Shutdown()
	--gadgetHandler:RemoveSyncAction('UpdateCustomUnitDefs')
    
end

else -- Unsynced

local function WrapToLuaUI_UpdateCustomUnitDefs()
    if (Script.LuaUI('UpdateCustomUnitDefs')) then
        Script.LuaUI.UpdateCustomUnitDefs()
    end
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction('UpdateCustomUnitDefs',WrapToLuaUI_UpdateCustomUnitDefs)
end

function gadget:Shutdown()
	gadgetHandler:RemoveSyncAction('UpdateCustomUnitDefs')
end

end