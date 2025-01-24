
if Spring==nil then
    Spring={}
end
if Spring.Utilities==nil then
    Spring.Utilities={}
end
if not Spring.Utilities.wacky_utils then
    local wacky_utils={}
end
if not Spring.Utilities.wacky_utils.GetMass then
    local wacky_utils=Spring.Utilities.wacky_utils

    function wacky_utils.GetMass(health, cost)
        return (((cost/2) + (health/8))^0.6)*6.5
    end

    Spring.Utilities.wacky_utils=wacky_utils
end