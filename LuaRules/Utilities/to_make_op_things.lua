---@class list<t> : {[integer]:t}
if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end

if not Spring.Utilities.to_make_op_things then
    VFS.Include("LuaRules/Utilities/tablefunctions.lua")
    VFS.Include("LuaRules/Utilities/wacky_utils.lua")
    local wacky_utils=Spring.Utilities.wacky_utils
    VFS.Include("LuaRules/Utilities/ordered_list.lua")

    if not Spring.Utilities.json then
        Spring.Utilities.json= VFS.Include("LuaRules/Utilities/json.lua")
    end
    local to_make_op_things={}
    Spring.Utilities.to_make_op_things=to_make_op_things

    --[=[
    local function MakeAddBuildFrontValueWithOrder(builer,buildee)
        return{
            k="add_build(" .. builer .. ", " .. buildee .. ")",
            b={"default_add_build_begin"},
            a={"default_add_build_end"},
            v=function ()
                if not UnitDefs[builer] then
                    error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
                end
                if not UnitDefs[buildee] then
                    Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
                end
                if not UnitDefs[builer].buildoptions then
                    UnitDefs[builer].buildoptions={}
                end
                --Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
                table.insert(UnitDefs[builer].buildoptions,1,buildee)
                --UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
            end
        }
    end

    to_make_op_things.MakeAddBuildFrontValueWithOrder=MakeAddBuildFrontValueWithOrder
    ]=]

    ---set unit to dontcount, and no wreck
    function to_make_op_things.set_free_unit(ud)
        ud.corpse=nil
        --ud.buildTime=ud.metalCost
        --ud.metalCost=0
        --ud.name = prename .. ud.name
        --ud.explodeAs=[[NOWEAPON]]
        --ud.selfDestructAs=[[NOWEAPON]]
        ud.customParams.dontcount = [[1]]
        ud.featureDefs=nil
        ud.reclaimable=false
    end

    function to_make_op_things.set_ded(ud,ded)
        ud.explodeAs              = ded
        ud.selfDestructAs=ded
    end

    function to_make_op_things.set_ded_BIG_UNIT(ud)
        ud.explodeAs              = [[BIG_UNIT]]
        ud.selfDestructAs=[[BIG_UNIT]]
    end
    
    function to_make_op_things.set_ded_ATOMIC_BLAST(ud)
        ud.explodeAs              = [[ATOMIC_BLAST]]
        ud.selfDestructAs=[[ATOMIC_BLAST]]
    end
    ---set number to be a multiples of 1/30, needed for reloadtime
    

    


    

    

    --[=[
    function to_make_op_things.string_a_b(str)
        local l,r=string.find(str,"_")
        if l then
            return string.sub(str,1,l-1),string.sub(str,r+1)
        else
            return nil
        end
    end]=]

    
    do
        
    end
    to_make_op_things.units_basic_factories={
        [[factorycloak]],
        [[factoryshield]],
        [[factoryveh]],
        [[factoryhover]],
        [[factorygunship]],
        [[factoryplane]],
        [[factoryspider]],
        [[factoryjump]],
        [[factorytank]],
        [[factoryamph]],
        [[factoryship]],
    }
    to_make_op_things.units_basic_cons={
        "cloakcon",
        "shieldcon",
        "vehcon",
        "hovercon",
        "gunshipcon",
        "planecon",
        "spidercon",
        "jumpcon",
        "tankcon",
        "amphcon",
        "shipcon",
    }
    to_make_op_things.noweapon_weapon={
        name="NOWEAPON"
    }
end

local luaFiles=VFS.DirList("LuaRules/Utilities/to_make_op_things", "*.lua") or {}
for i = 1, #luaFiles do
    VFS.Include(luaFiles[i])
end


return Spring.Utilities.to_make_op_things