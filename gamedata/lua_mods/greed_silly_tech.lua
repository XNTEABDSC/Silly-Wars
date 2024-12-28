VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local GreedFactor = GreedFactor or 4

utils_op.AddFnToUnitDefsTweakFns({
    k="sillycon_integral_menu_be_in_tab",
    v=function ()
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
    b={"default_add_build_begin"},
    a={"default_add_build_end"},
    v=function ()

        UnitDefs.cloakcon.buildoptions[#UnitDefs.cloakcon.buildoptions+1] = "sillycon"
        UnitDefs["athena"].buildoptions[#UnitDefs["athena"].buildoptions+1]="sillyconvery"
        UnitDefs["striderhub"].buildoptions[#UnitDefs["striderhub"].buildoptions+1]="sillyconveryvery"
    end
})
utils_op.AddFnToUnitDefsTweakFns({
    k="greed_silly_super_mult",
    v=function ()
        local super_list={
            "pdrp",
            "emppudrp",
            "mahlazercap",
            "thepeace"
        }
        for key, value in pairs(super_list) do
            UnitDefs[value].metalcost=UnitDefs[value].metalcost*10
        end
    end,
    b={"default_modify_cost_begin"},
    a={"default_modify_cost_end"},
})

return {option_notes="Builder -> Silly Con; Athena -> Very Silly Con; Strider Hub -> Very Very Silly Con"}