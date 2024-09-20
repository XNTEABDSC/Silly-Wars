function widget:GetInfo()
    return {
      name      = "Change Custom Modoptions Info",
      desc      = "Change Custom Modoptions Info",
      author    = "XNTWSAD",
      date      = "",
      license   = "GNU GPL, v2 or later",
      layer     = -math.huge,
      enabled   = true  --  loaded by default?
    }
end


VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

function widget:Initialize()
    utils.update_modoptions()
end