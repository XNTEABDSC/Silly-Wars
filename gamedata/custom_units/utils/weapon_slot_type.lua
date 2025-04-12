---[=[
--- merge
--- slot:{
---     allow weapons,
---     
---     Use Weapon( custom_weapon, weapon slot, )->{
---         map_unit_weapon_slot_to_custom_weapon_slot 
---     }
--- }
---]=]

--[=[

---
---
local function TargeterSlot(targeter)
    return {
        allow_weapons={}
    }
end
]=]
--[=[
local wacky_utils = Spring.Utilities.wacky_utils
local utils=Spring.GameData.CustomUnits.utils

local function Slot()
    return {
        unit_weapons={},
        --allow_weapons={},
    }
end

local function GenWeaponSlotForTargeter(targeter)
    return {
        unit_weapons={targeter.name},
        --allow_weapons={},
    }
end

local function MergeSlot(slot1,slot2)
    return {
        unit_weapons=wacky_utils.mt_chain(slot1.unit_weapons,slot2.unit_weapons),
        --allow_weapons=wacky_utils.mt_union(slot1.allow_weapons,slot2.allow_weapons),
    }
end

utils.WeaponSlotForTargeter=GenWeaponSlotForTargeter
utils.MergeWeaponSlot=MergeSlot
local WeaponSlots={}
utils.WeaponSlots=WeaponSlots

WeaponSlots.projectile=GenWeaponSlotForTargeter(utils.targeterweapons.projectile_targeter)
WeaponSlots.line=GenWeaponSlotForTargeter(utils.targeterweapons.line_targeter)
WeaponSlots.aa=GenWeaponSlotForTargeter(utils.targeterweapons.aa_targeter)

Spring.GameData.CustomUnits.utils=utils
]=]