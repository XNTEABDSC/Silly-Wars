local to_make_op_things=Spring.Utilities.to_make_op_things
function to_make_op_things.set_morph(domain,srcname,copyedname,morphtime)
    to_make_op_things.add_fn_to_fn_list(domain,
        "set_morph(" .. srcname .. ", " .. copyedname .. ")",
        function ()
            if not UnitDefs[srcname] then
                error("unit " .. srcname .. "do not exist")
            end
            morphtime=morphtime or 10
            UnitDefs[srcname].customparams.morphto=copyedname
            UnitDefs[srcname].customparams.morphtime=morphtime
            UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morph into " .. copyedname
        end
    )
end
function to_make_op_things.set_morph_mul(domain,srcname,copyedname,morphtime,morphprice)
    to_make_op_things.add_fn_to_fn_list(domain,
        "set_morph_mul(" .. srcname .. ", " .. copyedname .. ")"
        ,function ()
            if not UnitDefs[srcname] then
                error("unit " .. srcname .. "do not exist")
            end
            morphprice=morphprice or UnitDefs[copyedname].metalcost-UnitDefs[srcname].metalcost
            local ud_cp=UnitDefs[srcname].customparams
            local i=1
            morphtime=morphtime or 10
            while true do
                if not ud_cp["morphto_" .. i] then
                    ud_cp["morphto_" .. i]=copyedname
                    ud_cp["morphtime_" .. i]=morphtime
                    ud_cp["morphcost_" .. i]=morphprice
                    break
                end
                i=i+1
            end
            UnitDefs[srcname].description=UnitDefs[srcname].description .. "  Can morph into " .. copyedname
        end)
end

function to_make_op_things.add_build(domain,builer,buildee)
    to_make_op_things.add_fn_to_fn_list(domain,
        "add_build(" .. builer .. ", " .. buildee .. ")",
        function ()
            if not UnitDefs[builer] then
                error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
            end
            if not UnitDefs[buildee] then
                Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
            end
            if not UnitDefs[builer].buildoptions then
                UnitDefs[builer].buildoptions={}
            end
            Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
            UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=buildee
        end)
end

function to_make_op_things.add_build_front(domain,builer,buildee)
    to_make_op_things.add_fn_to_fn_list(domain,
        "add_build(" .. builer .. ", " .. buildee .. ")",
        function ()
            if not UnitDefs[builer] then
                error("add_build(" .. builer .. ", " .. buildee .. "): unit " .. builer .. " do not exist")
            end
            if not UnitDefs[buildee] then
                Spring.Echo("warning: ".. "add_build(" .. builer .. ", " .. buildee .. "): unit " .. buildee .. "do not exist")
            end
            if not UnitDefs[builer].buildoptions then
                UnitDefs[builer].buildoptions={}
            end
            Spring.Echo("add_build(" .. builer .. ", " .. buildee .. ")")
            table.insert(UnitDefs[builer].buildoptions,1,buildee)
            --UnitDefs[builer].buildoptions[#UnitDefs[builer].buildoptions+1]=building
        end)
end