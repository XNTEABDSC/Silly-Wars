VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local none=utils.None

return utils_op.CopyTweakSillyBuildMorphSimple("gunshipassault","gunshipassaultcharge",utils.table_replace({
    name=[[Revenant + Charging Salvo]],
    description=[[Heavy Raider/Assault Gunship, Can Both Burst And Keep Shotting]],
    customParams={
        tactical_ai_defs_copy="gunshipassault",
        translations=[=[{
            en={
                name="Revenant + Charging Salvo",
                description="Heavy Raider/Assault Gunship, Can Both Burst And Keep Shotting",
                helptext="Charging Salvo solves a big problem of Revenant: bad at taking out low hp targets. Charging Salvo allows Revenant to both shot and store ammo, so it can both keep shoting and burst shoting."
            }
        }]=]
    },
    metalCost=900,
    weaponDefs={
        VTOL_SALVO={
            customparams={
                use_unit_weapon_charging_salvo="1",
                script_burst=9,
                script_burst_rate=2/30,
                script_reload=10,
                
            },
            burst=none,
            burstrate=none,
            reloadtime=math.floor(10/9*30+0.5)/30,
        },
    },
}))