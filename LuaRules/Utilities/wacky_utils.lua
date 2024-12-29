if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.wacky_utils then
    local wacky_utils={}
    Spring.Utilities.wacky_utils=wacky_utils


    wacky_utils.None={}
    -- Spring.Utilities.OverwriteTableInplace, but allow to set nil by to_make_op_things.table_replace_nil
    local function table_replace(tweaks)
        local function replace(t)
            for k, v in pairs(tweaks) do
                if v==wacky_utils.None then
                    t[k]=nil
                elseif (type(v) == "table") then
                    if t[k] and type(t[k]) == "table" then
                        wacky_utils.table_replace(v)(t[k])
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
    wacky_utils.table_replace=table_replace

    local function lowerkeys(t)
        local tn = {}
        if type(t) == "table" then
            for i,v in pairs(t) do
                local typ = type(i)
                if type(v)=="table" then
                    v = lowerkeys(v)
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
    wacky_utils.lowerkeys=lowerkeys
    local function lowervalues(t)
        for key, value in pairs(t) do
            if type(value)=="string" then
                t[key]=value:lower()
            end
        end
        return t
    end
    wacky_utils.lowervalues=lowervalues
    local function round_to(n,base)
        n = n/base
        n = math.ceil(n+0.5)
        n = n*base
        return n
    end
    wacky_utils.round_to=round_to
    local function list_to_set(list,value)
        if value==nil then
            value=true
        end
        local set={}
        for _, k in pairs(list) do
            set[k]=value
        end
        return set
    end
    wacky_utils.list_to_set=list_to_set
    

    local function better_gsub_rec(str,pattern,mapper)
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
    wacky_utils.better_gsub_rec=better_gsub_rec

    local function better_gsub(str,pattern,mapper)
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
    wacky_utils.better_gsub=better_gsub

    local function mt_union(a,b)
        setmetatable(a,{__index=b})
        return a
    end
    wacky_utils.mt_union=mt_union

    
    local function justloadstring(str,_gextra,_glevel)
        _glevel=_glevel or 1
        local postfunc, err = loadstring(str)
		if postfunc then
            local _gr=getfenv(_glevel)
            if _gextra then
                setfenv(postfunc,mt_union(_gextra,_gr))
            else
                setfenv(postfunc,_gr)
            end
			return postfunc()
		else
            error("failed to load string: " .. str .. " with error: " .. tostring(err))
            --return nil
		end
    end
    wacky_utils.justloadstring=justloadstring

    local function justeval(str,_gextra,_glevel)
        if type(str)~="string" then
            return str
        end
        str="return " .. str
        _glevel=_glevel or 1
        local postfunc, err = loadstring(str)
		if postfunc then
            local _gr=getfenv(_glevel)
            if _gextra then
                setfenv(postfunc,mt_union(_gextra,_gr))
            else
                setfenv(postfunc,_gr)
            end
			return postfunc()
		else
            error("failed to load string: " .. str .. " with error: " .. tostring(err))
            --return nil
		end
    end
    wacky_utils.justeval=justeval

    local function eval(str,env)
        local postfunc, err = loadstring("return " .. str)
		if postfunc then
			return postfunc()
		else
            return nil
		end
    end
    wacky_utils.eval=eval

    local function loop_until_finish_all_list(values,fn)
        local values_unfinished={}
        while #values>0 do
            local c=#values
            local c2=0
            for i=1,c do
                local value=values[i]
                if fn(value) then

                else
                    c2=c2+1
                    values_unfinished[c2]=value
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
    wacky_utils.loop_until_finish_all_list=loop_until_finish_all_list
    local function loop_until_finish_all_table(values,fn)
        local values_unfinished={}
        while next(values) do
            local reduced=false
            for key,value in pairs(values) do
                local res=fn(key,value)
                values_unfinished[key]=res
                if not res then
                    reduced=true
                end
            end
            if not reduced then
                return values_unfinished
            else
                values=values_unfinished
                values_unfinished={}
            end
        end
        return nil
    end
    wacky_utils.loop_until_finish_all_table=loop_until_finish_all_table

    local function maylowerkeyget(t,k)
        return t[k] or t[string.lower(k)]
        --[=[
        if t[k]~=nil then
            return t[k]
        else
            local k2=string.lower(k)
            if t[k2]~=nil then
                return t[k2]
            else
                return nil
            end
        end]=]
    end
    local function maylowerkeyset(t,k,v)
        if t[k]~=nil then
            t[k]=v
        else
            local k2=string.lower(k)
            if t[k2]~=nil then
                t[k2]=v
            else
                t[k]=v
            end
        end
    end
    wacky_utils.maylowerkeyget=maylowerkeyget
    wacky_utils.maylowerkeyset=maylowerkeyset

    do
        wacky_utils.MayLowerKeyProxy=function (tb)
            local maylowermt={
                __index=function (t,k)
                    return maylowerkeyget(tb,k)
                end,
                __newindex=function (t,k,v)
                    maylowerkeyset(tb,k,v)
                end
            }
            local o={}
            setmetatable(o,maylowermt)
            return o
        end
    end
end