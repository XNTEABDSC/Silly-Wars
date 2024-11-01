---@class list<t> : {[integer]:t}
if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end

if not Spring.Utilities.to_make_op_things then
    local to_make_op_things={}
    Spring.Utilities.to_make_op_things=to_make_op_things

    VFS.Include("LuaRules/Utilities/tablefunctions.lua")


    --[==[
    local utils={
        "fn_list"
    }
    local utilsPath="utils/to_make_op_things/"
    for _, value in pairs(utils) do
        VFS.Include(utilsPath .. value)
    end
    ]==]

    ---list of functions
    ---
    ---[domain] [key] = fn
    ---
    to_make_op_things.fn_list={}
    ---add a function, at domain, with key
    ---
    ---multiple add with same key makes overlap
    ---
    ---order of fn to be called are stored when key assigned
    ---
    ---notes fn may needs to use lowerkeys 
    ---@param domain string
    ---@param key string
    ---@param fn function
    function to_make_op_things.add_fn_to_fn_list(domain,key,fn)
        if domain=="now" then
            fn()
            return
        end
        if not to_make_op_things.fn_list[domain] then
            to_make_op_things.fn_list[domain]={}
            to_make_op_things.fn_list[domain].order={}
        end
        local l=to_make_op_things.fn_list[domain]
        if not l[key] then
            l.order[#l.order+1]=key
        end
        l[key]=fn
    end
    ---call all fns in domain
    ---@param domain string
    function to_make_op_things.do_fn_list_fns(domain)
        if to_make_op_things.fn_list[domain] then
            local l=to_make_op_things.fn_list[domain]
            for _, key  in pairs(l.order) do
                l[key]()
            end
        end
    end
    ---copy all fns from domainfrom to domainto, by add_fn_to_fn_list
    ---@param domainfrom string
    ---@param domainto string
    function to_make_op_things.copy_fn_lists(domainfrom,domainto)
        local l=to_make_op_things.fn_list
        if l[domainfrom] then
            local lf=l[domainfrom]
            for _, key  in pairs(lf.order) do
                to_make_op_things.add_fn_to_fn_list(domainto,key,lf[key])
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
        to_make_op_things.add_fn_to_fn_list(domain,
            "set_morth(" .. srcname .. ", " .. copyedname .. ")",
            function ()
                if not UnitDefs[srcname] then
                    error("unit " .. srcname .. "do not exist")
                end
                morphtime=morphtime or 10
                UnitDefs[srcname].customparams.morphto=copyedname
                UnitDefs[srcname].customparams.morphtime=morphtime
                --UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morth into " .. copyedname
            end
        )
    end
    function to_make_op_things.set_morth_mul(domain,srcname,copyedname,morphtime,morthprice)
        to_make_op_things.add_fn_to_fn_list(domain,
            "set_morth_mul(" .. srcname .. ", " .. copyedname .. ")"
            ,function ()
                if not UnitDefs[srcname] then
                    error("unit " .. srcname .. "do not exist")
                end
                local ud_cp=UnitDefs[srcname].customparams
                if ud_cp.morphto then
                    ud_cp.morphto_1=ud_cp.morphto
                    ud_cp.morphto=nil
                    ud_cp.morphtime_1=ud_cp.morphtime
                    ud_cp.morphtime=nil
                    ud_cp.morphcost_1=ud_cp.morphcost
                    ud_cp.morphcost=nil
                end
                morthprice=morthprice or UnitDefs[copyedname].metalcost-UnitDefs[srcname].metalcost
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
                --UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morth into " .. copyedname
            end)
    end

    function to_make_op_things.add_build(domain,builer,buildee)
        to_make_op_things.add_fn_to_fn_list(domain,
            "add_build(" .. builer .. ", " .. buildee .. ")",
            function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=buildee
            end)
    end

    function to_make_op_things.add_build_front(domain,builer,buildee)
        to_make_op_things.add_fn_to_fn_list(domain,
            "add_build(" .. builer .. ", " .. buildee .. ")",
            function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                table.insert(UnitDefs[builer].buildoptions,1,buildee)
                --UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
            end)
    end

    to_make_op_things.table_replace_nil={}
    -- Spring.Utilities.OverwriteTableInplace, but allow to set nil by to_make_op_things.table_replace_nil
    function to_make_op_things.table_replace(tweaks)
        local function replace(t)
            for k, v in pairs(tweaks) do
                if v==to_make_op_things.table_replace_nil then
                    t[k]=nil
                elseif (type(v) == "table") then
                    if t[k] and type(t[k]) == "table" then
                        to_make_op_things.table_replace(v)(t[k])
                    else
                        t[k] = v--Spring.Utilities.CopyTable(v, true)
                    end
                else
                    t[k] = v
                end
            end
        end
        return replace
    end
    ---set unit to dontcount, and no wreck
    function to_make_op_things.set_free_unit(ud)
        ud.corpse=nil
        --ud.buildTime=ud.metalCost
        --ud.metalCost=0
        --ud.name = prename .. ud.name
        --ud.explodeAs=[[NOWEAPON]]
        --ud.selfDestructAs=[[NOWEAPON]]
        ud.customParams.dontcount = [[1]]
        ud.featureDefs=nil
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
    function to_make_op_things.lowervalues(t)
        for key, value in pairs(t) do
            if type(value)=="string" then
                t[key]=value:lower()
            end
        end
        return t
    end
    ---get lua table of unit defined by .lua file
    function to_make_op_things.get_unit_lua(udname)
        return VFS.Include("units/".. udname ..".lua")[udname]
    end
    ---copy a unit, tweak it, and return {[toname]=ud}
    function to_make_op_things.copy_tweak(srcname,toname,fn)
        local ud=to_make_op_things.get_unit_lua(srcname)
        fn(ud)
        return {[toname]=ud}
    end

    function to_make_op_things.copy_tweak_silly_build_morth(srcname,toname,builder,fn)
        to_make_op_things.add_build("silly_build",builder,toname)
        to_make_op_things.set_morth_mul("silly_morth",srcname,toname)
        return to_make_op_things.copy_tweak(srcname,toname,fn)
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
    ---set number to be a multiples of 30, needed for reloadtime
    function to_make_op_things.round_to_inv30(n)
        n = n*30
        n = math.ceil(n)
        n = n/30
        return n
    end

    function to_make_op_things.list_to_set(list,value)
        if value==nil then
            value=true
        end
        local set={}
        for _, k in pairs(list) do
            set[k]=value
        end
        return set
    end

    function to_make_op_things.better_gsub_rec(str,pattern,mapper)
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

    function to_make_op_things.better_gsub(str,pattern,mapper)
        local done=""
        local left=str
        while true do
            local l,r=string.find(left,pattern)
            if not l then
                break
            else
                local str1=string.sub(left,1,l-1)
                --local str2=string.sub(str,l,r)
                local str3=string.sub(left,r+1)
                local str2transed=mapper({string.match(left,pattern)})
                done=done .. str1 .. str2transed
                left=str3
                --str = str1 .. str2transed .. str3
            end
        end
        return done .. left
    end

    ---t[key]=modifyfn(t[key],key,t)
    ---@param t table
    ---@param keys list<string>
    ---@param modifyfn fun(value:any,key:string,t:table):any
    function to_make_op_things.modify_all(t,keys,modifyfn)
        if keys then
            for _, key in pairs(keys) do
                t[key]=modifyfn(t[key],key,t)
            end
        end
    end
    
    ---t[key]=modifyfn(t[key],value,key,t)
    ---@param t table
    ---@param tochange {[string]:any}
    ---@param modifyfn fun(value:any,tochange:any,key:string,t:table):any
    function to_make_op_things.modify_all_2(t,tochange,modifyfn)
        for key,value in pairs(tochange) do
            t[key]=modifyfn(t[key],value,key,t)
        end
    end

    local modify_all=to_make_op_things.modify_all
    local modify_all_2=to_make_op_things.modify_all_2

    ---@param params {udkeys:list<string>,udcpkeys:list<string>,wdkeys:list<string>,wdcpkeys:list<string>,udfn:(fun(value:any,key:string,t:table):any),udcpfn:(fun(value:any,key:string,t:table):any),wdfn:(fun(value:any,key:string,t:table):any),wdcpfn:(fun(value:any,key:string,t:table):any),modifycondition:(fun(ud):boolean)}
    function to_make_op_things.modify_all_units(params)
        local udkeys,udcpkeys,wdkeys,wdcpkeys,
        udfn,udcpfn,wdfn,wdcpfn,modifycondition=params.udkeys,params.udcpkeys,params.wdkeys,params.wdcpkeys,
        params.udfn,params.udcpfn,params.wdfn,params.wdcpfn,params.modifycondition
        modifycondition=modifycondition or function ()
            return true
        end
        for _, ud in pairs(UnitDefs) do
            if modifycondition(ud) then
                modify_all(ud,udkeys,udfn)
                modify_all(ud.customparams,udcpkeys,udcpfn)
                if ud.weapondefs then
                    for _, wd in pairs(ud.weapondefs) do
                        modify_all(wd,wdkeys,wdfn)
                        if wd.customparams then
                            modify_all(wd.customparams,wdcpkeys,wdcpfn)
                        end
                    end
                end
            end
        end
    end

    function to_make_op_things.tweak_units(tweaks)
        for name, ud in pairs(UnitDefs) do
            if tweaks[name] then
                Spring.Echo("Loading tweakunits for " .. name)
                Spring.Utilities.OverwriteTableInplace(ud, to_make_op_things.lowerkeys(tweaks[name]), true)
            end
        end
    end

    do
        function to_make_op_things.meta_union(a,b)
            setmetatable(a,{__index=b})
            return a
        end
    end

    function to_make_op_things.justloadstring(str,_gextra,_glevel)
        _glevel=_glevel or 1
        local postfunc, err = loadstring(str)
		if postfunc then
            local _gr=getfenv(_glevel)
            if _gextra then
                setfenv(postfunc,to_make_op_things.meta_union(_gextra,_gr))
            else
                setfenv(postfunc,_gr)
            end
			return postfunc()
		else
            error("failed to load string: " .. str .. " with error: " .. tostring(err))
            --return nil
		end
    end

    function to_make_op_things.justeval(str,_gextra,_glevel)
        if type(str)~="string" then
            return str
        end
        str="return " .. str
        _glevel=_glevel or 1
        local postfunc, err = loadstring(str)
		if postfunc then
            local _gr=getfenv(_glevel)
            if _gextra then
                setfenv(postfunc,to_make_op_things.meta_union(_gextra,_gr))
            else
                setfenv(postfunc,_gr)
            end
			return postfunc()
		else
            error("failed to load string: " .. str .. " with error: " .. tostring(err))
            --return nil
		end
    end

    function to_make_op_things.eval(str,env)
        local postfunc, err = loadstring("return " .. str,"chunk")
		if postfunc then
			return postfunc()
		else
            return nil
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
    

    --- load modOptions.mods \
    function to_make_op_things.load_modoptions()
        --do_lua_mods=do_lua_mods or false
        local modOptions = {}
        local utils=to_make_op_things
        if (Spring.GetModOptions) then
            modOptions = Spring.GetModOptions()
        end
        Spring.GetModOptions=function ()
            return modOptions
        end
        if modOptions.did_load_mod then
            Spring.Echo("modoptions already loaded")
            return
        end

        if not modOptions.mods then
            modOptions.mods ="silly()"
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
            option_notes="\n---\n",
        }
        ---@type integer
        local tweakdefs_count=1
        ---@type integer
        local tweakunits_count=1
        local do_at_def_pre_count=1
        local json_mods_dir="gamedata/mods/"
        local lua_mods_dir="gamedata/lua_mods/"
        local mods=modOptions.mods
        

        local load_mod
        local function load_modoption(themodoptions)
            local fns={}
            fns.tweakunits={}
            fns.tweakdefs={}
            fns.mods={}
            local function push_fn(key,fn)
                fns[key][#fns[key]+1] = fn
            end
            local function do_fns(key)
                for _, value in pairs(fns[key]) do
                    value()
                end
            end
            for key, value in pairs(themodoptions) do
                if key=="do_at_def_pre" then
                    utils.add_fn_to_fn_list("def_pre","def_pre" .. do_at_def_pre_count,value)
                    do_at_def_pre_count=do_at_def_pre_count+1
                elseif string.match(key,"^tweakunits") then
                    --[=[
                    modOptions["tweakunits" .. (tweakunits_count or "")]=value
                    ]=]
                    local tweakunitstable=Spring.Utilities.CustomKeyToUsefulTable(value)
                    push_fn("tweakunits",function ()
                        utils.add_fn_to_fn_list("def","tweakunits" .. tweakunits_count,function ()
                            utils.tweak_units(tweakunitstable)
                        end)
                        tweakunits_count=tweakunits_count+1
                    end)
                elseif string.match(key,"^tweakdefs") then
                    --modOptions["tweakdefs" .. (tweakdefs_count or "")]=value
                    
                    local codestr=Spring.Utilities.Base64Decode(value)
                    push_fn("tweakdefs",function ()
                        utils.add_fn_to_fn_list("def","tweakdefs" .. tweakdefs_count,function ()
                            utils.tweak_defs(codestr)
                        end)
                        tweakdefs_count=tweakdefs_count+1
                    end)
                    
                elseif key=="mods" then
                    local modstr=value
                    push_fn("mods",function ()
                        load_mod(modstr)
                    end)
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
            end-- loaded at end
            do_fns("tweakdefs")
            do_fns("tweakunits")
            do_fns("mods")
        end
        --local update_mod;
        local function load_json_mod(mod,moddir)
            Spring.Echo("SW: Load mod " .. mod)
            local dataRaw=VFS.LoadFile(moddir)
            local mod_data=Spring.Utilities.json.decode(dataRaw)
            if mod_data then
                local themodoptions=mod_data.options
                if themodoptions then
                    load_modoption(themodoptions)
                end
            else
                Spring.Echo("Warning: SW: failed to load mod " .. mod)
            end
        end
        local function load_lua_mod(mod,moddir,env)
            Spring.Echo("SW: Run luamod " .. mod)
            local themodoptions=VFS.Include(moddir,env)
            if themodoptions then
                load_modoption(themodoptions)
            end
        end
        
        local load_mod_env={}
        --[==[
        local load_mod_env_mt={__index=function (table,key)
            
            local mod=key
            local jsonmoddir=mods_dir .. mod .. ".json"
            local lua_mod_dir=lua_mods_dir .. mod .. ".lua"
            if VFS.FileExists(jsonmoddir) then
                return function ()
                    load_json_mod(mod,jsonmoddir)
                end
            elseif VFS.FileExists(lua_mod_dir) then
                return function (env)
                    env=to_make_op_things.meta_union(env,getfenv(0))
                    load_lua_mod(mod,lua_mod_dir,env)
                end
            else
                Spring.Echo("Warning: SW: mod " .. mod .. " don't exist")
                return function ()
                    return nil
                end
            end
        end}
        setmetatable(load_mod_env,load_mod_env_mt)]==]
        for key, value in pairs(VFS.DirList(lua_mods_dir)) do
            local mod=string.match(value,[[([a-zA-Z_]+)%.lua]])
            Spring.Echo("find luamod: " .. value .. " modname: " .. tostring( mod))
            if mod then
                load_mod_env[mod]=function (env)
                    env=env or {}
                    env=to_make_op_things.meta_union(env,getfenv(0))
                    load_lua_mod(mod,value,env)
                end
            end
        end

        for key, value in pairs(VFS.DirList(json_mods_dir)) do
            local mod=string.match(value,[[([a-zA-Z_]+)%.json]])
            Spring.Echo("find jsonmod: " .. value .. " modname: " .. tostring( mod))
            if mod then
                load_mod_env[mod]=function ()
                    load_json_mod(mod,value)
                end
            end
        end

        load_mod=function(modstr)
            to_make_op_things.justloadstring(modstr,load_mod_env)
        end

        load_mod(mods)

        modOptions.did_load_mod=true
        Spring.Echo("modOptions result: ")
        Spring.Utilities.TableEcho(modOptions,"modOptions")
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
    
    function to_make_op_things.GetDimensions(str)
        if not str then
            return nil
        end
        local dimensionsStr = to_make_op_things.StrExplode(" ", str)
        -- string conversion (required for MediaWiki export)
        if dimensionsStr then
            local dimensions = {}
            for i,v in pairs(dimensionsStr) do

                dimensions[i] = tonumber(v)
            end
            return dimensions
        else
            return nil
            --error("Fail to GetDimensions on " .. scale)
        end
    end

    function to_make_op_things.ToDimensions(v3)
        return tostring(v3[1]) .. " " .. tostring(v3[2]) .. " " .. tostring(v3[3])
    end

    do
        --- did automatically via def_scale
        local udtryScales3=to_make_op_things.lowervalues({
            --"collisionVolumeOffsets",
            --"collisionVolumeScales",
            "selectionVolumeOffsets",
            "selectionVolumeScales"
        })
        local udtryScales1=to_make_op_things.lowervalues({
            "trackOffset",
            "trackWidth",
            "trackStrength",
            "trackStretch",
            "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed"
        })
        local udtryScales1round=to_make_op_things.lowervalues({
            "footprintX",
            "footprintZ",
        })
        local udcptryScales3=to_make_op_things.lowervalues({
            --"aimposoffset","midposoffset"
        })
        local udcptryScales1=to_make_op_things.lowervalues({
            --"modelradius","modelheight"
        })
        local GetDimensions=to_make_op_things.GetDimensions
        local ToDimensions=to_make_op_things.ToDimensions
        local function scale3(scale)
            return function(v)
                if type(v)=="string" then
                    local ss=GetDimensions(v)
                    if ss then
                        if #ss~=3 then
                            Spring.Echo("Odd things find " .. v)
                        end
                        for i = 1, #ss do
                            ss[i]=ss[i]*scale
                        end
                        return ToDimensions(ss)
                    else
                        return v
                    end
                else
                    return v
                end
            end
        end
        local function scale1(scale)
            return function (v)
                if type(v)=="number" then
                    return v*scale
                else
                    return v
                end
            end
        end
        local function scale1round(scale)
            return function (v)
                if type(v)=="number" then
                    v=v*scale
                    v=math.floor(v+0.5)
                    if v<1 then
                        v=1
                    end
                    return v
                else
                    return v
                end
            end
        end
        --local modify_all=to_make_op_things.modify_all
        function to_make_op_things.set_scale(ud,scale)
            modify_all(ud,udtryScales3,scale3(scale))
            modify_all(ud,udtryScales1,scale1(scale))
            modify_all(ud,udtryScales1round,scale1round(scale))
            if ud.customparams then
                local udcp=ud.customparams
                modify_all(udcp,udcptryScales3,scale3(scale))
                modify_all(udcp,udcptryScales1,scale1(scale))
                ud.customparams.dynamic_colvol=true
            end
            if ud.movementclass then
                local b,s,p=to_make_op_things.MoveDef_CanGen(ud.movementclass)
                if b then
                    s=s*scale
                    s=math.floor(s+0.5)
                    if s<1 then
                        s=1
                    end
                    Spring.Echo("Change unit " .. ud.name .. "'s movementclass to: " ..p .. b .. tostring(s))
                    ud.movementclass=p .. b .. tostring(s)
                end
            end
        end
    end
    
    function to_make_op_things.string_a_b(str)
        local l,r=string.find(str,"_")
        if l then
            return string.sub(str,1,l-1),string.sub(str,r+1)
        else
            return nil
        end
    end

    ---loop call fn(value), return false then fn(value) will be done later
    ---@param values any
    ---@param fn any
    ---@return table|nil
    function to_make_op_things.loop_until_finish_all(values,fn)
        local values_unfinished={}
        while #values>0 do
            for _, value in pairs(values) do
                if fn(value) then

                else
                    values_unfinished[#values_unfinished+1]=value
                end
            end
            if #values==#values_unfinished then
                return values_unfinished
            else
                values=values_unfinished
                values_unfinished={}
            end
        end
        return nil
    end
    do
        local common_depthmodparams = {
            quadraticCoeff = 0.0027,
            linearCoeff = 0.02,
        }
        local function selectless(t,size)
            return ((size<=#t) and t[size]) or t[#t]
        end
        local crushstrengthGen=function (size)
            return selectless({5,50,150,500,5000} ,size)
        end
        local minwaterdepthGenBoat
        local BaseGen={
            KBOT=function (size)
                return {
                    footprintx = size,
                    footprintz = size,
                    maxwaterdepth = selectless({16,22,22,22,123} ,size),
                    maxslope = 36,
                    crushstrength = crushstrengthGen(size),
                    depthmodparams = common_depthmodparams,
                }
            end,
            TANK=function (size)
                return {
                    footprintx = size,
                    footprintz = size,
                    slopemod = 20,
                    maxwaterdepth = selectless({22,22,22,22,123} ,size),
                    maxslope = 18,
                    crushstrength = crushstrengthGen(size),
                    depthmodparams = common_depthmodparams,
                }
            end,
            HOVER=function (size)
                return {
                    footprintx = size,
                    footprintz = size,
                    maxslope = 18,
                    maxwaterdepth = 5000,
                    slopemod = 30,
                    crushstrength = crushstrengthGen(size),
                }
            end,
            BOAT5 = function(size)
                return {
                    footprintx = size,
                    footprintz = size,
                    minwaterdepth = selectless({5,5,5,5,15} ,size),
                    crushstrength = 5000,
                }
            end
        }
        local PrefixDo={
            A=function (t)
                t.maxwaterdepth = 5000
                t.depthmod = 0
                t.depthmodparams=nil
            end,
            T=function (t)
                t.maxslope = 70
            end,
            U=function (t)
                t.subMarine=1
            end,
            B=function (t,b,s)
                if b=="HOVER" then
                    t.maxslope = 36
                end
            end,
            S=function (t)
                t.maxwaterdepth=t.maxwaterdepth/2
                t.crushstrength=t.crushstrength/4
            end
        }
        function to_make_op_things.MoveDef_CanGen(md)
            Spring.Echo("MoveDefGen Evaluating " .. md)
            local basetyl,basetyr
            for key, _ in pairs(BaseGen) do
                basetyl,basetyr=string.find(md,key)
                if basetyl then
                    break
                end
            end
            if basetyl and basetyr then
                local prefixs=string.sub(md,1,basetyl-1)
                local baset=string.sub(md,basetyl,basetyr)
                local size=string.sub(md,basetyr+1)
                size=tonumber(size)
                if not size then
                    Spring.Echo("MoveDefGen Evaluate no size")
                    return false
                end
                for i=1,string.len(prefixs) do
                    local prefix=string.sub(prefixs,i,i)--prefixs[i]
                    if prefix==nil then
                        Spring.Echo("MoveDefGen Evaluate odd nil prefix " .. tostring( prefix) .. " from " .. tostring( prefixs) .. " at " .. i)
                    elseif not PrefixDo[prefix] then
                        Spring.Echo("MoveDefGen Evaluate bad prefix " .. prefix)
                        return nil
                    end
                end
                Spring.Echo("MoveDefGen Evaluate Result: ".. baset , size,prefixs)
                return baset,size,prefixs
            else
                Spring.Echo("MoveDefGen Evaluate no base")
            end
            return nil
        end
        function to_make_op_things.MoveDef_TryGen(baset,size,prefixs)
            local movedef=BaseGen[baset](size)
            for i=1,string.len(prefixs) do
                local prefix=string.sub(prefixs,i,i)
                PrefixDo[prefix](movedef,baset,size)
            end
            return movedef
        end
    end
end
VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
return Spring.Utilities.to_make_op_things