VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.add_build("def","staticcon","sillycon")
utils.add_build("def","sillycon","bigsillycon")
utils.add_build("def","bigsillycon","verybigsillycon")
return {option_notes="caretaker -> Silly Con -> Big Silly Con -> Very Big Silly Con"}