local base = piece('base')
local drone = piece('drone')
local spSetUnitCOBValue=Spring.SetUnitCOBValue
local spGetUnitRulesParam  = Spring.GetUnitRulesParam
local spGetGameFrame       = Spring.GetGameFrame
local spGetUnitWeaponState = Spring.GetUnitWeaponState
local spSetUnitWeaponState = Spring.SetUnitWeaponState

local SIG_ACTIVATE=8

local emit=drone

local smokePiece={drone}


local waveWeaponDef=WeaponDefs[UnitDefs[unitDefID].weapons[3].weaponDef]--WeaponDefNames[UnitDefs[unitDefID].weapons[3].name]
local WAVE_RELOAD = math.floor(waveWeaponDef.reload * Game.gameSpeed)
local WAVE_TIMEOUT = math.ceil(waveWeaponDef.damageAreaOfEffect / waveWeaponDef.explosionSpeed)* (1000 / Game.gameSpeed) + 200 -- empirically maximum delay of damage was (damageAreaOfEffect / explosionSpeed) - 4 frames

function AutoAttack_Thread()
	Signal(SIG_ACTIVATE)
	SetSignalMask(SIG_ACTIVATE)
	while true do
		Sleep(100)
		local reloaded = select(2, spGetUnitWeaponState(unitID,3))
		if reloaded then
			local gameFrame = spGetGameFrame()
            local reloadMult = spGetUnitRulesParam(unitID, "totalReloadSpeedChange") or 1.0
            local reloadFrame = gameFrame + WAVE_RELOAD / reloadMult
            spSetUnitWeaponState(unitID, 3, {reloadFrame = reloadFrame})
            
            EmitSfx(emit, GG.Script.DETO_W3)
            --FireAnim()
		end
	end
end

function script.Create()
	StartThread(GG.Script.SmokeUnit, unitID, smokePiece)
	Spring.SetUnitNanoPieces(unitID, {drone})
end

function script.Activate()
	StartThread(AutoAttack_Thread)
end

function script.AimFromWeapon(num)
	return drone
end

-- fake weapon, do not fire
function script.AimWeapon(num)
	return num==3
end

function script.QueryWeapon(num)
	return drone
end

function script.StartBuilding()
	spSetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1);
end


function script.StopBuilding()
	spSetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0);
end

local function Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	if severity < 0.5 then
		Explode(base, SFX.NONE)
		return 1
	else
		Explode(base, SFX.SHATTER)
		return 2
	end
end

function script.Killed(recentDamage, maxHealth)
	Signal(SIG_ACTIVATE) -- prevent pulsing while undead

	-- keep the unit technically alive (but hidden) for some time so that any inbound
	-- pulses know who their owner is (so that they can do no damage to allies)
	return GG.Script.DelayTrueDeath(unitID, unitDefID, recentDamage, maxHealth, Killed, WAVE_TIMEOUT)
end
