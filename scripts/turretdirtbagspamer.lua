local base = piece('base')
local drone = piece('drone')

function script.AimFromWeapon(num)
	return drone
end

-- fake weapon, do not fire
function script.AimWeapon(num)
	return false
end

function script.QueryWeapon(num)
	return drone
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth
	if severity < 0.5 then
		Explode(base, SFX.NONE)
		return 1
	else
		Explode(base, SFX.SHATTER)
		return 2
	end
end

local SIG_SPAM = 1
function SpamDirtbag()
	Signal(SIG_SPAM)
	SetSignalMask(SIG_SPAM)
	while true do
		Sleep(1000)
		local px, py, pz = Spring.GetUnitPosition(unitID)
		local team = Spring.GetUnitTeam(unitID)
		local created = GG.CustomUnits.SpawnCustomUnit(2, px + 100, py + 100, pz + 100, 0, team)
		--local created=Spring.CreateUnit("shieldscout",px+100,py+100,pz+100,0,team)
		if created and GG.AddSillyUnit and false then
			GG.AddSillyUnit(created)
		else
			--[=[
			if not GG.AddSillyUnit then
				Spring.Echo("No GG.AddSillyUnit")
			end
			if not created then
				Spring.Echo("No created")
			end]=]
		end
	end
end

function script.Activate()
	StartThread(SpamDirtbag)
end
