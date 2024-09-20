VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
--[=[
local function make_drunk(wd)
    if wd.range then
        if not wd.sprayangle then
            wd.sprayangle = 4000 - wd.range
        else
            wd.sprayangle = wd.sprayangle + 4000 - wd.range
        end
    end
    if not wd.burst then
        wd.burst = 10
    else
        wd.burst = wd.burst * 10
    end
    if wd.reloadtime then
        wd.reloadtime = wd.reloadtime * 2
    end
    if wd.areaOfEffect then
        wd.areaOfEffect = wd.areaOfEffect * 0.1
    end
end
return utils.copy_tweak("jumparty","jumpartydrunk",function (ud)
    make_drunk(ud.weaponDefs.NAPALM_SPRAYER)
    ud.name="Drunk" .. ud.name
    ud.description="Drunk" .. ud.description
    ud.metalCost=ud.metalCost*5
    ud.health=ud.health*5
    ud.customParams.def_scale=2
end)
]=]

utils.set_morth_mul("silly_morth","jumparty","jumpartydrunk")
utils.add_build("silly_build","bigsillycon","jumpartydrunk")
return utils.copy_tweak("jumparty","jumpartydrunk",function (ud)
    GG.to_make_very_op_things.make_unit_drunk(ud)
    utils.set_ded_ATOMIC_BLAST(ud)
    --ud.health=ud.health*0.6
end)