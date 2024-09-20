VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("silly_morth","tankheavyassault","tankheavyassaultnuke")
utils.add_build("silly_build","bigsillycon","tankheavyassaultnuke")
return utils.copy_tweak("tankheavyassault","tankheavyassaultnuke",utils.do_tweak({
    name="Nuclear Cyclops",
    description="Shoot Nuclear Warhead (200 stockpile)",
    metalCost=8000,
    health=32000,
    speed=51,
    weaponDefs={
        COR_GOL={
            name                    = [[Nukey Cannon]],
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
            reloadtime              = 6,
            weaponVelocity          = 200,
        },
    },
    customParams={
        stockpiletime  = [[15]],
        stockpilecost  = [[200]],
        priority_misc  = 1,
        def_scale=2
    },
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST"
}))