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
weapon_modifies.name=
genCustomModify("name","name","unitpics/terraunit.png",function (data,name)
    data.name=name
end,"string")

weapon_modifies.damage=
genCustomModify("damage","add damage","unitpics/module_dmg_booster.png",utils.TableMutate(utils.MutateCostMassAnd({damage_default_mut=utils.bias_factor})),"number")


weapon_modifies.proj_speed=
genCustomModify("speed","add projectiles' speed","unitpics/commweapon_assaultcannon.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)
    tb.projSpeed_mut=tb.projSpeed_mut*factor^(utils.bias_factor)
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
    --tb.range_mut=tb.range_mut*factor^(utils.bias_factor*0.5)
    tb.range_mut=tb.range_mut*( ( (1+factor)^(utils.bias_factor*0.75)-1 )*2 )
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


weapon_modifies.into_aa=
genCustomModify("into_aa","make this a aa weapon","icons/kbotaa.dds",
---@param tb CustomWeaponDataModify
function (tb,flag)
    if flag then
        tb.range_mut=tb.range_mut*2
        tb.projSpeed_mut=tb.projSpeed_mut*1.5
        tb.targeter_weapon="aa_targeter"
    end
end,"boolean"
)
do
    local postfix="_tracks"
    weapon_modifies.tracks=
    genCustomModify("tracks","allow missile tracks enemy","unitpics/commweapon_missilelauncher.png",
        function (tb,v)
            if v then
                tb.tracks=true
                tb.damage_default_mut=tb.damage_default_mut*0.5
                tb.weapon_def_name=tb.weapon_def_name .. postfix
            end
        end,"boolean",
        function (wds)
            local newwds={}
            for key, value in pairs(wds) do
                newwds[key]=value
                local newwd=Spring.Utilities.CopyTable(value,true)
                newwds[key .. postfix] = newwd
                newwd.tracks=true
            end
            return newwds
        end
    )
end
do
    local postfix="_slowpartial"
    weapon_modifies.slow_partial=
    genCustomModify("slow_partial","damage x0.75, give slow damage = 2x damage","unitpics/conversion_disruptor.png",
        function (tb,v)
            if v then
                tb.tracks=true
                tb.damage_default_mut=tb.damage_default_mut*0.75
                tb.weapon_def_name=tb.weapon_def_name .. postfix
            end
        end,"boolean",
        function (wds)
            local newwds={}
            for key, value in pairs(wds) do
                newwds[key]=value
                local newwd=Spring.Utilities.CopyTable(value,true)
                newwds[key .. postfix] = newwd
                if not newwd.customparams then
                    newwd.customparams={}
                end
                newwd.customparams.timeslow_damagefactor=2
                newwd.rgbcolor                = [[0.9 0.1 0.9]]
            end
            return newwds
        end
    )
end

GameData.CustomUnits.utils=utils