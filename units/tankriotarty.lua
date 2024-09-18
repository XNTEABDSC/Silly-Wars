VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("tankriot","tankriotarty")
utils.add_build("sillycon","tankriotarty")
return utils.copy_tweak("tankriot","tankriotarty",utils.do_tweak({
    name="Ranged Orge",
    description="Orge with just Adv. Targeting System (expensive)",
    weaponDefs={
        TAWF_BANISHER={
            range=1200
        }
    },
    metalCost=5000,
    speed=38,
    customParams={
        def_scale=2
    },
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST",
}
))