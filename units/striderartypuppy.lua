VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils
local None=utils.None
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeSetSillyBuildMorphSimple("striderarty","striderartypuppy")

local ud=utils.GetUnitLua("striderarty")

local puppyud=utils.GetUnitLua("jumpscout")

utils_op.set_free_unit(puppyud)
puppyud.name="Puppys' Merlin's Puppy"
utils.table_replace({
    grey_goo = None,
    grey_goo_spawn = None,
    grey_goo_drain = None,
    grey_goo_cost = None,
    grey_goo_range = None,
})(puppyud.customParams)

local puppyudname="striderartypuppypuppy"

ud.name="Puppys' Merlin"
ud.metalCost=9000
ud.health=8000

ud.customParams.def_scale=1.5

local wd=ud.weaponDefs.ROCKET

wd.damage = {
default = 30.1,
planes  = 30.1,
}
wd.areaOfEffect            = 40
wd.model                   = [[puppymissile.s3o]]
utils.table_replace({
    damage_vs_shield = [[440.1]],
    force_ignore_ground = [[1]],

    spawns_name = puppyudname,
    spawns_expire = 10,
    spawn_blocked_by_shield = 1,
    light_radius = 0,
    nofriendlyfire=1,
})(wd.customParams)
ud.speed=ud.speed*0.9
ud.customParams.translations=[=[{
    en={
        name="Puppies' Merlin",
        description="Heavy Puppies Artillery Strider",
        helptext="Puppys' Merlin can shot 40 puppies which can destroy target accurately. Shot puppies cant goo",
    }
}]=]

return{
    ["striderartypuppy"]=ud,
    [puppyudname]=puppyud
}