VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.GetDimensions then
    local to_make_op_things=Spring.Utilities.to_make_op_things
    VFS.Include("LuaRules/Utilities/wacky_utils/str_explode.lua")
    local str_explode=Spring.Utilities.wacky_utils.str_explode

    function to_make_op_things.GetDimensions(str)
        if not str then
            return nil
        end
        local dimensionsStr = str_explode(" ", str)
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