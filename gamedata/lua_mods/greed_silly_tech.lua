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

utils_op.AddFnToUnitDefsTweakFns({
    k="greed_silly_tech",
    b={"load_modoptions_end"},
    v=function ()
        UnitDefs["athena"].buildoptions[#UnitDefs["athena"].buildoptions+1]="sillyconvery"
        UnitDefs["striderhub"].buildoptions[#UnitDefs["striderhub"].buildoptions+1]="sillyconveryvery"
    end
})

utils.add_fn_to_fn_list("def_pre","greed_silly_tech",function ()
    
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

return {option_notes="Builder -> Silly Con; Athena -> Very Silly Con; Strider Hub -> Very Very Silly Con"}