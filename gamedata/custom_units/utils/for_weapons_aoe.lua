local utils = GameData.CustomUnits.utils

local wacky_utils = Spring.Utilities.wacky_utils

local function ExpectAoe(damage)
    return math.sqrt(damage) * 4
end

local function ExpectAoeArea(damage)
    return damage * 16
end

local function ExpectAoeCostMut(aoe)
    return aoe * aoe / 10000
end

local function CalcCostBuffForAoe(damage, aoe)
    --[=[
    local expectAoeArea = ExpectAoeArea(damage)
    local costbuff = aoe * aoe / expectAoeArea
    ]=]
    local costbuff = aoe / ExpectAoe(damage)
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
            humanName = tostring(aoe / 2), -- same as shown in context menu
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
        utils.genCustomModifyChoose1Modify_Empty,
        EZGenAoe {
            aoe = 64,
            desc = "Scallop",
            edgeEffectiveness = 0.5,
            explosionGenerator = [[custom:archplosion_aoe]],
            impulseFactor = 0.4
        },
        EZGenAoe {
            aoe                = 96,
            desc               = "Reaver",
            edgeEffectiveness  = 0.5,
            explosionGenerator = [[custom:EMG_HIT_HE]],
            impulseBoost       = 0,
            impulseFactor      = 0.4,
            craterBoost        = 0.15,
            craterMult         = 0.3,
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
        EZGenAoe {
            aoe                = 160,
            desc               = "Orge",
            edgeEffectiveness  = 0.4,
            explosionGenerator = [[custom:xamelimpact]],
            craterBoost        = 1,
            craterMult         = 2,
            impulseBoost       = 0,
            impulseFactor      = 0.6,
        },
        EZGenAoe {
            aoe                = 200,
            desc               = "Crab",
            edgeEffectiveness  = 0.3,
            explosionGenerator = [[custom:spidercrabe_EXPLOSION]],
            craterBoost        = 0,
            craterMult         = 0.5,
            impulseBoost       = 0,
            impulseFactor      = 0.32,
        },
        EZGenAoe {
            aoe                = 256,
            desc               = "Eos",
            edgeEffectiveness  = 0.3,
            explosionGenerator = [[custom:NUKE_150]],
            craterBoost        = 4,
            craterMult         = 3.5,
            impulseBoost       = 0,
            impulseFactor      = 0.4,
        },
    }

    utils.weapon_modifies.plasma_aoe = utils.genCustomModifyChoose1Modify(
        "aoe", "Area Of effect. Higher the damage, cheaper the aoe", "unitpics/commweapon_riotcannon.png",
        plasma_aoes
    )
end

GameData.CustomUnits.utils = utils
