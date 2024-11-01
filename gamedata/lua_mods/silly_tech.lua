VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.add_fn_to_fn_list("def","sillycon_into_buildoption",function ()
    UnitDefs.sillycon.customparams.is_default_buildoption=1
    UnitDefs.sillycon.customparams.integral_menu_be_in_tab=[==[
        {
          tab="FACTORY",
          pos= {order = 14, row = 3, col = 1},
        }
        ]==]
end)
utils.add_build("def","sillycon","bigsillycon")
utils.add_build("def","bigsillycon","verybigsillycon")
return {option_notes="Builder -> Silly Con -> Very Silly Con -> Very Very Silly Con"}