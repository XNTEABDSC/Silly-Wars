

local utils=Spring.Utilities.CustomUnits.utils


local GenCUD_mod=GameData.CustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal

local jsondecode=Spring.Utilities.json.decode

local function GenCustomUnitDef(cudTable)
    local cud_mod=GenCUD_mod(cudTable)
    local cud=GenCustomUnitDataFinal(cud_mod)
    return cud
end

local function TryGenCustomUnitDefFromJson(cudString)
    local suc,res=pcall (jsondecode, cudString)
    if suc then
        local cudTable= res
        local suc2,res2=pcall(GenCustomUnitDef,cudTable)
        if suc2 then
            local cud=res2
            return true,cud
        else
            return false,"failed to GenCustomUnitDef for " .. cudString .. " with error " .. res2
        end
        return false,"failed to jsondecode string " .. cudString .. " with error " .. res
    end
end

utils.GenCustomUnitDef=GenCustomUnitDef
utils.TryGenCustomUnitDef=TryGenCustomUnitDefFromJson

Spring.Utilities.CustomUnits.utils=utils