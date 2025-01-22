VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.modify_all_2 then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    
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
    
    Spring.Utilities.to_make_op_things=to_make_op_things
end