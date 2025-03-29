VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return {
  custom_units={
    fn=function ()
      
      utils_op.AddFnToUnitDefsTweakFns({
        k="customunitcon_as_default",
        v=function ()
            UnitDefs.customunitcon.customparams.is_default_buildoption=1
            UnitDefs.customunitcon.customparams.integral_menu_be_in_tab=[==[
                {
                tab="FACTORY",
                pos= {order = 15, row = 3, col = 2},
                }
                ]==]
        end
      })

      return {option_notes="Can Make Custom Units",custon_units=true}
    end
  }
}