if not GG then
    GG={}
end
VFS.Include("utils/to_make_very_op_things.lua")

if not GG.to_make_op_things then
    local to_make_op_things={}
    GG.to_make_op_things=to_make_op_things
    to_make_op_things.do_ud_post_fn_list={}
    function to_make_op_things.add_do_ud_post_fn(key,fn)
        to_make_op_things.do_ud_post_fn_list[key]=fn
    end
    function to_make_op_things.do_ud_post()
        for key, value in pairs(to_make_op_things.do_ud_post_fn_list) do
            value()
        end
    end
    function to_make_op_things.set_morth(srcname,copyedname,morphtime)
        to_make_op_things.add_do_ud_post_fn(
            "set_morth(" .. srcname .. ", " .. copyedname .. ")",
            function ()
                if not UnitDefs[srcname] then
                    error("unit " .. srcname .. "do not exist")
                end
                morphtime=morphtime or 10
                UnitDefs[srcname].customparams.morphto=copyedname
                UnitDefs[srcname].customparams.morphtime=morphtime
                UnitDefs[srcname].description=UnitDefs[srcname].description+"Can morth into " .. copyedname
            end
        )
    end
    function to_make_op_things.set_morth_mul(srcname,copyedname,morphtime,morthprice)
        to_make_op_things.add_do_ud_post_fn( 
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

    function to_make_op_things.add_build(builer,building)
        to_make_op_things.add_do_ud_post_fn(
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

    -- from Spring.Utilities.CustomKeyToUsefulTable
    function to_make_op_things.str_to_obj(dataRaw)
        --Spring.Echo("return " .. dataRaw)
        local dataFunc, err = loadstring("return " .. dataRaw)
		if dataFunc then
			local success, result = pcall(dataFunc)
			if success then
				if collectgarbage then
					collectgarbage("collect")
				end
				return result
			end
		end
		if err then
			Spring.Echo("str_to_obj error: ", err)
		end
    end

    function to_make_op_things.strjson_to_obj(dataRaw)
        dataRaw=to_make_op_things.better_gsub(dataRaw,'"([%w_]+)" *:',function (n)
            return n .. " ="
        end)
        return to_make_op_things.str_to_obj(dataRaw)
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

    function to_make_op_things.update_modoptions()
        do
            local modOptions = {}
            local utils=to_make_op_things
            if (Spring.GetModOptions) then
                modOptions = Spring.GetModOptions()
            end
            local optionmult=utils.list_to_set( {"metalmult","energymult","terracostmult","cratermult","hpmult",
            "team_1_econ","team_2_econ","team_3_econ","team_4_econ","team_5_econ","team_6_econ","team_7_econ","team_8_econ",
            "wavesizemult","queenhealthmod","techtimemult"
            } )
            local optionaddwithdef={
            }
            local optionmultwithdef={
                innatemetal=2,
                innateenergy=2,
                zombies_delay=10,
                zombies_rezspeed=12
            }
            ---@type boolean|integer
            local tweakdefs_count=false
            ---@type boolean|integer
            local tweakunits_count=false
            local modsdir="gamedata/mods/"
            local mods=modOptions["mods"]
            if mods then
                for mod in string.gmatch(mods,"%w+") do
                    local moddir=modsdir .. mod .. ".json"
                    if VFS.FileExists(moddir) then
                        Spring.Echo("SW: Load mod " .. mod)
                        local dataRaw=VFS.LoadFile(moddir)
                        local moddata=VFS.Include("LuaRules/Utilities/json.lua").decode(dataRaw)--utils.strjson_to_obj(dataRaw)
                        if moddata then
                            local themodoptions=moddata.options
                            if themodoptions then
                                for key, value in pairs(themodoptions) do
                                    if string.match(key,"^tweakunits") then
                                        modOptions["tweakunits" .. (tweakunits_count or "")]=value
                                        tweakunits_count=(tweakunits_count or 0)+1
        
                                    elseif string.match(key,"^tweakdefs") then
                                        modOptions["tweakdefs" .. (tweakdefs_count or "")]=value
                                        tweakdefs_count=(tweakdefs_count or 0)+1
        
                                    elseif  modOptions[key] then
                                        if optionmult[key] then
                                            modOptions[key]=modOptions[key]*value
                                        elseif optionaddwithdef[key] then
                                            modOptions[key]=modOptions[key]+value-optionaddwithdef[key]
                                        elseif optionmultwithdef[key] then
                                            modOptions[key]=modOptions[key]*value/optionmultwithdef[key]
                                        elseif key=="disabledunits" then
                                            modOptions[key]=modOptions[key] .. "+ " .. value
                                        elseif key=="option_notes" then
                                            modOptions[key]=modOptions[key] .. " " .. value
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
end
return GG.to_make_op_things