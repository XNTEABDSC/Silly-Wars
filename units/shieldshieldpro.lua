
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("shieldshield","shieldshieldpro")
return utils.copy_tweak("shieldshield","shieldshieldpro",function (ud)
    ud.name = "Greater " .. ud.name
    ud.description = "Greater Shield to counter greater silly"
    ud.metalCost=ud.metalCost*4
    ud.health=ud.health*4
    local wd=ud.weaponDefs.COR_SHIELD_SMALL
    wd.shieldPower=wd.shieldPower*3.5
    wd.shieldPowerRegen=wd.shieldPowerRegen*3.5
    wd.shieldPowerRegenEnergy=wd.shieldPowerRegenEnergy*3.5
    wd.shieldRadius=wd.shieldRadius*1.5
end)