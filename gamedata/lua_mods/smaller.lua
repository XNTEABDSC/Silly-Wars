VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.add_fn_to_fn_list("def_pre","smaller",function ()
    local scale=0.1
    local udinto0p1=utils.lowerkeys({
        "brakerate","radarDistance","sightDistance","sonarDistance","speed","turnRadius",
        
    })
    local udcpinto0p1=utils.lowerkeys({
        "def_scale"
    })
    local wdinto0p1=utils.lowerkeys({
        "areaOfEffect","light_radius","range","weaponVelocity","startVelocity","shieldRadius"
    })
    local wdcpinto0p1=utils.lowerkeys({
        "area_damage_radius"
    })
    local function to01(v,key)
        if key=="def_scale" then
            return (tonumber(v) or 1)*scale
        end
        if type(v)=="number"then
            return v*scale
        elseif type(v)=="string" then
            return tonumber(v)*scale
        else
            return v
        end
    end
    GG.to_make_very_op_things.modify_all_units(udinto0p1,udcpinto0p1,wdinto0p1,wdcpinto0p1,to01,to01,to01,to01)
end)

return {option_notes="Everything is x0.1 size"}