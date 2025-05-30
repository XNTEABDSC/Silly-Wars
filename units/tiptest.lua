local included = VFS.Include("units/vehassault.lua")
local unitDef = included.vehassault
unitDef.metalCost=300
unitDef.name = "Turn In Place test"
unitDef.description = "Tests turn in place"

unitDef.acceleration = 0.01
unitDef.speed = 150
unitDef.turnRate = 50
unitDef.turninplace = 0
unitDef.customParams.turnatfullspeed = 1


VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things
utils_op.MakeAddSillyBuild("tiptest")
utils_op.MakeSetSillyMorphBig("vehassault","tiptest")

return { tiptest = unitDef }
