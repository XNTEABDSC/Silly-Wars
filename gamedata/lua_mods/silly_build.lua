VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

utils.copy_fn_lists("silly_build","def")

return {option_notes="Silly things can be built by silly cons"}