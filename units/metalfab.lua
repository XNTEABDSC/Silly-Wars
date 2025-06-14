VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

local genericStructure=utils.lowerkeys( utils.GetUnitLua("pw_generic") )

local pw_metal = function(unitDef)
    unitDef.health = 10000
    unitDef.name = "Ancient Fabricator"
    unitDef.description = "Produces Metal out of thin air (+20)"
    unitDef.objectname = "pw_mine3.dae"
    unitDef.script = "pw_mine3.lua"
    unitDef.icontype = [[pw_metal]]

    unitDef.customparams = unitDef.customparams or {}
    unitDef.customparams.removewait = 1
    unitDef.metalmake = 20

    unitDef.footprintx = 12
    unitDef.footprintz = 12
    unitDef.metalcost = 2000

    unitDef.explodeas = "NUCLEAR_MISSILE"
    unitDef.selfdestructas = "NUCLEAR_MISSILE"

    unitDef.customparams.soundselect = "building_select2"

    unitDef.collisionvolumescales = [[130 130 130]]

    unitDef.featuredefs.dead.object = "pw_mine3_dead.dae"

    

    return unitDef
end

local unitDef=pw_metal(genericStructure)

--unitDef.customparams.def_scale=15/12


unitDef.buildPic="pw_metal.png"

unitDef.metalmake=unitDef.metalmake*2

unitDef.metalcost=unitDef.metalcost*2

unitDef.health=4000

unitDef.name="Chispy " .. unitDef.name

unitDef.description="Produces Metal out of thin air (+40)"

unitDef.customparams.translations=[=[
{
    en={
        name="Chispy Ancient Fabricator",
        description = "Produces Metal out of thin air (+40)",
        helptext="Just Produces Metal. Explode as nuke"
    }
}
]=]

utils_op.MakeAddSillyBuild("metalfab")

return{["metalfab"]=unitDef}