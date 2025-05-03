
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return {
    silly=function ()
        return {mods="silly_tech() silly_build() silly_morph_simple() silly_morph_big() more_build() add_chixs()"}
    end,
    silly_tech=function ()
      
      utils.AddFnToUnitDefsTweakFns({
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
  
      return {option_notes="Tech Tree: Builder -> Silly Con -> Very Silly Con -> Very Very Silly Con"}
    end,
    silly_build=function ()
        
        utils.PushOptionalUnitDefsTweakFns("silly_build")

        return {option_notes="Silly things can be built by silly cons"}
    end,
    silly_morph_simple=function ()
        
        utils.PushOptionalUnitDefsTweakFns("silly_morph_simple")

        return {option_notes="Units can morth into its mutate version"}
    end,
    silly_morph_big=function ()
        utils.PushOptionalUnitDefsTweakFns("silly_morph_big")
        
        return {option_notes="Silly things can morph from other things"}
    end,
    more_build={
        fn=function ()
            
            utils_op.MakeAddSillyBuild("chicken_leaper","sillyconvery")
            utils_op.MakeAddSillyBuild("dronefighter","sillyconvery")

            utils.AddFnToUnitDefsTweakFns({
                k="more_build",
                b={"default_add_build_begin"},
                a={"default_add_build_end"},
                v=function ()
                    local add_build=function (a,b)
                        UnitDefs[a].buildoptions[#UnitDefs[a].buildoptions+1]=b
                    end
                    add_build("striderhub","dyntrainer_assault_base")
                    add_build("striderhub","dyntrainer_recon_base")
                    add_build("striderhub","dyntrainer_strike_base")
                    add_build("striderhub","dyntrainer_support_base")
                    add_build("striderhub","dyntrainer_knight_base")
                    add_build("striderhub","dyntrainer_chicken_base")
                    --add_build("staticcon","staticcon")
                    add_build("striderhub","nebula")
                end
            })



            return {option_notes="Strider Hub can build Commanders and Nebula;\n Big Silly Con can build Leaper and Spicula"}
        end
    }
}