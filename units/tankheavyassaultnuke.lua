VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorphAuto("tankheavyassault","tankheavyassaultnuke",utils.table_replace({
    name="Nuclear Cyclops",
    description="Shoot Nuclear Warhead (175 stockpile)",
    metalCost=6660,
    health=36000,
    speed=45,
    weaponDefs={
        COR_GOL={
            name                    = [[Nuclear Cannon]],
            areaOfEffect            = 192,
            damage                  = {
                default = 3502.4,
            },
            edgeEffectiveness       = 0.4,
            explosionGenerator      = [[custom:NUKE_150]],
            impulseBoost            = 0,
            impulseFactor           = 0.4,
            stockpile               = true,
            stockpileTime           = 10^5,
            soundHit                = [[explosion/mini_nuke]],
            range=350,
            weaponVelocity          = 300,
        },
        SLOWBEAM={
            range=620,
            damage={
                default=3000,
            }
        }
    },
    customParams={
        stockpiletime  = [[15]],
        stockpilecost  = [[175]],
        priority_misc  = 2,
        def_scale=1.7,
        bait_level_default=3,
        tactical_ai_defs_behaviour_config=[=[{
            name = "tankheavyassaultnuke",
            skirms = lowRangeSkirmieeArray,
            --swarms = {},
            --flees = {},
            avoidHeightDiff = explodableFull,
            fightOnlyUnits = shortRangeExplodables,
            skirmOrderDis = 220,
            skirmLeeway = 50,
            skirmBlockedApproachFrames = 60,
	    }]=],
        tactical_ai_defs_belongs_to_copy="tankheavyassault",
    },
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST"
}))