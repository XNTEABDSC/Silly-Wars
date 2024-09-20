if not GG then
    GG={}
end

if not GG.to_make_op_things then
    local to_make_op_things={}
    GG.to_make_op_things=to_make_op_things
    to_make_op_things.do_ud_post_fn_list={}
    function to_make_op_things.add_do_ud_post_fn(domain,key,fn)
        if not to_make_op_things.do_ud_post_fn_list[domain] then
            to_make_op_things.do_ud_post_fn_list[domain]={}
        end
        to_make_op_things.do_ud_post_fn_list[domain][key]=fn
    end
    function to_make_op_things.do_ud_post(domain)
        for key, value in pairs(to_make_op_things.do_ud_post_fn_list[domain] or {}) do
            value()
        end
    end
    function to_make_op_things.copy_ud_post(domainfrom,domainto)
        local l=to_make_op_things.do_ud_post_fn_list
        if l[domainfrom] then
            local lf=l[domainfrom]
            if not l[domainto] then
                l[domainto]={}
            end
            local lt=l[domainto]
            for key, value in pairs(lf) do
                lt[key]=value
            end
        end
    end
    function to_make_op_things.set_morth(domain,srcname,copyedname,morphtime)
        to_make_op_things.add_do_ud_post_fn(domain,
            "set_morth(" .. srcname .. ", " .. copyedname .. ")",
            function ()
                if not UnitDefs[srcname] then
                    error("unit " .. srcname .. "do not exist")
                end
                morphtime=morphtime or 10
                UnitDefs[srcname].customparams.morphto=copyedname
                UnitDefs[srcname].customparams.morphtime=morphtime
                UnitDefs[srcname].description=UnitDefs[srcname].description .. "Can morth into " .. copyedname
            end
        )
    end
    function to_make_op_things.set_morth_mul(domain,srcname,copyedname,morphtime,morthprice)
        to_make_op_things.add_do_ud_post_fn(domain,
            "set_morth_mul(" .. srcname .. ", " .. copyedname .. ")"
            ,function ()
                if not UnitDefs[srcname] then
                    error("unit " .. srcname .. "do not exist")
                end
                morthprice=morthprice or UnitDefs[copyedname].metalcost-UnitDefs[srcname].metalcost
                local ud_cp=UnitDefs[srcname].customparams
                local i=1
                morphtime=morphtime or 10
                while true do
                    if not ud_cp["morphto_" .. i] then
                        ud_cp["morphto_" .. i]=copyedname
                        ud_cp["morphtime_" .. i]=morphtime
                        ud_cp["morphcost_" .. i]=morthprice
                        break
                    end
                    i=i+1
                end
                UnitDefs[srcname].description=UnitDefs[srcname].description .. "Can morth into " .. copyedname
            end)
    end

    function to_make_op_things.add_build(domain,builer,building)
        to_make_op_things.add_do_ud_post_fn(domain,
            "add_build(" .. builer .. ", " .. building .. ")",
            function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. building .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[building] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. building .. "): unit " .. building .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
            end)
    end

    function to_make_op_things.do_tweak(tweaks)
        return function (t)
            Spring.Utilities.OverwriteTableInplace(t, tweaks, true)
        end
    end
    function to_make_op_things.set_free_unit(ud)
        ud.corpse=nil
        ud.buildTime=ud.metalCost
        ud.metalCost=0
        --ud.name = prename .. ud.name
        ud.explodeAs=[[NOWEAPON]]
        ud.selfDestructAs=[[NOWEAPON]]
        ud.customParams.dontcount = [[1]]
    end
    function to_make_op_things.lowerkeys(t)
        local tn = {}
        if type(t) == "table" then
            for i,v in pairs(t) do
                local typ = type(i)
                if type(v)=="table" then
                    v = to_make_op_things.lowerkeys(v)
                end
                if typ=="string" then
                    tn[i:lower()] = v
                else
                    tn[i] = v
                end
            end
        end
        return tn
    end
    function to_make_op_things.get_unit_lua(udname)
        return VFS.Include("units/".. udname ..".lua")[udname]
    end

    function to_make_op_things.copy_tweak(srcname,toname,fn)
        local ud=to_make_op_things.get_unit_lua(srcname)
        fn(ud)
        return {[toname]=ud}
    end

    function to_make_op_things.set_ded(ud,ded)
        ud.explodeAs              = ded
        ud.selfDestructAs=ded
    end

    function to_make_op_things.set_ded_BIG_UNIT(ud)
        ud.explodeAs              = [[BIG_UNIT]]
        ud.selfDestructAs=[[BIG_UNIT]]
    end
    
    function to_make_op_things.set_ded_ATOMIC_BLAST(ud)
        ud.explodeAs              = [[ATOMIC_BLAST]]
        ud.selfDestructAs=[[ATOMIC_BLAST]]
    end

    function to_make_op_things.round_to_inv30(n)
        n = n*30
        n = math.ceil(n)
        n = n/30
        return n
    end

    function to_make_op_things.list_to_set(list)
        local set={}
        for key, value in pairs(list) do
            set[value]=true
        end
        return set
    end

    function to_make_op_things.better_gsub(str,pattern,mapper)
        
        while true do
            local l,r=string.find(str,pattern)
            if not l then
                break
            else
                local str1=string.sub(str,1,l-1)
                --local str2=string.sub(str,l,r)
                local str3=string.sub(str,r+1)
                local str2transed=mapper(string.match(str,pattern))
                str = str1 .. str2transed .. str3
            end

        end
        return str
    end

    function to_make_op_things.update_modoptions(do_lua_mods)
        do_lua_mods=do_lua_mods or false
        do
            local modOptions = {}
            local utils=to_make_op_things
            if (Spring.GetModOptions) then
                modOptions = Spring.GetModOptions()
            end
            local option_mult=utils.list_to_set( {"metalmult","energymult","terracostmult","cratermult","hpmult",
            "team_1_econ","team_2_econ","team_3_econ","team_4_econ","team_5_econ","team_6_econ","team_7_econ","team_8_econ",
            "wavesizemult","queenhealthmod","techtimemult"
            } )
            local option_add_withdef={
            }
            local option_mult_withdef={
                innatemetal=2,
                innateenergy=2,
                zombies_delay=10,
                zombies_rezspeed=12
            }
            local option_bindstr={
                disabledunits="+ ",
                option_notes=". ",
            }
            ---@type boolean|integer
            local tweakdefs_count=false
            ---@type boolean|integer
            local tweakunits_count=false
            local mods_dir="gamedata/mods/"
            local lua_mods_dir="gamedata/lua_mods/"
            local mods=modOptions["mods"]
            if mods then
                for mod in string.gmatch(mods,"[A-Za-z01-9_]+") do
                    local moddir=mods_dir .. mod .. ".json"
                    local mua_mod_dir=lua_mods_dir .. mod .. ".lua"
                    if VFS.FileExists(moddir) then
                        Spring.Echo("SW: Load mod " .. mod)
                        local dataRaw=VFS.LoadFile(moddir)
                        if not _G then
                            _G=getfenv(2)
                        end
                        local mod_data=VFS.Include("LuaRules/Utilities/json.lua").decode(dataRaw)--utils.strjson_to_obj(dataRaw)
                        if mod_data then
                            local themodoptions=mod_data.options
                            if themodoptions then
                                for key, value in pairs(themodoptions) do
                                    if string.match(key,"^tweakunits") then
                                        modOptions["tweakunits" .. (tweakunits_count or "")]=value
                                        tweakunits_count=(tweakunits_count or 0)+1
        
                                    elseif string.match(key,"^tweakdefs") then
                                        modOptions["tweakdefs" .. (tweakdefs_count or "")]=value
                                        tweakdefs_count=(tweakdefs_count or 0)+1
        
                                    elseif  modOptions[key] then
                                        if option_mult[key] then
                                            modOptions[key]=modOptions[key]*value
                                        elseif option_add_withdef[key] then
                                            modOptions[key]=modOptions[key]+value-option_add_withdef[key]
                                        elseif option_mult_withdef[key] then
                                            modOptions[key]=modOptions[key]*value/option_mult_withdef[key]
                                        elseif option_bindstr[key] then
                                            modOptions[key]=modOptions[key] .. option_bindstr[key] .. value
                                        else
                                            modOptions[key]=value
                                        end
                                    else
                                        modOptions[key]=value
                                    end
                                end
                            end
                        else
                            Spring.Echo("Warning: SW: failed to load mod " .. mod)
                        end
                    elseif VFS.FileExists(mua_mod_dir) then
                        if do_lua_mods then
                            Spring.Echo("Run luamod " .. mod)
                            VFS.Include(mua_mod_dir)
                        else
                            Spring.Echo("Find luamod " .. mod)
                        end
                    else
                        Spring.Echo("Warning: SW: mod " .. mod .. " don't exist")
                    end
                end
            end
        
            Spring.GetModOptions=function ()
                return modOptions
            end
            Spring.Echo("modOptions result: ")
            Spring.Utilities.TableEcho(modOptions,"modOptions")
        end
    end

    function to_make_op_things.StrExplode(div, str)
        if div == '' then
            return nil
        end
        local pos, arr = 0, {}
        -- for each divider found
        for st, sp in function() return string.find(str, div, pos, true) end do
            table.insert(arr, string.sub(str, pos, st - 1)) -- Attach chars left of current divider
            pos = sp + 1 -- Jump past current divider
        end
        table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
        return arr
    end
    
    function to_make_op_things.GetDimensions(scale)
        if not scale then
            return nil
        end
        local dimensionsStr = to_make_op_things.StrExplode(" ", scale)
        -- string conversion (required for MediaWiki export)
        if dimensionsStr then
            local dimensions = {}
            for i,v in pairs(dimensionsStr) do
                dimensions[i] = tonumber(v)
            end
            local largest = (dimensions and dimensions[1] and tonumber(dimensions[1])) or 0
            for i = 2, 3 do
                largest = math.max(largest, (dimensions and dimensions[i] and tonumber(dimensions[i])) or 0)
            end
            return dimensions, largest
        else
            return nil
            --error("Fail to GetDimensions on " .. scale)
        end
    end

    function to_make_op_things.ToDimensions(v3)
        return tostring(v3[1]) .. " " .. tostring(v3[2]) .. " " .. tostring(v3[3])
    end

    function to_make_op_things.set_scale(ud,scale)
        local GetDimensions=to_make_op_things.GetDimensions
        local ToDimensions=to_make_op_things.ToDimensions
        --[=[
        local udcp=ud.customParams or ud.customparams
        if not udcp then
            ud.customParams={}
            udcp=ud.customParams
        end
        udcp.def_scale= (udcp.def_scale or 1)* scale
        ]=]
        local tryScales3={
            "collisionVolumeOffsets",
            "collisionVolumeScales",
            "selectionVolumeOffsets",
            "selectionVolumeScales"
        }
        for _, value in pairs(tryScales3) do
            value=value:lower()
            if ud[value] then
                local ss=GetDimensions(ud[value])
                if ss then
                    for i = 1, 3 do
                        ss[i]=ss[i]*scale
                    end
                    ud[value]=ToDimensions(ss)
                end
            end
        end

        local tryScale1={
            "footprintX",
            "footprintZ",
            "trackOffset",
            "trackWidth",
            "trackStrength",
            "trackStretch",
        }
        for _, value in pairs(tryScale1) do
            value=value:lower()
            if ud[value]then
                ud[value]=ud[value]*scale
            end
        end

        if ud.customparams.modelradius then
            ud.customparams.modelradius=tonumber(ud.customparams.modelradius)*scale
        end

        if ud.customparams.modelheight then
            ud.customparams.modelheight=tonumber(ud.customparams.modelheight)*scale
        end
        
    end
end
VFS.Include("utils/to_make_very_op_things.lua")
return GG.to_make_op_things