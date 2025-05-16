function gadget:GetInfo()
	return {
		name      = "Change Pieces",
		desc      = "changes the geometry and texture of defined unit pieces",
		author    = "Pressure Line",
		date      = "June, 2012",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false --loaded by default?
	}
end

--------------------------------------------------------------------------------

local Debug = true --turn on/off verbose debug messages

--------------------------------------------------------------------------------
--load Drawdefs
--------------------------------------------------------------------------------

local drawDefNames  = VFS.Include"LuaRules/Configs/changepiece_defs.lua"

---drawDefs[udid][i] = (src unit, src piece, tar piece)
---@type {[UnitDefId]:{[integer]:[UnitDefId,string,string]}}
local drawDefs = {}

for name, datas in pairs(drawDefNames) do
	local tarudid=UnitDefNames[name].id
	drawDefs[tarudid] = datas

	for i, data in pairs(datas) do
		local srcud=
		UnitDefNames[
			data[1]
		]
		data[1]=UnitDefNames[data[1]].id
		
	end
end

--------------------------------------------------------------------------------
--Displaylist table stuff
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--Stuff
--------------------------------------------------------------------------------

local gtID = Spring.GetGaiaTeamID()

local delayedCalls = {}

local function DelayedCall(fun)
  delayedCalls[#delayedCalls+1] = fun
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then --synced
--------------------------------------------------------------------------------

function gadget:GameFrame()
  for i=1,#delayedCalls do
    local fun = delayedCalls[i]
    fun()
  end
  delayedCalls = {}
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if drawDefs[unitDefID] then
		--[=[
		DelayedCall(function()
			
			
		end)]=]
		for key, value in pairs(drawDefs[unitDefID]) do
			GG.TryLoadUnitPieceDrawList(value[1])
			
		end
		SendToUnsynced("OnUnitCreated", unitID)
	end
end

--------------------------------------------------------------------------------
else --unsynced
--------------------------------------------------------------------------------

local function DLists()
	return GG.UnitsPieceDrawLists
end

function gadget:Initialize()
	if Debug then
		Spring.Echo("unit_changepiece.lua: Initializing in debug mode")
		Spring.Echo("unit_changepiece.lua: To deactivate debug mode set 'Debug' to false in unit_changepiece.lua")
	else
		Spring.Echo("unit_changepiece.lua: Initializing in game mode")
		Spring.Echo("unit_changepiece.lua: To activate debug mode set 'Debug' to true in unit_changepiece.lua")
	end
	gadgetHandler:AddSyncAction("OnUnitCreated", SetupUnit)
	Spring.Echo("unit_changepiece.lua: Initialization complete")
end --eof

function gadget:SetupUnit(unitID) --set the unit materials and displaylists
	local unitDefID = Spring.GetUnitDefID(unitID)
	if Debug then Spring.Echo("unit_changepiece.lua: Setting up displaylists for "..UnitDefs[unitDefID].name) end

	-- [=[
	--setup materials--
	Spring.UnitRendering.SetLODCount(unitID,1)
	Spring.UnitRendering.SetLODLength(unitID,1,-1000)
	-- ]=]
	-- [=[
	Spring.UnitRendering.SetMaterial(unitID,1,"opaque",{shader="s3o",texunit0='%'..unitDefID..":0",texunit1='%'..unitDefID..":1"})
	Spring.UnitRendering.SetMaterial(unitID,1,"shadow",{shader="s3o"})
	Spring.UnitRendering.SetMaterial(unitID,1,"alpha",{shader="s3o"})
	-- ]=]

	--setup displaylists--
	local pieces = Spring.GetUnitPieceList(unitID)
	local piecesMap = Spring.GetUnitPieceMap(unitID)
	--[=[
	for pID,pName in pairs(pieces) do --set all piece displaylists to default
		Spring.UnitRendering.SetPieceList(unitID,1,pID,nil)
	end
	-- ]=]
	
	local drawDef = drawDefs[unitDefID]
	local DLists=DLists()
	
	for i, pieceReplaceInfo in pairs(drawDef) do
		local srcUnitDefId=pieceReplaceInfo[1]
		local srcPieceName=pieceReplaceInfo[2]
		local tarPieceName=pieceReplaceInfo[3]
		local tarPieceId=piecesMap[tarPieceName]
		local dls=DLists[srcUnitDefId]

		local dlID=dls[srcPieceName]
		--Spring.UnitRendering.SetPieceList(unitID,1,tarPieceId,nil)
		Spring.UnitRendering.SetPieceList(unitID,1,tarPieceId,dlID)
	end
	
--[[for uDID,drawDef in pairs(drawDefs) do --find which pieces need their displaylists changing
		if(Spring.GetUnitDefID(unitID) == uDID)then
			for count,pieceDef in pairs(drawDef) do
				local mpName = pieceDef[2]
				local tpName = pieceDef[3]
				for pID,pName in pairs(pieces) do
					if(pName == tpName)then
						for dlID,dlName in pairs(DLists) do
							if(dlName == mpName)then
								if Debug then Spring.Echo("unit_changepiece.lua: Setting "..pName.." displaylist to "..dlName) end
								Spring.UnitRendering.SetPieceList(unitID,1,pID,dlID) --change the piece displaylist
							end
						end				
					end
				end
			end
		end
	end--]]
	if Debug then Spring.Echo("unit_changepiece.lua: displaylists setup complete") end
end --eof
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------