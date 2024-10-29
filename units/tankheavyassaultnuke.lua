VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.set_morth_mul("silly_morth","tankheavyassault","tankheavyassaultnuke")
utils.add_build("silly_build","bigsillycon","tankheavyassaultnuke")
return utils.copy_tweak("tankheavyassault","tankheavyassaultnuke",utils.table_replace({
    name="Nuclear Cyclops",
    description="Shoot Nuclear Warhead (200 stockpile)",
    metalCost=8000,
    health=40000,
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
            reloadtime              = 5,
            weaponVelocity          = 300,
        },
        SLOWBEAM={
            range=620,
            damage={
                default=3500,
            }
        }
    },
    customParams={
        stockpiletime  = [[15]],
        stockpilecost  = [[200]],
        priority_misc  = 2,
        def_scale=1.7,
        bait_level_default=3,
    },
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST"
}))