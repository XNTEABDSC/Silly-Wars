

local wacky_utils = Spring.Utilities.wacky_utils

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
genCustomModify("damage","add damage","unitpics/module_dmg_booster.png",---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*factor
    tb.damage_default_mut=tb.damage_default_mut*factor^(utils.bias_factor)
end,"number")


weapon_modifies.proj_speed=
genCustomModify("speed","add projectiles' speed","unitpics/commweapon_assaultcannon.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)--/2
    tb.projSpeed_mut=tb.projSpeed_mut*factor
end,"number")


weapon_modifies.proj_range=
genCustomModify("range","add projectiles' range","unitpics/module_adv_targeting.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)--/2
    tb.range_mut=tb.range_mut*( ( (1+factor)^(--[=[utils.bias_factor*]=](1/3))-1 )/(1/3) )
end,"number"
)


weapon_modifies.beam_range=
genCustomModify("range","add beams' range","unitpics/module_adv_targeting.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)--/2
    --tb.range_mut=tb.range_mut*factor^(utils.bias_factor*0.5)
    tb.range_mut=tb.range_mut*( ( (1+factor)^(utils.bias_factor*0.333)-1 )/0.333 )
end,"number"
)


weapon_modifies.reload=
genCustomModify("reload","reduce reload time","unitpics/commweapon_heavymachinegun.png",
---@param tb CustomWeaponDataModify
function (tb,factor)
    tb.cost=tb.cost*(1+factor)--/2
    tb.reload_time_mut=tb.reload_time_mut*factor^(-1)
end,"number"
)


weapon_modifies.into_aa=
genCustomModify("into_aa","make this aa only","icons/kbotaa.dds",
---@param tb CustomWeaponDataModify
function (tb,flag)
    if flag then
        tb.range_mut=tb.range_mut*2
        tb.projSpeed_mut=tb.projSpeed_mut*1.5
        tb.targeter_weapon="aa_targeter"
        tb.damages_mut.default=(tb.damages_mut.default or 1)
        tb.damages_mut.planes=(tb.damages_mut.planes or 1)
        for key, value in pairs(tb.damages_mut) do
            if key~="planes" then
                tb.damages_mut[key]=value*0.1
            end
        end
        --tb.damages_mut.default=(tb.damages_mut.default or 1)*0.1
    end
end,"boolean"
)

weapon_modifies.projectiles=genCustomModify("projectiles","count of projectiles","unitpics/commweapon_shotgun.png",
---@param tb CustomWeaponDataModify
function (tb,count)
    count=math.max( math.round(count or 1,0) , 1)

    tb.cost=tb.cost*count--^(1/utils.bias_factor)
    tb.projectiles_mut=tb.projectiles_mut*count
    tb.sprayAngle_add=tb.sprayAngle_add+(count-1)*0.025
end,"number"
)


weapon_modifies.burst=genCustomModify("burst","count of burst","unitpics/commweapon_multistunner.png",
---@param tb CustomWeaponDataModify
function (tb,count)
    count=math.max( math.round(count or 1,0) , 1)

    tb.cost=tb.cost*count^(1/utils.bias_factor)
    tb.burst_mut=tb.burst_mut*count
end,"number"
)
---@type CustomModify
weapon_modifies.weapon_def_finish=
{
    name = "weapon_def_finish",
    description = "get weapon_def_raw",
    pic = "",
    ---@param tb CustomWeaponDataModify 
    modfn = function (tb)
        local res=GameData.CustomUnits.custom_weapon_defs_raw[tb.weapon_def_name]
        if not res then
            error("weapon def " .. tostring(tb.weapon_def_name) .. " dont exist")
        end
        tb.weapon_def_raw=res
        local def_damage=0
        for key, value in pairs(res.damage) do
            def_damage=math.max(def_damage,value)
        end
        tb.damage_default_base=def_damage
        return tb
    end,
    genUIFn =nil,
    --utils.ui.SimpleValueUI(pic,name,desc,paramType),
    moddeffn = nil,
}
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
    local postfix="_slowp"
    weapon_modifies.slow_partial=
    genCustomModify("slow_partial","damage x0.75, give slow damage = 2x damage","unitpics/conversion_disruptor.png",
        function (tb,v)
            if v then
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
                local newwdlk=wacky_utils.may_lower_key_proxy(newwd,wacky_utils.may_lower_key_proxy_wd_checkkeys)
                if not newwdlk.customParams then
                    newwdlk.customParams={}
                end
                newwdlk.customParams.timeslow_damagefactor=2
                newwdlk.rgbcolor                = [[0.9 0.1 0.9]]
            end
            return newwds
        end
    )
end

GameData.CustomUnits.utils=utils