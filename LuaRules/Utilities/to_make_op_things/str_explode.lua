VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.StrExplode then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    
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

    Spring.Utilities.to_make_op_things=to_make_op_things
end