local ud=UnitDefs.statictele
ud.metalcost=50000
local udcp=ud.customparams
udcp.stockpiletime="90"
udcp.stockpilecost="4000"
ud.weapondefs.bogus_cloak_target.reloadtime=30

ud.health=10000
ud.buildpic="pw_warpgatealt.png"
ud.name = "Warp Gate"
ud.description = "Transfer everything (units, structures, terra, regardless of the owner) between the gate and target position with 400 elmo radius. Each warp needs 4000m 90s stokepile"
ud.customparams.statsname=nil


VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things
utils_op.MakeAddSillyBuild("statictele")
utils_op.MakeSetSillyMorph("amphlaunchpro","statictele")