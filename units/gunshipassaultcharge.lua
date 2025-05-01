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
    metalCost=900,
    weaponDefs={
        VTOL_SALVO={
            customparams={
                use_unit_weapon_charge="1",
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