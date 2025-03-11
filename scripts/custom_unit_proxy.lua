local CustomUnitProxyUsingScript,DefPieceWeaponNum=CustomUnitProxyUsingScript,DefPieceWeaponNum

local CustomUnitProxyUsingScriptFile="scripts/" .. CustomUnitProxyUsingScript

local customUnitScript
local unit_weapon_num_to_custom_weapon_num
if false then
    customUnitScript=GG.CustomUnits.CreateCustomUnitscript(unitID)
    unit_weapon_num_to_custom_weapon_num=customUnitScript.unit_weapon_num_to_custom_weapon_num
    
end

function SetCustomUnitScript()
    customUnitScript=GG.CustomUnits.CreateCustomUnitscript(unitID)
    unit_weapon_num_to_custom_weapon_num=customUnitScript.unit_weapon_num_to_custom_weapon_num
end

local function Use_unit_weapon_num_to_custom_weapon_num(origFn,defReturn)
    if origFn then
        return function (num,...)
            num=unit_weapon_num_to_custom_weapon_num[num]
            if not num then
                return defReturn
            else
                return origFn(num,...)
            end
            
        end
    else
        return nil
    end
end

local chunk=Spring.UnitScript.scripts[CustomUnitProxyUsingScriptFile]
if not chunk then
    error("chunk " .. CustomUnitProxyUsingScriptFile .. " not found")
end
setfenv(chunk,_G)
Spring.UnitScript.CallAsUnit(unitID,chunk)

--VFS.Include(CustomUnitProxyUsingScriptFile,__G)


script.BlockShot=Use_unit_weapon_num_to_custom_weapon_num(script.BlockShot,true)

--local orig_AimWeapon=script.AimWeapon

script.AimWeapon=Use_unit_weapon_num_to_custom_weapon_num(script.AimWeapon,false)

if script.AimFromWeapon then
    script.AimFromWeapon=Use_unit_weapon_num_to_custom_weapon_num(script.AimFromWeapon,script.AimFromWeapon(DefPieceWeaponNum))
end
if script.QueryWeapon then
    script.QueryWeapon=Use_unit_weapon_num_to_custom_weapon_num(script.QueryWeapon,script.QueryWeapon(DefPieceWeaponNum))
end

script.FireWeapon=Use_unit_weapon_num_to_custom_weapon_num(script.FireWeapon,nil)

script.Shot=Use_unit_weapon_num_to_custom_weapon_num(script.Shot,nil)

script.EndBurst=Use_unit_weapon_num_to_custom_weapon_num(script.EndBurst,nil)
