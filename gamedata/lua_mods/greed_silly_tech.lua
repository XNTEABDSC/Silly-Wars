VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.add_fn_to_fn_list("def_pre","greed_silly_tech",function ()
    utils.add_build("def_post","staticcon","sillycon")
    utils.add_build("def_post","athena","bigsillycon")
    utils.add_build_front("def_post","striderhub","verybigsillycon")
    local super_list={
        "pdrp",
        "emppudrp",
        "mahlazercap",
        "thepeace"
    }
    for key, value in pairs(super_list) do
        UnitDefs[value].metalcost=UnitDefs[value].metalcost*10
    end
end)

return {option_notes="Caretaker -> Silly Con; Athena -> Very Silly Con; Strider Hub -> Very Very Silly Con"}