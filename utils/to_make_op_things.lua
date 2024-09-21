if not GG then
    GG={}
end

if not GG.to_make_op_things then
    local to_make_op_things={}
    GG.to_make_op_things=to_make_op_things
    to_make_op_things.do_ud_post_fn_list={}
    function to_make_op_things.add_do_ud_post_fn(domain,key,fn)
        if domain=="now" then
            fn()
            return
        end
        if not to_make_op_things.do_ud_post_fn_list[domain] then
            to_make_op_things.do_ud_post_fn_list[domain]={}
            to_make_op_things.do_ud_post_fn_list[domain].order={}
        end
        local l=to_make_op_things.do_ud_post_fn_list[domain]
        if not l[key] then
            l.order[#l.order+1]=key
        end
        l[key]=fn
    end
    function to_make_op_things.do_ud_post(domain)
        if to_make_op_things.do_ud_post_fn_list[domain] then
            local l=to_make_op_things.do_ud_post_fn_list[domain]
            for _, key  in pairs(l.order) do
                l[key]()
            end
        end
        
        --[=[
        for key, value in pairs(to_make_op_things.do_ud_post_fn_list[domain] or {}) do
            value()
        end]=]
    end
    function to_make_op_things.copy_ud_post(domainfrom,domainto)
        local l=to_make_op_things.do_ud_post_fn_list
        if l[domainfrom] then
            local lf=l[domainfrom]
            for _, key  in pairs(lf.order) do
                to_make_op_things.add_do_ud_post_fn(domainto,key,lf[key])
            end
            --[=[
            if not l[domainto] then
                l[domainto]={}
            end
            local lt=l[domainto]
            ]=]
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
                UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morth into " .. copyedname
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
                UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morth into " .. copyedname
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
                Spring.Echo("add_build(" .. builer .. ", " .. building .. ")")
                UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
            end)
    end
    to_make_op_things.table_replace_nil={}

    function to_make_op_things.table_replace(tweaks)
        local function replace(t)
            for k, v in pairs(tweaks) do
                if v==to_make_op_things.table_replace_nil then
                    t[k]=nil
                elseif (type(v) == "table") then
                    if t[k] and type(t[k]) == "table" then
                        to_make_op_things.table_replace(v)(t[k])
                    else
                        t[k] = Spring.Utilities.CopyTable(v, true)
                    end
                else
                    t[k] = v
                end
            end
        end
        return replace
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

    function to_make_op_things.tweak_units(tweaks)
        for name, ud in pairs(UnitDefs) do
            if tweaks[name] then
                Spring.Echo("Loading tweakunits for " .. name)
                Spring.Utilities.OverwriteTableInplace(ud, to_make_op_things.lowerkeys(tweaks[name]), true)
            end
        end
    end

    function to_make_op_things.tweak_defs(postsFuncStr)
        local postfunc, err = loadstring(postsFuncStr)
		if postfunc then
			postfunc()
		else
			Spring.Log("defs.lua", LOG.ERROR, "tweakdefs", err)
		end
    end
    
    if not _G then
        _G=getfenv(2)
    end
    
    to_make_op_things.json=VFS.Include("LuaRules/Utilities/json.lua")


    function to_make_op_things.update_modoptions()
        --do_lua_mods=do_lua_mods or false
        do
            local modOptions = {}
            local utils=to_make_op_things
            if (Spring.GetModOptions) then
                modOptions = Spring.GetModOptions()
            end
            if not modOptions.mods then
                modOptions.mods ="silly_tech + silly_build + silly_morth + more_build + add_chixs"
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
                option_notes="\n",
            }
            ---@type integer
            local tweakdefs_count=1
            ---@type integer
            local tweakunits_count=1
            local do_at_def_pre_count=1
            local mods_dir="gamedata/mods/"
            local lua_mods_dir="gamedata/lua_mods/"
            local mods=modOptions["mods"]
            if mods then
                local function load_modoption(themodoptions)
                    for key, value in pairs(themodoptions) do
                        if key=="mods" then
                            --[=[
                            for mod2 in string.gmatch(value,"[A-Za-z01-9_]+") do
                                update_mod(mod2)
                            end]=]
                        elseif key=="do_at_def_pre" then
                            utils.add_do_ud_post_fn("def_pre","def_pre" .. do_at_def_pre_count,value)
                            do_at_def_pre_count=do_at_def_pre_count+1
                        elseif string.match(key,"^tweakunits") then
                            --[=[
                            modOptions["tweakunits" .. (tweakunits_count or "")]=value
                            ]=]
                            local tweakunitstable=Spring.Utilities.CustomKeyToUsefulTable(value)
                            utils.add_do_ud_post_fn("def","tweakunits" .. tweakunits_count,function ()
                                utils.tweak_units(tweakunitstable)
                            end)
                            tweakunits_count=tweakunits_count+1
                        elseif string.match(key,"^tweakdefs") then
                            --modOptions["tweakdefs" .. (tweakdefs_count or "")]=value
                            local codestr=Spring.Utilities.Base64Decode(value)
                            utils.add_do_ud_post_fn("def","tweakdefs" .. tweakdefs_count,function ()
                                utils.tweak_defs(codestr)
                            end)
                            tweakdefs_count=tweakdefs_count+1

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
                --local update_mod;
                local function load_json_mod(mod,moddir)
                    Spring.Echo("SW: Load mod " .. mod)
                    local dataRaw=VFS.LoadFile(moddir)
                    local mod_data=to_make_op_things.json.decode(dataRaw)
                    if mod_data then
                        local themodoptions=mod_data.options
                        if themodoptions then
                            load_modoption(themodoptions)
                        end
                    else
                        Spring.Echo("Warning: SW: failed to load mod " .. mod)
                    end
                end
                local function load_lua_mod(mod,moddir)
                    local themodoptions=VFS.Include(moddir)
                    if themodoptions then
                        load_modoption(themodoptions)
                    end
                end
                local function load_mod(mod)
                    local jsonmoddir=mods_dir .. mod .. ".json"
                    local lua_mod_dir=lua_mods_dir .. mod .. ".lua"
                    if VFS.FileExists(jsonmoddir) then
                        load_json_mod(mod,jsonmoddir)
                    elseif VFS.FileExists(lua_mod_dir) then
                        Spring.Echo("SW: Run luamod " .. mod)
                        load_lua_mod(mod,lua_mod_dir)
                    else
                        Spring.Echo("Warning: SW: mod " .. mod .. " don't exist")
                    end
                end

                for mod in string.gmatch(mods,"[A-Za-z01-9_]+") do
                    load_mod(mod)
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