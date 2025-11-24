while task.wait(0.5) do
    -- Ищем таблицы Combat Drone по характерным ключам
    local droneTables = filtergc("table", {
        Keys = { 
            "DirectControlMagSize", "DirectControlReloadTime", "MovementSpeed",
            "ReloadTime", "Range", "Damage", "ProjectileConfig", "AttackConfig",
            "FirstPersonConfig", "UpgradePathData", "HelicopterMovement"
        },
    }, false)

    if droneTables then
        for i, drone in next, droneTables do
            -- Улучшаем параметры Direct Control
            if drone.DirectControlMagSize then
                rawset(drone, "DirectControlMagSize", 9999)
            end
            
            if drone.DirectControlReloadTime then
                rawset(drone, "DirectControlReloadTime", 0)
            end
            
            -- Улучшаем мобильность дрона
            if drone.MovementSpeed then
                rawset(drone, "MovementSpeed", 50)
            end
            
            if drone.ReloadTime then
                rawset(drone, "ReloadTime", 0)
            end
            
            if drone.Range then
                rawset(drone, "Range", 999)
            end
            
            -- Улучшаем снаряды
            if drone.ProjectileConfig then
                rawset(drone.ProjectileConfig, "Velocity", 5000)
                rawset(drone.ProjectileConfig, "Gravity", 0)
                rawset(drone.ProjectileConfig, "Lifetime", 10)
            end
            
            -- Улучшаем конфиг атаки
            if drone.AttackConfig then
                if drone.AttackConfig.RecoilConfig then
                    rawset(drone.AttackConfig.RecoilConfig, "CamKickMin", Vector3.zero)
                    rawset(drone.AttackConfig.RecoilConfig, "CamKickMax", Vector3.zero)
                end
                rawset(drone.AttackConfig, "FireRate", 0.01)
                rawset(drone.AttackConfig, "DefaultSpreadDegrees", 0)
            end
            
            -- Модифицируем FirstPersonConfig (Direct Control)
            if drone.FirstPersonConfig then
                if drone.FirstPersonConfig.AttackConfigs then
                    for _, attackConfig in ipairs(drone.FirstPersonConfig.AttackConfigs) do
                        rawset(attackConfig, "ShotInterval", 0.01)
                        rawset(attackConfig, "ReloadTime", 0)
                        rawset(attackConfig, "DefaultSpreadDegrees", 0)
                        if attackConfig.RecoilConfig then
                            rawset(attackConfig.RecoilConfig, "CamKickMin", Vector3.zero)
                            rawset(attackConfig.RecoilConfig, "CamKickMax", Vector3.zero)
                        end
                    end
                end
                
                -- Улучшаем движение в First Person
                if drone.FirstPersonConfig.MovementConfig then
                    rawset(drone.FirstPersonConfig.MovementConfig, "VerticalMovementSpeed", 20)
                    rawset(drone.FirstPersonConfig.MovementConfig, "LevelStatsMovementSpeedMultiplier", 5)
                end
            end
            
            -- Улучшаем параметры вертолетного движения
            if drone.HelicopterMovement then
                -- Добавляем любые улучшения для вертолетного движения
            end
        end
        print("[✓] Параметры Combat Drone улучшены!")
    end
    
    -- Дополнительно ищем оружие дрона
    local weapons = filtergc("table", {
        Keys = { "ReloadTime", "ShotsRemaining", "AttackConfig", "WeaponName" },
    }, false)

    if weapons then
        for i, weapon in next, weapons do
            -- Проверяем, что это оружие дрона (AR, GUN, MG, RCKT, BOMB, MSL, PAVE)
            local droneWeapons = {"AR", "GUN", "MG", "RCKT", "BOMB", "MSL", "PAVE"}
            if weapon.WeaponName and table.find(droneWeapons, weapon.WeaponName) then
                rawset(weapon, "ReloadTime", 0)
                rawset(weapon, "DefaultShotInterval", 0.01)
                rawset(weapon, "SplashRadius", 50)
                rawset(weapon, "DefaultSpreadDegrees", 0)
                
                if weapon.AttackConfig and weapon.AttackConfig.RecoilConfig then
                    rawset(weapon.AttackConfig.RecoilConfig, "CamKickMin", Vector3.zero)
                    rawset(weapon.AttackConfig.RecoilConfig, "CamKickMax", Vector3.zero)
                end
                
                if weapon.ProjectileConfig then
                    rawset(weapon.ProjectileConfig, "Velocity", 5000)
                    rawset(weapon.ProjectileConfig, "FlyForwardsOverrideVelocity", 5000)
                    rawset(weapon.ProjectileConfig, "MinimumTimeToHit", 0)
                end
                
                print("[✓] Улучшено оружие: " .. weapon.WeaponName)
            end
        end
    end
end