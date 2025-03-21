
---@class ModifyUI 
---@field control table
---@field getValue (fun():any)
---@field setValue (fun(param:any))

---@alias ModifyUIgenfn fun(WG:table,parent:table):ModifyUI

--For modifying. It may be a custom option, or just a modfn
---@class CustomModify
---@field name string name
---@field description string
---@field pic string? picture of it
---@field modfn fun(data:any,param:any):any fn to modify data with param
---@field genUIFn ModifyUIgenfn? fn to gen UI
---@field moddeffn function? fn to gen defs