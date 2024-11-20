VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils.copy_tweak_silly_build_morth("cloakraid","cloakraidepic","bigsillycon",function (ud)
    to_make_very_op_things.good_scale_unit(ud,100)
    ud.name="Epic " .. ud.name
    ud.description=ud.description .. ", but bigger"
    ud.iconType="cloakraidepic"
end)