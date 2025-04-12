for name, ud in pairs(UnitDefs) do
    if ud.customparams.icontypes_this then
        --Spring.Echo("awdcfv: " .. name)
        ud.icontype=name
    end
end