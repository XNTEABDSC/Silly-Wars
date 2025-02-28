local utils = GameData.CustomUnits.utils

local wacky_utils = Spring.Utilities.wacky_utils

local function ExpectAoe(damage)
    return math.sqrt(damage)
end

local function ExpectAoeArea(damage)
    return damage*16
end

local function ExpectAoeCostMut(aoe)
    return aoe * aoe / 10000
end

local function CalcCostBuffForAoe(damage, aoe)
    local expectAoeArea = ExpectAoeArea(damage)
    local costbuff = aoe * aoe / expectAoeArea
    return 1 + costbuff
end
--[=[
]=]

local may_lower_key_proxy = wacky_utils.may_lower_key_proxy
do
    ---@param params {aoe:number,desc:string,edgeEffectiveness:number,explosionGenerator:string,craterBoost:number,craterMult:number,impulseBoost:number,impulseFactor:number}
    local function EZGenAoe(params)
        local aoe = params.aoe
        local desc = params.desc
        local edgeEffectiveness = params.edgeEffectiveness
        local explosionGenerator = params.explosionGenerator
        local craterBoost = params.craterBoost
        local craterMult = params.craterMult
        local impulseBoost = params.impulseBoost
        local impulseFactor = params.impulseFactor
        return {

            name = "aoe" .. tostring(aoe),
            humanName = tostring(aoe),
            desc = desc,
            ---@param wpn CustomWeaponDataModify
            modfn = function(wpn)
                wpn.cost               = wpn.cost *
                    CalcCostBuffForAoe(wpn.damage_default_base * wpn.damage_default_mut, aoe)
                -- [=[
                wpn.aoe                = aoe
                wpn.edgeEffectiveness  = edgeEffectiveness
                wpn.explosionGenerator = explosionGenerator
                wpn.craterBoost_add    = craterBoost
                wpn.craterMult_add     = craterMult
                wpn.impulseBoost_add   = impulseBoost
                wpn.impulseFactor_add  = impulseFactor
                --]=]
            end,
            --[=[
            moddeffn=function (wd)
                wd=may_lower_key_proxy(wd)
                wd.areaOfEffect=160
                wd.edgeEffectiveness  = 0.4
                wd.explosionGenerator = [[custom:xamelimpact]]
                wd.craterBoost    = 1
                wd.craterMult     = 2
                wd.impulseBoost   = 0
                wd.impulseFactor  = 0.6
            end]=]
        }
    end
    local plasma_aoes = {
        {
            name = "empty",
            humanName = "Empty",
            desc = "empty",
            modfn = function(wpn)
                return wpn
            end,
            moddeffn = function(v)
                return v
            end
        },
        EZGenAoe {
            aoe = 64,
            desc = "Scallop",
            edgeEffectiveness = 0.5,
            explosionGenerator = [[custom:archplosion_aoe]],
            impulseFactor = 0.4
        },
        EZGenAoe {
            aoe                = 144,
            desc               = "Ripper",
            edgeEffectiveness  = 0.75,
            explosionGenerator = [[custom:archplosion_aoe]],
            craterBoost        = 1,
            craterMult         = 0.5,
            impulseBoost       = 30,
            impulseFactor      = 0.6
        }, 
        EZGenAoe{
            aoe=160,
            desc="Orge",
            edgeEffectiveness  = 0.4,
            explosionGenerator = [[custom:xamelimpact]],
            craterBoost    = 1,
            craterMult     = 2,
            impulseBoost   = 0,
            impulseFactor  = 0.6,
        },
        EZGenAoe{
            aoe=200,
            desc="Crab",
            edgeEffectiveness  = 0.3,
            explosionGenerator = [[custom:spidercrabe_EXPLOSION]],
            craterBoost    = 0,
            craterMult     = 0.5,
            impulseBoost   = 0,
            impulseFactor  = 0.32,
        },
        EZGenAoe{
            aoe=256,
            desc="Eos",
            edgeEffectiveness  = 0.3,
            explosionGenerator = [[custom:NUKE_150]],
            craterBoost    = 4,
            craterMult     = 3.5,
            impulseBoost   = 0,
            impulseFactor  = 0.4,
        },
    }
    local plasma_aoes_name = {}
    local plasma_aoes_id_to_humanName = {}
    local plasma_aoes_id_to_name = {}
    local plasma_aoes_name_to_id = {}
    for key, value in pairs(plasma_aoes) do
        --[=[
        if value.explosionGenerator:find("custom:") then
            value.explosionGenerator=string.sub( value.explosionGenerator, ("custom:"):len()+1)
        end]=]

        plasma_aoes_name[value.name] = value
        plasma_aoes_id_to_humanName[key] = value.humanName
        plasma_aoes_id_to_name[key] = value.name
        plasma_aoes_name_to_id[value.name] = key
    end
    utils.weapon_modifies.plasma_aoe = utils.genCustomModify(
        "aoe", "Area Of effect. Higher the damage, cheaper the aoe", "unitpics/commweapon_riotcannon.png",
        ---@param wd CustomWeaponDataModify
        function(wd, choose_aoe)
            if choose_aoe == nil or choose_aoe == false then
                return
            end 

            local aoe = plasma_aoes_name[choose_aoe]
            if aoe then
                if aoe.name ~= "empty" then
                    aoe.modfn(wd)
                    if aoe.moddeffn then
                        wd.weapon_def_name = wd.weapon_def_name .. "_" .. aoe.name
                    end
                else

                end
            else
                error("aoe " .. tostring(choose_aoe) .. " don't exist")
            end
        end,
        utils.ui.ChooseOneToUse(plasma_aoes_id_to_name,plasma_aoes_id_to_humanName,plasma_aoes_name_to_id),
        --[=[
        function(WG, parent)
            local choose_item_combobox = WG.Chili.ComboBox:New {
                parent = parent,
                items = plasma_aoes_id_to_humanName,
                x = 8,
                right = 8,
                y = 2,
                height = 20,
                minWidth = 100,
                width = 100,
            }
            ---@type ModifyUI
            return {
                control = choose_item_combobox,
                getValue = function()
                    return plasma_aoes_id_to_name[choose_item_combobox.selected]
                end,
                setValue = function(v)
                    choose_item_combobox:Select(plasma_aoes_name_to_id[v])
                end
            }
        end,]=]
        utils.SpamDefs(function(wdname, wd)
            local res = {}
            for _, value in pairs(plasma_aoes) do
                if value.moddeffn then
                    local key = value.name
                    local newname
                    if key == "empty" then
                        newname = wdname
                    else
                        newname = wdname .. "_" .. key
                    end
                    local newwd = Spring.Utilities.CopyTable(wd, true)
                    value.moddeffn(newwd)
                    res[newname] = newwd
                end
            end
            return res
        end)
    )
end

GameData.CustomUnits.utils = utils
