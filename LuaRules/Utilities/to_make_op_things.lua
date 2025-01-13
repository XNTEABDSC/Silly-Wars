---@class list<t> : {[integer]:t}
if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end

if not Spring.Utilities.to_make_op_things then
    VFS.Include("LuaRules/Utilities/tablefunctions.lua")
    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local wacky_utils=Spring.Utilities.wacky_utils
    VFS.Include("LuaRules/Utilities/ordered_list.lua")

    if not Spring.Utilities.json then
        Spring.Utilities.json= VFS.Include("LuaRules/Utilities/json.lua")
    end
    local to_make_op_things={}
    Spring.Utilities.to_make_op_things=to_make_op_things


    local UnitDefsTweakFns=Spring.Utilities.OrderedList.New()
    to_make_op_things.unit_defs_tweak_fns=UnitDefsTweakFns
    
    local WeaponDefsTweakFns=Spring.Utilities.OrderedList.New()
    to_make_op_things.weapon_defs_tweak_fns=WeaponDefsTweakFns

    local function AddFnToUnitDefsTweakFns(ordered)
        UnitDefsTweakFns.Add(ordered)
    end
    to_make_op_things.AddFnToUnitDefsTweakFns=AddFnToUnitDefsTweakFns

    local function AddFnToUnitDefsTweakFnsMut(ordered)
        Spring.Utilities.OrderedList.AddMult(UnitDefsTweakFns,ordered)
    end
    to_make_op_things.AddFnToUnitDefsTweakFnsMut=AddFnToUnitDefsTweakFnsMut

    local function RunOrderedList(OList)
        local res=OList.ForEach(function (v,k)
            Spring.Echo("Run Task: " .. k)
            if v then
                v()
            end
        end)
        if res then
            for key, value in pairs(res) do
                Spring.Echo("Warning: Not Done Task " .. key .. ", after:")
                for _, k2 in pairs(value.afters) do
                    Spring.Echo(k2)
                end
            end
        end
    end
    to_make_op_things.RunOrderedList=RunOrderedList
    to_make_op_things.RunUnitDefsTweakFns=function ()
        RunOrderedList(UnitDefsTweakFns)
    end

    

    --- make "modify_" .. key .. "_begin" and "modify_" .. key .. "_end" and order
    --- they are in modify_values_begin and modify_values_end
    --- cost exclude, use modify_cost_begin modify_cost_end
    local OrderKeyGen=function (order,keys)
        local begins,ends={},{}
        for _, key in pairs(keys) do
            
            local beginstr="modify_" .. key .. "_begin"
            local endstr="modify_" .. key .. "_end"
            if not order.kvlist[beginstr] and not order.kvlist[endstr] then
                order.Add({k=beginstr,a={endstr},b="modify_values_begin"})
                order.Add({k=endstr,a="modify_values_end"})
            end
            begins[#begins+1] = beginstr
            endstr[#endstr+1] = endstr
        end
        return begins,ends
    end
    
    to_make_op_things.OrderKeyGen=OrderKeyGen

    do
        local fns=UnitDefsTweakFns
        fns.Add({k="pre_set_values"})
        fns.Add({k="default_add_build_begin",a={"default_add_build_end"}})
        fns.Add({k="default_add_build_end"})
        fns.Add({k="default_set_morph_begin",a={"default_set_morph_end"}})
        fns.Add({k="default_set_morph_end"})
        fns.Add({k="default_modify_value_begin",a={"default_modify_value_end"},b={"pre_set_values"}})
        fns.Add({k="default_modify_value_end",a={"post_set_values"}})
        fns.Add({k="default_modify_cost_begin",a={"default_modify_cost_end"},b={"pre_set_values"}})
        fns.Add({k="default_modify_cost_end",a={"post_set_values"}})
        fns.Add({k="default_modify_feature_begin",a={"default_modify_feature_end"},b={"pre_set_values"}})
        fns.Add({k="default_modify_feature_end",a={"post_set_values"}})
        fns.Add({k="post_set_values"})
        --- notes that changes that may removes previous modify (e.g. buildoptions = ...) should be before default_modify, not in
    end
    --[==[
    local utils={
        "fn_list"
    }
    local utilsPath="utils/to_make_op_things/"
    for _, value in pairs(utils) do
        VFS.Include(utilsPath .. value)
    end
    ]==]

    --- Optional Fns that may be done
    local OptionalUnitDefsTweakFns={}
    --- Optional Fns that may be done
    to_make_op_things.OptionalUnitDefsTweakFns=OptionalUnitDefsTweakFns
    ---add a function at domain
    ---
    ---notes fn may needs to use lowerkeys 
    ---@param domain string
    ---@param ordered ValueAndOrder<fun()>
    local function AddFnToOptionalUnitDefsTweakFns(domain,ordered)

        if OptionalUnitDefsTweakFns[domain]==nil then
            OptionalUnitDefsTweakFns[domain]={}
        end
        
        if OptionalUnitDefsTweakFns[domain]==true then
            AddFnToUnitDefsTweakFns(ordered)
        else
            local l=OptionalUnitDefsTweakFns[domain]
            l[ordered.k]=ordered
        end
    end
    to_make_op_things.AddFnToOptionalUnitDefsTweakFns=AddFnToOptionalUnitDefsTweakFns
    
    ---put fns in domain into 
    ---@param domain string
    local function PushOptionalUnitDefsTweakFns(domain)
        local lf=OptionalUnitDefsTweakFns[domain]
        if lf~=nil and lf~=true then
            for _, value in pairs(lf) do
                AddFnToUnitDefsTweakFns(value)
            end
            OptionalUnitDefsTweakFns[domain]=true
        end
    end
    to_make_op_things.PushOptionalUnitDefsTweakFns=PushOptionalUnitDefsTweakFns

    local function SetMorphMut(srcname,copyedname,morphtime,morphprice)
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
        --morphprice=morphprice or UnitDefs[copyedname].metalcost-UnitDefs[srcname].metalcost
        local i=1
        morphtime=morphtime or 10
        while true do
            if not ud_cp["morphto_" .. i] then
                ud_cp["morphto_" .. i]=copyedname
                ud_cp["morphtime_" .. i]=morphtime
                ud_cp["morphcost_" .. i]=morphprice
                break
            end
            i=i+1
        end
    end
    to_make_op_things.SetMorphMut=SetMorphMut

    local function MakeSetMorphMutValueWithOrder(srcname,copyedname,morphtime,morphprice)
        return{
            k=("set_morph_mul(" .. srcname .. ", " .. copyedname .. ")"),
            b={"default_set_morph_begin"},
            a={"default_set_morph_end"},
            v=function ()
                SetMorphMut(srcname,copyedname,morphtime,morphprice)
                --UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morph into " .. copyedname
            end
        }
    end
    to_make_op_things.MakeSetMorphMutValueWithOrder=MakeSetMorphMutValueWithOrder

    local function MakeAddBuildValueWithOrder(builer,buildee)
        return{
            k="add_build(" .. builer .. ", " .. buildee .. ")",
            b={"default_add_build_begin"},
            a={"default_add_build_end"},
            v=function ()
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
            end
        }
    end

    to_make_op_things.MakeAddBuildValueWithOrder=MakeAddBuildValueWithOrder

    local function MakeDefAddBuild(builder,buildee)
        AddFnToUnitDefsTweakFns({
            k="def_add_build("..builder .. ", "..buildee .. ")",
            b={"default_add_build_begin"},
            a={"default_add_build_end"},
            v=function ()
                if not UnitDefs[builder] then
                    error("add_build(" .. builder .. ", " .. buildee .. "): unit " .. builder .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builder .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builder].buildoptions then
                    UnitDefs[builder].buildoptions={}
                end
                --Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                --table.insert(UnitDefs[builder].buildoptions,1,buildee)
                UnitDefs[builder].buildoptions[#UnitDefs[builder].buildoptions+1]=buildee
            end
        })
        --AddFnToOptionalUnitDefsTweakFns("silly_morph",MakeSetMorphMutValueWithOrder(srcname,toname,morphtime,morphprice))
    end
    to_make_op_things.MakeDefAddBuild=MakeDefAddBuild
    local function ModifyTableMBLowkey(tb,key,fn)
        local v=tb[key]
        if not v then
            local key2=string.lower(key)
            v=tb[key2]
            if v then
                key=key2
            end
        end
        v[key]=fn(v)
    end
    to_make_op_things.ModifyTableMBLowkey=ModifyTableMBLowkey

    do
        local maxBuildPer=18
        local silly_build_units={
            {name="sillycon",range={0,2000}},
            {name="sillyconvery",range={2000,10000}},
            {name="sillyconveryvery",range={10000,100000}}
        }

        local function Init()
            for key, value in pairs(silly_build_units) do
                value.builderCount=1
                local ud=UnitDefs[value.name]
                if not ud then
                    Spring.Echo("unit " .. value.name .. "don't exist")
                end
                value.currentUD=ud
                value.currentName=value.name
                value.HumanName=ud.name
                value.HumanDesc=ud.description
                ud.buildoptions=ud.buildoptions or {}
                ud.name=ud.name .. " Vol.1"
                ud.description=ud.description .. ", Vol.1"
            end
        end

        local function NextBuilder(sillyConsInfo)
            sillyConsInfo.builderCount=sillyConsInfo.builderCount+1
            local oldname=sillyConsInfo.currentName

            local newname=sillyConsInfo.name .. sillyConsInfo.builderCount
            local copyUD=Spring.Utilities.CopyTable(sillyConsInfo.currentUD,true)
            copyUD.name=sillyConsInfo.HumanName .. " Vol." .. sillyConsInfo.builderCount
            copyUD.description=sillyConsInfo.HumanDesc .. ", Vol." .. sillyConsInfo.builderCount
            copyUD.buildoptions={}

            SetMorphMut(sillyConsInfo.currentName,newname,1)

            UnitDefs[newname]=copyUD
            sillyConsInfo.currentUD=copyUD
            sillyConsInfo.currentName=newname
        end

        local function AddSillyBuild(unitname,sillyOption)
            local ud=UnitDefs[unitname]
            local metalcost=ud.metalcost
            local sillyConsInfo
            for i = 1, #silly_build_units do
                sillyConsInfo=silly_build_units[i]
                if sillyOption then
                    if sillyConsInfo.name==sillyOption then
                        break
                    end
                else
                    if sillyConsInfo.range[1]<=metalcost and metalcost<= sillyConsInfo.range[2] then
                        break
                    end
                end
                
            end
            if not sillyConsInfo.currentUD then
                Spring.Echo("????? empry currentUD info: " .. sillyConsInfo.name)
            end
            if #sillyConsInfo.currentUD.buildoptions>=maxBuildPer then
                NextBuilder(sillyConsInfo)
            end
            sillyConsInfo.currentUD.buildoptions[#sillyConsInfo.currentUD.buildoptions+1]=unitname
        end
        
        local function End()
            for key, value in pairs(silly_build_units) do
                local lastudname=value.currentName
                local firstudname=value.name
                if firstudname~=lastudname then
                    SetMorphMut(lastudname,firstudname,1)
                    
                end
            end
        end

        local function MakeAddSillyBuildValueWithOrder(unitname,con)
            return{
                k="add_silly_build(" .. unitname .. ")",
                b={"default_add_silly_build_begin"},
                a={"default_add_silly_build_end"},
                v=function ()
                    AddSillyBuild(unitname,con)
                end
            }
        end
        AddFnToUnitDefsTweakFns({
            k="default_add_silly_build_begin",
            v=function ()
                Init()
            end,
            b={"default_add_build_begin"}
        })
        AddFnToUnitDefsTweakFns({
            k="default_add_silly_build_end",
            v=function ()
                End()
            end,
            b={"default_add_silly_build_begin"},
            a={"default_add_build_end"}
        })
        to_make_op_things.MakeAddSillyBuildValueWithOrder=MakeAddSillyBuildValueWithOrder
        --to_make_op_things.AddSillyBuild=AddSillyBuild
    end

    local function MakeAddBuildFrontValueWithOrder(builer,buildee)
        return{
            k="add_build(" .. builer .. ", " .. buildee .. ")",
            b={"default_add_build_begin"},
            a={"default_add_build_end"},
            v=function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                --Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                table.insert(UnitDefs[builer].buildoptions,1,buildee)
                --UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
            end
        }
    end

    to_make_op_things.MakeAddBuildFrontValueWithOrder=MakeAddBuildFrontValueWithOrder
    
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
        ud.reclaimable=false
    end
    
    ---get lua table of unit defined by .lua file
    local function GetUnitLua(udname)
        return VFS.Include("units/".. udname ..".lua")[udname]
    end
    to_make_op_things.GetUnitLua=GetUnitLua
    ---copy a unit, tweak it, and return {[toname]=ud}
    function to_make_op_things.CopyTweak(srcname,toname,fn)
        local ud=GetUnitLua(srcname)
        fn(ud)
        return {[toname]=ud}
    end
    
    local function MakeSetSillyMorph(srcname,toname,morphtime,morphprice)
        AddFnToOptionalUnitDefsTweakFns("silly_morph",MakeSetMorphMutValueWithOrder(srcname,toname,morphtime,morphprice))
    end

    local function MakeAddSillyBuild(name,con)
        AddFnToOptionalUnitDefsTweakFns("silly_build",to_make_op_things.MakeAddSillyBuildValueWithOrder(name,con))
    end
    to_make_op_things.MakeSetSillyMorph=MakeSetSillyMorph
    to_make_op_things.MakeAddSillyBuild=MakeAddSillyBuild
    function to_make_op_things.CopyTweakSillyBuildMorph(srcname,toname,fn)
        MakeSetSillyMorph(srcname,toname)
        MakeAddSillyBuild(toname)
        --to_make_op_things.add_build("silly_build",builder,toname)
        --to_make_op_things.set_morph_mul("silly_morph",srcname,toname)
        return to_make_op_things.CopyTweak(srcname,toname,fn)
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
    ---set number to be a multiples of 1/30, needed for reloadtime
    

    

    ---t[key]=modifyfn(t[key],key,t)
    ---@param t table
    ---@param keys list<string>
    ---@param modifyfn fun(value:any,key:string,t:table):any
    local function modify_all(t,keys,modifyfn)
        if keys then
            for _, key in pairs(keys) do
                local key2=key
                local tbvalue=t[key2]
                if not tbvalue then
                    key2=string.lower(key2)
                    tbvalue=t[key2]
                end
                t[key]=modifyfn(tbvalue,key,t)
            end
        end
    end
    
    ---t[key]=modifyfn(t[key],value,key,t)
    ---@param t table
    ---@param toChange {[string]:any}
    ---@param modifyfn fun(value:any,tochange:any,key:string,t:table):any
    local function modify_all_2(t,toChange,modifyfn)
        for key,value in pairs(toChange) do
            local key2=key
            local tbvalue=t[key2]
            if not tbvalue then
                key2=string.lower(key2)
                tbvalue=t[key2]
            end
            t[key2]=modifyfn(tbvalue,value,key,t)
        end
    end

    to_make_op_things.modify_all=modify_all
    to_make_op_things.modify_all_2=modify_all_2

    ---@param params {udkeys:list<string>,udcpkeys:list<string>,wdkeys:list<string>,wdcpkeys:list<string>,udfn:(fun(value:any,key:string,t:table):any),udcpfn:(fun(value:any,key:string,t:table):any),wdfn:(fun(value:any,key:string,t:table):any),wdcpfn:(fun(value:any,key:string,t:table):any)}
    function to_make_op_things.modify_unit_all(params,ud)
        local udkeys,udcpkeys,wdkeys,wdcpkeys,
        udfn,udcpfn,wdfn,wdcpfn=params.udkeys,params.udcpkeys,params.wdkeys,params.wdcpkeys,
        params.udfn,params.udcpfn,params.wdfn,params.wdcpfn
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

    ---comment
    ---@param params {udToChange:{[string]:any},udcpToChange:{[string]:any},wdToChange:{[string]:any},wdcpToChange:{[string]:any},udfn:(fun(value:any,tochange:any,key:string,t:table):any),udcpfn:(fun(value:any,tochange:any,key:string,t:table):any),wdfn:(fun(value:any,tochange:any,key:string,t:table):any),wdcpfn:(fun(value:any,tochange:any,key:string,t:table):any)}
    ---@param ud any
    function to_make_op_things.modify_unit_all_2(params,ud)
        local udToChange,udcpToChange,wdToChange,wdcpToChange,
        udfn,udcpfn,wdfn,wdcpfn=
        params.udToChange,params.udcpToChange,params.wdToChange,params.wdcpToChange,
        params.udfn,params.udcpfn,params.wdfn,params.wdcpfn
        modify_all_2(ud,udToChange,udfn)
        local udcp=ud.customParams or ud.customparams
        if udcp then
            modify_all_2(udcp,udcpToChange,udcpfn)
        end
        local wds=ud.weaponDefs or ud.weapondefs
        if wds then
            for _, wd in pairs(wds) do
                modify_all_2(wd,wdToChange,wdfn)
                local wdcp=wd.customParams or wd.customparams
                if wdcp then
                    modify_all_2(wdcp,wdcpToChange,wdcpfn)
                end
            end
        end
    end

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

    local function tweak_units(tweaks)
        for name, _ in pairs(tweaks) do
            if UnitDefs[name] then
                Spring.Echo("Loading tweakunits for " .. name)
                Spring.Utilities.OverwriteTableInplace(UnitDefs[name], wacky_utils.lowerkeys(tweaks[name]), true)
            end
        end
        --[=[
        for name, ud in pairs(UnitDefs) do
            if tweaks[name] then
                Spring.Echo("Loading tweakunits for " .. name)
                Spring.Utilities.OverwriteTableInplace(ud, to_make_op_things.lowerkeys(tweaks[name]), true)
            end
        end]=]
    end

    to_make_op_things.tweak_units=tweak_units
    

    local function tweak_defs(postsFuncStr)
        local postfunc, err = loadstring(postsFuncStr)
		if postfunc then
			postfunc()
		else
			Spring.Log("defs.lua", LOG.ERROR, "tweakdefs", err)
		end
    end
    to_make_op_things.tweak_defs=tweak_defs

    --- load modOptions
    function to_make_op_things.load_modoptions()
        --do_lua_mods=do_lua_mods or false
        local modOptions = {}
        local utils=wacky_utils
        local toload={}
        if (Spring.GetModOptions) then
            toload = Spring.GetModOptions()
        end
        if toload.did_load_mod then
            Spring.Echo("modoptions already loaded")
            return
        end
        Spring.GetModOptions=function ()
            return modOptions
        end

        if not toload.mods then
            toload.mods ="silly()"
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
            mods=" "
        }
        local json_mods_dir="gamedata/mods/"
        local lua_mods_dir="gamedata/lua_mods/"

        local mod_count=0
        local last_order="load_modoptions_begin"
        

        local load_mod
        local function load_modoption(loaded_mod_options)
            for key, value in pairs(loaded_mod_options) do
                if  modOptions[key] then
                    if option_mult[key] then
                        modOptions[key]=modOptions[key]*value
                    elseif option_add_withdef[key] then
                        modOptions[key]=modOptions[key]+value-option_add_withdef[key]
                    elseif option_mult_withdef[key] then
                        modOptions[key]=modOptions[key]*value/option_mult_withdef[key]
                    elseif option_bindstr[key] then
                        modOptions[key]=modOptions[key] .. option_bindstr[key] .. value
                    elseif string.find(key,"tweakdefs") then
                    elseif string.find(key,"tweakunits") then
                    else
                        modOptions[key]=value
                    end
                else
                    modOptions[key]=value
                end
            end

            AddFnToUnitDefsTweakFns({
                v=function ()
                    local append = false
                    local name = "tweakdefs"
                    while loaded_mod_options[name] and loaded_mod_options[name] ~= "" do
                        local postsFuncStr = Spring.Utilities.Base64Decode(loaded_mod_options[name])
                        Spring.Echo("Loading tweakdefs modoption ".. (append or 0) .. "\n" .. postsFuncStr)
                        tweak_defs(postsFuncStr)
                        append = (append or 0) + 1
                        name = "tweakdefs" .. append
                    end
                end,
                k="modoption " .. mod_count .. " tweakdefs",
                b={last_order}
            })
            AddFnToUnitDefsTweakFns({
                v=function ()
                    local append = false
                    local modoptName = "tweakunits"
                    while loaded_mod_options[modoptName] and loaded_mod_options[modoptName] ~= "" do
                        local tweaks = Spring.Utilities.CustomKeyToUsefulTable(loaded_mod_options[modoptName])
                        if type(tweaks) == "table" then
                            Spring.Echo("Loading tweakunits modoption", append or 0)
                            tweak_units(tweaks)
                        end
                        append = (append or 0) + 1
                        modoptName = "tweakunits" .. append
                    end
                end,
                k="modoption " .. mod_count .. " tweakunits",
                b={"modoption " .. mod_count .. " tweakdefs"}
            })
            last_order="modoption " .. mod_count .. " tweakunits"
            mod_count=mod_count+1
            if loaded_mod_options.mods then
                load_mod(loaded_mod_options.mods)
            end
            
            --[==[
            do_fns("tweakdefs")
            do_fns("tweakunits")
            do_fns("mods")
            ]==]
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
        for key, value in pairs(VFS.DirList(lua_mods_dir,"*.lua")) do
            local mod=string.match(value,[[([a-zA-Z_]+)%.lua]])
            Spring.Echo("find luamod: " .. value .. " modname: " .. tostring( mod))
            if mod then
                load_mod_env[mod]=function (env)
                    env=env or {}
                    env=utils.mt_union(env,getfenv(0))
                    load_lua_mod(mod,value,env)
                end
            end
        end

        for key, value in pairs(VFS.DirList(json_mods_dir,"*.json")) do
            local mod=string.match(value,[[([a-zA-Z_]+)%.json]])
            Spring.Echo("find jsonmod: " .. value .. " modname: " .. tostring( mod))
            if mod then
                load_mod_env[mod]=function ()
                    load_json_mod(mod,value)
                end
            end
        end
        setmetatable(load_mod_env,{__index=function (t,k)
            Spring.Log("defs.lua", LOG.ERROR, "load_mod", "Mod " .. k .. " don't exist")
            return function() end
        end})
        
        load_mod=function(modstr)
            local chunk,errmsg=loadstring(modstr)
            if chunk then
                setfenv(chunk,load_mod_env)
                local suc,res=pcall(chunk)
                if not suc then
                    Spring.Log("defs.lua", LOG.ERROR, "load_mod", "Failed to run string " .. modstr .. " with error ".. res)
                end
            else
                Spring.Log("defs.lua", LOG.ERROR, "load_mod", "Failed to load string " .. modstr .. " with error ".. errmsg)
            end
            --wacky_utils.justloadstring(modstr,load_mod_env)
        end

        --load_mod(mods)

        load_modoption(toload)

        UnitDefsTweakFns.AddOrder(last_order,"load_modoptions_end")

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
        local lowervalues=wacky_utils.lowervalues
        local udtryScales3=lowervalues({
            --"collisionVolumeOffsets",
            --"collisionVolumeScales",
            "selectionVolumeOffsets",
            "selectionVolumeScales"
        })
        local udtryScales1=lowervalues({
            "trackOffset",
            "trackWidth",
            "trackStrength",
            "trackStretch",
            "buildingGroundDecalSizeX","buildingGroundDecalSizeY","buildingGroundDecalDecaySpeed"
        })
        local udcpdefScales1=lowervalues({
            "model_rescale"
        })
        local udtryScales1round=lowervalues({
            -- special
            --"footprintX",
            --"footprintZ",
        })
        local udcptryScales3=lowervalues({
            --"aimposoffset","midposoffset"
        })
        local udcptryScales1=lowervalues({
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
        local function defscale1(scale)
            return function (v)
                if type(v)=="number" then
                    return v*scale
                else
                    return scale
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
        local function ScaleYardMap(oldYardMap,oldx,oldz,newx,newz)
            local oldYardMapTable={}
            local oldYardMapIndex=1
            for z = 1, oldz do
                local oldYardMapTablez={}
                oldYardMapTable[z]=oldYardMapTablez
                for x = 1, oldx do
                    local nextchar
                    while true do
                        nextchar=string.sub(oldYardMap,oldYardMapIndex,oldYardMapIndex)
                        oldYardMapIndex=oldYardMapIndex+1
                        if nextchar==nil then
                            error("Bad YardMap and size")
                        end
                        if nextchar~=" " then
                            break
                        end
                    end
                    oldYardMapTablez[x]=nextchar
                end
            end
            local newYardMapTable={}
            local newYardMap=""
            local newxToOldx=oldx/newx
            local newzToOldz=oldz/newz
            for z = 1, newz do
                local oldYardMapTabley=oldYardMapTable[math.ceil((z-0.5)*newzToOldz)]
                for x = 1, newx do
                    newYardMap=newYardMap .. oldYardMapTabley[math.ceil((x-0.5)*newxToOldx)]
                end
            end
            return newYardMap
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
                modify_all(udcp,udcpdefScales1,defscale1(scale))
            end
            if ud.movementclass then
                local b,s,p=to_make_op_things.MoveDef_CanGen(ud.movementclass)
                if b then
                    s=s*scale
                    s=math.floor(s+0.5)
                    if s<1 then
                        s=1
                    end
                    --Spring.Echo("Change unit " .. ud.name .. "'s movementclass to: " ..p .. b .. tostring(s))
                    ud.movementclass=p .. b .. tostring(s)
                end
            end
            if ud.footprintx then
                local oldfpx,oldfpz=ud.footprintx,ud.footprintz
                local newfpx,newfpz=scale1round(scale)(oldfpx),scale1round(scale)(oldfpz)
                ud.footprintx,ud.footprintz=newfpx,newfpz
                if ud.yardmap then
                    ud.yardmap=ScaleYardMap(ud.yardmap,oldfpx,oldfpz,newfpx,newfpz)
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
    to_make_op_things.units_basic_factories={
        [[factorycloak]],
        [[factoryshield]],
        [[factoryveh]],
        [[factoryhover]],
        [[factorygunship]],
        [[factoryplane]],
        [[factoryspider]],
        [[factoryjump]],
        [[factorytank]],
        [[factoryamph]],
        [[factoryship]],
    }
    to_make_op_things.units_basic_cons={
        "cloakcon",
        "shieldcon",
        "vehcon",
        "hovercon",
        "gunshipcon",
        "planecon",
        "spidercon",
        "jumpcon",
        "tankcon",
        "amphcon",
        "shipcon",
    }
end
return Spring.Utilities.to_make_op_things