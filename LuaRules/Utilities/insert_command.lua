
local spGiveOrderToUnit=Spring.GiveOrderToUnit
local CMD_INSERT=CMD.INSERT
local CMD_OPT_ALT=CMD.OPT_ALT
function Spring.Utilities.InsertOrderToUnit(unitId,PosOrTag,Pos_Tag,cmdID,cmdParam,cmdOpts)

    local insertparams={Pos_Tag,cmdID,cmdOpts}
    ---@type any
    local insertOption=0

    for index, value in ipairs(cmdParam) do
        insertparams[index+3]=value
    end
    
    if PosOrTag then
        insertOption=CMD_OPT_ALT
    end
    spGiveOrderToUnit(
        unitId,
        CMD_INSERT,
        insertparams,
        insertOption
    );
end