

local utils=Spring.Utilities.CustomUnits.utils


local GenCUD_mod=GameData.CustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal

local jsondecode=Spring.Utilities.json.decode

local function GenCustomUnitDef(cudTable)
    local cud_mod=GenCUD_mod(cudTable)
    local cud=GenCustomUnitDataFinal(cud_mod)
    return cud
end
---@param cudString string
local function TryGenCustomUnitDefFromJson(cudString)
    if cudString==nil or cudString:len()==0 then
        return false,(cudString==nil and "nil" or "empty")
    end
    local suc,res=pcall (jsondecode, cudString)
    if suc then
        local cudTable= res
        local suc2,res2=pcall(GenCustomUnitDef,cudTable)
        if suc2 then
            local cud=res2
            return true,cud
        else
            return false,"failed to GenCustomUnitDef\n error: " .. res2 .. "\n for string " .. cudString--"failed to GenCustomUnitDef for " .. cudString .. " with error " .. res2
        end
        return false,"failed to jsondecode\n error: " .. res .. "\n for string " .. cudString--"failed to jsondecode string " .. cudString .. " with error " .. res
    end
end

utils.GenCustomUnitDef=GenCustomUnitDef
utils.TryGenCustomUnitDef=TryGenCustomUnitDefFromJson

Spring.Utilities.CustomUnits.utils=utils