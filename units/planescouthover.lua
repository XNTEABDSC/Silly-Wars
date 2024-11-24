VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local tbnil=utils.table_replace_nil
return utils_op.CopyTweakSillyBuildMorph("planescout","planescouthover",function (ud)
    utils.table_replace({
        metalCost=750,
        health=2250,
        acceleration        = 0.288,
        canFly=tbnil,
        category            = [[UNARMED HOVER]],
        customParams={
            def_scale=1.2,
            refuelturnradius=tbnil,
            turnatfullspeed_hover = [[1]],
            
            canjump            = 1,
            jump_range         = 600,
            jump_speed         = 6,
            jump_reload        = 15,
            sonar_can_be_disabled = tbnil,
            disable_radar_preview = tbnil,
            tactical_ai_defs_copy="planescout",
        },
        movementClass       = [[HOVER3]],
        moveState           = 0,
        speed=81,
        turnRate            = 985,
        cruiseAltitude      = tbnil,
        maxSlope            = 36,
        maxAcc              = tbnil,
        maxAileron          = tbnil,
        maxElevator         = tbnil,
        maxRudder           = tbnil,
        iconType="planescouthover",
        workerTime          = tbnil,
        collide             = tbnil,
    })(ud)
end)