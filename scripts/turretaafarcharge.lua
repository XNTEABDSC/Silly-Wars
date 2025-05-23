include 'constants.lua'

--------------------------------------------------------------------------------
-- pieces
--------------------------------------------------------------------------------

-- unused pieces: anteny, ozdoba

local cervena = piece 'cervena'
local modra = piece 'modra'
local zelena = piece 'zelena'
local spodni_zebra = piece 'spodni_zebra'
local vrchni_zebra = piece 'vrchni_zebra'
local trubky = piece 'trubky'

local solid_ground = piece 'solid_ground'
local gear = piece 'gear'
local plovak = piece 'plovak'
local gear001 = piece 'gear001'
local gear002 = piece 'gear002'
local rotating_bas = piece 'rotating_bas'
local mc_rocket_ho = piece 'mc_rocket_ho'
local raketa = piece 'raketa'
local raketa_l = piece 'raketa_l'
local raketa002 = piece 'raketa002'
local raketa002_l = piece 'raketa002_l'
local raketa004 = piece 'raketa004'
local raketa004_l = piece 'raketa004_l'
local raketa006 = piece 'raketa006'
local raketa006_l = piece 'raketa006_l'
local raketa007 = piece 'raketa007'
local raketa007_l = piece 'raketa007_l'
local raketa008 = piece 'raketa008'
local raketa008_l = piece 'raketa008_l'
local raketa009 = piece 'raketa009'
local raketa009_l = piece 'raketa009_l'
local raketa010 = piece 'raketa010'
local raketa010_l = piece 'raketa010_l'
local raketa011 = piece 'raketa011'
local raketa011_l = piece 'raketa011_l'
local raketa012 = piece 'raketa012'
local raketa012_l = piece 'raketa012_l'
local raketa013 = piece 'raketa013'
local raketa013_l = piece 'raketa013_l'
local raketa014 = piece 'raketa014'
local raketa014_l = piece 'raketa014_l'
local raketa026 = piece 'raketa026'
local raketa026_l = piece 'raketa026_l'
local raketa027 = piece 'raketa027'
local raketa027_l = piece 'raketa027_l'
local flare = {piece 'flare_l',piece 'flare_r'}
local raketa_total_count=14
--- len=14
local raketa_r_pieces={
	raketa,raketa002,raketa004,
	raketa027,
	raketa006,raketa007,raketa008,raketa009,raketa010,raketa011,raketa012,raketa013,raketa014,
	raketa026,}
local raketa_l_pieces={
	raketa_l,raketa002_l,raketa004_l,
	raketa027_l,
	raketa006_l,raketa007_l,raketa008_l,raketa009_l,raketa010_l,raketa011_l,raketa012_l,raketa013_l,raketa014_l,
	raketa026_l}

local raketa_pieces={raketa_r_pieces,raketa_l_pieces}

--- len= 13
--- 

local RELOAD_SPEED = 20

local raketa_r_trail={
		{0, 4.8, 0},          -- raketa (step14)
		{0.2, 5, 0},          -- raketa002 (step12)
		{0.2, 5.2, 0},        -- raketa004 (step11)
		{1.2, 4, 0},          -- raketa027 (step10)
		{3.6, 3, 0},          -- raketa006 (step9)
		{4.6, 1.6, -1.8},     -- raketa007 (step8)
		{5.2, -1, -0.4},      -- raketa008 (step7)
		{4.2, -2.8, 0.4},     -- raketa009 (step6)
		{2.2, -4.2, 0.2},     -- raketa010 (step5)
		{1.6, -4.6, 1.9},     -- raketa011 (step4)
		{-0.3, -4.1, 2.5},    -- raketa012 (step3)
		{-1.5, -3.6, 3.3},    -- raketa013 (step2)
		{-2.5, -3.9, 4},      -- raketa014 (step1)
}

local raketa_l_trail={
	{0.2, 4.5, 0},        -- raketa_l (step14)
	{-0.2, 4.9, 0},       -- raketa002_l (step12)
	{-0.8, 4.2, 0},       -- raketa004_l (step11)
	{-1.6, 4.1, 0},       -- raketa027_l (step10)
	{-3.6, 3, 0},         -- raketa006_l (step9)
	{-4.6, 1.6, -1.8},    -- raketa007_l (step8)
	{-5.2, -1, -0.4},     -- raketa008_l (step7)
	{-4.2, -2.8, 0.4},    -- raketa009_l (step6)
	{-2.2, -4.2, 0.2},    -- raketa010_l (step5)
	{-1.6, -4.6, 1.9},    -- raketa011_l (step4)
	{0.3, -4.1, 2.5},     -- raketa012_l (step3)
	{1.5, -3.6, 3.3},     -- raketa013_l (step2)
	{2.5, -3.9, 4},       -- raketa014_l (step1)
}

local raketa_trail={raketa_r_trail,raketa_l_trail}

local raketa_trail_vel_factor={{},{}}
do
	for i=1,2 do
		local raketa_trail_=raketa_trail[i]
		local raketa_trail_vel_factor_=raketa_trail_vel_factor[i]
		for key, value in pairs(raketa_trail_) do
			local move_len_sq=value[1]*value[1]+value[2]*value[2]+value[3]*value[3]
			local move_len=math.sqrt(move_len_sq)
			local factor=RELOAD_SPEED/move_len
			raketa_trail_vel_factor_[key]=factor
		end
	end
end


local pos_state={{},{}}
local pos_state_exist=1
local pos_state_empty=0
--local pos_state_moving_in=2
local pos_state_moving_out=2

local function check(lr,pos)
	Spring.Echo("lr: " .. tostring(lr) .. "pos: " .. tostring(pos) )
	local v=pos_state[lr][pos]
	--Spring.Echo(bit_and(v,pos_state_exist) .. ", " .. bit_and(v,pos_state_moving_in) .. ", " .. bit_and(v,pos_state_moving_out))
end

for lr=1,2 do
	local pos_state_=pos_state[lr]
	for i=1,raketa_total_count do
		pos_state_[i]=pos_state_exist
	end
end

local reloadMult=1
local function setReloadMultThread()
	while true do
		local stunnedOrInbuild = Spring.GetUnitIsStunned(unitID)
		reloadMult = (stunnedOrInbuild and 0) or (Spring.GetUnitRulesParam(unitID, "totalReloadSpeedChange")--[[@as number]] or 1)
		Sleep(100)
	end
end
local IsInMove=Spring.UnitScript.IsInMove
local function raketa_try_move1(lr,pos)
	if pos>=raketa_total_count or pos<1 then
		return
	end

	local newPos=pos+1

	local pos_state_=pos_state[lr]


	--check(lr,pos)
	--check(lr,newPos)

	if pos_state_[pos]~=pos_state_exist then
		--Spring.Echo("A")
		return
	end
	
	if pos_state_[newPos]==pos_state_exist then
		--Spring.Echo("C")
		return
	end

	
	local piece=raketa_pieces[lr][pos]
	local nextPiece=raketa_pieces[lr][newPos]

	local moves=raketa_trail[lr][pos]
	local move_vel_factor=raketa_trail_vel_factor[lr][pos]
	--[=[
	pstate=bit_xor(pstate,pos_state_exist)--pos_state_moving_out
	pstate=bit_or(pstate,pos_state_moving_out)--pos_state_moving_out
	--]=]

	pos_state_[pos]=pos_state_moving_out
	
	raketa_try_move1(lr,pos-1)
	raketa_try_move1(lr,newPos)

	StartThread(
		function ()
			Move(piece, x_axis, moves[1], moves[1]*move_vel_factor*reloadMult)
			Move(piece, y_axis, moves[2], moves[2]*move_vel_factor*reloadMult)
			Move(piece, z_axis, moves[3], moves[3]*move_vel_factor*reloadMult)
			Sleep(33)
			while true do
				if not IsInMove(piece,x_axis) and not IsInMove(piece,y_axis) and not IsInMove(piece,z_axis) then
					break
				else
					Move(piece, x_axis, moves[1], moves[1]*move_vel_factor*reloadMult)
					Move(piece, y_axis, moves[2], moves[2]*move_vel_factor*reloadMult)
					Move(piece, z_axis, moves[3], moves[3]*move_vel_factor*reloadMult)
				end
				Sleep(33)
			end
			--Sleep(1000)
			
	
			while true do
				if pos_state_[newPos]==pos_state_empty then
					break
				else
					Sleep(33)
				end
			end
			Hide(piece)
			Move(piece, x_axis, 0)
			Move(piece, y_axis, 0)
			Move(piece, z_axis, 0)
			Show(nextPiece)

			
			pos_state_[pos]=pos_state_empty
			pos_state_[newPos]=pos_state_exist

			raketa_try_move1(lr,pos-1)
			raketa_try_move1(lr,newPos)
		end
	)
end

local function tryMoveAll()
	for lr=1,2 do
		local pos_state_=pos_state[lr]
		for pos_state_pos, value in pairs(pos_state_) do
			raketa_try_move1(lr,pos_state_pos)
		end
	end
end

local raketa_count={raketa_total_count,raketa_total_count}

local function createRaketa(lr,pos)
	
	if pos_state[lr][pos]==pos_state_empty then
		Show(raketa_pieces[lr][pos])
		pos_state[lr][pos]=pos_state_exist
		raketa_try_move1(lr,pos)
		raketa_count[lr]=raketa_count[lr]+1
		return true
	else
		return false
	end
end


local ud=UnitDefs[ Spring.GetUnitDefID(unitID) ]
local wd1 = WeaponDefs[ud.weapons[1].weaponDef ]
local reload1
do
	local cp=wd1.customParams
	local salvoCap=tonumber(cp.script_burst)
	local fullreload=tonumber(cp.script_reload)
	reload1=fullreload/salvoCap/2

end
local sleep_time=1/30
local sleep_mili=1000*sleep_time
local toCreateRaketaReload=0
local function createRaketaThread()
	while true do
		if toCreateRaketaReload<1 then
			toCreateRaketaReload=toCreateRaketaReload+1/reload1*sleep_time*reloadMult
		else
			local lr=1
			if raketa_count[2]<raketa_count[1] then
				lr=2
			end
			if createRaketa(lr,1) then
				toCreateRaketaReload=toCreateRaketaReload-1
			else
				lr=3-lr
				if createRaketa(lr,1) then
					toCreateRaketaReload=toCreateRaketaReload-1
				end
			end

		end
		Sleep(sleep_mili)
	end
end

local function useRocket(lr,pos)
	if pos_state[lr][pos]==pos_state_moving_out then
		Hide(raketa_pieces[lr][pos])
		pos_state[lr][pos]=0
		raketa_try_move1(lr,pos-1)
		raketa_count[lr]=raketa_count[lr]-1
		return true
	else
		return false
	end
end


--[=[
local salvo1=Spring.UnitScript.script_weapon_charging_salvo.newBurstWeaponFromWD(unitID,wd1,addToCreateRaketaCount(1))
local salvo2=Spring.UnitScript.script_weapon_charging_salvo.newBurstWeaponFromWD(unitID,wd2,addToCreateRaketaCount(2))
local salvos={salvo1,salvo2}]=]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--local flares = { flare_l, flare_r }

--------------------------------------------------------------------------------
-- constants and variables
--------------------------------------------------------------------------------
local smokePiece = {rotating_bas, mc_rocket_ho}

local OKP_DAMAGE = tonumber(UnitDefs[unitDefID].customParams.okp_damage)

local TURN_SPEED = math.rad(145)
local GEAR_SPEED = TURN_SPEED * 5
local MOV_DEL = 50

local lastHeading = 0
local rotateWise = 1
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- signals
--------------------------------------------------------------------------------
local SIG_IDLE = 1
local SIG_AIMs={2^1,2^2}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Methods and functions
--------------------------------------------------------------------------------
local function IdleAnim()
	Signal(SIG_IDLE)
	SetSignalMask(SIG_IDLE)
	while true do
		EmitSfx(zelena, 1025)
		
		local heading = math.random() * math.rad(180) - math.rad(90)
		if(lastHeading > heading) then
			rotateWise = 1
		else
			rotateWise = -1
		end
		lastHeading = heading

		
		Spin(gear, y_axis, GEAR_SPEED * rotateWise)
		Spin(gear001, y_axis, GEAR_SPEED * rotateWise)
		Spin(gear002, y_axis, GEAR_SPEED * rotateWise)
	
		Turn(rotating_bas, y_axis, heading, math.rad(60))
		Turn(mc_rocket_ho, x_axis, math.rad(-25)*math.random(), math.rad(60))
		
		WaitForTurn(rotating_bas, y_axis)
		EmitSfx(modra, 1026)
		StopSpin(gear, y_axis)
		StopSpin(gear001, y_axis)
		StopSpin(gear002, y_axis)
		
		
		Sleep(math.random(100, 6500))
	end
end

local stuns = {false, false, true}
function Stunned (stun_type)
	stuns[stun_type] = true
	Signal(SIG_IDLE)
end

function Unstunned (stun_type)
	stuns[stun_type] = false
	if not stuns[1] and not stuns[2] and not stuns[3] then
		StartThread(IdleAnim)
	end
end

local function RestoreAfterDelay()
	--Sleep(2000)
	--StartThread(IdleAnim)
end

function script.Create()
	--Spring.Echo("Vytvořeno")
	--Hide(flare_l)
	--Hide(flare_r)
	
	if GG.Script.onWater(unitID) then
		Hide(solid_ground)
	else
		Hide(plovak)
	end
	
	StartThread(GG.Script.SmokeUnit, unitID, smokePiece)
	--[=[
	for lr=1,2 do
		StartThread(salvos[lr].ReloadThread)
		StartThread(createRaketaThread(lr))
	end]=]
	StartThread(setReloadMultThread)
	StartThread(createRaketaThread)
end
--[=[
function DoAmmoRotate()
	if doingRotation then
		return
	end
	SetSignalMask(0)
	doingRotation = true
	resetRockets()
	
	Show(raketa014_l)
	Show(raketa014)
	
	--1
	Move(raketa014, y_axis, -3.9, RELOAD_SPEED)
	Move(raketa014, x_axis, -2.5, RELOAD_SPEED)
	Move(raketa014, z_axis, 4, RELOAD_SPEED)
	Move(raketa014_l, y_axis, -3.9, RELOAD_SPEED)
	Move(raketa014_l, x_axis, 2.5, RELOAD_SPEED)
	Move(raketa014_l, z_axis, 4, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--2
	Move(raketa013, y_axis, -3.6, RELOAD_SPEED)
	Move(raketa013, x_axis, -1.5, RELOAD_SPEED)
	Move(raketa013, z_axis, 3.3, RELOAD_SPEED)
	Move(raketa013_l, y_axis, -3.6, RELOAD_SPEED)
	Move(raketa013_l, x_axis, 1.5, RELOAD_SPEED)
	Move(raketa013_l, z_axis, 3.3, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--3
	Move(raketa012, y_axis, -4.1, RELOAD_SPEED)
	Move(raketa012, x_axis, -0.3, RELOAD_SPEED)
	Move(raketa012, z_axis, 2.5, RELOAD_SPEED)
	Move(raketa012_l, y_axis, -4.1, RELOAD_SPEED)
	Move(raketa012_l, x_axis, 0.3, RELOAD_SPEED)
	Move(raketa012_l, z_axis, 2.5, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--4
	Move(raketa011, y_axis, -4.6, RELOAD_SPEED)
	Move(raketa011, x_axis, 1.6, RELOAD_SPEED)
	Move(raketa011, z_axis, 1.9, RELOAD_SPEED)
	Move(raketa011_l, y_axis, -4.6, RELOAD_SPEED)
	Move(raketa011_l, x_axis, -1.6, RELOAD_SPEED)
	Move(raketa011_l, z_axis, 1.9, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--5
	Move(raketa010, y_axis, -4.2, RELOAD_SPEED)
	Move(raketa010, x_axis, 2.2, RELOAD_SPEED)
	Move(raketa010, z_axis, 0.2, RELOAD_SPEED)
	Move(raketa010_l, y_axis, -4.2, RELOAD_SPEED)
	Move(raketa010_l, x_axis, -2.2, RELOAD_SPEED)
	Move(raketa010_l, z_axis, 0.2, RELOAD_SPEED)
	
	
	Sleep(MOV_DEL)
	
	--6
	Move(raketa009, y_axis, -2.8, RELOAD_SPEED)
	Move(raketa009, x_axis, 4.2, RELOAD_SPEED)
	Move(raketa009, z_axis, 0.4, RELOAD_SPEED)
	Move(raketa009_l, y_axis, -2.8, RELOAD_SPEED)
	Move(raketa009_l, x_axis, -4.2, RELOAD_SPEED)
	Move(raketa009_l, z_axis, 0.4, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--7
	Move(raketa008, y_axis, -1, RELOAD_SPEED)
	Move(raketa008, x_axis, 5.2, RELOAD_SPEED)
	Move(raketa008, z_axis, -0.4, RELOAD_SPEED)
	Move(raketa008_l, y_axis, -1, RELOAD_SPEED)
	Move(raketa008_l, x_axis, -5.2, RELOAD_SPEED)
	Move(raketa008_l, z_axis, -0.4, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--8
	Move(raketa007, y_axis, 1.6, RELOAD_SPEED)
	Move(raketa007, x_axis, 4.6, RELOAD_SPEED)
	Move(raketa007, z_axis, -1.8, RELOAD_SPEED)
	Move(raketa007_l, y_axis, 1.6, RELOAD_SPEED)
	Move(raketa007_l, x_axis, -4.6, RELOAD_SPEED)
	Move(raketa007_l, z_axis, -1.8, RELOAD_SPEED)
	
	Sleep(MOV_DEL)

	--9
	Move(raketa006, y_axis, 3, RELOAD_SPEED)
	Move(raketa006, x_axis, 3.6, RELOAD_SPEED)
	Move(raketa006, z_axis, 0, RELOAD_SPEED)
	Move(raketa006_l, y_axis, 3, RELOAD_SPEED)
	Move(raketa006_l, x_axis, -3.6, RELOAD_SPEED)
	Move(raketa006_l, z_axis, 0, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--10
	Move(raketa027, y_axis, 4, RELOAD_SPEED)
	Move(raketa027, x_axis, 1.2, RELOAD_SPEED)
	Move(raketa027, z_axis, 0, RELOAD_SPEED)
	Move(raketa027_l, y_axis, 4.1, RELOAD_SPEED)
	Move(raketa027_l, x_axis, -1.6, RELOAD_SPEED)
	Move(raketa027_l, z_axis, 0, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--11 !!!switched l&r (again, so its right)
	Move(raketa004, y_axis, 5.2, RELOAD_SPEED)
	Move(raketa004, x_axis, 0.2, RELOAD_SPEED)
	Move(raketa004, z_axis, 0, RELOAD_SPEED)
	Move(raketa004_l, y_axis, 4.2, RELOAD_SPEED)
	Move(raketa004_l, x_axis, -0.8, RELOAD_SPEED)
	Move(raketa004_l, z_axis, 0, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--12
	Move(raketa002, y_axis, 5, RELOAD_SPEED)
	Move(raketa002, x_axis, 0.2, RELOAD_SPEED)
	Move(raketa002, z_axis, 0, RELOAD_SPEED)
	Move(raketa002_l, y_axis, 4.9, RELOAD_SPEED)
	Move(raketa002_l, x_axis, -0.2, RELOAD_SPEED)
	Move(raketa002_l, z_axis, 0, RELOAD_SPEED)
	
	Sleep(MOV_DEL)
	
	--14
	Move(raketa, y_axis, 4.8, RELOAD_SPEED)
	Move(raketa, x_axis, 0, RELOAD_SPEED)
	Move(raketa, z_axis, 0, RELOAD_SPEED)
	Move(raketa_l, y_axis, 4.5, RELOAD_SPEED)
	Move(raketa_l, x_axis, 0.2, RELOAD_SPEED)
	Move(raketa_l, z_axis, 0, RELOAD_SPEED)
	
	doingRotation = false
	loaded = true
end

function resetRockets()
	Move(raketa, z_axis, -5)
	Move(raketa_l, z_axis, -3)
	Move(raketa, y_axis, -5)
	Move(raketa_l, y_axis, -3)
	setZero(raketa002)
	setZero(raketa004)
	setZero(raketa006)
	setZero(raketa007)
	setZero(raketa008)
	setZero(raketa009)
	setZero(raketa010)
	setZero(raketa011)
	setZero(raketa012)
	setZero(raketa013)
	--setZero(raketa014)
	setZero(raketa002_l)
	setZero(raketa004_l)
	setZero(raketa006_l)
	setZero(raketa007_l)
	setZero(raketa008_l)
	setZero(raketa009_l)
	setZero(raketa010_l)
	setZero(raketa011_l)
	setZero(raketa012_l)
	setZero(raketa013_l)
	--setZero(raketa014_l)
	--setZero(raketa026)
	setZero(raketa027)
	--setZero(raketa026_l)
	setZero(raketa027_l)
end

function setZero(piece)
	Move(piece, x_axis, 0)
	Move(piece, y_axis, 0)
	Move(piece, z_axis, 0)
end

]=]

function script.AimWeapon(num, heading, pitch)
	Signal(SIG_AIMs[num])
	SetSignalMask(SIG_AIMs[num])
	EmitSfx(cervena, 1024)
	if(lastHeading > heading) then
		rotateWise = 1
	else
		rotateWise = -1
	end
	lastHeading = heading

	
	
	Turn(rotating_bas, y_axis, heading, TURN_SPEED)
	
	Spin(gear, y_axis, GEAR_SPEED * rotateWise)
	Spin(gear001, y_axis, GEAR_SPEED * rotateWise)
	Spin(gear002, y_axis, GEAR_SPEED * rotateWise)
	
	Turn(mc_rocket_ho, x_axis, -pitch, math.rad(200))
	WaitForTurn(rotating_bas, y_axis)
	WaitForTurn(mc_rocket_ho, x_axis)
	
	StopSpin(gear, y_axis)
	StopSpin(gear001, y_axis)
	StopSpin(gear002, y_axis)
	
	
	while true do
		if pos_state[num][14]==pos_state_exist then
			break
		else
			--Spring.Echo("Aim: " .. tostring(pos_state[num][14]))
			Sleep(33)
			
		end
	end
	StartThread(RestoreAfterDelay)
	return true
end
function script.FireWeapon(num)
	pos_state[num][14]=pos_state_moving_out
end

function script.EndBurst(num)
	--flare, flare2 = flare2, flare
    --salvos[num].DoShot()
	useRocket(num,14)

	--StartThread(Bum)
end
--[=[
function Bum()
	flare, flare2 = flare2, flare

	if(gun) then
		Hide(raketa026)
				
		Hide(raketa014)
		setZero(raketa014)
		gun = false
	else
		Hide(raketa026_l)
		
		gun = true
		loaded = false
		Hide(raketa014_l)
		setZero(raketa014_l)
	end
end
]=]
function script.QueryWeapon(num)
	return flare[num]
end

function script.AimFromWeapon()
	return mc_rocket_ho
end

function script.BlockShot(num, targetID)
	if pos_state[num][14]~=pos_state_exist then
		return true
	end
	return GG.Script.OverkillPreventionCheck(unitID, targetID, OKP_DAMAGE, 1800, 70, 0.1, true)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth
	if severity <= 0.25 then
		return 1
	elseif severity <= 0.50 then
		Explode(trubky, SFX.FALL)
		Explode(raketa027, SFX.FALL)
		Explode(raketa004, SFX.FALL)
		Explode(raketa011_l, SFX.FALL)
		Explode(raketa008_l, SFX.FALL)
		Explode(raketa009, SFX.FALL)
		Explode(cervena, SFX.FALL)
		Explode(modra, SFX.FALL)
		Explode(zelena, SFX.FALL)
		Explode(spodni_zebra, SFX.FALL)
		Explode(vrchni_zebra, SFX.FALL)
		Explode(mc_rocket_ho, SFX.FALL)
		Explode(rotating_bas, SFX.SHATTER)
		return 1
	else
		Explode(trubky, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(raketa027, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(raketa004, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(raketa011_l, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(raketa008_l, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(raketa009, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(cervena, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(modra, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(zelena, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(spodni_zebra, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(vrchni_zebra, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(mc_rocket_ho, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		Explode(rotating_bas, SFX.SHATTER)
		return 2
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
