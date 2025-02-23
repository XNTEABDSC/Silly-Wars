local utils = GameData.CustomUnits.utils
do
    local plasma_aoes = {
        {
            name = "empty",
            humanName = "Empty",
            desc = "empty",
            modfn = function(wpn)
                return wpn
            end
        },
        {
            name = "aoe64",
            humanName = "64",
            desc = "Scallop",
            ---@param wpn CustomWeaponDataModify
            modfn = function(wpn)
                wpn.cost               = wpn.cost * 1.1
                wpn.aoe                = 64
                wpn.edgeEffectiveness  = 0.5
                wpn.explosionGenerator = [[archplosion_aoe]]
                wpn.impulseFactor_add  = 0.4
            end,
        }, {

        name = "aoe144",
        humanName = "144",
        desc = "Ripper",
        ---@param wpn CustomWeaponDataModify
        modfn = function(wpn)
            wpn.cost               = wpn.cost * 1.5
            wpn.aoe                = 144
            wpn.edgeEffectiveness  = 0.75
            wpn.explosionGenerator = [[archplosion_aoe]]
            wpn.craterBoost_add    = 1
            wpn.craterMult_add     = 0.5
            wpn.impulseBoost_add   = 30
            wpn.impulseFactor_add  = 0.6
        end,
    }, {

        name = "aoe160",
        humanName = "160",
        desc = "Orge",
        ---@param wpn CustomWeaponDataModify
        modfn = function(wpn)
            wpn.cost               = wpn.cost * 1.5
            wpn.aoe                = 160
            wpn.edgeEffectiveness  = 0.4
            wpn.explosionGenerator = [[xamelimpact]]
            wpn.craterBoost_add    = 1
            wpn.craterMult_add     = 2
            wpn.impulseBoost_add   = 0
            wpn.impulseFactor_add  = 0.6
        end,
    }
    --[=[
    {
        name="aoe176",
        humanName="176",
        desc="Strategy Long-range Riot Cannon",
        ---@param wpn CustomWeaponDataModify
        modfn=function (wpn)
            wpn.cost=wpn.cost*2
            wpn.aoe=176
            wpn.edgeEffectiveness       = nil
            wpn.explosionGenerator=[[custom:lrpc_expl]]
            wpn.craterBoost_add             = 0.25
            wpn.craterMult_add              = 0.5
            wpn.impulseBoost_add            = 0.5
            wpn.impulseFactor_add           = 0.2
        end,
    },]=],
        {
            name = "aoe200",
            humanName = "200",
            desc = "Crab",
            ---@param wpn CustomWeaponDataModify
            modfn = function(wpn)
                wpn.cost               = wpn.cost * 1.5
                wpn.aoe                = 200
                wpn.edgeEffectiveness  = 0.3
                wpn.explosionGenerator = [[spidercrabe_EXPLOSION]]
                wpn.craterBoost_add    = 0
                wpn.craterMult_add     = 0.5
                wpn.impulseBoost_add   = 0
                wpn.impulseFactor_add  = 0.32
            end,
        },
        {
            name = "aoe256",
            humanName = "256",
            desc = "Tac Nuke",
            ---@param wpn CustomWeaponDataModify
            modfn = function(wpn)
                wpn.cost               = wpn.cost * 1.5
                wpn.aoe                = 256
                wpn.edgeEffectiveness  = 0.3
                wpn.explosionGenerator = [[NUKE_150]]
                wpn.craterBoost_add    = 4
                wpn.craterMult_add     = 3.5
                wpn.impulseBoost_add   = 0
                wpn.impulseFactor_add  = 0.4
            end,

        }
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
        "aoe", "Area Of effect", "unitpics/commweapon_riotcannon.png",
        ---@param wd CustomWeaponDataModify
        function(wd, choose_aoe)
            if choose_aoe == nil or choose_aoe == false then
                return
            end

            local aoe = plasma_aoes_name[choose_aoe]
            if aoe then
                aoe.modfn(wd)
            else
                error("aoe " .. tostring(choose_aoe) .. " don't exist")
            end
        end,
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
        end
    )
end

GameData.CustomUnits.utils = utils
