VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeAddSillyBuild("chicken_leaper","sillyconvery")
utils_op.MakeAddSillyBuild("dronefighter","sillyconvery")

utils_op.AddFnToUnitDefsTweakFns({
    k="more_build",
    b={"default_add_build_begin"},
    a={"default_add_build_end"},
    v=function ()
        local add_build=function (a,b)
            UnitDefs[a].buildoptions[#UnitDefs[a].buildoptions+1]=b
        end
        add_build("striderhub","dynhub_assault_base")
        add_build("striderhub","dynhub_recon_base")
        add_build("striderhub","dynhub_strike_base")
        add_build("striderhub","dynhub_support_base")
        add_build("striderhub","dynknight0")
        add_build("striderhub","dynchicken0")
        --add_build("staticcon","staticcon")
        add_build("striderhub","nebula")
    end
})



return {option_notes="Strider Hub can build Commanders and Nebula;\n Big Silly Con can build Leaper and Spicula"}