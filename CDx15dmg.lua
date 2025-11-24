local MULTIPLIER = 15.0

-- Метод 1: Перехват системы патронов
local function hookAmmoSystem()
    local ammoTables = filtergc("table", {
        Keys = {"ShotsRemaining", "MagSize", "CurrentAmmo", "AmmoCount"}
    }, false)
    
    if ammoTables then
        for _, tbl in next, ammoTables do
            -- Подменяем значения патронов ДО отправки на сервер
            if tbl.ShotsRemaining then
                local original = tbl.ShotsRemaining
                rawset(tbl, "ShotsRemaining", function(...)
                    local result = original(...)
                    -- Всегда возвращаем полный боезапас
                    return 9999
                end)
            end
        end
        return true
    end
    return false
end

-- Метод 2: Модификация через AbilityData
local function modifyAbilityData()
    while task.wait(1) do
        local abilities = filtergc("table", {
            Keys = {"AbilityType", "MaxCharges", "CurrentCharges", "UseCost"}
        }, false)
        
        if abilities then
            for _, ability in next, abilities do
                -- Для Pave Missile и других способностей
                if ability.MaxCharges then
                    rawset(ability, "MaxCharges", 999)
                end
                if ability.CurrentCharges then
                    rawset(ability, "CurrentCharges", 999)
                end
                if ability.UseCost then
                    rawset(ability, "UseCost", 0)
                end
            end
        end
    end
end

-- Метод 3: Перехват через RemoteEvents (более агрессивный)
local function interceptNetworkEvents()
    local remotes = {
        "WeaponFire", "AbilityUse", "ProjectileCreate", "DamageEvent"
    }
    
    for _, remoteName in pairs(remotes) do
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName)
            if remote and remote:IsA("RemoteEvent") then
                local original = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    -- Модифицируем данные перед отправкой
                    if type(args[1]) == "table" then
                        if args[1].ammo then args[1].ammo = 999 end
                        if args[1].charges then args[1].charges = 999 end
                    end
                    return original(self, unpack(args))
                end
            end
        end)
    end
end

-- Запускаем все методы
coroutine.wrap(hookAmmoSystem)()
coroutine.wrap(modifyAbilityData)()
coroutine.wrap(interceptNetworkEvents)()

print("[⚡] Запущен обход системы патронов")
