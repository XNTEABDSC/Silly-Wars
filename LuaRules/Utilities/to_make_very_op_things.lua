
if not Spring.Utilities.to_make_very_op_things then
    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local utils=Spring.Utilities.wacky_utils

    VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local utils_op=Spring.Utilities.to_make_op_things
    local to_make_very_op_things={}
    Spring.Utilities.to_make_very_op_things=to_make_very_op_things
    --- from SmokeDragon
    
    -- too op
    
    
end

local luaFiles=VFS.DirList("LuaRules/Utilities/to_make_very_op_things", "*.lua") or {}
for i = 1, #luaFiles do
    VFS.Include(luaFiles[i])
end

return Spring.Utilities.to_make_very_op_things