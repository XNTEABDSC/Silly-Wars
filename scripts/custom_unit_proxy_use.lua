
local udcp=UnitDef.customParams

--[=[
local spEcho=Spring.Echo

local us=Spring.UnitScript

local aenv={}
setmetatable(aenv,{
    __index=function (t,k)
        local v=__G[k]
        if not v then
            v=us[k]
        end
        return v
    end,
    __newindex=function (t,k,v)
        __G[k]=v
    end
})
--setmetatable(__G,{__index=us})

Spring.Echo("DEBUG: custom_unit_proxy_use: Check StartThread: " .. tostring(StartThread) .. ", __G.StartThread: " .. tostring(__G.StartThread))
]=]
--[==[
local fn=VFS.Include("scripts/custom_unit_proxy.lua")


local CustomUnitProxyUsingScript,defPiece,defPieceAimFromWeapon,defPieceQueryWeapon=
udcp.custom_unit_proxy_use_script,udcp.custom_unit_proxy_use_def_piece,udcp.custom_unit_proxy_use_def_piece_aim_from_weapon,
udcp.custom_unit_proxy_use_def_piece_query_weapon

fn(CustomUnitProxyUsingScript,defPiece,defPieceAimFromWeapon,defPieceQueryWeapon)
]==]
CustomUnitProxyUsingScript,DefPiece,DefPieceAimFromWeapon,DefPieceQueryWeapon=
udcp.custom_unit_proxy_use_script,udcp.custom_unit_proxy_use_def_piece,udcp.custom_unit_proxy_use_def_piece_aim_from_weapon,
udcp.custom_unit_proxy_use_def_piece_query_weapon
--[=[
local __G0=getfenv(0)
local __G=getfenv()
local __G1=getfenv(1)
Spring.Echo("DEBUG: 0" .. tostring(__G0) .. tostring(__G) .. tostring(__G1))
Spring.Echo("DEBUG: a" .. tostring( unitID ))
Spring.Echo("DEBUG: b" .. tostring( __G0.unitID ))
Spring.Echo("DEBUG: c" .. tostring( __G1.unitID ))
Spring.Echo("DEBUG: d" .. tostring( _G.unitID ))
Spring.Echo("DEBUG: e" .. "???????")
]=]
VFS.Include("scripts/custom_unit_proxy.lua",_G)