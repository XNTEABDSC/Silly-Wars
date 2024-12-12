-- mission editor compatibility
Spring.GetModOptions = Spring.GetModOptions or function() return {} end
local ModularCommDefsShared_={}
ModularCommDefsShared=ModularCommDefsShared_
ModularCommDefsShared=nil
local skinDefs
local SKIN_FILE = "LuaRules/Configs/dynamic_comm_skins.lua"
if VFS.FileExists(SKIN_FILE) then
	skinDefs = VFS.Include(SKIN_FILE)
else
	skinDefs = {}
end

local LEVEL_BOUND = math.floor(tonumber(Spring.GetModOptions().max_com_level or 0))
if LEVEL_BOUND <= 0 then
	LEVEL_BOUND = nil -- unlimited
else
	LEVEL_BOUND = LEVEL_BOUND - 1 -- UI counts from 1 but internals count from 0
end

local COST_MULT = 1
local HP_MULT = 1
local ECHO_MODULES_FOR_CIRCUIT = false

if (Spring.GetModOptions) then
	local modOptions = Spring.GetModOptions()
	if modOptions then
		if modOptions.hpmult and modOptions.hpmult ~= 1 then
			HP_MULT = modOptions.hpmult
		end
	end
end

ModularCommDefsShared_.HP_MULT=HP_MULT
ModularCommDefsShared_.COST_MULT=COST_MULT
local moduleImagePath = "unitpics/"
ModularCommDefsShared_.moduleImagePath=moduleImagePath
local disableResurrect = (Spring.GetModOptions().disableresurrect == 1) or (Spring.GetModOptions().disableresurrect == "1")
ModularCommDefsShared_.disableResurrect=disableResurrect
------------------------------------------------------------------------
-- Module Definitions
------------------------------------------------------------------------

-- For autogenerating expensive advanced versions
local basicWeapons = {
	["commweapon_beamlaser"] = true,
	["commweapon_flamethrower"] = true,
	["commweapon_heatray"] = true,
	["commweapon_heavymachinegun"] = true,
	["commweapon_lightninggun"] = true,
	["commweapon_lparticlebeam"] = true,
	["commweapon_missilelauncher"] = true,
	["commweapon_riotcannon"] = true,
	["commweapon_rocketlauncher"] = true,
	["commweapon_shotgun"] = true,
}
ModularCommDefsShared_.basicWeapons=basicWeapons

local moduleDefNames = {}
ModularCommDefsShared_.moduleDefNames=moduleDefNames
local moduleDefNamesAllList = {}
ModularCommDefsShared_.moduleDefNamesAllList=moduleDefNamesAllList

local chassisListNames={}
for key, value in pairs({"recon", "strike", "assault", "support", "knight"}) do
	chassisListNames[value]=true
end

ModularCommDefsShared_.applicationFunctionApplyWeapon=function (GetWeaponName)
	return function (modules, sharedData)
		if sharedData.noMoreWeapons then
			return
		end
		if not sharedData.weapon1 then
			sharedData.weapon1 = GetWeaponName(modules,sharedData)
		else
			sharedData.weapon2 = GetWeaponName(modules,sharedData)
		end
	end
end

ModularCommDefsShared_.applicationFunctionApplyNoMoreWeapon=function (GetWeaponName)
	return function (modules, sharedData)
		if sharedData.noMoreWeapons then
			return
		end
		local weaponName = GetWeaponName(modules,sharedData)
		sharedData.weapon1 = weaponName
		sharedData.weapon2 = nil
		sharedData.noMoreWeapons = true
	end
end
ModularCommDefsShared_.UnitDefNames=UnitDefNames
local moduleDefs = {
	-- Empty Module Slots
	{
		name = "nullmodule",
		humanName = "No Module",
		description = "No Module",
		image = "LuaUI/Images/dynamic_comm_menu/cross.png",
		limit = false,
		emptyModule = true,
		cost = 0,
		requireLevel = 0,
		slotType = "module",
	},
	{
		name = "nullbasicweapon",
		humanName = "No Weapon",
		description = "No Weapon",
		image = "LuaUI/Images/dynamic_comm_menu/cross.png",
		limit = false,
		emptyModule = true,
		requireChassis = {"knight"},
		cost = 0,
		requireLevel = 0,
		slotType = "basic_weapon",
	},
	{
		name = "nulladvweapon",
		humanName = "No Weapon",
		description = "No Weapon",
		image = "LuaUI/Images/dynamic_comm_menu/cross.png",
		limit = false,
		emptyModule = true,
		cost = 0 * COST_MULT,
		requireLevel = 0,
		slotType = "adv_weapon",
	},
	{
		name = "nulldualbasicweapon",
		humanName = "No Weapon",
		description = "No Weapon",
		image = "LuaUI/Images/dynamic_comm_menu/cross.png",
		limit = false,
		emptyModule = true,
		cost = 0 * COST_MULT,
		requireLevel = 0,
		slotType = "dual_basic_weapon",
	},
	
	-- Weapons
	{
		name = "commweapon_beamlaser",
		humanName = "Beam Laser",
		description = "Beam Laser: An effective short-range cutting tool",
		image = moduleImagePath .. "commweapon_beamlaser.png",
		limit = 2,
		cost = 0,
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_beamlaser"
			else
				sharedData.weapon2 = "commweapon_beamlaser"
			end
		end
	},
	{
		name = "commweapon_flamethrower",
		humanName = "Flamethrower",
		description = "Flamethrower: Good for deep-frying swarmers and large targets alike",
		image = moduleImagePath .. "commweapon_flamethrower.png",
		limit = 2,
		cost = 0,
		requireChassis = {"recon", "assault", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_flamethrower"
			else
				sharedData.weapon2 = "commweapon_flamethrower"
			end
		end
	},
	{
		name = "commweapon_heatray",
		humanName = "Heatray",
		description = "Heatray: Rapidly melts anything at short range; steadily loses all of its damage over distance",
		image = moduleImagePath .. "commweapon_heatray.png",
		limit = 2,
		cost = 0,
		requireChassis = {"assault", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_heatray"
			else
				sharedData.weapon2 = "commweapon_heatray"
			end
		end
	},
	{
		name = "commweapon_heavymachinegun",
		humanName = "Machine Gun",
		description = "Machine Gun: Close-in automatic weapon with AoE",
		image = moduleImagePath .. "commweapon_heavymachinegun.png",
		limit = 2,
		cost = 0,
		requireChassis = {"recon", "assault", "strike", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.conversion_disruptor[1]] and "commweapon_heavymachinegun_disrupt") or "commweapon_heavymachinegun"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	--{
	--	name = "commweapon_hpartillery",
	--	humanName = "Plasma Artillery",
	--	description = "Plasma Artillery",
	--	image = moduleImagePath .. "commweapon_assaultcannon.png",
	--	limit = 2,
	--	cost = 300 * COST_MULT,
	--	requireChassis = {"assault"},
	--	requireLevel = 3,
	--	slotType = "adv_weapon",
	--	applicationFunction = function (modules, sharedData)
	--		if sharedData.noMoreWeapons then
	--			return
	--		end
	--		local weaponName = (modules[moduleDefNames.weaponmod_napalm_warhead] and "commweapon_hpartillery_napalm") or "commweapon_hpartillery"
	--		if not sharedData.weapon1 then
	--			sharedData.weapon1 = weaponName
	--		else
	--			sharedData.weapon2 = weaponName
	--		end
	--	end
	--},
	{
		name = "commweapon_lightninggun",
		humanName = "Lightning Rifle",
		description = "Lightning Rifle: Paralyzes and damages annoying bugs",
		image = moduleImagePath .. "commweapon_lightninggun.png",
		limit = 2,
		cost = 0,
		requireChassis = {"recon", "support", "strike", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.weaponmod_stun_booster[1]] and "commweapon_lightninggun_improved") or "commweapon_lightninggun"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_lparticlebeam",
		humanName = "Light Particle Beam",
		description = "Light Particle Beam: Fast, light pulsed energy weapon",
		image = moduleImagePath .. "commweapon_lparticlebeam.png",
		limit = 2,
		cost = 0,
		requireChassis = {"support", "recon", "strike", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.conversion_disruptor[1]] and "commweapon_disruptor") or "commweapon_lparticlebeam"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_missilelauncher",
		humanName = "Missile Launcher",
		description = "Missile Launcher: Lightweight seeker missile with good range",
		image = moduleImagePath .. "commweapon_missilelauncher.png",
		limit = 2,
		cost = 0,
		requireChassis = {"support", "strike", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_missilelauncher"
			else
				sharedData.weapon2 = "commweapon_missilelauncher"
			end
		end
	},
	{
		name = "commweapon_riotcannon",
		humanName = "Riot Cannon",
		description = "Riot Cannon: The weapon of choice for crowd control",
		image = moduleImagePath .. "commweapon_riotcannon.png",
		limit = 2,
		cost = 0,
		requireChassis = {"assault", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.weaponmod_napalm_warhead[1]] and "commweapon_riotcannon_napalm") or "commweapon_riotcannon"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_rocketlauncher",
		humanName = "Rocket Launcher",
		description = "Rocket Launcher: Medium-range, low-velocity hitter",
		image = moduleImagePath .. "commweapon_rocketlauncher.png",
		limit = 2,
		cost = 0,
		requireChassis = {"assault", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.weaponmod_napalm_warhead[1]] and "commweapon_rocketlauncher_napalm") or "commweapon_rocketlauncher"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_shotgun",
		humanName = "Shotgun",
		description = "Shotgun: Can hammer a single large target or shred several small ones",
		image = moduleImagePath .. "commweapon_shotgun.png",
		limit = 2,
		cost = 0,
		requireChassis = {"recon", "support", "strike", "knight"},
		requireLevel = 1,
		slotType = "basic_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.conversion_disruptor[1]] and "commweapon_shotgun_disrupt") or "commweapon_shotgun"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_hparticlebeam",
		humanName = "Heavy Particle Beam",
		description = "Heavy Particle Beam - Replaces other weapons. Short range, high-power beam weapon with moderate reload time",
		image = moduleImagePath .. "conversion_hparticlebeam.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"support", "knight"},
		requireLevel = 1,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.conversion_disruptor[1]] and "commweapon_heavy_disruptor") or "commweapon_hparticlebeam"
			sharedData.weapon1 = weaponName
			sharedData.weapon2 = nil
			sharedData.noMoreWeapons = true
		end
	},
	{
		name = "commweapon_shockrifle",
		humanName = "Shock Rifle",
		description = "Shock Rifle - Replaces other weapons. Long range sniper rifle",
		image = moduleImagePath .. "conversion_shockrifle.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"support", "knight"},
		requireLevel = 1,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			sharedData.weapon1 = "commweapon_shockrifle"
			sharedData.weapon2 = nil
			sharedData.noMoreWeapons = true
		end
	},
	{
		name = "commweapon_clusterbomb",
		humanName = "Cluster Bomb",
		description = "Cluster Bomb - Manually fired burst of bombs.",
		image = moduleImagePath .. "commweapon_clusterbomb.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"recon", "assault", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_clusterbomb"
			else
				sharedData.weapon2 = "commweapon_clusterbomb"
			end
		end
	},
	{
		name = "commweapon_concussion",
		humanName = "Concussion Shell",
		description = "Concussion Shell - Manually fired high impulse projectile.",
		image = moduleImagePath .. "commweapon_concussion.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"recon", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_concussion"
			else
				sharedData.weapon2 = "commweapon_concussion"
			end
		end
	},
	{
		name = "commweapon_disintegrator",
		humanName = "Disintegrator",
		description = "Disintegrator - Manually fired weapon that destroys almost everything it touches.",
		image = moduleImagePath .. "commweapon_disintegrator.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"assault", "strike", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_disintegrator"
			else
				sharedData.weapon2 = "commweapon_disintegrator"
			end
		end
	},
	{
		name = "commweapon_disruptorbomb",
		humanName = "Disruptor Bomb",
		description = "Disruptor Bomb - Manually fired bomb that slows enemies in a large area.",
		image = moduleImagePath .. "commweapon_disruptorbomb.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"recon", "support", "strike", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_disruptorbomb"
			else
				sharedData.weapon2 = "commweapon_disruptorbomb"
			end
		end
	},
	{
		name = "commweapon_multistunner",
		humanName = "Multistunner",
		description = "Multistunner - Manually fired sustained burst of lightning.",
		image = moduleImagePath .. "commweapon_multistunner.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"support", "recon", "strike", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			local weaponName = (modules[moduleDefNamesAllList.weaponmod_stun_booster[1]] and "commweapon_multistunner_improved") or "commweapon_multistunner"
			if not sharedData.weapon1 then
				sharedData.weapon1 = weaponName
			else
				sharedData.weapon2 = weaponName
			end
		end
	},
	{
		name = "commweapon_napalmgrenade",
		humanName = "Hellfire Grenade",
		description = "Hellfire Grenade - Manually fired bomb that inflames a large area.",
		image = moduleImagePath .. "commweapon_napalmgrenade.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"assault", "recon", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_napalmgrenade"
			else
				sharedData.weapon2 = "commweapon_napalmgrenade"
			end
		end
	},
	{
		name = "commweapon_slamrocket",
		humanName = "S.L.A.M. Rocket",
		description = "S.L.A.M. Rocket - Manually fired miniature tactical nuke.",
		image = moduleImagePath .. "commweapon_slamrocket.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"assault", "knight"},
		requireLevel = 3,
		slotType = "adv_weapon",
		applicationFunction = function (modules, sharedData)
			if sharedData.noMoreWeapons then
				return
			end
			if not sharedData.weapon1 then
				sharedData.weapon1 = "commweapon_slamrocket"
			else
				sharedData.weapon2 = "commweapon_slamrocket"
			end
		end
	},
	
	-- Unique Modules
	{
		name = "econ",
		humanName = "Vanguard Economy Pack",
		description = "Vanguard Economy Pack - A vital part of establishing a beachhead, this module is equipped by all new commanders to kickstart their economy. Provides 4 metal income and 6 energy income.",
		image = moduleImagePath .. "module_energy_cell.png",
		limit = 1,
		unequipable = true,
		cost = 100 * COST_MULT,
		requireLevel = 0,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.metalIncome = (sharedData.metalIncome or 0) + 4
			sharedData.energyIncome = (sharedData.energyIncome or 0) + 6
		end
	},
	{
		name = "commweapon_personal_shield",
		humanName = "Personal Shield",
		description = "Personal Shield - A small, protective bubble shield.",
		image = moduleImagePath .. "module_personal_shield.png",
		limit = 1,
		cost = 300 * COST_MULT,
		prohibitingModules = {"module_personal_cloak"},
		requireLevel = 2,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			-- Do not override area shield
			sharedData.shield = sharedData.shield or "commweapon_personal_shield"
		end
	},
	{
		name = "commweapon_areashield",
		humanName = "Area Shield",
		description = "Area Shield - Projects a large shield. Replaces Personal Shield.",
		image = moduleImagePath .. "module_areashield.png",
		limit = 1,
		cost = 250 * COST_MULT,
		requireChassis = {"assault", "support", "knight"},
		requireOneOf = {"commweapon_personal_shield"},
		prohibitingModules = {"module_personal_cloak"},
		requireLevel = 3,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.shield = "commweapon_areashield"
		end
	},
	{
		name = "weaponmod_napalm_warhead",
		humanName = "Napalm Warhead",
		description = "Napalm Warhead - Riot Cannon and Rocket Launcher set targets on fire. Reduced direct damage.",
		image = moduleImagePath .. "weaponmod_napalm_warhead.png",
		limit = 1,
		cost = 350 * COST_MULT,
		requireChassis = {"assault", "knight"},
		requireOneOf = {
			"commweapon_rocketlauncher", "commweapon_rocketlauncher_adv",
			"commweapon_riotcannon", "commweapon_riotcannon_adv",
			"commweapon_hpartillery"},
		requireLevel = 2,
		slotType = "module",
	},
	{
		name = "conversion_disruptor",
		humanName = "Disruptor Ammo",
		description = "Disruptor Ammo - Heavy Machine Gun, Shotgun and Particle Beams deal slow damage. Reduced direct damage.",
		image = moduleImagePath .. "weaponmod_disruptor_ammo.png",
		limit = 1,
		cost = 300 * COST_MULT,
		requireChassis = {"strike", "recon", "support", "knight"},
		requireOneOf = {
			"commweapon_heavymachinegun", "commweapon_heavymachinegun_adv",
			"commweapon_shotgun", "commweapon_shotgun_adv",
			"commweapon_lparticlebeam", "commweapon_lparticlebeam_adv",
			"commweapon_hparticlebeam"
		},
		requireLevel = 2,
		slotType = "module",
	},
	{
		name = "weaponmod_stun_booster",
		humanName = "Flux Amplifier",
		description = "Flux Amplifier - Improves EMP duration and strength of Lightning Rifle and Multistunner.",
		image = moduleImagePath .. "weaponmod_stun_booster.png",
		limit = 1,
		cost = 300 * COST_MULT,
		requireChassis = {"support", "strike", "recon", "knight"},
		requireOneOf = {
			"commweapon_lightninggun", "commweapon_lightninggun_adv",
			"commweapon_multistunner"
		},
		requireLevel = 2,
		slotType = "module",
	},
	{
		name = "module_jammer",
		humanName = "Radar Jammer",
		description = "Radar Jammer - Hide the radar signals of nearby units.",
		image = moduleImagePath .. "module_jammer.png",
		limit = 1,
		cost = 200 * COST_MULT,
		requireLevel = 2,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			if not sharedData.cloakFieldRange then
				sharedData.radarJammingRange = 500
			end
		end
	},
	{
		name = "module_radarnet",
		humanName = "Field Radar",
		description = "Field Radar - Attaches a basic radar system.",
		image = moduleImagePath .. "module_fieldradar.png",
		limit = 1,
		cost = 75 * COST_MULT,
		requireLevel = 1,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.radarRange = 1800
		end
	},
	{
		name = "module_personal_cloak",
		humanName = "Personal Cloak",
		description = "Personal Cloak - A personal cloaking device. Reduces total speed by 12%.",
		image = moduleImagePath .. "module_personal_cloak.png",
		limit = 1,
		cost = 400 * COST_MULT,
		prohibitingModules = {"commweapon_personal_shield", "commweapon_areashield"},
		requireLevel = 2,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.decloakDistance = math.max(sharedData.decloakDistance or 0, 150)
			sharedData.personalCloak = true
			sharedData.speedMultPost = (sharedData.speedMultPost or 1) - 0.12
		end
	},
	{
		name = "module_cloak_field",
		humanName = "Cloaking Field",
		description = "Cloaking Field - Cloaks all nearby units.",
		image = moduleImagePath .. "module_cloak_field.png",
		limit = 1,
		cost = 600 * COST_MULT,
		requireChassis = {"support", "strike", "knight"},
		requireOneOf = {"module_jammer"},
		requireLevel = 3,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.areaCloak = true
			sharedData.decloakDistance = 180
			sharedData.cloakFieldRange = 320
			sharedData.cloakFieldUpkeep = 15
			sharedData.cloakFieldRecloakRate = 800 -- UI only, update in unit_commander_upgrade
			sharedData.radarJammingRange = 320
		end
	},
	{
		name = "module_resurrect",
		humanName = "Lazarus Device",
		description = "Lazarus Device - Upgrade nanolathe to allow resurrection.",
		image = moduleImagePath .. "module_resurrect.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = disableResurrect and {} or {"support", "knight"},
		requireLevel = 2,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.canResurrect = true
		end
	},
	{
		name = "module_jumpjet",
		humanName = "Jumpjets",
		description = "Jumpjets - Leap over obstacles and out of danger. Each High Powered Servos reduces jump reload by 1s.",
		image = moduleImagePath .. "module_jumpjet.png",
		limit = 1,
		cost = 400 * COST_MULT,
		requireChassis = {"knight"},
		requireLevel = 3,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.canJump = true
		end
	},
	
	-- Repeat Modules
	{
		name = "module_companion_drone",
		humanName = "Companion Drone",
		description = "Companion Drone - Commander spawns protective drones. Limit: 5",
		image = moduleImagePath .. "module_companion_drone.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 2,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.drones = (sharedData.drones or 0) + 1
		end
	},
	{
		name = "module_battle_drone",
		humanName = "Battle Drone",
		description = "Battle Drone - Commander spawns heavy drones. Limit: 5, Requires Companion Drone",
		image = moduleImagePath .. "module_battle_drone.png",
		limit = 5,
		cost = 350 * COST_MULT,
		requireChassis = {"assault", "support", "knight"},
		requireOneOf = {"module_companion_drone"},
		requireLevel = 3,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.droneheavyslows = (sharedData.droneheavyslows or 0) + 1
		end
	},
	{
		name = "module_autorepair",
		humanName = "Autorepair",
		description = "Autorepair - Commander self-repairs at +" .. 12*HP_MULT .. " hp/s. Reduces Health by " .. 100*HP_MULT .. ". Limit: 5",
		image = moduleImagePath .. "module_autorepair.png",
		limit = 5,
		cost = 150 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"strike", "knight"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 12*HP_MULT
			sharedData.healthBonus = (sharedData.healthBonus or 0) - 100*HP_MULT
		end
	},
	{
		name = "module_autorepair",
		humanName = "Autorepair",
		description = "Autorepair - Commander self-repairs at +" .. 10*HP_MULT .. " hp/s. Reduces Health by " .. 100*HP_MULT .. ". Limit: 5",
		image = moduleImagePath .. "module_autorepair.png",
		limit = 5,
		cost = 150 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"assault", "recon", "support"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.autorepairRate = (sharedData.autorepairRate or 0) + 10*HP_MULT
			sharedData.healthBonus = (sharedData.healthBonus or 0) - 100*HP_MULT
		end
	},
	{
		name = "module_ablative_armor",
		humanName = "Ablative Armour Plates",
		description = "Ablative Armour Plates - Provides " .. 750*HP_MULT .. " health. Limit: 5",
		image = moduleImagePath .. "module_ablative_armor.png",
		limit = 5,
		cost = 150 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"assault", "knight"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.healthBonus = (sharedData.healthBonus or 0) + 750*HP_MULT
		end
	},
	{
		name = "module_heavy_armor",
		humanName = "High Density Plating",
		description = "High Density Plating - Provides " .. 2000*HP_MULT .. " health but reduces total speed by 2%. " ..
		"Limit: 5, Requires Ablative Armour Plates",
		image = moduleImagePath .. "module_heavy_armor.png",
		limit = 5,
		cost = 400 * COST_MULT,
		requireOneOf = {"module_ablative_armor"},
		requireLevel = 2,
		requireChassis = {"assault", "knight"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.healthBonus = (sharedData.healthBonus or 0) + 2000*HP_MULT
			sharedData.speedMultPost = (sharedData.speedMultPost or 1) - 0.02
		end
	},
	{
		name = "module_ablative_armor",
		humanName = "Ablative Armour Plates",
		description = "Ablative Armour Plates - Provides " .. 600*HP_MULT .. " health. Limit: 5",
		image = moduleImagePath .. "module_ablative_armor.png",
		limit = 5,
		cost = 150 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"strike", "recon", "support"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.healthBonus = (sharedData.healthBonus or 0) + 600*HP_MULT
		end
	},
	{
		name = "module_heavy_armor",
		humanName = "High Density Plating",
		description = "High Density Plating - Provides " .. 1600*HP_MULT .. " health but reduces total speed by 2%. " ..
		"Limit: 5, Requires Ablative Armour Plates",
		image = moduleImagePath .. "module_heavy_armor.png",
		limit = 5,
		cost = 400 * COST_MULT,
		requireOneOf = {"module_ablative_armor"},
		requireLevel = 2,
		requireChassis = {"strike", "recon", "support"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.healthBonus = (sharedData.healthBonus or 0) + 1600*HP_MULT
			sharedData.speedMultPost = (sharedData.speedMultPost or 1) - 0.02
		end
	},
	{
		name = "module_dmg_booster",
		humanName = "Damage Booster",
		description = "Damage Booster - Increases damage by 15% but reduces total speed by 2%.  Limit: 5",
		image = moduleImagePath .. "module_dmg_booster.png",
		limit = 5,
		cost = 150 * COST_MULT,
		requireLevel = 1,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.damageMult = (sharedData.damageMult or 1) + 0.15
			sharedData.speedMultPost = (sharedData.speedMultPost or 1) - 0.02
		end
	},
	{
		name = "module_high_power_servos",
		humanName = "High Power Servos",
		description = "High Power Servos - Increases speed by 4 and reduced jump cooldown by 1s. Limit: 5",
		image = moduleImagePath .. "module_high_power_servos.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"recon", "knight"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.speedMod = (sharedData.speedMod or 0) + 4
			sharedData.jumpReloadMod = (sharedData.jumpReloadMod or 0) - 1
		end
	},
	{
		name = "module_high_power_servos",
		humanName = "High Power Servos",
		description = "High Power Servos - Increases speed by 3.5. Limit: 5",
		image = moduleImagePath .. "module_high_power_servos.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"strike", "assault", "support"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.speedMod = (sharedData.speedMod or 0) + 3.5
		end
	},
	{
		name = "module_adv_targeting",
		humanName = "Adv. Targeting System",
		description = "Advanced Targeting System - Increases range by 7.5% but reduces total speed by 3%. Limit: 5",
		image = moduleImagePath .. "module_adv_targeting.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.rangeMult = (sharedData.rangeMult or 1) + 0.075
			sharedData.speedMultPost = (sharedData.speedMultPost or 1) - 0.03
		end
	},
	{
		name = "module_adv_nano",
		humanName = "CarRepairer's Nanolathe",
		description = "CarRepairer's Nanolathe - Increases build power by 6. Limit: 5",
		image = moduleImagePath .. "module_adv_nano.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"support"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 6
		end
	},
	{
		name = "module_adv_nano",
		humanName = "CarRepairer's Nanolathe",
		description = "CarRepairer's Nanolathe - Increases build power by 5. Limit: 5",
		image = moduleImagePath .. "module_adv_nano.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"strike", "assault", "knight"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 5
		end
	},
	{
		name = "module_adv_nano",
		humanName = "CarRepairer's Nanolathe",
		description = "CarRepairer's Nanolathe - Increases build power by 4. Limit: 5",
		image = moduleImagePath .. "module_adv_nano.png",
		limit = 5,
		cost = 200 * COST_MULT,
		requireLevel = 1,
		requireChassis = {"recon"},
		slotType = "module",
		applicationFunction = function (modules, sharedData)
			sharedData.bonusBuildPower = (sharedData.bonusBuildPower or 0) + 4
		end
	},
	
	-- Decorative Modules
	{
		name = "banner_overhead",
		humanName = "Banner",
		description = "Banner",
		image = moduleImagePath .. "module_ablative_armor.png",
		limit = 1,
		cost = 0,
		requireLevel = 0,
		slotType = "decoration",
		applicationFunction = function (modules, sharedData)
			sharedData.bannerOverhead = true
		end
	}
}
local SharedEnv={ModularCommDefsShared=ModularCommDefsShared_,UnitDefNames=UnitDefNames}

setmetatable(SharedEnv,{__index=getfenv()})

-- cuz hardcode
for i = 1, #moduleDefs do
	local def = moduleDefs[i]
	if basicWeapons[def.name] or def.isBasicWeapon then
		local newDef = Spring.Utilities.CopyTable(def, true)
		newDef.name = newDef.name .. "_adv"
		newDef.slotType = "dual_basic_weapon"
		newDef.cost = 350 * COST_MULT
		moduleDefs[#moduleDefs + 1] = newDef
	end
	if def.requireChassis then
		for key, value in pairs(def.requireChassis) do
			chassisListNames[value]=true
		end
	end
end

local modulesalldefs=include("gamedata/modularcomms/modulesloadall.lua")
--local moduleFiles=VFS.DirList("gamedata/modularcomms/modules", "*.lua") or {}

for i = 1, #modulesalldefs do
	local moduleDef = modulesalldefs[i].dynamic_comm_def(ModularCommDefsShared_)
	moduleDefs[#moduleDefs+1]=moduleDef
	local def=moduleDef
	if basicWeapons[def.name] or def.isBasicWeapon then
		local newDef = Spring.Utilities.CopyTable(def, true)
		newDef.name = newDef.name .. "_adv"
		newDef.slotType = "dual_basic_weapon"
		newDef.cost = 350 * COST_MULT
		moduleDefs[#moduleDefs + 1] = newDef
	end
	if def.requireChassis then
		for key, value in pairs(def.requireChassis) do
			chassisListNames[value]=true
		end
	end
end

-- Add second versions of basic weapons


--[[ Stochastic check for module IDs,
     not perfect but should do its job.
     See the error message below. ]]
if moduleDefs[ 1].name ~= "nullmodule"
or moduleDefs[ 4].name ~= "nulldualbasicweapon"
or moduleDefs[10].name ~= "commweapon_lparticlebeam"
or moduleDefs[25].name ~= "commweapon_personal_shield"
or moduleDefs[42].name ~= "module_ablative_armor"
or moduleDefs[61].name ~= "commweapon_shotgun_adv" then
	Spring.Echo("MODULE IDs NEED TO STAY CONSTANT BECAUSE AI HARDCODES THEM.\n"
	         .. "SEE https://github.com/ZeroK-RTS/Zero-K/issues/4796 \n"
	         .. "REMEMBER TO CHANGE CircuitAI CONFIG IF MODIFYING THE LIST!")
	Script.Kill()
end

for name, data in pairs(skinDefs) do
	moduleDefs[#moduleDefs + 1] = {
		name = "skin_" .. name,
		humanName = data.humanName,
		description = data.humanName,
		image = moduleImagePath .. "module_ablative_armor.png",
		limit = 1,
		cost = 0,
		requireChassis = {data.chassis},
		requireLevel = 0,
		slotType = "decoration",
		applicationFunction = function (modules, sharedData)
			sharedData.skinOverride = name
		end
	}
end

for i = 1, #moduleDefs do
	local data = moduleDefNamesAllList[moduleDefs[i].name] or {}
	data[#data + 1] = i
	moduleDefNamesAllList[moduleDefs[i].name] = data
end

local chassisList={}
for k,v in pairs(chassisListNames) do
	moduleDefNames[k] = {}
	chassisList[#chassisList+1]=k
end

for i = 1, #moduleDefs do
	local data = moduleDefs[i]
	local allowedChassis = moduleDefs[i].requireChassis or chassisList
	for j = 1, #allowedChassis do
		moduleDefNames[allowedChassis[j]][data.name] = i
	end
end

------------------------------------------------------------------------
-- Chassis Definitions
------------------------------------------------------------------------

-- it'd help if there was a name -> chassisDef map you know

--------------------------------------------------------------------------------------
-- Must match staticomms.lua around line 250 (MakeCommanderChassisClones)
--------------------------------------------------------------------------------------
-- A note on personal shield and area shield:
-- The personal shield weapon is replaced by the area shield weapon in moduledefs.lua.
-- Therefore the clonedef with an area shield and no personal shield does not actually
-- have an area shield. This means that the below functions return the correct values,
-- if a commander has a an area shield and a personal shield it should return the
-- clone which was given those modules.





local morphCosts = {
	50,
	100,
	150,
	200,
	250,
}
ModularCommDefsShared_.morphCosts=morphCosts
local morphBuildPower = {
	5,
	7.5,
	10,
	12.5,
	15
}
ModularCommDefsShared_.morphBuildPower=morphBuildPower
local function extraLevelCostFunction(level)
	return level * 50 * COST_MULT
end
ModularCommDefsShared_.extraLevelCostFunction=extraLevelCostFunction

ModularCommDefsShared_.GetCloneModuleString=function (chassis,listOfCloneModules)
	return function (modulesByDefID)
		local res=""
		for key, value in pairs(listOfCloneModules) do
			res=res .. (modulesByDefID[moduleDefNames[chassis][value]] or 0)
		end
		return res
	end
end

do
	
	ModularCommDefsShared_.morphUnitDefFunction=function (name,GetCloneModuleString)
		return function (lv)
			return function (modulesByDefID)
				
				return UnitDefNames[name .. lv .. "_" .. GetCloneModuleString(modulesByDefID)].id
			end
		end
	end
end

local chassisDefs = {
	
	
	
	
	
}

local chassisFiles=VFS.DirList("gamedata/modularcomms/chassises_dynamic_comm_defs", "*.lua") or {}

for i = 1, #chassisFiles do
	local chassisDef = VFS.Include(chassisFiles[i],SharedEnv)
	chassisDefs[#chassisDefs+1]=chassisDef
end

local chassisDefByBaseDef = {}
if UnitDefNames then
	for i = 1, #chassisDefs do
		chassisDefByBaseDef[chassisDefs[i].baseUnitDef] = i
	end
end

local chassisDefNames = {}
for i = 1, #chassisDefs do
	chassisDefNames[chassisDefs[i].name] = i
end

------------------------------------------------------------------------
-- Processing
------------------------------------------------------------------------

-- Set cost in module tooltip
for i = 1, #moduleDefs do
	local data = moduleDefs[i]
	if not data.emptyModule then
		if data.cost > 0 then
			data.description = data.description .. "\nCost: " .. data.cost
		else
			data.description = data.description .. "\nCost: Free"
		end
	end
end

-- Transform from human readable format into number indexed format
for i = 1, #moduleDefs do
	local data = moduleDefs[i]
	
	-- Required modules are a list of moduleDefIDs
	if data.requireOneOf then
		local newRequire = {}
		for j = 1, #data.requireOneOf do
			local reqModuleIDs = moduleDefNamesAllList[data.requireOneOf[j]]
			if reqModuleIDs then
				for i = 1, #reqModuleIDs do
					newRequire[#newRequire + 1] = reqModuleIDs[i]
				end
			end
		end
		data.requireOneOf = newRequire
	end
	
	-- Prohibiting modules are a list of moduleDefIDs too
	if data.prohibitingModules then
		local newProhibit = {}
		for j = 1, #data.prohibitingModules do
			local reqModuleIDs = moduleDefNamesAllList[data.prohibitingModules[j]]
			if reqModuleIDs then
				for i = 1, #reqModuleIDs do
					newProhibit[#newProhibit + 1] = reqModuleIDs[i]
				end
			end
		end
		data.prohibitingModules = newProhibit
	end
	
	-- Required chassis is a map indexed by chassisDefID
	if data.requireChassis then
		local newRequire = {}
		for j = 1, #data.requireChassis do
			for k = 1, #chassisDefs do
				if chassisDefs[k].name == data.requireChassis[j] then
					newRequire[k] = true
					break
				end
			end
		end
		data.requireChassis = newRequire
	end
end

-- Find empty modules so slots can find their appropriate empty module
local emptyModules = {}
for i = 1, #moduleDefs do
	if moduleDefs[i].emptyModule then
		emptyModules[moduleDefs[i].slotType] = i
	end
end

-- Process slotAllows into a table of keys
for i = 1, #chassisDefs do
	for j = 0, #chassisDefs[i].levelDefs do
		local levelData = chassisDefs[i].levelDefs[j]
		for k = 1, #levelData.upgradeSlots do
			local slotData = levelData.upgradeSlots[k]
			if type(slotData.slotAllows) == "string" then
				slotData.empty = emptyModules[slotData.slotAllows]
				slotData.slotAllows = {[slotData.slotAllows] = true}
			else
				local newSlotAllows = {}
				slotData.empty = emptyModules[slotData.slotAllows[1]]
				for m = 1, #slotData.slotAllows do
					newSlotAllows[slotData.slotAllows[m]] = true
				end
				slotData.slotAllows = newSlotAllows
			end
		end
	end
end

-- Add baseWreckID and baseHeapID
if UnitDefNames then
	for i = 1, #chassisDefs do
		local data = chassisDefs[i]
		local wreckData = FeatureDefNames[UnitDefs[data.baseUnitDef].corpse]

		data.baseWreckID = wreckData.id
		data.baseHeapID = wreckData.deathFeatureID
	end
end

------------------------------------------------------------------------
-- Utility Functions
------------------------------------------------------------------------

local function ModuleIsValid(level, chassis, slotAllows, moduleDefID, alreadyOwned, alreadyOwned2)
	local data = moduleDefs[moduleDefID]
	if (not slotAllows[data.slotType]) or (data.requireLevel or 0) > level or
			(data.requireChassis and (not data.requireChassis[chassis])) or data.unequipable then
		return false
	end
	
	-- Check that requirements are met
	if data.requireOneOf then
		local foundRequirement = false
		for j = 1, #data.requireOneOf do
			-- Modules should not depend on themselves so this check is simplier than the
			-- corresponding chcek in the replacement set generator.
			local reqDefID = data.requireOneOf[j]
			if (alreadyOwned[reqDefID] or (alreadyOwned2 and alreadyOwned2[reqDefID])) then
				foundRequirement = true
				break
			end
		end
		if not foundRequirement then
			return false
		end
	end
	
	-- Check that nothing prohibits this module
	if data.prohibitingModules then
		for j = 1, #data.prohibitingModules do
			-- Modules cannot prohibit themselves otherwise this check makes no sense.
			local probihitDefID = data.prohibitingModules[j]
			if (alreadyOwned[probihitDefID] or (alreadyOwned2 and alreadyOwned2[probihitDefID])) then
				return false
			end
		end
	
	end

	-- cheapass hack to prevent cremcom dual wielding same weapon (not supported atm)
	-- proper solution: make the second instance of a weapon apply projectiles x2 or reloadtime x0.5 and get cremcoms unit script to work with that
	local limit = data.limit
	if chassis == 5 and data.slotType == "basic_weapon" and limit == 2 then
		limit = 1
	end

	-- Check that the module limit is not reached
	if limit and (alreadyOwned[moduleDefID] or (alreadyOwned2 and alreadyOwned2[moduleDefID])) then
		local count = (alreadyOwned[moduleDefID] or 0) + ((alreadyOwned2 and alreadyOwned2[moduleDefID]) or 0)
		if count > limit then
			return false
		end
	end
	return true
end

local function ModuleSetsAreIdentical(set1, set2)
	-- Sets should be sorted prior to this function
	if (not set1) or (not set2) or (#set1 ~= #set2) then
		return false
	end

	for i = 1, #set1 do
		if set1[i] ~= set2[i] then
			return false
		end
	end
	return true
end

local function ModuleListToByDefID(moduleList)
	local byDefID = {}
	for i = 1, #moduleList do
		local defID = moduleList[i]
		byDefID[defID] = (byDefID[defID] or 0) + 1
	end
	return byDefID
end

local function GetUnitDefShield(unitDefNameOrID, shieldName)
	local unitDefID = (type(unitDefNameOrID) == "string" and UnitDefNames[unitDefNameOrID].id) or unitDefNameOrID
	local wepTable = UnitDefs[unitDefID].weapons
	for num = 1, #wepTable do
		local wd = WeaponDefs[wepTable[num].weaponDef]
		if wd.type == "Shield" then
			local weaponName = string.sub(wd.name, (string.find(wd.name,"commweapon") or 0), 100)
			if weaponName == shieldName then
				return wd.id, num
			end
		end
	end
end

local utilities = {
	ModuleIsValid          = ModuleIsValid,
	ModuleSetsAreIdentical = ModuleSetsAreIdentical,
	ModuleListToByDefID    = ModuleListToByDefID,
	GetUnitDefShield       = GetUnitDefShield
}

------------------------------------------------------------------------
-- Circuit need static module IDs
------------------------------------------------------------------------

if ECHO_MODULES_FOR_CIRCUIT then
	local function SortFunc(a, b)
		return a[2] < b[2]
	end

	for chassis, chassisModules in pairs(moduleDefNames) do
		Spring.Echo("==============================================================")
		Spring.Echo("Modules for", chassis)
		local printList = {}
		for name, chassisDefID in pairs(chassisModules) do
			printList[#printList + 1] = {chassisDefID, name}
		end
		table.sort(printList, SortFunc)
		for i = 1, #printList do
			Spring.Echo(printList[i][1], printList[i][2])
		end
	end
	Spring.Echo("==============================================================")
end

------------------------------------------------------------------------
-- Return Values
------------------------------------------------------------------------

return moduleDefs, chassisDefs, utilities, LEVEL_BOUND, chassisDefByBaseDef, moduleDefNames, chassisDefNames
