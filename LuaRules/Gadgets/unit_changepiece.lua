function gadget:GetInfo()
	return {
		name      = "Change Pieces",
		desc      = "changes the geometry and texture of defined unit pieces",
		author    = "Pressure Line",
		date      = "June, 2012",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true --loaded by default?
	}
end

--------------------------------------------------------------------------------

local Debug = true --turn on/off verbose debug messages

--------------------------------------------------------------------------------
--load Drawdefs
--------------------------------------------------------------------------------

local drawDefNames  = VFS.Include"LuaRules/Configs/changepiece_defs.lua"

local drawDefs = {}

for name, data in pairs(drawDefNames) do
  drawDefs[UnitDefNames[name].id] = data
end

--------------------------------------------------------------------------------
--Displaylist table stuff
--------------------------------------------------------------------------------

local DLists = {}

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
		DelayedCall(function()
			if Debug then  Spring.Echo("unit_draw.lua: Loading source models for "..UnitDefs[unitDefID].name) end
			for count,pieceDef in pairs(drawDefs[unitDefID]) do
				local spName = pieceDef[2]
				local sourceunitID = Spring.CreateUnit(pieceDef[1],64,65536,64,0,gtID)
				Spring.SetUnitNeutral(sourceunitID,true)
				SendToUnsynced("LoadDLists",unitDefID,sourceunitID)
				Spring.DestroyUnit(sourceunitID)
			end
			if Debug then Spring.Echo("unit_draw.lua: Source model loading completed") end
			SendToUnsynced("OnUnitCreated", unitID)
		end)
	end
end

--------------------------------------------------------------------------------
else --unsynced
--------------------------------------------------------------------------------

function gadget:Initialize()
	if Debug then
		Spring.Echo("unit_changepiece.lua: Initializing in debug mode")
		Spring.Echo("unit_changepiece.lua: To deactivate debug mode set 'Debug' to false in unit_changepiece.lua")
	else
		Spring.Echo("unit_changepiece.lua: Initializing in game mode")
		Spring.Echo("unit_changepiece.lua: To activate debug mode set 'Debug' to true in unit_changepiece.lua")
	end
	gadgetHandler:AddSyncAction("LoadDLists", CreateDList)
	gadgetHandler:AddSyncAction("OnUnitCreated", SetupUnit)
	Spring.Echo("unit_changepiece.lua: Initialization complete")
end --eof

function gadget:SetupUnit(unitID) --set the unit materials and displaylists
	local unitDefID = Spring.GetUnitDefID(unitID)
	if Debug then Spring.Echo("unit_changepiece.lua: Setting up materials and displaylists for "..UnitDefs[unitDefID].name) end

	--setup materials--
	Spring.UnitRendering.SetLODCount(unitID,1)
	Spring.UnitRendering.SetLODLength(unitID,1,-1000)
	Spring.UnitRendering.SetMaterial(unitID,1,"opaque",{shader="s3o",texunit0='%'..unitDefID..":0",texunit1='%'..unitDefID..":1"})
	Spring.UnitRendering.SetMaterial(unitID,1,"shadow",{shader="s3o"})
	Spring.UnitRendering.SetMaterial(unitID,1,"alpha",{shader="s3o"})

	--setup displaylists--
	local pieces = Spring.GetUnitPieceList(unitID)
	
	for pID,pName in pairs(pieces) do --set all piece displaylists to default
		Spring.UnitRendering.SetPieceList(unitID,1,pID,nil)
	end
	
	local drawDef = drawDefs[unitDefID]
	
	for pID,pName in pairs(pieces) do
		for _,pieceDef in pairs(drawDef) do
			local tpName = pieceDef[3]
			if (pName == tpName)then
				local mpName = pieceDef[2]
				for dlID,dlName in pairs(DLists) do
					if(dlName == mpName)then
						if Debug then Spring.Echo("unit_changepiece.lua: Setting "..pName.." displaylist to "..dlName) end
						Spring.UnitRendering.SetPieceList(unitID,1,pID,dlID) --change the piece displaylist
					end
				end					
			end
		end		
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
	if Debug then Spring.Echo("unit_changepiece.lua: Materials and displaylists setup complete") end
end --eof


function gadget:CreateDList(unitDefID,sourceunitID) --Create the displaylists
	local drawDef = drawDefs[unitDefID]
	local sourceunitDefID = Spring.GetUnitDefID(sourceunitID)
	local pieces = Spring.GetUnitPieceList(sourceunitID)
	
	for pieceID,pieceName in pairs(pieces) do
		for count,pieceDef in pairs(drawDef) do
			if(pieceName == pieceDef[2]) then
				local DListIDCheck = 1
				
				for key,value in pairs(DLists) do --Check the DList table to make sure we aren't duplicating IDs
					if(value == pieceName) then
						DListIDCheck = 2 --this displaylistID is already in use, which means it has already been loaded
					end
				end
				
				if(DListIDCheck ~= 2) then --this displaylistID is free, create a new displaylist
					if Debug then Spring.Echo("unit_changepiece.lua: Creating displaylist "..pieceName) end
					local DList = gl.CreateList(function()
						gl.PushAttrib(GL.TEXTURE_BIT)
							gl.Texture(0,'%'..sourceunitDefID..":1")
							gl.UnitPiece(sourceunitID,pieceID)
							gl.Texture(0,'%'..sourceunitDefID..":0")
							gl.Texture(1,'%'..sourceunitDefID..":1")
							gl.UnitPiece(sourceunitID,pieceID)
						gl.PopAttrib()
					end)
					DLists[DList]=pieceName
					if Debug then Spring.Echo("unit_changepiece.lua: Created displaylist "..pieceName) end
				end
			end
		end
	end

	for key1,value1 in pairs(DLists)do --print out a list of the currently loaded displaylists
		Spring.Echo("unit_changepiece.lua: Currently loaded displaylist "..key1.." "..value1)
	end
end --eof

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------