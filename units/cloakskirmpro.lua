VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


utils_op.MakeSetSillyMorph("cloakskirm","cloakskirmpro")
utils_op.MakeAddSillyBuild("cloakskirmpro")

return utils_op.CopyTweak("cloakskirm","cloakskirmpro",function (ud)
    utils.table_replace({
        metalCost=250,
        speed=75,
        health=650,
        name="Guided Ronin",
        description=[[Skirmisher Bot (Homing Missile)]],
        weaponDefs={
            BOT_ROCKET={
                tracks                  = true,
                turnRate                = 10000,
            },
        },
        customParams={
            tactical_ai_defs_copy="cloakskirm",
            --[====[
            tactical_ai_defs_behaviour_config=
            [===[{
                name = "cloakskirmpro",

                skirms = medRangeAndTurretSkirmieeArray,
                swarms = medRangeSwarmieeArray,
                avoidHeightDiff = explodableFull,
                fightOnlyUnits = medRangeExplodables,
                maxSwarmLeeway = 30,
                minSwarmLeeway = 130,
                jinkPeriod = 2.5,
                skirmLeeway = 10,
                reloadSkirmLeeway = 1.2,
                skirmBlockedApproachFrames = 60,
                velPredChaseFactor = 0.9,
                skirmBlockedApproachOnFight = true,

                bonusRangeUnits = personalShieldUnits,
                wardFireTargets = personalShieldUnits,
                wardFireLeeway = 20,
                wardFireHeight = 20,
                wardFirePredict = 50,
                wardFireShield = 200,
                wardFireDefault = true,
                }
            ]===]
            ]====]
        }
    })(ud)
end)