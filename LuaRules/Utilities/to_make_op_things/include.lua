if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.to_make_op_things then
    Spring.Utilities.to_make_op_things={}
end
if not Spring.Utilities.to_make_op_things.to_make_op_things_include then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    
    local function to_make_op_things_include(name)
        
        VFS.Include("LuaRules/Utilities/to_make_op_things/" .. name .. ".lua")
    end
    to_make_op_things.to_make_op_things_include=to_make_op_things_include

    Spring.Utilities.to_make_op_things=to_make_op_things
end