VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

Scale=Scale or 0.25

utils_op.AddFnToUnitDefsTweakFnsMut({
    k="scale",
    b={"default_modify_value_begin"},
    a={"default_modify_value_end"},
    v=function ()
        local udtoscale=utils.lowervalues({
            "brakerate","radarDistance","sightDistance","sonarDistance","speed","radarDistanceJam","buildDistance",
            "cruiseAltitude",
            "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed"
        })
        local udcptoscale=utils.lowervalues({
            "def_scale",
            "jump_range",
            "pylonrange",
            "area_cloak_radius"
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
                return (tonumber(v) or 1)*Scale
            end
            if type(v)=="number"then
                return v*Scale
            elseif type(v)=="string" then
                return tonumber(v)*Scale
            else
                return v
            end
        end
        Spring.Utilities.to_make_op_things.modify_all_units({
            udkeys=udtoscale,
            udcpkeys=udcptoscale,
            wdkeys=wdtoscale,
            wdcpkeys=wdcptoscale,
            udfn=to01,
            wdcpfn=to01,
            udcpfn=to01,
            wdfn=to01,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        --udtoscale,udcptoscale,wdtoscale,wdcptoscale,to01,to01,to01,to01
    
    end
})

return {option_notes="Everything is x".. Scale .." size, except commanders"}