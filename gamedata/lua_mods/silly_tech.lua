VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.AddFnToUnitDefsTweakFns({
  k="sillycon_as_default",
  v=function ()
      UnitDefs.sillycon.customparams.is_default_buildoption=1
      UnitDefs.sillycon.customparams.integral_menu_be_in_tab=[==[
          {
          tab="FACTORY",
          pos= {order = 14, row = 3, col = 1},
          }
          ]==]
  end
})
utils_op.MakeAddSillyBuild("sillyconvery","sillycon")
utils_op.MakeAddSillyBuild("sillyconveryvery","sillyconvery")

return {option_notes="Builder -> Silly Con -> Very Silly Con -> Very Very Silly Con"}