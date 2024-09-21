VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("silly_morth","tankriot","tankriotarty")
utils.add_build("silly_build","bigsillycon","tankriotarty")
return utils.copy_tweak("tankriot","tankriotarty",function (ud)
    utils.table_replace({
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
    )(ud)
    --utils.set_scale(ud,2)
end)
--