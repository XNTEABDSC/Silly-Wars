if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.wacky_utils then
    Spring.Utilities.wacky_utils={}
end
if not Spring.Utilities.wacky_utils.may_lower_key_proxy then
    local wacky_utils=Spring.Utilities.wacky_utils

    
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
        wacky_utils.may_lower_key_proxy=function (tb)
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

    Spring.Utilities.wacky_utils=wacky_utils
end