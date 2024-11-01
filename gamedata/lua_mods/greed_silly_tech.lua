VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.add_fn_to_fn_list("def_pre","greed_silly_tech",function ()
    UnitDefs.sillycon.customparams.is_default_buildoption=1
    UnitDefs.sillycon.customparams.integral_menu_be_in_tab=[==[
        {
          tab="FACTORY",
          pos= {order = 14, row = 3, col = 1},
        }
        ]==]
    --utils.add_build("def_post","staticcon","sillycon")
    local super_list={
        "pdrp",
        "emppudrp",
        "mahlazercap",
        "thepeace"
    }
    for key, value in pairs(super_list) do
        UnitDefs[value].metalcost=UnitDefs[value].metalcost*10
    end
end)
utils.add_build("def_post","athena","bigsillycon")
utils.add_build_front("def_post","striderhub","verybigsillycon")

return {option_notes="Builder -> Silly Con; Athena -> Very Silly Con; Strider Hub -> Very Very Silly Con"}