return {
    fake_projectile_targeter={
        name                    = [[Projectile Gun]],
        craterBoost             = 0,
        craterMult              = 0,

        damage                  = {
            default = 1,
            planes  = 1,
        },
        interceptedByShieldType = 1,
        noSelfDamage            = true,
        range                   = 350,
        reloadtime              = 2,
        soundHit                = [[explosion/ex_med5]],
        soundStart              = [[weapon/cannon/cannon_fire5]],
        turret                  = true,
        weaponType              = [[Cannon]],
        weaponVelocity          = 280,
    },
    fake_beam_targeter = {
        name                    = [[Beam Targeter]],
        beamTime                = 1/30,
        craterBoost             = 0,
        craterMult              = 0,
  
        customParams            = {
        },
  
        damage                  = {
          default = 1,
        },
        fireStarter             = 100,
        impactOnly              = true,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        laserFlareSize          = 7.5,
        minIntensity            = 1,
        range                   = 300,
        reloadtime              = 0.3,
        rgbColor                = [[1 1 1]],
        soundStart              = [[weapon/laser/mini_laser]],
        soundStartVolume        = 6,
        thickness               = 5,
        tolerance               = 8192,
        turret                  = true,
        weaponType              = [[BeamLaser]],
      }
}