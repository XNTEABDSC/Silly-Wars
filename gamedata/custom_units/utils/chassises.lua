
if not GameData.CustomUnits.chassis_defs then
    ---Definition of a chassis, all in GameData.CustomUnits.chassis_defs
    ---@class CustomChassisData
    ---@field speed_base number speed of the unitDef
    ---@field weapon_slots list<list<string>> {[weapon_slot_num]:list<targeter_name>} for each weapon_slot, what targeter can be used
    ---@field genUnitDefs function
    ---@field genfn fun(params:any):CustomUnitDataModify
    ---@field name string
    ---@field targeter_name_to_unit_weapon {[string]:integer}
    ---@field pic string
    ---@field modifies CustomModify
    ---@field genUIFn ModifyUIgenfn
    ---@field description string
    ---@field humanName string

    ---@type table<string,CustomChassisData>
    local chassis_defs={}
    local luaFiles=VFS.DirList("gamedata/custom_units/chassises", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        chassis_defs[result.name]=result
    end
    GameData.CustomUnits.chassis_defs=chassis_defs
end