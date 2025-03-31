---[=[
--- different from scripts/scriptreload.lua and scripts/goodBurstSalvo.lua
--- this gadget stores ChargeExtra, that 
--- increase when units' weapons are not reloading ,
--- while shift to units' reloadFrame when weapons need it, with the rate canShiftChargePerFrame
--- you cannot set wd.customParams.use_unit_good_burst_salvo=true to let it works automatically,
--- 
--- ChargeExtra = wdcp.script_burst-1 
--- canShiftChargePerFrame = 30/wdcp.script_burst_rate
--- reloadBurstPerSecont = spGetUnitWeaponState(uid,wpnnum,"reloadTime")
--- 
---]=]

if not gadgetHandler:IsSyncedCode() then
	return
end

function gadget:GetInfo()
	return {
		name      = "Good Burst Salvo",
		desc      = "Implement Good Burst Salvo via gadget to avoid script spam",
		author    = "XNTEABDSC",
		date      = "",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true,  --  loaded by default?
	}
end

---SalvoDataWDs[wdid]={chargeExtra,canShiftChargePerFrame,reloadTimePerBurst}?
---@type {[WeaponDefId]:{chargeExtra:integer,canShiftChargePerFrame:integer}}
local SalvoDataWDs={}

---SalvoDataUDsHas[udid]=list<[wpnnum,wdid]>
---@type {[UnitDefId]:list<[integer,WeaponDefId]>}
local SalvoDataUDsHas={}

---SalvoDatas[uid][wpnnum]={chargeExtra,canShiftChargePerFrame,reloadTimePerBurst,currentCharge,lastFrame}
---@type {[UnitId]:{[integer]:{chargeExtra:integer,canShiftChargePerFrame:integer,currentCharge:number,lastFrame:integer}}}
local SalvoDatas={}

local spGetGameFrame=Spring.GetGameFrame
local spSetUnitWeaponState=Spring.SetUnitWeaponState
local spGetUnitWeaponState=Spring.GetUnitWeaponState

---commented
---@param unitId UnitId
---@param wpnnum integer
---@return {chargeExtra:integer,canShiftChargePerFrame:integer,currentCharge:number}|nil
local function GetUnitGoodBurstState(unitId,wpnnum)
    local sdu=SalvoDatas[unitId]
    if not sdu then
        return nil
    end
    local sduw=sdu[wpnnum]
    if not sduw then
        return nil
    end
    return sduw
end

GG.GetUnitGoodBurstState=GetUnitGoodBurstState

for wdid, wd in pairs(WeaponDefs) do
    local wdcp=wd.customParams
    if wdcp.use_unit_good_burst_salvo then
        local script_burst=tonumber( wdcp.script_burst )
        local script_burst_rate=tonumber(wdcp.script_burst_rate)
        
        if script_burst and script_burst_rate then
            SalvoDataWDs[wdid]={
                chargeExtra=script_burst-1,
                canShiftChargePerFrame=1/script_burst_rate/30,
            }
            --Spring.Echo("unit_good_burst_salvo.lua: loaded weapondef " .. tostring(wd.name) .. " wdid " .. wdid .. " chargeExtra: " .. script_burst-1 .. " canShiftChargePerFrame: " .. (1/script_burst_rate/30))
        else
            Spring.Echo("Warning: unit_good_burst_salvo.lua: Bad unit_good_burst_salvo def for weapondef " .. tostring( wd.name))
        end
    end
end

for udid, ud in pairs(UnitDefs) do
    local wpns=ud.weapons
    if wpns then
        for wpnnum, value in pairs(wpns) do
            local wdid=value.weaponDef
            local wd=WeaponDefs[wdid]
            if SalvoDataWDs[wdid] then
                local SalvoDataUDHas=SalvoDataUDsHas[udid] or {}
                SalvoDataUDsHas[udid]=SalvoDataUDHas
                SalvoDataUDHas[#SalvoDataUDHas+1] = {wpnnum,wdid}
                --Spring.Echo("unit_good_burst_salvo.lua: loaded unitdef " .. tostring(ud.name) .. " which has gbs weapon slot " .. wpnnum)
            end
        end
        
    end
end

function gadget:UnitCreated(unitId,unitDefId,unitTeamId)
    local SalvoDataUDHas=SalvoDataUDsHas[unitDefId]
    if SalvoDataUDHas then
        local SalvoData={}
        if false then
            SalvoData=SalvoDatas[unitId]
        end
        SalvoDatas[unitId]=SalvoData
        for _, v in pairs(SalvoDataUDHas) do
            local wpnnum,wdid=v[1],v[2]
            local SalvoDataWD=SalvoDataWDs[wdid]
            if not SalvoDataWD then
                Spring.Echo("Error: unit_good_burst_salvo.lua: Wrong SalvoDataUDsHas for unitdefid " .. tonumber(unitDefId) .. " wpnnum: " .. tonumber(wpnnum) .. " wdid: " .. tonumber(wdid) .. " is not a good_burst_salvo")
                --break
            else
                SalvoData[wpnnum]={
                    chargeExtra=SalvoDataWD.chargeExtra,
                    canShiftChargePerFrame=SalvoDataWD.canShiftChargePerFrame,
                    --reloadChargePerFrame=SalvoDataWD.reloadChargePerFrame,
                    currentCharge=SalvoDataWD.chargeExtra,
                    lastFrame=spGetGameFrame()
                }
            end
        end
    end
end

function gadget:UnitDestroyed(unitId)
    SalvoDatas[unitId]=nil
end

local spGetUnitIsStunned=Spring.GetUnitIsStunned
local spGetUnitRulesParam=Spring.GetUnitRulesParam
local spSetUnitRulesParam=Spring.SetUnitRulesParam

local mmax=math.max
local mmin=math.min
local floor=math.floor

local ALLY_ACCESS = {allied = true}

---commented
---@param uid UnitId
-- ---@param salvoData {[integer]:{chargeExtra:integer,canShiftChargePerFrame:integer,reloadChargePerFrame:integer,currentCharge:number,lastFrame:integer}}
---@param wpnnum integer
---@param reloadMult number
---@param salvoDataW {chargeExtra:integer,canShiftChargePerFrame:integer,currentCharge:number,lastFrame:integer}
---@param f integer
local function ProcessSalvoData(uid,wpnnum, salvoDataW,reloadMult,f)
    local deltaFrame=f-salvoDataW.lastFrame

    local chargeExtra=salvoDataW.chargeExtra
    local canShiftChargePerFrame=salvoDataW.canShiftChargePerFrame
    local currentCharge=salvoDataW.currentCharge
    local chargeFull= (currentCharge>=chargeExtra)

    
    local currentReloadFrame=spGetUnitWeaponState(uid,wpnnum,"reloadFrame")

    local reloadFramePerBurst=spGetUnitWeaponState(uid,wpnnum,"reloadTime")*30 -- notes that this contains reloadMult already

    local reloadChargePerFrame=1/reloadFramePerBurst

    local reloadFrameLast=currentReloadFrame-f

    --[=[
    Spring.Echo("DEBUG: unit_good_burst_salvo.lua: reloadFrameLast: " .. tostring(reloadFrameLast))
    Spring.Echo("DEBUG: unit_good_burst_salvo.lua: currentCharge: " .. tostring(currentCharge))
    ]=]



    if reloadFrameLast<0 then -- reload finish
        if not chargeFull then-- +charge
            currentCharge=currentCharge+reloadChargePerFrame*deltaFrame
        else
        end
    else -- reload not finish, 
        if currentCharge>0 then-- charge -> reload
            --Convert some Charge into reloadFrame
            --
            local canShiftCharge=mmin( deltaFrame*reloadMult*canShiftChargePerFrame,currentCharge)
            local canShiftReloadFrame=canShiftCharge*reloadFramePerBurst
            local ShiftReloadFrame=mmin(canShiftReloadFrame,reloadFrameLast)
            local ShiftCharge=ShiftReloadFrame*reloadChargePerFrame
            --[=[
            Spring.Echo("DEBUG: unit_good_burst_salvo.lua: reloadFramePerBurst: " .. tostring(reloadFramePerBurst))
            Spring.Echo("DEBUG: unit_good_burst_salvo.lua: canShiftChargePerFrame: " .. tostring(canShiftChargePerFrame))
            Spring.Echo("DEBUG: unit_good_burst_salvo.lua: canShiftCharge: " .. tostring(canShiftCharge))
            Spring.Echo("DEBUG: unit_good_burst_salvo.lua: ShiftCharge: " .. tostring(ShiftCharge))
            ]=]

            
            spSetUnitWeaponState(uid,wpnnum,"reloadFrame",currentReloadFrame-ShiftReloadFrame)
            currentCharge=currentCharge-ShiftCharge
            
            
        end
    end

    
    local scriptLoaded=currentCharge + (1-mmax(reloadFrameLast,0)*reloadChargePerFrame)
    ---@type number|nil
    local scriptReloadFrame=f+mmax(reloadFrameLast,0)+(chargeExtra-currentCharge)*reloadFramePerBurst
    if currentCharge>=chargeExtra then
        currentCharge=chargeExtra
        scriptReloadFrame=nil
    end

    spSetUnitRulesParam(uid, "scriptLoaded", scriptLoaded, ALLY_ACCESS)
    spSetUnitRulesParam(uid, "scriptReloadFrame", scriptReloadFrame, ALLY_ACCESS)

    salvoDataW.currentCharge=currentCharge
    salvoDataW.lastFrame=f
end

function gadget:GameFrame(f)
    --local chooosenum=f%3
    for uid, salvoData in pairs(SalvoDatas) do
        do
            local isStunned=spGetUnitIsStunned(uid)
            if not isStunned then
                local reloadMult = (spGetUnitRulesParam(uid, "totalReloadSpeedChange") or 1)
                ---@cast reloadMult number
                for wpnnum, salvoDataW in pairs(salvoData) do 
                    ProcessSalvoData(uid, wpnnum,salvoDataW, reloadMult,f)
                end
            end
        end
    end
end

---comment
---@param uid UnitId
---@param wpnnum integer
---@param salvoDataW {chargeExtra:integer,canShiftChargePerFrame:integer,currentCharge:number,lastFrame:integer}
local function SetUnitGoodBurstSalvo(uid,wpnnum,salvoDataW)
    local salvoData=SalvoDatas[uid] or {}
    SalvoDatas[uid]=salvoData
    salvoData[wpnnum] = salvoDataW
end
GG.GoodBurstSalvo={
    SetUnitGoodBurstSalvo=SetUnitGoodBurstSalvo,
    SalvoDatas=SalvoDatas,
    SalvoDataWDs=SalvoDataWDs,
    SalvoDataUDsHas=SalvoDataUDsHas
}

--[=[
---commented
---@param pid ProjectileId
---@param uid UnitId
---@param wdid WeaponDefId
function gadget:ProjectileCreated(pid,uid,wdid)
    
end
]=]