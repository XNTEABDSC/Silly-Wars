if not GG.goodBurstSalvo then
    local goodBurstSalvo={}
    GG.goodBurstSalvo=goodBurstSalvo
    function goodBurstSalvo.newBurstWeapon(salvoCapacity,salvoReloadSecond)
        local o={}
        local count=salvoCapacity
        local reloadingTimeLeft=0
        local active=true
        function o.CanShot()
            return count>0
        end
        function o.DoShot()
            count=count-1
        end
        function o.TryShot()
            if count>0 then
                count=count-1
                return true
            end
            return false
        end
        function o.ReloadThread()
            while active do
                if count<salvoCapacity then
                    if reloadingTimeLeft<0 then
                        reloadingTimeLeft=reloadingTimeLeft+salvoReloadSecond
                        count=count+1
                    end
                    local stunnedOrInbuild = Spring.GetUnitIsStunned(unitID)
		            local reloadMult = (stunnedOrInbuild and 0) or (Spring.GetUnitRulesParam(unitID, "totalReloadSpeedChange") or 1)
                    reloadingTimeLeft=reloadingTimeLeft-reloadMult*0.1
                end
                Sleep(100)
            end
        end
        function o.Deactive()
            active=false
        end
        function o.WaitUntilReady()
            while count<=0 do
                Sleep(100)
            end
        end
        return o
    end
    function goodBurstSalvo.newBurstWeaponFromWD(wd)
        local cp=wd.customParams or wd.customparams
        local salvo=tonumber(cp.script_burst)
        local fullreload=tonumber(cp.script_reload)
        return goodBurstSalvo.newBurstWeapon(salvo,fullreload/salvo)
    end
end
return GG.goodBurstSalvo