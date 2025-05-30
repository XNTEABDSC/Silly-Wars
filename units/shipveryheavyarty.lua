VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("shipheavyarty","shipveryheavyarty",function (ud)
    --ud=utils.may_lower_key_proxy(ud,utils.may_lower_key_proxy_ud_checkkeys)
    ud.name="Big Bertha Shogun"
    ud.description=[[Very Heavy Artillery Battleship (charging salvo)]]
    ud.health=ud.health*2
    ud.metalCost=25000
    ud.customParams.def_scale=1.5
    ud.weaponDefs.PLASMA={
      name                    = [[Very Heavy Plasma Cannon]],
      accuracy                = 500,
      areaOfEffect            = 176,
      avoidFeature            = false,
      cegTag                  = [[vulcanfx]],
      craterBoost             = 0.25,
      craterMult              = 0.5,

      customParams            = {
        gatherradius     = [[240]],
        smoothradius     = [[120]],
        smoothmult       = [[0.5]],
        movestructures   = [[0.25]],
        force_ignore_ground = "1",
        
        light_color = [[2.4 1.5 0.6]],

        
        script_burst=3,
        script_burst_rate=0.2,
        script_reload=8*3,
        use_unit_weapon_charging_salvo="1",
      },
      
      damage                  = {
        default = 2002.4,
      },

      explosionGenerator      = [[custom:lrpc_expl]],
      fireTolerance           = 1820, -- 10 degrees
      impulseBoost            = 0.5,
      impulseFactor           = 0.2,
      interceptedByShieldType = 1,
      noSelfDamage            = true,
      range                   = 5600,
      reloadtime              = 8,
      soundHit                = [[weapon/cannon/lrpc_hit]],
      soundStart              = [[weapon/cannon/big_begrtha_gun_fire]],
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 1050/1.5,
    }
end)