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

local function Use_unit_weapon_num_to_custom_weapon_num_or_defnum(origFn,defnum)
    if origFn then
        return function (num,...)
            num=unit_weapon_num_to_custom_weapon_num[num] or defnum
            return origFn(num,...)
        end
    else
        return nil
    end
end
local function Use_unit_weapon_num_to_custom_weapon_num(origFn,defvalue)
    if origFn then
        return function (num,...)
            num=unit_weapon_num_to_custom_weapon_num[num]
            if num then
                return origFn(num,...)
            else
                return defvalue
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

script.AimFromWeapon=Use_unit_weapon_num_to_custom_weapon_num_or_defnum(script.AimFromWeapon,DefPieceWeaponNum)

script.QueryWeapon=Use_unit_weapon_num_to_custom_weapon_num_or_defnum(script.QueryWeapon,DefPieceWeaponNum)

script.FireWeapon=Use_unit_weapon_num_to_custom_weapon_num(script.FireWeapon,nil)

script.Shot=Use_unit_weapon_num_to_custom_weapon_num(script.Shot,nil)

script.EndBurst=Use_unit_weapon_num_to_custom_weapon_num(script.EndBurst,nil)
