VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
local add_build=function (a,b)
    utils.add_build("def",a,b)
end
add_build("bigsillycon","chicken_leaper")
add_build("striderhub","dynhub_assault_base")
add_build("striderhub","dynhub_recon_base")
add_build("striderhub","dynhub_strike_base")
add_build("striderhub","dynhub_support_base")
add_build("striderhub","dynknight0")
add_build("bigsillycon","dronefighter")

add_build("staticcon","staticcon")
add_build("striderhub","nebula")


return {option_notes="Strider Hub -> Commanders , Nebula\n Big Silly Con-> Leaper , Spicula"}