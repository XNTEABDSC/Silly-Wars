

local utils=Spring.Utilities.CustomUnits.utils


local GenCUD_mod=GameData.CustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal

local jsondecode=Spring.Utilities.json.decode

---@return CustomUnitDataFinal
local function GenCustomUnitDef(cudTable)
    local cud_mod=GenCUD_mod(cudTable)
    local cud=GenCustomUnitDataFinal(cud_mod)
    return cud
end

---@param cudString string
local function TryGenCustomUnitDefFromJson(cudString)
    if cudString==nil or cudString:len()==0 then
        return false,(cudString==nil and "is nil" or "is empty")
    end
    local suc,res=pcall (jsondecode, cudString)
    if suc then
        local cudTable= res
        local suc2,res2=pcall(GenCustomUnitDef,cudTable)
        if suc2 then
            ---@cast res2 CustomUnitDataFinal
            local cud=res2
            return true,cud
        else
            
            ---@cast res2 +string 
            ---@cast res2 -CustomUnitDataFinal
            
            local realerrmsg=string.match(res2,"%[.-%]:%d-:(.*)")

            return false,"failed to GenCustomUnitDef\n \n"..
            "error: " .. tostring(realerrmsg or res2) .. "\n \n" ..
            "for string " .. cudString .. "\n\n" ..
            "detail: " .. res2--"failed to GenCustomUnitDef for " .. cudString .. " with error " .. res2
        end
        return false,"failed to jsondecode\n\n error: " .. res .. "\n\n for string " .. cudString--"failed to jsondecode string " .. cudString .. " with error " .. res
    end
end

utils.GenCustomUnitDef=GenCustomUnitDef
utils.TryGenCustomUnitDef=TryGenCustomUnitDefFromJson

Spring.Utilities.CustomUnits.utils=utils