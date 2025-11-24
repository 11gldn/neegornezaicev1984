-- Чистый скрипт только для увеличения урона Combat Drone
local DAMAGE_MULTIPLIER = 15.0

while task.wait(0.5) do
    -- Ищем таблицы Combat Drone по характерным ключам
    local droneTables = filtergc("table", {
        Keys = { 
            "BASE_DAMAGE_MULTIPLIER", "HEADSHOT_DAMAGE_MULTIPLIER",
            "BaseMultiplier", "HeadshotMultiplier", "DirectControlMagSize"
        },
    }, false)

    if droneTables then
        for i, drone in next, droneTables do
            -- Меняем только множители урона
            if drone.BASE_DAMAGE_MULTIPLIER then
                rawset(drone, "BASE_DAMAGE_MULTIPLIER", DAMAGE_MULTIPLIER)
            end
            if drone.HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(drone, "HEADSHOT_DAMAGE_MULTIPLIER", DAMAGE_MULTIPLIER)
            end
            if drone.BOSS_HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(drone, "BOSS_HEADSHOT_DAMAGE_MULTIPLIER", DAMAGE_MULTIPLIER)
            end
            if drone.STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(drone, "STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER", DAMAGE_MULTIPLIER)
            end
            if drone.BaseMultiplier then
                rawset(drone, "BaseMultiplier", DAMAGE_MULTIPLIER)
            end
            if drone.HeadshotMultiplier then
                rawset(drone, "HeadshotMultiplier", DAMAGE_MULTIPLIER)
            end
        end
        print("[✓] Урон Combat Drone увеличен в " .. DAMAGE_MULTIPLIER .. " раз")
    end
end