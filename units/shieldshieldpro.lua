
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.set_morth_mul("silly_morth","shieldshield","shieldshieldpro")
utils.add_build("silly_build","bigsillycon","shieldshieldpro")
return utils.copy_tweak("shieldshield","shieldshieldpro",function (ud)
    ud.name = "Greater " .. ud.name
    ud.description = "Greater Shield to counter greater silly"
    ud.metalCost=ud.metalCost*4
    ud.health=ud.health*2.5
    ud.customParams.tactical_ai_defs_copy="shieldshield"
    local wd=ud.weaponDefs.COR_SHIELD_SMALL
    wd.shieldPower=wd.shieldPower*3
    wd.shieldPowerRegen=wd.shieldPowerRegen*3
    wd.shieldPowerRegenEnergy=wd.shieldPowerRegenEnergy*3
    wd.shieldRadius=wd.shieldRadius*1.5
end)