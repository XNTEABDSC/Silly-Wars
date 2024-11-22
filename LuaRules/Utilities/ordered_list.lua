if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.OrderedList then
    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    
    --VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
    local LoopUntilFinishAllTable=Spring.Utilities.wacky_utils.loop_until_finish_all_table
    local empty={}
    local OrderedList={}
    function OrderedList.New()
        local self={}
        local kvlist={}
        self.kvlist=kvlist

        local Add

        local function RawGet(key)
            if not kvlist[key] then
                Add({key=key})
            end
            return kvlist[key]
        end
        --self.Get=Get

        local function AddOrder(k1,k2)
            local k1a=RawGet(k1).afters
            k1a[#k1a+1] = k2
            local k2o=RawGet(k2)
            k2o.before_count=k2o.before_count+1
        end
        self.AddOrder=AddOrder

        Add=function (order)
            local key,value,befores,afters=order.k,order.v,order.b,order.a
            kvlist[key]={
                value=value,
                before_count=0,
                afters={}
            }
            if befores then
                for _, before in pairs(befores) do
                    AddOrder(before,key)
                end
            end
            if afters then
                for _, after in pairs(afters) do
                    AddOrder(key,after)
                end
            end
        end
        self.Add=Add

        local function GenList()
            local l={}
            local count=0
            local before_count={}
            for key, value in pairs(kvlist) do
                before_count[key]=#value.befores
            end
            local unfinished= LoopUntilFinishAllTable(kvlist,function (k,v)
                if before_count[k]==0 then
                    if v.value then
                        count=count+1
                        l[count]=v.value
                    end
                    for _, key in pairs(v.afters) do
                        before_count[key]=before_count[key]-1
                    end
                    return nil
                end
                return v
            end)
            if unfinished then
                
            end
            return l
        end

        self.GenList=GenList

        return self
    end

    Spring.Utilities.OrderedList=OrderedList
end
return Spring.Utilities.OrderedList