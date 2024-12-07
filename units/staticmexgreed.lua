VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorph("staticmex", "staticmexgreed", utils.table_replace({
    name                   = [[Greed Metal Extractor]],
    description            = [[Produces 10x Metal]],
    metalCost = 10000,
    health = 16000,
    selfDestructAs = [[AMPHBOMB_DEATH]],
    explodeAs = [[AMPHBOMB_DEATH]],
    customParams = {
        metal_extractor_mult = 10,
    },
    sfxtypes = {
        explosiongenerators = {
            [[custom:RAIDMUZZLE]],
            [[custom:VINDIBACK]],
            [[custom:RIOTBALL]],
        },
    },
    weapons = {
        {
            def = [[BIGSHIELD]],
        },
    },
    weaponDefs = {
        AMPHBOMB_DEATH = {
            areaOfEffect = 5000,
            craterBoost = 1,
            craterMult = 3.5,
            customparams = {
                lups_explodespeed = 1.04,
                lups_explodelife = 0.88,
                timeslow_damagefactor = 10,
                timeslow_overslow_frames = 2 * 30,
                nofriendlyfire = 1,
                light_color = [[1.88 0.63 2.5]],
                light_radius = 320,
            },
            damage = {
                default = 120.1,
            },
            edgeEffectiveness = 1,
            explosionGenerator = "custom:riotballplus2_purple_limpet",
            explosionSpeed = 10,
            impulseBoost = 10,
            impulseFactor = 10,
            name = "Slowing Explosion",
            soundHit = [[weapon/aoe_aura2]],
            soundHitVolume = 4,
        },
        BIGSHIELD = {
            name = [[Big Energy Shield]],
            damage = {
                default = 10,
            },
            customParams = {
                unlinked = true,
            },
            exteriorShield = true,
            shieldAlpha = 0.01,
            shieldBadColor = [[0.1 0.01 0.01 0.1]],
            shieldGoodColor = [[0.01 0.01 0.1 0.1]],
            shieldInterceptType = 3,
            shieldPower = 10000,
            shieldPowerRegen = 100,
            shieldPowerRegenEnergy = 0,
            shieldRadius = 800,
            shieldRepulser = false,
            shieldStartingPower = 0,
            smartShield = true,
            visibleShield = false,
            visibleShieldRepulse = false,
            weaponType = [[Shield]],
        },
    },
}
))
