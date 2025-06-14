VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("cloakraidgreat","cloakraidepic",function (ud)
    to_make_very_op_things.good_scale_unit(ud,10)
    ud.name="Epic Glaive"
    ud.description="Epic Raider Bot"
    ud.iconType="cloakraidepic"
    ud.customParams.tactical_ai_defs_belongs_to_copy="cloakraid"
    ud.customParams.tactical_ai_defs_behaviour_config_copy="cloakraid"
    ud.customParams.translations=[=[{
        en={
            name="Epic Glaive",
            description="Epic Raider Bot",
            helptext="100x glaive"
        }
    }]=]
end)