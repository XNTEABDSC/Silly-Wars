
local spGiveOrderToUnit=Spring.GiveOrderToUnit
local CMD_INSERT=CMD.INSERT
function Spring.Utilities.InsertOrderToUnit(unitId,PosOrTag,Pos_Tag,CmdId,params,option)

    local insertparams={Pos_Tag,CmdId,option}
    ---@type any
    local insertOption=0

    for index, value in ipairs(params) do
        insertparams[index+3]=value
    end
    
    if PosOrTag then
        insertOption={"alt"}
    end
    spGiveOrderToUnit(
        unitId,
        CMD_INSERT,
        insertparams,
        insertOption
    );
end