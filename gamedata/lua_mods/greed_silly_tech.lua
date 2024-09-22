VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.add_do_ud_post_fn("def_pre","greed_silly_tech",function ()
    utils.add_build("def_post","staticcon","sillycon")
    utils.add_build("def_post","athena","bigsillycon")
    utils.add_build("def_post","striderhub","verybigsillycon")
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

return {option_notes="caretaker->sillycon, athena->bigsillycon, striderhub->verybigsillycon"}