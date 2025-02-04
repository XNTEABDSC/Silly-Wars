
---@class ModifyUI 
---@field control any
---@field getValue (fun():any)
---@field setValue (fun(param:any))

---@alias ModifyUIGenFn fun(WG:table,parent:table):ModifyUI

---@class CustomModify
---@field name string name
---@field description string
---@field pic string picture of it
---@field modfn fun(data:any,param:any):any
---@field genUIFn ModifyUIGenFn
---@field paramType string