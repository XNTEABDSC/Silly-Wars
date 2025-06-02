local included = VFS.Include("units/vehassault.lua")
local unitDef = included.vehassault
unitDef.metalCost=300
unitDef.name = "Turn In Place test"
unitDef.description = "Tests turn in place"
unitDef.customParams.translations=[=[
{
    en={
        name="Turn In Place test",
        description="Tests turn in place",
        helptext="This unit is used to test how will it turn in place. It is fast but accelerates and turns sloooow."
    }
}
]=]

unitDef.acceleration = 0.01
unitDef.brakeRate=0.1
unitDef.speed = 150
unitDef.turnRate = 50
unitDef.turnInPlace = 1
--unitDef.customParams.turnatfullspeed = 1


VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things
utils_op.MakeAddSillyBuild("tiptest")
utils_op.MakeSetSillyMorphBig("vehassault","tiptest")

return { tiptest = unitDef }
