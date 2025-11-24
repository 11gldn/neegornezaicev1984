local MULTIPLIER = 15.0

print("[⚡] Запуск усиленного мода Combat Drone...")

-- Метод 1: Точечный поиск через filtergc
local function preciseCombatDroneMod()
    local foundTables = filtergc("table", {
        Keys = {
            "BASE_DAMAGE_MULTIPLIER",
            "HEADSHOT_DAMAGE_MULTIPLIER", 
            "BOSS_HEADSHOT_DAMAGE_MULTIPLIER",
            "STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER",
            "BaseMultiplier",
            "HeadshotMultiplier",
            "BossHeadshotMultiplier",
            "StrongBossHeadshotMultiplier",
            "DirectControlMagSize",
            "UpgradePathData"
        }
    }, false)

    if foundTables then
        for _, tbl in next, foundTables do
            -- Модифицируем основные множители
            if tbl.BASE_DAMAGE_MULTIPLIER then
                rawset(tbl, "BASE_DAMAGE_MULTIPLIER", MULTIPLIER)
                print("[✓] BASE_DAMAGE_MULTIPLIER = " .. MULTIPLIER)
            end
            if tbl.HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(tbl, "HEADSHOT_DAMAGE_MULTIPLIER", MULTIPLIER)
                print("[✓] HEADSHOT_DAMAGE_MULTIPLIER = " .. MULTIPLIER)
            end
            if tbl.BOSS_HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(tbl, "BOSS_HEADSHOT_DAMAGE_MULTIPLIER", MULTIPLIER)
                print("[✓] BOSS_HEADSHOT_DAMAGE_MULTIPLIER = " .. MULTIPLIER)
            end
            if tbl.STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER then
                rawset(tbl, "STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER", MULTIPLIER)
                print("[✓] STRONG_BOSS_HEADSHOT_DAMAGE_MULTIPLIER = " .. MULTIPLIER)
            end
            
            -- Модифицируем AttackConfigs множители
            if tbl.BaseMultiplier then
                rawset(tbl, "BaseMultiplier", MULTIPLIER)
                print("[✓] BaseMultiplier = " .. MULTIPLIER)
            end
            if tbl.HeadshotMultiplier then
                rawset(tbl, "HeadshotMultiplier", MULTIPLIER)
                print("[✓] HeadshotMultiplier = " .. MULTIPLIER)
            end
            if tbl.BossHeadshotMultiplier then
                rawset(tbl, "BossHeadshotMultiplier", MULTIPLIER)
                print("[✓] BossHeadshotMultiplier = " .. MULTIPLIER)
            end
            if tbl.StrongBossHeadshotMultiplier then
                rawset(tbl, "StrongBossHeadshotMultiplier", MULTIPLIER)
                print("[✓] StrongBossHeadshotMultiplier = " .. MULTIPLIER)
            end
            
            -- Улучшаем другие параметры дрона
            if tbl.DirectControlMagSize then
                rawset(tbl, "DirectControlMagSize", 9999)
                print("[✓] DirectControlMagSize = 9999")
            end
            if tbl.DirectControlReloadTime then
                rawset(tbl, "DirectControlReloadTime", 0)
                print("[✓] DirectControlReloadTime = 0")
            end
        end
        return true
    end
    return false
end

-- Метод 2: Глубокий поиск во вложенных таблицах
local function deepSearchModification()
    local modified = false
    
    for _, obj in pairs(getgc()) do
        if type(obj) == "table" then
            -- Рекурсивно ищем множители во вложенных таблицах
            local function searchRecursive(t, path)
                for k, v in pairs(t) do
                    if type(v) == "table" then
                        searchRecursive(v, path .. "." .. tostring(k))
                    elseif type(k) == "string" and type(v) == "number" then
                        if k:find("Multiplier") and v > 1 and v < 10 then
                            t[k] = MULTIPLIER
                            print("[✓] Найден множитель: " .. path .. "." .. k .. " = " .. MULTIPLIER)
                            modified = true
                        end
                    end
                end
            end
            
            searchRecursive(obj, "root")
        end
    end
    
    return modified
end

-- Метод 3: Перехват функций урона через hookfunction
local function hookDamageFunctions()
    local hooked = 0
    
    for _, func in pairs(getgc()) do
        if type(func) == "function" then
            local info = getinfo(func)
            if info.name and (info.name:lower():find("damage") or info.name:lower():find("multiplier") or info.name:lower():find("calculate")) then
                local original = func
                hookfunction(func, function(...)
                    local result = original(...)
                    -- Если функция возвращает число (возможно урон), умножаем его
                    if type(result) == "number" and result > 1 and result < 1000 then
                        return result * MULTIPLIER
                    end
                    return result
                end)
                hooked = hooked + 1
                print("[✓] Перехвачена функция: " .. (info.name or "unknown"))
            end
        end
    end
    
    return hooked > 0
end

-- Метод 4: Модификация через метатаблицы
local function metaTableModification()
    local success = false
    
    -- Получаем метатаблицы всех таблиц
    for _, obj in pairs(getgc()) do
        if type(obj) == "table" then
            local mt = getrawmetatable(obj)
            if mt then
                -- Перехватываем индексацию чтобы подменить значения
                local oldIndex = mt.__index
                if oldIndex then
                    mt.__index = function(self, key)
                        local value = oldIndex(self, key)
                        if type(key) == "string" and key:find("Multiplier") and type(value) == "number" and value > 1 and value < 10 then
                            return MULTIPLIER
                        end
                        return value
                    end
                    success = true
                end
            end
        end
    end
    
    return success
end

-- Основной процесс модификации
local function applyAllMods()
    print("[⚡] Применяем все методы модификации...")
    
    local results = {
        filtergc = pcall(preciseCombatDroneMod),
        deepSearch = pcall(deepSearchModification),
        hookFunctions = pcall(hookDamageFunctions),
        metaTables = pcall(metaTableModification)
    }
    
    print("[⚡] Результаты:")
    for method, success in pairs(results) do
        print("  " .. method .. ": " .. (success and "✓ УСПЕХ" or "✗ НЕ УДАЛОСЬ"))
    end
    
    return results.filtergc or results.deepSearch or results.hookFunctions or results.metaTables
end

-- Запускаем модификацию
local success = applyAllMods()

if success then
    print("[⚡] Модификации применены! Проверь урон Combat Drone в режиме Direct Control.")
    print("[ℹ] Используй только верхний путь (Path 1) для безопасности")
else
    print("[!] Не удалось применить модификации. Попробуй:")
    print("    1. Перезапустить игру")
    print("    2. Запустить скрипт через 30 секунд после входа")
    print("    3. Использовать приватный сервер")
end

-- Постоянный мониторинг на случай сброса
while task.wait(5) do
    pcall(preciseCombatDroneMod)
end