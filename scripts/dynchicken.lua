local body = piece 'body' 
local head = piece 'head' 
local tail = piece 'tail' 
local lthighf = piece 'lthighf' 
local lkneef = piece 'lkneef' 
local lshinf = piece 'lshinf' 
local lfootf = piece 'lfootf' 
local rthighf = piece 'rthighf' 
local rkneef = piece 'rkneef' 
local rshinf = piece 'rshinf' 
local rfootf = piece 'rfootf' 
local lthighb = piece 'lthighb' 
local lkneeb = piece 'lkneeb' 
local lshinb = piece 'lshinb' 
local lfootb = piece 'lfootb' 
local rthighb = piece 'rthighb' 
local rkneeb = piece 'rkneeb' 
local rshinb = piece 'rshinb' 
local rfootb = piece 'rfootb' 
local lforearml = piece 'lforearml' 
local lbladel = piece 'lbladel' 
local rforearml = piece 'rforearml' 
local rbladel = piece 'rbladel' 
local lforearmu = piece 'lforearmu' 
local lbladeu = piece 'lbladeu' 
local rforearmu = piece 'rforearmu' 
local rbladeu = piece 'rbladeu' 
local spike1 = piece 'spike1' 
local spike2 = piece 'spike2' 
local spike3 = piece 'spike3' 
local firepoint = piece 'firepoint' 


local bMoving
local gun_1=1

-- Signal definitions
local SIG_AIM = 2
local SIG_AIM_2 = 4
local SIG_MOVE = 8

local dyncomm = include('dynamicCommander.lua')
_G.dyncomm = dyncomm

local WeaponLauncherType={}
local WeaponLauncherType_Head_Mid=1
local WeaponLauncherType_Head_Fast=2
local WeaponLauncherType_Head_Slow=3
local WeaponLauncherType_Spike=4
local WeaponLauncherType_Shield=5
local WeaponLauncherType_Odd=6
for key, value in pairs(UnitDef.weapons or {}) do
	local wd=WeaponDefs[value.weaponDef]
	if wd then
		--Spring.Utilities.TableEcho(wd,wd.name)
		if wd.type=="shield" then
			WeaponLauncherType[key]=WeaponLauncherType_Shield
		else
			if not wd.turret then
				local reload=wd.reload
				if reload then
					local res
					if reload<1 then
						res=WeaponLauncherType_Head_Fast
					elseif reload<10 then
						res=WeaponLauncherType_Head_Mid
					else
						res=WeaponLauncherType_Head_Slow
					end
					WeaponLauncherType[key]=res
				else
					WeaponLauncherType[key]=WeaponLauncherType_Odd
				end
			else
				WeaponLauncherType[key]=WeaponLauncherType_Spike
			end
		end
	end
end


local function Walk()
		
	Signal( SIG_MOVE)
	SetSignalMask( SIG_MOVE)
	while bMoving do
		
--			bMoving = false
			Turn( lthighf , x_axis, math.rad(70), math.rad(115) )
			Turn( lkneef , x_axis, math.rad(-40), math.rad(145) )
			Turn( lshinf , x_axis, math.rad(20), math.rad(145) )
			Turn( lfootf , x_axis, math.rad(-50), math.rad(210) )
			
			Turn( rthighf , x_axis, math.rad(-20), math.rad(210) )
			Turn( rkneef , x_axis, math.rad(-60), math.rad(210) )
			Turn( rshinf , x_axis, math.rad(50), math.rad(210) )
			Turn( rfootf , x_axis, math.rad(30), math.rad(210) )
			
			Turn( rthighb , x_axis, math.rad(70), math.rad(115) )
			Turn( rkneeb , x_axis, math.rad(-40), math.rad(145) )
			Turn( rshinb , x_axis, math.rad(20), math.rad(145) )
			Turn( rfootb , x_axis, math.rad(-50), math.rad(210) )
			
			Turn( lthighb , x_axis, math.rad(-20), math.rad(210) )
			Turn( lkneeb , x_axis, math.rad(-60), math.rad(210) )
			Turn( lshinb , x_axis, math.rad(50), math.rad(210) )
			Turn( lfootb , x_axis, math.rad(30), math.rad(210) )
			
			Turn( body , z_axis, math.rad(-(5)), math.rad(20) )
			Turn( lthighf , z_axis, math.rad(-(-5)), math.rad(20) )
			Turn( rthighf , z_axis, math.rad(-(-5)), math.rad(20) )
			Turn( lthighb , z_axis, math.rad(-(-5)), math.rad(20) )
			Turn( rthighb , z_axis, math.rad(-(-5)), math.rad(20) )
			Move( body , y_axis, 0.7 , 4000 )			
			Turn( tail , y_axis, math.rad(10), math.rad(40) )
			Turn( head , x_axis, math.rad(-10), math.rad(20) )
			Turn( tail , x_axis, math.rad(10), math.rad(20) )
			WaitForTurn(lthighf, x_axis)
			
			Turn( lthighf , x_axis, math.rad(-10), math.rad(160) )
			Turn( lkneef , x_axis, math.rad(15), math.rad(145) )
			Turn( lshinf , x_axis, math.rad(-60), math.rad(250) )
			Turn( lfootf , x_axis, math.rad(30), math.rad(145) )
			
			Turn( rthighf , x_axis, math.rad(40), math.rad(145) )
			Turn( rkneef , x_axis, math.rad(-35), math.rad(145) )
			Turn( rshinf , x_axis, math.rad(-40), math.rad(145) )
			Turn( rfootf , x_axis, math.rad(35), math.rad(145) )
			
			Turn( rthighb , x_axis, math.rad(-10), math.rad(160) )
			Turn( rkneeb , x_axis, math.rad(15), math.rad(145) )
			Turn( rshinb , x_axis, math.rad(-60), math.rad(250) )
			Turn( rfootb , x_axis, math.rad(30), math.rad(145) )
			
			Turn( lthighb , x_axis, math.rad(40), math.rad(145) )
			Turn( lkneeb , x_axis, math.rad(-35), math.rad(145) )
			Turn( lshinb , x_axis, math.rad(-40), math.rad(145) )
			Turn( lfootb , x_axis, math.rad(35), math.rad(145) )
			
			Move( body , y_axis, 0 , 4000 )
			Turn( head , x_axis, math.rad(10), math.rad(20) )
			Turn( tail , x_axis, math.rad(-10), math.rad(20) )
			WaitForTurn(lshinf, x_axis)
			
			Turn( rthighf , x_axis, math.rad(70), math.rad(115) )
			Turn( rkneef , x_axis, math.rad(-40), math.rad(145) )
			Turn( rshinf , x_axis, math.rad(20), math.rad(145) )
			Turn( rfootf , x_axis, math.rad(-50), math.rad(210) )
			
			Turn( lthighf , x_axis, math.rad(-20), math.rad(210) )
			Turn( lkneef , x_axis, math.rad(-60), math.rad(210) )
			Turn( lshinf , x_axis, math.rad(50), math.rad(210) )
			Turn( lfootf , x_axis, math.rad(30), math.rad(210) )
						
			Turn( lthighb , x_axis, math.rad(70), math.rad(115) )
			Turn( lkneeb , x_axis, math.rad(-40), math.rad(145) )
			Turn( lshinb , x_axis, math.rad(20), math.rad(145) )
			Turn( lfootb , x_axis, math.rad(-50), math.rad(210) )
			
			Turn( rthighb , x_axis, math.rad(-20), math.rad(210) )
			Turn( rkneeb , x_axis, math.rad(-60), math.rad(210) )
			Turn( rshinb , x_axis, math.rad(50), math.rad(210) )
			Turn( rfootb , x_axis, math.rad(30), math.rad(210) )
			
			Turn( tail , y_axis, math.rad(-10), math.rad(40) )
			Turn( body , z_axis, math.rad(-(-5)), math.rad(20) )
			Turn( lthighf , z_axis, math.rad(-(5)), math.rad(20) )
			Turn( rthighf , z_axis, math.rad(-(5)), math.rad(20) )
			Turn( lthighb , z_axis, math.rad(-(5)), math.rad(20) )
			Turn( rthighb , z_axis, math.rad(-(5)), math.rad(20) )
			Move( body , y_axis, 0.7 , 4000 )
			Turn( head , x_axis, math.rad(-10), math.rad(20) )
			Turn( tail , x_axis, math.rad(10), math.rad(20) )
			WaitForTurn(rthighf, x_axis)
			
			Turn( rthighf , x_axis, math.rad(-10), math.rad(160) )
			Turn( rkneef , x_axis, math.rad(15), math.rad(145) )
			Turn( rshinf , x_axis, math.rad(-60), math.rad(250) )
			Turn( rfootf , x_axis, math.rad(30), math.rad(145) )
			
			Turn( lthighf , x_axis, math.rad(40), math.rad(145) )
			Turn( lkneef , x_axis, math.rad(-35), math.rad(145) )
			Turn( lshinf , x_axis, math.rad(-40), math.rad(145) )
			Turn( lfootf , x_axis, math.rad(35), math.rad(145) )
						
			Turn( lthighb , x_axis, math.rad(-10), math.rad(160) )
			Turn( lkneeb , x_axis, math.rad(15), math.rad(145) )
			Turn( lshinb , x_axis, math.rad(-60), math.rad(250) )
			Turn( lfootb , x_axis, math.rad(30), math.rad(145) )
			
			Turn( rthighb , x_axis, math.rad(40), math.rad(145) )
			Turn( rkneeb , x_axis, math.rad(-35), math.rad(145) )
			Turn( rshinb , x_axis, math.rad(-40), math.rad(145) )
			Turn( rfootb , x_axis, math.rad(35), math.rad(145) )

			Move( body , y_axis, 0 , 4000 )
			Turn( head , x_axis, math.rad(10), math.rad(20) )
			Turn( tail , x_axis, math.rad(-10), math.rad(20) )
			WaitForTurn(rshinf, x_axis)
			
--			bMoving = false
		end
end


local function StopWalk ()
	
	Signal( SIG_MOVE)
	SetSignalMask( SIG_MOVE)
	Turn( lfootf		, x_axis, 0, math.rad(200) )
	Turn( rfootf		, x_axis, 0, math.rad(200) )
	Turn( rthighf	, x_axis, 0, math.rad(200) )
	Turn( lthighf	, x_axis, 0, math.rad(200) )
	Turn( lshinf		, x_axis, 0, math.rad(200) )
	Turn( rshinf		, x_axis, 0, math.rad(200) )
	Turn( lkneef 	, x_axis, 0, math.rad(200) )
	Turn( rkneef		, x_axis, 0, math.rad(200) )
	Turn( lfootb		, x_axis, 0, math.rad(200) )
	Turn( rfootb		, x_axis, 0, math.rad(200) )
	Turn( rthighb	, x_axis, 0, math.rad(200) )
	Turn( lthighb 	, x_axis, 0, math.rad(200) )
	Turn( lshinb  	, x_axis, 0, math.rad(200) )
	Turn( rshinb		, x_axis, 0, math.rad(200) )
	Turn( lkneeb  	, x_axis, 0, math.rad(200) )
	Turn( rkneeb		, x_axis, 0, math.rad(200) )
end

function script.StartMoving()

	bMoving = true
	StartThread(Walk)
end

function script.StopMoving()

	bMoving = false
	StartThread(StopWalk)
end


function script.Create()

	EmitSfx( body,  1026 )
	EmitSfx( head,  1026 )
	EmitSfx( tail,  1026 )
	Spring.SetUnitNanoPieces(unitID, {firepoint})
	dyncomm.Create()
end

function script.StopBuilding()
    SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.StartBuilding(heading, pitch)
	SetUnitValue(COB.INBUILDSTANCE, 1)

end



function script.AimFromWeapon(num)
	if dyncomm.GetWeapon(num) == 1 or dyncomm.GetWeapon(num) == 2 then
		local wlt=WeaponLauncherType[num]
		if wlt==WeaponLauncherType_Spike then
			return spike1
		elseif wlt==WeaponLauncherType_Shield then
			return body
		else
			return firepoint
		end
	end
	return body
end
--[=[
function script.AimFromWeapon(num)
    return firepoint
end]=]
function script.QueryWeapon(num)
	if dyncomm.GetWeapon(num) == 1 or dyncomm.GetWeapon(num) == 2 then
		local wlt=WeaponLauncherType[num]
		if wlt==WeaponLauncherType_Spike then
			return spike1
		elseif wlt==WeaponLauncherType_Shield then
			return body
		else
			return firepoint
		end
	end
	return body
end
--[=[
function  script.QueryWeapon(num)
    return firepoint
end]=]

function script.AimWeapon(num,heading,pitch)
	local commwpnnum=dyncomm.GetWeapon(num)
	local wd=WeaponDefs[ UnitDef.weapons[num].weaponDef ]
	if commwpnnum==3 then
		return true
	end

	if commwpnnum==1 or commwpnnum==2 then
		local wlt=WeaponLauncherType[num]
		if wlt==WeaponLauncherType_Spike or wlt==WeaponLauncherType_Shield then
			return true
		else
			Signal( SIG_AIM)
			SetSignalMask( SIG_AIM)
			Turn( head , y_axis, (heading ), math.rad(250) )
			Turn( head , x_axis, (-pitch ), math.rad(200) )
				
			WaitForTurn(head, y_axis)
			--StartThread(RestoreAfterDelay)
			
			return true
		end
	end
end
local Blades={
	{lforearmu,lbladeu,true},
	{lforearml,lbladel,true},
	{rforearmu,rbladeu,false},
	{rforearml,rbladel,false},
}
local function MoveBlade(num)
	local BladeInfo=Blades[num]
	local forearm,blade,left=BladeInfo[1],BladeInfo[2],BladeInfo[3]
	local leftmut=left and 1 or -1
	
	Turn( forearm , y_axis, math.rad(-140*leftmut), math.rad(600) )
	Turn( blade , y_axis, math.rad(140*leftmut), math.rad(600) )
	WaitForTurn(blade, y_axis)
	Turn( forearm , y_axis, 0, math.rad(120) )
	Turn( blade , y_axis, 0, math.rad(120) )
end
function script.Shot(num)
	local wpnnum=dyncomm.GetWeapon(num)
	if wpnnum==3 then
		return
	end
	if wpnnum==1 or wpnnum==2 then
		local wlt=WeaponLauncherType[num]
		if wlt==WeaponLauncherType_Spike or wlt==WeaponLauncherType_Shield then
			return
		else
			if wlt==WeaponLauncherType_Head_Mid then
				gun_1=gun_1+1
				if gun_1 > 4 then
					
					gun_1 = 1
				end
				StartThread(MoveBlade,gun_1)
			elseif wlt==WeaponLauncherType_Head_Fast then
				return
			elseif wlt==WeaponLauncherType_Head_Slow then
				StartThread(MoveBlade,1)
				StartThread(MoveBlade,2)
				StartThread(MoveBlade,3)
				StartThread(MoveBlade,4)
			end
		end
		
	end
end

function script.HitByWeapon ()
	
    EmitSfx( body,  1024 )
end
local sfxFall=SFX.FALL
local sfxExplodeOnHit=2
function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	EmitSfx( body,  1025 )
	EmitSfx( head,  1025 )
	EmitSfx( rbladeu,  1025 )
	EmitSfx( lbladel,  1025 )
	EmitSfx( tail,  1025 )
	EmitSfx( rthighf,  1025 )
	EmitSfx( rthighb,  1025 )
	EmitSfx( lthighf,  1025 )
	EmitSfx( lthighb,  1025 )
	EmitSfx( rfootf,  1025 )
	EmitSfx( rfootb,  1025 )
	EmitSfx( lfootf,  1025 )
	EmitSfx( lfootb,  1025 )
	Explode( body, sfxFall + sfxExplodeOnHit)
	Explode( head, sfxFall + sfxExplodeOnHit)
	Explode( tail, sfxFall + sfxExplodeOnHit)
	Explode( lthighf, sfxFall + sfxExplodeOnHit)
	Explode( lkneef, sfxFall + sfxExplodeOnHit)
	Explode( lshinf, sfxFall + sfxExplodeOnHit)
	Explode( lfootf, sfxFall + sfxExplodeOnHit)
	Explode( rthighf, sfxFall + sfxExplodeOnHit)
	Explode( rkneef, sfxFall + sfxExplodeOnHit)
	Explode( rshinf, sfxFall + sfxExplodeOnHit)
	Explode( rfootf, sfxFall + sfxExplodeOnHit)
	Explode( lthighb, sfxFall + sfxExplodeOnHit)
	Explode( lkneeb, sfxFall + sfxExplodeOnHit)
	Explode( lshinb, sfxFall + sfxExplodeOnHit)
	Explode( lfootb, sfxFall + sfxExplodeOnHit)
	Explode( rthighb, sfxFall + sfxExplodeOnHit)
	Explode( rkneeb, sfxFall + sfxExplodeOnHit)
	Explode( rshinb, sfxFall + sfxExplodeOnHit)
	Explode( rfootb, sfxFall + sfxExplodeOnHit)
	Explode( lforearml, sfxFall + sfxExplodeOnHit)
	Explode( lbladel, sfxFall + sfxExplodeOnHit)
	Explode( rforearml, sfxFall + sfxExplodeOnHit)
	Explode( rbladel, sfxFall + sfxExplodeOnHit)
	Explode( lforearmu, sfxFall + sfxExplodeOnHit)
	Explode( lbladeu, sfxFall + sfxExplodeOnHit)
	Explode( rforearmu, sfxFall + sfxExplodeOnHit)
	Explode( rbladeu, sfxFall + sfxExplodeOnHit)
	Explode( spike1, sfxFall + sfxExplodeOnHit)
	Explode( spike2, sfxFall + sfxExplodeOnHit)
	Explode( spike3, sfxFall + sfxExplodeOnHit)
	Explode( firepoint, sfxFall + sfxExplodeOnHit)
	if severity<0.5 then
		
		dyncomm.SpawnModuleWrecks(1)
		dyncomm.SpawnWreck(1)
	else
		
		dyncomm.SpawnModuleWrecks(2)
		dyncomm.SpawnWreck(2)
	end
end