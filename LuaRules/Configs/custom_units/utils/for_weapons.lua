local utils=Spring.Utilities.CustomUnits.utils
utils.BasicWeaponMutate={
    damage=utils.TableMutate(utils.MutateCostMassAnd({damage=utils.bias_factor})),
    range=utils.TableMutate({range=utils.bias_factor*0.5,cost=1,mass=2}),
    speed=utils.TableMutate({speed=utils.bias_factor*2,cost=1,mass=1}),
    reload_time=utils.TableMutate(utils.MutateCostMassAnd({reload_time=-utils.bias_factor})),
}
utils.UseWeaponMutateTable=utils.UseMutateTable(utils.BasicWeaponMutate)
Spring.Utilities.CustomUnits.utils=utils