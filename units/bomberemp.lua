VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

utils_op.MakeSetSillyMorph("bomberdisarm","bomberemp")

utils_op.MakeAddSillyBuild("bomberemp")

return utils_op.CopyTweak("bomberdisarm","bomberemp",function (ud)
    utils.table_replace({
        name="EMP Bird",
        description         = [[Paralyse Lightning Bomber]],
        weaponDefs={
            ARMBOMBLIGHTNING={
                customParams={
                    disarmDamageMult=utils.None,
                    disarmDamageOnly=utils.None,
                    disarmTimer=utils.None,
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