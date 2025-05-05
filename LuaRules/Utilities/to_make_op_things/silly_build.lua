VFS.Include("LuaRules/Utilities/to_make_op_things/include.lua")
if not Spring.Utilities.to_make_op_things.MakeAddSillyBuildValueWithOrder then
    local to_make_op_things=Spring.Utilities.to_make_op_things

    --VFS.Include("LuaRules/Utilities/to_make_op_things/tweak_fns.lua")
    VFS.Include("LuaRules/Utilities/to_make_op_things/set_morph.lua")
    local utils=Spring.Utilities.wacky_utils

    local SetMorphMut=to_make_op_things.SetMorphMut
    local AddFnToUnitDefsTweakFns=utils.AddFnToUnitDefsTweakFns

    local maxBuildPer=18
    local silly_build_units={
        {name="sillycon",range={0,2000}},
        {name="sillyconvery",range={2000,10000}},
        {name="sillyconveryvery",range={10000,100000}}
    }

    local function Init()
        for key, value in pairs(silly_build_units) do
            value.builderCount=1
            local ud=UnitDefs[value.name]
            if not ud then
                Spring.Echo("unit " .. value.name .. "don't exist")
            end
            value.currentUD=ud
            value.currentName=value.name
            value.HumanName=ud.name
            value.HumanDesc=ud.description
            ud.buildoptions=ud.buildoptions or {}
            ud.name=ud.name .. " Vol.1"
            ud.description=ud.description .. ", Vol.1"
        end
    end

    local function NextBuilder(sillyConsInfo)
        sillyConsInfo.builderCount=sillyConsInfo.builderCount+1
        local oldname=sillyConsInfo.currentName

        local newname=sillyConsInfo.name .. sillyConsInfo.builderCount
        local copyUD=Spring.Utilities.CopyTable(sillyConsInfo.currentUD,true)
        copyUD.name=sillyConsInfo.HumanName .. " Vol." .. sillyConsInfo.builderCount
        copyUD.description=sillyConsInfo.HumanDesc .. ", Vol." .. sillyConsInfo.builderCount
        copyUD.buildoptions={}

        SetMorphMut(sillyConsInfo.currentName,newname,1)

        UnitDefs[newname]=copyUD
        sillyConsInfo.currentUD=copyUD
        sillyConsInfo.currentName=newname
    end

    local function AddSillyBuild(unitname,sillyOption)
        local ud=UnitDefs[unitname]
        local metalcost=ud.metalcost
        local sillyConsInfo
        for i = 1, #silly_build_units do
            sillyConsInfo=silly_build_units[i]
            if sillyOption then
                if sillyConsInfo.name==sillyOption then
                    break
                end
            else
                if sillyConsInfo.range[1]<=metalcost and metalcost<= sillyConsInfo.range[2] then
                    break
                end
            end
            
        end
        if not sillyConsInfo.currentUD then
            Spring.Echo("????? empry currentUD info: " .. sillyConsInfo.name)
        end
        if #sillyConsInfo.currentUD.buildoptions>=maxBuildPer then
            NextBuilder(sillyConsInfo)
        end
        sillyConsInfo.currentUD.buildoptions[#sillyConsInfo.currentUD.buildoptions+1]=unitname
    end
    
    local function End()
        for key, value in pairs(silly_build_units) do
            local lastudname=value.currentName
            local firstudname=value.name
            if firstudname~=lastudname then
                SetMorphMut(lastudname,firstudname,1)
                UnitDefs[lastudname].description=UnitDefs[lastudname].description .. ", can morph to switch build options"
            end
        end
    end

    local function MakeAddSillyBuildValueWithOrder(unitname,con)
        return{
            k="add_silly_build(" .. unitname .. ")",
            b={"default_add_silly_build_begin"},
            a={"default_add_silly_build_end"},
            v=function ()
                AddSillyBuild(unitname,con)
            end
        }
    end
    AddFnToUnitDefsTweakFns({
        k="default_add_silly_build_begin",
        v=function ()
            Init()
        end,
        b={"default_add_build_begin"}
    })
    AddFnToUnitDefsTweakFns({
        k="default_add_silly_build_end",
        v=function ()
            End()
        end,
        b={"default_add_silly_build_begin"},
        a={"default_add_build_end"}
    })
    to_make_op_things.MakeAddSillyBuildValueWithOrder=MakeAddSillyBuildValueWithOrder
    
    Spring.Utilities.to_make_op_things=to_make_op_things
end