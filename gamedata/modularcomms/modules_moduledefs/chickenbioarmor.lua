return {
    module_chickenbioarmor={
        name="Bio Armor",

    },
    module_ablative_armor = {
		name = "Ablative Armor Plates",
		description = "Adds 400 HP 6sh",
		func = function(unitDef)
				unitDef.health = unitDef.health + 600
			end,
	},module_autorepair = {
		name = "Autorepair System",
		description = "Self-repairs 10 HP/s",
		func = function(unitDef)
				unitDef.autoheal = (unitDef.autoheal or 0) + 10
			end,
	}
}