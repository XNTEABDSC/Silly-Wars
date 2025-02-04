



local utils=Spring.Utilities.CustomUnits.utils

local targeterwdid_to_custom_weapon_num={}
for key, value in pairs(GameData.CustomUnits.utils.targeterweapons) do
    for i = 1, GameData.CustomUnits.utils.targeters_wpnnum_count do
        local wd=WeaponDefNames[key..tostring( i )]
        targeterwdid_to_custom_weapon_num[ wd.id ]=i
    end
end
utils.targeterwdid_to_custom_weapon_num=targeterwdid_to_custom_weapon_num

Spring.Utilities.CustomUnits.utils=utils