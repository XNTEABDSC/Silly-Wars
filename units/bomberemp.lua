VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("bomberdisarm","bomberemp")

utils.add_build("sillycon","bomberemp")

return utils.copy_tweak("bomberdisarm","bomberemp",function (ud)
    utils.do_tweak({
        name="EMPbird",
        description         = [[Paralyse Lightning Bomber]],
        WeaponDefs={
            ARMBOMBLIGHTNING={
                customParams={
                    disarmDamageMult=nil,
                    disarmDamageOnly=nil,
                    disarmTimer=nil,
                },
                paralyzer               = true,
                paralyzeTime            = 16,
                rgbColor                = [[1 1 0.25]],
            }
        },
        customParams={
            def_scale=1.5
        }
        
    })(ud)
    ud.metalCost=ud.metalCost*2.5
    ud.health=ud.health*2

end)