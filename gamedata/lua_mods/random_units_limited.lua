VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

return {
    random_units_limited = {
        fn = function(params)
            params=params or {}
            local Variance = params.Variance or 4
            local Bias = params.Bias or 1

            utils_op.AddFnToUnitDefsTweakFnsMut({
                k = "random_units_limited",
                b = { "default_modify_value_begin" },
                a = { "default_modify_value_end" },
                v = function()
                    local lowerkeys = utils.lowerkeys
                    local function sinrand()
                        return math.sin((math.random() * 2 - 1) * math.pi / 2)
                    end
                    local function cbrtrand()
                        return (math.random() * 2 - 1) ^ (1 / 3)
                    end
                    local to_get_op_value = sinrand
                    -- holy math.tan(  * math.pi/2) /(math.pi/2)
                    local function get_rand_mult()
                        return Bias * Variance ^ (to_get_op_value())
                    end
                    Spring.Utilities.to_make_very_op_things.random_units(get_rand_mult)
                end
            })


            return { option_notes = "Random Units Values! " }
        end
    },
    random_units_unlimited=function (params)
        params=params or {}
        local Variance = params.Variance or 2
        local Bias = params.Bias or 1

        utils_op.AddFnToUnitDefsTweakFnsMut({
            k="random_units_unlimited",
            b={"default_modify_value_begin"},
            a={"default_modify_value_end"},
            v=function ()
                local function atanh(x)
                    return 1/2*math.log ((1+x)/(1-x))
                end
                local function atanhrand()
                    return atanh((math.random()*2-1))
                end
                local function atanrand() -- too op
                    return math.tan( (math.random()*2-1) * math.pi/2) /(math.pi/2)
                end
                local function normalrandom()
                    local u1 = math.random()
                    local u2 = math.random()
                    local z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
                    return z
                end
                local to_get_op_value=normalrandom
                local function get_rand_mult()
                    return Bias*Variance^(to_get_op_value() )
                end
                Spring.Utilities.to_make_very_op_things.random_units(get_rand_mult)
            end
        })



        return {option_notes="RANDOM UNITS VALUES, UNLIMITED! "}
    end
}
