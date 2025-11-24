local DAMAGE_MULTIPLIER = 0.1  -- Ваш множитель
local MAG_SIZE = 9999
local SPLASH_RADIUS = 1

while task.wait(0.5) do
    local targets = filtergc("table", {
        Keys = { "BaseMultiplier", "HeadshotMultiplier", "BossHeadshotMultiplier", "StrongBossHeadshotMultiplier", "Damage", "SplashRadius", "MagSize", "DirectControlMagSize" },
    }, false)

    if targets then
        for i, v in next, targets do
            -- Множители урона (самая важная часть)
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
            
            -- Прямое увеличение урона способностей
            if v.Damage then
                rawset(v, "Damage", v.Damage * DAMAGE_MULTIPLIER)
            end
            
            -- Другие полезные параметры
            if v.SplashRadius then
                rawset(v, "SplashRadius", SPLASH_RADIUS)
            end
            if v.MagSize then
                rawset(v, "MagSize", MAG_SIZE)
            end
            if v.DirectControlMagSize then
                rawset(v, "DirectControlMagSize", MAG_SIZE)
            end
        end
    end
end
