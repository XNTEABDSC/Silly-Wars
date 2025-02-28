
local utils=Spring.Utilities.CustomUnits.utils

---generate a string to show stats of a custom unit def
---@param cud CustomUnitDataFinal|string
local function GenCustomUnitDefView(cud)
    local text=""
	if type(cud)=="string" then
		text=cud
	elseif type(cud)=="table" then
		local tabcount=0
		local function TabStr()
			local res=""
			for i = 1, tabcount do
				res=res .. "    "
			end
			return res
		end
		local function PutStrLn(str)
			text=text .. TabStr() .. str .. "\n"
		end
		local cudm=cud.CustomUnitDataModify


		local function PutKV(k,v)
			PutStrLn(tostring(k) .. ": " .. tostring( v ))
		end
		

		local function PutCudParam(key,key_name)
			key_name=key_name or key
			PutStrLn(key .. ": " .. tostring( cud[key]))
		end


		local function PutCudmParam(key,key_name)
			key_name=key_name or key
			PutStrLn(key .. ": " .. tostring(cudm[key]))
		end


		PutCudParam("name")
        PutKV("Chassis", GameData.CustomUnits.chassis_defs[cud.chassis_name].humanName)
        
        
		PutCudParam("cost")
		PutCudParam("health")
		PutKV("speed",cud.speed)
		PutKV("motor",cud.motor)

		PutCudParam("mass")

		for wpn_i = 1, #GameData.CustomUnits.chassis_defs[cud.chassis_name].weapon_slots do
			local cwd=cud.weapons[wpn_i]
			if cwd then
				PutStrLn("Weapon " .. wpn_i)
				tabcount=tabcount+1
				PutKV("name",cwd.name)
				PutKV("cost",cwd.cost)
				local damage=0
				for damage_i = 0, #cwd.damages do
					damage=math.max(damage,cwd.damages[damage_i])
				end
				PutKV("damage",damage)
				local projCount=1
				if cwd.projectiles then
					projCount=projCount*cwd.projectiles
				end
				if cwd.burst then
					projCount=projCount*cwd.burst
				end
				if projCount>1 then
					PutKV("projectiles",projCount)
				end
				PutKV("reload time",cwd.reload_time .. "s")
				PutKV("dps",projCount*damage/cwd.reload_time)
				PutKV("range",cwd.range)
				PutKV("speed",cwd.projSpeed*Game.gameSpeed)
				if cwd.aoe then
					PutKV("aoe",cwd.aoe)
				end
				tabcount=tabcount-1
			end
		end


	end
    return text
end

utils.GenCustomUnitDefView=GenCustomUnitDefView

Spring.Utilities.CustomUnits.utils=utils