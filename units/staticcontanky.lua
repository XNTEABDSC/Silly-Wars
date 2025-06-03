VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("staticcon","staticcontanky",utils.table_replace({
    name                          = [[Tanky Caretaker]],
    description                   = [[Tanky Construction Assistant]],
    health=2000,
    metalCost=250,
    explodeAs                     = [[NOWEAPON]],
    selfDestructAs=[[NOWEAPON]],
    buildoptions={
        [[staticradar]],
        [[staticheavyradar]],
        [[staticshield]],
        [[staticjammer]],
        [[turretmissile]],
        [[turretlaser]],
        [[turretimpulse]],
        [[turretemp]],
        [[turretriot]],
        [[turretheavylaser]],
        [[turretgauss]],
        [[turretantiheavy]],
        [[turretheavy]],
        [[turrettorp]],
        [[turretaalaser]],
        [[turretaaclose]],
        [[turretaafar]],
        [[turretaaflak]],
        [[turretaaheavy]],
        [[staticantinuke]],
        [[staticarty]],
        [[staticheavyarty]],
        [[staticmissilesilo]],
        [[staticcontanky]],
        [[energypylon]],
        [[staticmex]],
        [[energysolar]],
        [[energyfusion]],
        [[tankcon]],

    },
    customParams={
        integral_menu_be_in_tab=
        [==[
        {
            tab="ECON",
            pos={order = 9, row = 3, col = 3}
        }
        ]==],
        translations=[=[
        {
            en={
                name="Tanky Caretaker",
                description="Tanky Construction Assistant",
                helptext="Tanky Caretaker has good hp and blueprints of everything you need to proc",
            }
        }
        ]=]
    }
}))