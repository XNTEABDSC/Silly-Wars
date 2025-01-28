local utils=GameData.CustomUnits.utils
utils.BasicWeaponMutate={
    damage=utils.TableMutate(utils.MutateCostMassAnd({damage_default_mut=utils.bias_factor})),
    range=utils.TableMutate({range_mut=utils.bias_factor*0.5,cost=1}),
    speed=utils.TableMutate({projSpeed_mut=utils.bias_factor*2,cost=1}),
    reload_time=utils.TableMutate(utils.MutateCostMassAnd({reload_time_mut=-utils.bias_factor})),
}
utils.UseWeaponMutateTable=utils.UseMutateTable(utils.BasicWeaponMutate)
GameData.CustomUnits.utils=utils