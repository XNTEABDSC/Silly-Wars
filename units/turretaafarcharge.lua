VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("turretaafar","turretaafarcharge",function (ud)
    utils.table_replace({
        name="Hailstorm",
        description="Heavy SAM Battery (from Future Wars but better)",
        weaponDefs={
            MISSILE={
                
                customParams={
                    script_reload =  3*14,
                    script_burst = 14,
                },
                reloadtime=1/30,
            }
        },
        script                        = [[turretaafarcharge.lua]],
        metalCost=1600,
        customParams={
            translations=[=[{
                en={
                    name="Hailstorm",
                    description="Heavy SAM Battery (from Future Wars but better)",
                    helptext="Hailstorm"
                }
            }]=]
        }
    })(ud)
    ud.
        weapons                       = {

            {
            def                = [[MISSILE]],
            --badTargetCategory  = [[GUNSHIP]],
            onlyTargetCategory = [[FIXEDWING GUNSHIP]],
            },
            {
            def                = [[MISSILE]],
            --badTargetCategory  = [[GUNSHIP]],
            onlyTargetCategory = [[FIXEDWING GUNSHIP]],
            },

        }
        
end)