
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("shieldshield","shieldshieldpro")
return utils.copy_tweak("shieldshield","shieldshieldpro",function (ud)
    ud.name = "Greater " .. ud.name
    ud.description = "Greater Shield to counter greater silly"
    ud.metalCost=ud.metalCost*10
    ud.health=ud.health*10
    local wd=ud.weaponDefs.COR_SHIELD_SMALL
    wd.shieldPower=wd.shieldPower*9
    wd.shieldPowerRegen=wd.shieldPowerRegen*9
    wd.shieldPowerRegenEnergy=wd.shieldPowerRegenEnergy*9
    wd.shieldRadius=wd.shieldRadius*2
end)