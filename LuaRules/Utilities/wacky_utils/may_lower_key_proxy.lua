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

    local function lowerkeyget(t,k)
        return t[string.lower(k)]
    end

    local function lowerkeyset(t,k,v)
        t[string.lower(k)]=v
    end

    do
        --- returns a table `o` that acts like `tb` e.g. `o.customParams`, but if `tb=lowerkey(tb)`, then `o` will do key:lower() 
        --- if checkKeys cant check, this function will enumerate all keys to check whether `tb=lowerkey(tb)`
        ---@param checkKeys list<string>? keys to check whether `tb=lowerkey(tb)`
        wacky_utils.may_lower_key_proxy=function (tb,checkKeys)
            local lower=nil
            if checkKeys then
                for _, checkKey in pairs(checkKeys) do
                    if tb[checkKey]~=nil then
                        lower=false
                        break
                    elseif tb[string.lower(checkKey)]~=nil then
                        lower=true
                        break
                    end
                end
            end
            if lower==nil then
                lower=true
                for key, _ in pairs(tb) do
                    if key~=string.lower(key) then
                        lower=false
                        break
                    end
                end
            end
            local maylowermt
            if lower then
                maylowermt={
                    __index=function (_,k)
                        return lowerkeyget(tb,k)
                    end,
                    __newindex=function (_,k,v)
                        lowerkeyset(tb,k,v)
                    end
                }
                local o={}
                setmetatable(o,maylowermt)
                return o
            else
                return tb
            end
        end
        local may_lower_key_proxy_wd_checkkeys={
            "weaponType"
        }
        wacky_utils.may_lower_key_proxy_wd_checkkeys=may_lower_key_proxy_wd_checkkeys
        local may_lower_key_proxy_ud_checkkeys={
            "objectName"
        }
        wacky_utils.may_lower_key_proxy_ud_checkkeys=may_lower_key_proxy_ud_checkkeys
    end

    Spring.Utilities.wacky_utils=wacky_utils
end