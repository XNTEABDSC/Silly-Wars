VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
scale=scale or 0.25
utils.add_fn_to_fn_list("def_pre","scale",function ()
    local udtoscale=utils.lowervalues({
        "brakerate","radarDistance","sightDistance","sonarDistance","speed",
        "cruiseAltitude",
        "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed"
    })
    local udcptoscale=utils.lowervalues({
        "def_scale",
        "jump_range"
    })
    local wdtoscale=utils.lowervalues({
        "areaOfEffect","damageAreaOfEffect","light_radius","range","weaponVelocity","startVelocity","shieldRadius",
        "myGravity"
    })
    local wdcptoscale=utils.lowervalues({
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
    GG.to_make_op_things.modify_all_units(udtoscale,udcptoscale,wdtoscale,wdcptoscale,to01,to01,to01,to01)

end)

return {option_notes="Everything is x".. scale .." size"}