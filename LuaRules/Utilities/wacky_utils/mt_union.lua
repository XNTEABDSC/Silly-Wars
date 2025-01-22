if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.wacky_utils then
    Spring.Utilities.wacky_utils={}
end
if not Spring.Utilities.wacky_utils.mt_union then
    local wacky_utils=Spring.Utilities.wacky_utils

    local function mt_union(a,b)
        setmetatable(a,{__index=b})
        return a
    end
    wacky_utils.mt_union=mt_union

    Spring.Utilities.wacky_utils=wacky_utils
end