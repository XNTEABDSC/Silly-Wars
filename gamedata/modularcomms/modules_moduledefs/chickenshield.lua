return {module_chickenshield = {
  name = "Chicken Shield",
  order = 5,
  description = "Generates a small bubble shield",
  func = function(unitDef)
      if unitDef.customparams.dynamic_comm then
        DynamicApplyWeapon(unitDef, "commweapon_chickenshield", #unitDef.weapons + 1)
      else
        ApplyWeapon(unitDef, "commweapon_chickenshield", 4)
      end
    end,
},}