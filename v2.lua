local DAMAGE_MULTIPLIER = 15.0

while task.wait(0.37) do
    local weapon = filtergc("table", {
        Keys = { "ReloadTime", "ShotsRemaining", "AttackConfig" },
    }, false)

    if weapon then
        for i,v in next, weapon do
            -- Оригинальные улучшения
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
            
            -- ДОБАВЛЯЕМ УРОН В AttackConfig:
            if v.AttackConfig then
                if v.AttackConfig.BaseMultiplier then
                    rawset(v.AttackConfig, "BaseMultiplier", DAMAGE_MULTIPLIER)
                end
                if v.AttackConfig.HeadshotMultiplier then
                    rawset(v.AttackConfig, "HeadshotMultiplier", DAMAGE_MULTIPLIER)
                end
            end
        end
    end
end