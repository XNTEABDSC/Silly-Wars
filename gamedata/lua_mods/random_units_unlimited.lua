VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.add_fn_to_fn_list("def_post","random_units_unlimited",function ()
    local lowerkeys=utils.lowerkeys
    local rand_range=2
    local bias=1
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
        return bias*rand_range^(to_get_op_value() )
    end
    GG.to_make_very_op_things.random_units(get_rand_mult)
end)

return {option_notes="RANDOM UNITS VALUES, UNLIMITED! "}