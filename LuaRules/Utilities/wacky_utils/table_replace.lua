if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.wacky_utils then
    Spring.Utilities.wacky_utils={}
end
if not Spring.Utilities.wacky_utils.table_replace then
    local wacky_utils=Spring.Utilities.wacky_utils

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

    Spring.Utilities.wacky_utils=wacky_utils
end

return Spring.Utilities.wacky_utils.table_replace