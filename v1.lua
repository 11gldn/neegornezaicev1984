local DAMAGE_MULTIPLIER = 15.0

while task.wait(0.37) do
    local weapon = filtergc("table", {
        Keys = { "ReloadTime", "ShotsRemaining", "AttackConfig" },
    }, false)

    if weapon then
        for i,v in next, weapon do
            -- Оригинальные улучшения (которые работают)
            rawset(v, "ReloadTime", 0)
            rawset(v, "DefaultShotInterval", 0)
            rawset(v, "SplashRadius", 50)
            rawset(v, "DefaultSpreadDegrees", 0)
            rawset(v.AttackConfig.RecoilConfig, "CamKickMin", Vector3.zero)
            rawset(v.AttackConfig.RecoilConfig, "CamKickMax", Vector3.zero)
            if v.ProjectileConfig and (v.ProjectileConfig ~= nil or v.ProjectileConfig ~= false)  then
                rawset(v.ProjectileConfig, "Velocity", 0xFFFFFFFFFF)
                rawset(v.ProjectileConfig, "FlyForwardsOverrideVelocity", 0xFFFFFFFFFF)
                rawset(v.ProjectileConfig, "MinimumTimeToHit", 0)
            end
            
            -- ПРОСТО ДОБАВЛЯЕМ ЭТИ СТРОКИ ДЛЯ УРОНА:
            if v.BaseMultiplier then
                rawset(v, "BaseMultiplier", DAMAGE_MULTIPLIER)
            end
            if v.HeadshotMultiplier then
                rawset(v, "HeadshotMultiplier", DAMAGE_MULTIPLIER) 
            end
            if v.BossHeadshotMultiplier then
                rawset(v, "BossHeadshotMultiplier", DAMAGE_MULTIPLIER)
            end
            if v.StrongBossHeadshotMultiplier then
                rawset(v, "StrongBossHeadshotMultiplier", DAMAGE_MULTIPLIER)
            end
        end
    end
end