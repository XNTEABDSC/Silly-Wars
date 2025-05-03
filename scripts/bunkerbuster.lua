include "constants.lua"

local base = piece 'base'
local torso = piece 'torso'
local turret = piece 'turret'
local lbarrel = piece 'lbarrel'
local rbarrel = piece 'rbarrel'

local lfrontleg = piece 'lfrontleg'
local lfrontleg1 = piece 'lfrontleg1'

local rfrontleg = piece 'rfrontleg'
local rfrontleg1 = piece 'rfrontleg1'

local laftleg = piece 'laftleg'
local laftleg1 = piece 'laftleg1'

local raftleg = piece 'raftleg'
local raftleg1 = piece 'raftleg1'

local larm=piece 'larm'
local rarm=piece 'rarm'

local SIG_Walk = 1

--constants
local sa = math.rad(-10)
local ma = math.rad(40)
local pause = 440

local forward = 2.2
local backward = 2
local up = 1

local spGetUnitIsStunned = Spring.GetUnitIsStunned
local spGetUnitRulesParam = Spring.GetUnitRulesParam

local smokePiece = {base, lbarrel, rbarrel}

local function UnitScalePiece(unitID, piece, scale)
    local pieceInfo = Spring.GetUnitPieceInfo(unitID, piece)
	if pieceInfo then
		local pieceTable = {
			scale, 0, 0, 0,
			0, scale, 0, 0,
			0, 0, scale, 0,
			pieceInfo.offset[1], pieceInfo.offset[2], pieceInfo.offset[3], 1
		}
		Spring.SetUnitPieceMatrix(unitID, piece, pieceTable)
	end
end

function script.Create()
	Turn(lfrontleg, y_axis, math.rad(45))
	Turn(rfrontleg, y_axis, math.rad(-45))
	Turn(laftleg, y_axis, math.rad(-45))
	Turn(raftleg, y_axis, math.rad(45))

	StartThread(GG.Script.SmokeUnit, unitID, smokePiece)

	UnitScalePiece(unitID,2,2)
	Hide (larm)
	Hide (rarm)
	Hide (lbarrel)
	Hide (rbarrel)
end


local function Walk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	while (true) do

		-- Move(base, y_axis, 1.5, 2*up)
		Turn(lfrontleg, y_axis, 1.5*ma, forward) -- right front forward
		Turn(lfrontleg, z_axis, -ma/2, up)		-- right front up
		Turn(lfrontleg1, z_axis, -ma/3, up)

		Turn(laftleg, y_axis, -1.5*ma, backward) -- right back backward
		Turn(laftleg, z_axis, 0, 6*up)			-- right back down
		Turn(laftleg1, z_axis, 0, up)

		Turn(rfrontleg, y_axis, sa, backward)	 -- left front backward
		Turn(rfrontleg, z_axis, 0, 6*up)		 -- left front down
		Turn(rfrontleg1, z_axis, 0, up)

		Turn(raftleg, y_axis, -sa, forward)	 -- left back forward
		Turn(raftleg, z_axis, ma/2, up)		 -- left back up
		Turn(raftleg1, z_axis, ma/3, up)

		Sleep(pause)

		-- Move(base, y_axis, 0, 4*up)
		Turn(lfrontleg, y_axis, -sa, backward)	-- right front backward
		Turn(lfrontleg, z_axis, 0, 6*up)		 -- right front down
		Turn(lfrontleg1, z_axis, 0, up)

		Turn(laftleg, y_axis, sa, forward)		-- right back forward
		Turn(laftleg, z_axis, -ma/2, up)		 -- right back up
		Turn(laftleg1, z_axis, -ma/3, up)

		Turn(rfrontleg, y_axis, -1.5*ma, forward) -- left front forward
		Turn(rfrontleg, z_axis, ma/2, up)		 -- left front up
		Turn(rfrontleg1, z_axis, ma/3, up)

		Turn(raftleg, y_axis, 1.5*ma, backward) -- left back backward
		Turn(raftleg, z_axis, 0, 6*up)			-- left back down
		Turn(raftleg1, z_axis, 0, up)

		Sleep(pause)
	end
end

local function StopWalk()
	Signal(SIG_Walk)
	SetSignalMask(SIG_Walk)
	Move(base, y_axis, 0, 4*up)
	Turn(lfrontleg, y_axis, 0) 	-- right front forward
	Turn(lfrontleg, z_axis, 0, up)
	Turn(lfrontleg1, z_axis, 0, up)

	Turn(laftleg, y_axis, 0) 	-- right back backward
	Turn(laftleg, z_axis, 0, up)
	Turn(laftleg1, z_axis, 0, up)

	Turn(rfrontleg, y_axis, 0) 	-- left front backward
	Turn(rfrontleg, z_axis, 0, up)
	Turn(rfrontleg1, z_axis, 0, up)

	Turn(raftleg, y_axis, 0) 	-- left back forward
	Turn(raftleg, z_axis, 0, up)
	Turn(raftleg1, z_axis, 0, up)

	Turn(lfrontleg, y_axis, math.rad(45), forward)
	Turn(rfrontleg, y_axis, math.rad(-45), forward)
	Turn(laftleg, y_axis, math.rad(-45), forward)
	Turn(raftleg, y_axis, math.rad(45), forward)
end

function script.StartMoving()
	StartThread(Walk)
end

function script.StopMoving()
	StartThread(StopWalk)
end


local selfd_time=5000
local selfd_thread=0
local slow=tonumber( UnitDef.customParams.combat_slowdown)

local function OnDetonate()

	while selfd_thread<selfd_time do

		Spring.SetUnitCloak(unitID,false)
		local time_delta_raw=100
		local stunnedOrInbuild = Spring.GetUnitIsStunned(unitID)
		local reloadMult = (stunnedOrInbuild and 0) or (Spring.GetUnitRulesParam(unitID, "totalReloadSpeedChange") or 1)
		local time_delta=time_delta_raw*reloadMult
		selfd_thread=selfd_thread+time_delta
		Spin(torso, y_axis, 20*reloadMult, 0.5*reloadMult)

		GG.Attributes.AddEffect(unitID,"script",{move=slow})
		Sleep(time_delta_raw)
		
	end

	Spring.DestroyUnit(unitID,true)
	--spDestroyUnit(toDestroy[i], true)
end

function Detonate()
    StartThread(OnDetonate)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	if severity <= 0.25 then
		Explode(base, SFX.NONE)
		return 1
	elseif severity <= 0.50 then
		Explode(base, SFX.NONE)
		Explode(lbarrel, SFX.FALL + SFX.SMOKE)
		Explode(rbarrel, SFX.FALL + SFX.SMOKE)
		return 1
	else
		Explode(base, SFX.SHATTER)
		Explode(lbarrel, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE)
		Explode(rbarrel, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE)
		return 2
	end
end
