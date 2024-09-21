VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("silly_morth","bomberdisarm","bomberemp")

utils.add_build("silly_build","sillycon","bomberemp")

return utils.copy_tweak("bomberdisarm","bomberemp",function (ud)
    utils.table_replace({
        name="EMP Bird",
        description         = [[Paralyse Lightning Bomber]],
        weaponDefs={
            ARMBOMBLIGHTNING={
                customParams={
                    disarmDamageMult=utils.table_replace_nil,
                    disarmDamageOnly=utils.table_replace_nil,
                    disarmTimer=utils.table_replace_nil,
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
    ud.health=ud.health*1.75

end)