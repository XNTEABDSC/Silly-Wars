local utils=GameData.CustomUnits.utils

--[=[
utils.BasicWeaponMutate={
    damage=utils.TableMutate(utils.MutateCostMassAnd({damage_default_mut=utils.bias_factor})),
    range=utils.TableMutate({range_mut=utils.bias_factor*0.75,cost=1}),
    speed=utils.TableMutate({projSpeed_mut=utils.bias_factor*2,cost=1}),
    reload_time=utils.TableMutate(utils.MutateCostMassAnd({reload_time_mut=-utils.bias_factor})),
}
utils.BeamWeaponMutate={
    range=utils.TableMutate({range_mut=utils.bias_factor*0.5,cost=1}),
}
utils.PlasmaWeaponMutateTable=utils.BasicWeaponMutate
utils.BeamWeaponMutateTable={
    damage=utils.BasicWeaponMutate.damage,
    reload_time=utils.BasicWeaponMutate.reload_time,
    range=utils.BeamWeaponMutate.range,
}
utils.UsePlasmaWeaponMutateTable=utils.UseMutateTable(utils.PlasmaWeaponMutateTable)
utils.UseBeamWeaponMutateTable=utils.UseMutateTable(utils.BeamWeaponMutateTable)
]=]

---@type table<string,CustomModify>
local weapon_modifies={}
utils.weapon_modifies=weapon_modifies
local genCustomModify=utils.genCustomModify
weapon_modifies.damage=
genCustomModify("damage","add damage","unitpics/module_dmg_booster.png",utils.TableMutate(utils.MutateCostMassAnd({damage_default_mut=utils.bias_factor})),"number")


weapon_modifies.proj_speed=
genCustomModify("speed","add projectiles' speed","unitpics/commweapon_assaultcannon.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)
    tb.projSpeed_mut=tb.projSpeed_mut*factor^(utils.bias_factor*2)
end,"number")


weapon_modifies.proj_range=
genCustomModify("range","add projectiles' range","unitpics/module_adv_targeting.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)
    tb.range_mut=tb.range_mut*factor^(utils.bias_factor)
end,"number"
)
weapon_modifies.beam_range=
genCustomModify("range","add beams' range","unitpics/module_adv_targeting.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)
    tb.range_mut=tb.range_mut*factor^(utils.bias_factor*0.5)
end,"number"
)

weapon_modifies.reload=
genCustomModify("reload","reduce reload time","unitpics/weaponmod_autoflechette.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(factor)
    tb.reload_time_mut=tb.reload_time_mut*factor^(-utils.bias_factor)
end,"number"
)


GameData.CustomUnits.utils=utils