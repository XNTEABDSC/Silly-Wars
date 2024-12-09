return "commweapon_chickenspike",{
    name                    = [[Spike]],
    areaOfEffect            = 16,
    avoidFeature            = true,
    avoidFriendly           = true,
    burnblow                = true,
    cegTag                  = [[small_green_goo]],
    collideFeature          = true,
    collideFriendly         = true,
    craterBoost             = 0,
    craterMult              = 0,
    
    customParams            = {
		is_unit_weapon = 1,
      light_radius = 0,
    },
    
    damage                  = {
      default = 180,
      planes  = 180,
    },

    explosionGenerator      = [[custom:EMG_HIT]],
    impactOnly              = true,
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 2,
    model                   = [[spike.s3o]],
    range                   = 460,
    reloadtime              = 2,
    soundHit                = [[chickens/spike_hit]],
    soundStart              = [[chickens/spike_fire]],
    startVelocity           = 320,
    subMissile              = 1,
    turret                  = true,
    waterWeapon             = true,
    weaponAcceleration      = 100,
    weaponType              = [[Cannon]],
    weaponVelocity          = 280,
  }