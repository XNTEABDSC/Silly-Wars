VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

Scale=Scale or (1/3)

utils_op.AddFnToUnitDefsTweakFnsMut({
    k="scale",
    b={"default_modify_value_begin"},
    a={"default_modify_value_end"},
    v=function ()
        ---
        local udtoscale=utils.lowervalues({
            "cruiseAltitude",
            "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed",
            --"acceleration",
            "minCloakDistance",
        })
        local udcptoscale=utils.lowervalues({
        })
        local wdtoscale=utils.lowervalues({
        })
        local wdcptoscale=utils.lowervalues({
        })
        ---
        local udtoscalesqrt=utils.lowervalues({
            "radarDistanceJam",
        })
        local udcptoscalesqrt=utils.lowervalues({
            "area_cloak_radius",
        })
        local wdtoscalesqrt=utils.lowervalues({
            "flightTime","areaOfEffect","damageAreaOfEffect","shieldRadius",
            "accuracy","sprayAngle",
        })
        local wdcptoscalesqrt=utils.lowervalues({
            "area_damage_radius",
        })
        ---
        local udtoscaleinv=utils.lowervalues({
        })
        local udcptoscaleinv=utils.lowervalues({
        })
        local wdtoscaleinv=utils.lowervalues({
            
        })
        local wdcptoscaleinvsqrt=utils.lowervalues({
        })
        ---
        local udtoscaleinvsqrt=utils.lowervalues({
        })
        local udcptoscaleinvsqrt=utils.lowervalues({
        })
        local wdtoscaleinvsqrt=utils.lowervalues({
            "weaponVelocity","startVelocity","myGravity","weaponAcceleration"
        })
        local wdcptoscaleinv=utils.lowervalues({
        })

        local function scale(v,key)
            if type(v)=="number"then
                return v*Scale
            elseif type(v)=="string" then
                return tonumber(v)*Scale
            else
                return v
            end
        end
        local function scalesqrt(v,key)
            local Scale=math.sqrt(Scale)
            if type(v)=="number"then
                return v*Scale
            elseif type(v)=="string" then
                return tonumber(v)*Scale
            else
                return v
            end
        end
        local function scaleinv(v,key)
            local Scale=1/Scale
            if type(v)=="number"then
                return v*Scale
            elseif type(v)=="string" then
                return tonumber(v)*Scale
            else
                return v
            end
        end
        local function scaleinvsqrt(v,key)
            local Scale=math.sqrt( 1/Scale )
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
            udfn=scale,
            wdcpfn=scale,
            udcpfn=scale,
            wdfn=scale,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        Spring.Utilities.to_make_op_things.modify_all_units({
            udkeys=udtoscalesqrt,
            udcpkeys=udcptoscalesqrt,
            wdkeys=wdtoscalesqrt,
            wdcpkeys=wdcptoscalesqrt,
            udfn=scalesqrt,
            wdcpfn=scalesqrt,
            udcpfn=scalesqrt,
            wdfn=scalesqrt,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        Spring.Utilities.to_make_op_things.modify_all_units({
            udkeys=udtoscalesqrt,
            udcpkeys=udcptoscalesqrt,
            wdkeys=wdtoscalesqrt,
            wdcpkeys=wdcptoscalesqrt,
            udfn=scalesqrt,
            wdcpfn=scalesqrt,
            udcpfn=scalesqrt,
            wdfn=scalesqrt,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        Spring.Utilities.to_make_op_things.modify_all_units({
            udkeys=udtoscaleinv,
            udcpkeys=udcptoscaleinv,
            wdkeys=wdtoscaleinv,
            wdcpkeys=wdcptoscaleinv,
            udfn=scaleinv,
            wdcpfn=scaleinv,
            udcpfn=scaleinv,
            wdfn=scaleinv,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        Spring.Utilities.to_make_op_things.modify_all_units({
            udkeys=udtoscaleinvsqrt,
            udcpkeys=udcptoscaleinvsqrt,
            wdkeys=wdtoscaleinvsqrt,
            wdcpkeys=wdcptoscaleinvsqrt,
            udfn=scaleinvsqrt,
            wdcpfn=scaleinvsqrt,
            udcpfn=scaleinvsqrt,
            wdfn=scaleinvsqrt,
            modifycondition=function (ud)
                if ud.customparams.commtype~=nil then
                    return false
                end
                return true
            end
        })
        for _, ud in pairs(UnitDefs) do
            if ud.customparams.commtype==nil then
                ud.customparams.def_scale= (ud.customparams.def_scale or 1)*Scale
            end
         end
        --udtoscale,udcptoscale,wdtoscale,wdcptoscale,to01,to01,to01,to01
    
    end
})

return {option_notes="Units size x" .. Scale ..", except commanders"}

--[==[
---
        local udtoscale=utils.lowervalues({
            "radarDistanceJam","buildDistance",
            "cruiseAltitude",
            "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed",
            "acceleration"
        })
        local udcptoscale=utils.lowervalues({
        })
        local wdtoscale=utils.lowervalues({
            
        })
        local wdcptoscale=utils.lowervalues({
        })
        ---
        local udtoscalesqrt=utils.lowervalues({
            "minCloakDistance",
        })
        local udcptoscalesqrt=utils.lowervalues({
            "area_cloak_radius"
        })
        local wdtoscalesqrt=utils.lowervalues({
            "areaOfEffect","damageAreaOfEffect","shieldRadius","accuracy","sprayAngle"
        })
        local wdcptoscalesqrt=utils.lowervalues({
            "area_damage_radius"
        })
        ---
        local udtoscaleinv=utils.lowervalues({
        })
        local udcptoscaleinv=utils.lowervalues({
        })
        local wdtoscaleinv=utils.lowervalues({
        })
        local wdcptoscaleinv=utils.lowervalues({
        })
]==]