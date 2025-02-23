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