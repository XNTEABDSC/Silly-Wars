VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local tbnil=utils.None
return utils_op.CopyTweakSillyBuildMorphAuto("planescout","planescouthover",function (ud)
    utils.table_replace({
        name="Not Flying Owl",
        description="Flying is too danger, just jump",
        metalCost=500,
        health=1000,
        acceleration        = 0.288,
        canFly=tbnil,
        category            = [[UNARMED HOVER]],
        customParams={
            refuelturnradius=tbnil,
            turnatfullspeed_hover = [[1]],
            
            canjump            = 1,
            jump_range         = 600,
            jump_speed         = 6,
            jump_reload        = 5,
            sonar_can_be_disabled = tbnil,
            disable_radar_preview = tbnil,
            
            tactical_ai_defs_behaviour_config=[=[{
                name="planescouthover",
                searchRange = 1200,
                fleeEverything = true,
                minFleeRange = 600, -- Avoid enemies standing in front of Pickets
                fleeLeeway = 600,
                fleeDistance = 600,
            }]=]
        },
        movementClass       = [[HOVER3]],
        moveState           = 0,
        speed=72,
        turnRate            = 400,
        cruiseAltitude      = tbnil,
        maxSlope            = 36,
        maxAcc              = tbnil,
        maxAileron          = tbnil,
        maxElevator         = tbnil,
        maxRudder           = tbnil,
        iconType="planescouthover",
        workerTime          = tbnil,
        collide             = tbnil,
        --radarEmitHeight=-500, sed nouse
        --losEmitHeight=-500,
    })(ud)
end)