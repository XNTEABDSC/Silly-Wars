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


VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

local INLOS_ACCESS={
    inlos=true
}
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

---@type {[UnitId]:string}
local SalvoDatas_GBSHas={}

local spGetGameFrame=Spring.GetGameFrame
local spSetUnitWeaponState=Spring.SetUnitWeaponState
local spGetUnitWeaponState=Spring.GetUnitWeaponState
local spGetUnitIsStunned=Spring.GetUnitIsStunned
local spGetUnitRulesParam=Spring.GetUnitRulesParam
local spSetUnitRulesParam=Spring.SetUnitRulesParam

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

for wdid, wd in pairs(WeaponDefs) do -- set SalvoDataWDs
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

for udid, ud in pairs(UnitDefs) do -- set SalvoDataUDHas
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


---Add GoodBurstSalvoData for unit's weapon, 
---@param uid UnitId
---@param wpnnum integer
---@param salvoDataW {chargeExtra:integer,canShiftChargePerFrame:integer,currentCharge:number,lastFrame:integer}|nil
---@param currentCharge number?
---@param lastFrame number?
---@param chargeExtra number?
---@param canShiftChargePerFrame number?
local function SetUnitGoodBurstSalvoData(uid,wpnnum,salvoDataW,currentCharge,lastFrame,chargeExtra,canShiftChargePerFrame)
    local salvoData
    if not salvoDataW then
        salvoData=SalvoDatas[uid]
        if not salvoData then -- create salvoData for unit
            salvoData={}
            SalvoDatas[uid]=salvoData
            SalvoDatas_GBSHas[uid]=""
        end
        salvoDataW = salvoData[wpnnum]
    end
    if not salvoDataW then -- create a salvoDataW for unit weapon

        local rulesParamStr=SalvoDatas_GBSHas[uid]
        rulesParamStr=rulesParamStr .. tostring(wpnnum) .. " "
        SalvoDatas_GBSHas[uid]=rulesParamStr
        spSetUnitRulesParam(uid,"GBSHas",rulesParamStr,INLOS_ACCESS)

        if chargeExtra==nil then
            Spring.Utilities.UnitEcho(uid,"Error: unit_good_burst_salvo.lua: SetUnitGoodBurstSalvoData: While Creating, Missing chargeExtra for unit wpnnum " .. wpnnum .. " fn blocked")
            return
        end

        if canShiftChargePerFrame==nil then
            Spring.Utilities.UnitEcho(uid,"Error: unit_good_burst_salvo.lua: SetUnitGoodBurstSalvoData: While Creating, Missing canShiftChargePerFrame for unit wpnnum " .. wpnnum .. " fn blocked")
            return
        end

        if lastFrame==nil then
            --Spring.Utilities.UnitEcho(uid,"Warning: unit_good_burst_salvo.lua: SetUnitGoodBurstSalvoData: Missing lastFrame for unit wpnnum " .. wpnnum .. ", use gameframe")
            --Spring.Echo("Warning: unit_good_burst_salvo.lua: SetUnitGoodBurstSalvoData: Missing lastFrame for unit")
            lastFrame=spGetGameFrame()
        end

        if currentCharge==nil then
            currentCharge=chargeExtra
        end
        salvoDataW={
            lastFrame=lastFrame,
            chargeExtra=chargeExtra,
            canShiftChargePerFrame=canShiftChargePerFrame,
            currentCharge=currentCharge,
        }
        salvoData[wpnnum]=salvoDataW
        spSetUnitRulesParam(uid,"GBSLastFrameOnWpn"..wpnnum,lastFrame,INLOS_ACCESS)
        spSetUnitRulesParam(uid,"GBSChargeExtraOnWpn"..wpnnum,chargeExtra,INLOS_ACCESS)
        spSetUnitRulesParam(uid,"GBSShiftChargeOnWpn"..wpnnum,canShiftChargePerFrame,INLOS_ACCESS)
        spSetUnitRulesParam(uid,"GBSChargeOnWpn"..wpnnum,currentCharge,INLOS_ACCESS)
    else
        if lastFrame then
            salvoDataW.lastFrame=lastFrame
            spSetUnitRulesParam(uid,"GBSLastFrameOnWpn"..wpnnum,lastFrame,INLOS_ACCESS)
        end
        if chargeExtra then
            salvoDataW.chargeExtra=chargeExtra
            spSetUnitRulesParam(uid,"GBSChargeExtraOnWpn"..wpnnum,chargeExtra,INLOS_ACCESS)
        end
        if canShiftChargePerFrame then
            salvoDataW.canShiftChargePerFrame=canShiftChargePerFrame
            spSetUnitRulesParam(uid,"GBSShiftChargeOnWpn"..wpnnum,canShiftChargePerFrame,INLOS_ACCESS)
        end
        if currentCharge then
            salvoDataW.currentCharge=currentCharge
            spSetUnitRulesParam(uid,"GBSChargeOnWpn"..wpnnum,currentCharge,INLOS_ACCESS)
        end
    end
end


local function RemoveUnitGoodBurstSalvo(uid,wpnnum)
    local salvoData=SalvoDatas[uid]
    salvoData[wpnnum]=nil
    spSetUnitRulesParam(uid,"GBSLastFrameOnWpn"..wpnnum,nil,INLOS_ACCESS)
    spSetUnitRulesParam(uid,"GBSChargeExtraOnWpn"..wpnnum,nil,INLOS_ACCESS)
    spSetUnitRulesParam(uid,"GBSShiftChargeOnWpn"..wpnnum,nil,INLOS_ACCESS)
    spSetUnitRulesParam(uid,"GBSChargeOnWpn"..wpnnum,nil,INLOS_ACCESS)

    local rulesParamStr=""
    for k, _ in pairs(salvoData) do
        rulesParamStr=rulesParamStr .. tostring(k) .. " "
    end
    SalvoDatas_GBSHas[uid]=rulesParamStr
    spSetUnitRulesParam(uid,"GBSHas",rulesParamStr,INLOS_ACCESS)
end

function gadget:UnitCreated(unitId,unitDefId,unitTeamId)
    local SalvoDataUDHas=SalvoDataUDsHas[unitDefId]
    if SalvoDataUDHas then
        for _, v in pairs(SalvoDataUDHas) do
            local wpnnum,wdid=v[1],v[2]
            local SalvoDataWD=SalvoDataWDs[wdid]
            if not SalvoDataWD then
                Spring.Echo("Error: unit_good_burst_salvo.lua: Wrong SalvoDataUDsHas for unitdefid " .. tonumber(unitDefId) .. " wpnnum: " .. tonumber(wpnnum) .. " wdid: " .. tonumber(wdid) .. " is not a good_burst_salvo")
                --break
            else
                SetUnitGoodBurstSalvoData(unitId,wpnnum,nil,SalvoDataWD.chargeExtra,spGetGameFrame(),SalvoDataWD.chargeExtra,SalvoDataWD.canShiftChargePerFrame)
                --[=[
                SalvoData[wpnnum]={
                    chargeExtra=SalvoDataWD.chargeExtra,
                    canShiftChargePerFrame=SalvoDataWD.canShiftChargePerFrame,
                    --reloadChargePerFrame=SalvoDataWD.reloadChargePerFrame,
                    currentCharge=SalvoDataWD.chargeExtra,
                    lastFrame=spGetGameFrame()
                }]=]
            end
        end
    end
end

function gadget:UnitDestroyed(unitId)
    SalvoDatas[unitId]=nil
end


local spGetAllUnits=Spring.GetAllUnits
local str_explode=utils.str_explode
function gadget:Initialize()
    for _, uid in pairs(spGetAllUnits()) do
        local GBSHas=spGetUnitRulesParam(uid,"GBSHas")
        if GBSHas and type(GBSHas)=="string" then
            local SalvoData={}
            SalvoDatas[uid]=SalvoData
            SalvoDatas_GBSHas[uid]=GBSHas
            local tb=str_explode(" ",GBSHas)
            if tb then
                for _, wpnnum in pairs(tb) do
                    wpnnum=tonumber(wpnnum)
                    if wpnnum~=nil then
                        local lastFrame=spGetUnitRulesParam(uid,"GBSLastFrameOnWpn"..wpnnum)
                        local chargeExtra=spGetUnitRulesParam(uid,"GBSChargeExtraOnWpn"..wpnnum)
                        local canShiftChargePerFrame=spGetUnitRulesParam(uid,"GBSShiftChargeOnWpn"..wpnnum)
                        local currentCharge=spGetUnitRulesParam(uid,"GBSChargeOnWpn"..wpnnum)
    
                        SalvoData[wpnnum]={
                            lastFrame=lastFrame,
                            chargeExtra=chargeExtra,
                            canShiftChargePerFrame=canShiftChargePerFrame,
                            currentCharge=currentCharge
                        }
                    else
                        Spring.Utilities.UnitEcho(uid,"Error: unit_good_burst_salvo.lua: Bad UnitRulesParam GBSHas for unit, GBSHas: " .. tostring(GBSHas))
                    end
                end
            else
                Spring.Utilities.UnitEcho(uid,"Error: unit_good_burst_salvo.lua: Bad UnitRulesParam GBSHas for unit, GBSHas: " .. tostring(GBSHas))
            end
        else
            --Spring.Utilities.UnitEcho(uid,"Error: unit_good_burst_salvo.lua: Bad UnitRulesParam GBSHas for unit, GBSHas: " .. tostring(GBSHas))
        end
    end
end

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
            local canShiftReloadFrame=canShiftCharge*reloadFramePerBurst-1
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


    SetUnitGoodBurstSalvoData(uid,wpnnum,salvoDataW,currentCharge,f)
    --[=[
    salvoDataW.currentCharge=currentCharge
    salvoDataW.lastFrame=f
    spSetUnitRulesParam(uid,"GBSLastFrame",f)
    spSetUnitRulesParam(uid,"GBSCharge",currentCharge)
    --]=]
    
    --[=[
    spSetUnitRulesParam(uid,"GBSChargeExtra",chargeExtra)
    spSetUnitRulesParam(uid,"GBSCanShiftChargePerFrame",canShiftChargePerFrame)
    ]=]
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

GG.GoodBurstSalvo={
    SetUnitGoodBurstSalvoData=SetUnitGoodBurstSalvoData,
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