local MULTIPLIER = 15.0
print("[⚡] Запуск активного мода Combat Drone...")

-- Поиск активных инстансов Combat Drone в игре
local function findAndModifyActiveDrones()
    local modified = false
    
    -- Ищем в workspace все объекты, которые могут быть дронами
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("combat") or obj.Name:lower():find("drone") or obj.Name:lower():find("turret")) then
            -- Это может быть дрон, ищем контроллеры и скрипты
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    pcall(function()
                        -- Получаем среду выполнения скрипта
                        local env = getfenv(child)
                        if env and type(env) == "table" then
                            -- Ищем множители урона в среде скрипта
                            for key, value in pairs(env) do
                                if type(value) == "number" and (key:find("Multiplier") or key:find("Damage")) then
                                    env[key] = MULTIPLIER
                                    print("[✓] Изменен " .. key .. " в активном дроне: " .. obj.Name)
                                    modified = true
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    
    return modified
end

-- Поиск и модификация TowerController'ов
local function modifyTowerControllers()
    local modified = false
    
    -- Ищем TowerController в памяти
    local controllers = filtergc("table", {
        Keys = {"TowerType", "Damage", "HeadshotMultiplier"}
    }, false)
    
    if controllers then
        for _, controller in next, controllers do
            if controller.TowerType and (string.find(tostring(controller.TowerType), "Combat") or string.find(tostring(controller.TowerType), "Drone")) then
                if controller.Damage then
                    rawset(controller, "Damage", controller.Damage * MULTIPLIER)
                    print("[✓] Увеличен урон TowerController")
                    modified = true
                end
                if controller.HeadshotMultiplier then
                    rawset(controller, "HeadshotMultiplier", MULTIPLIER)
                    print("[✓] Увеличен HeadshotMultiplier TowerController")
                    modified = true
                end
            end
        end
    end
    
    return modified
end

-- Перехват функции нанесения урона
local function hookDamageFunction()
    -- Ищем функцию нанесения урона
    for _, func in pairs(getgc()) do
        if type(func) == "function" then
            local info = getinfo(func)
            if info.name and (info.name:lower():find("damage") or info.name:lower():find("hit") or info.name:lower():find("attack")) then
                -- Перехватываем функцию урона
                local original = func
                hookfunction(func, function(...)
                    local args = {...}
                    
                    -- Пробуем модифицировать аргументы урона
                    for i, arg in ipairs(args) do
                        if type(arg) == "number" and arg > 1 and arg < 100 then
                            args[i] = arg * MULTIPLIER
                        elseif type(arg) == "table" then
                            for k, v in pairs(arg) do
                                if type(v) == "number" and (k:find("Damage") or k:find("Multiplier")) then
                                    arg[k] = v * MULTIPLIER
                                end
                            end
                        end
                    end
                    
                    local result = original(unpack(args))
                    
                    -- Если функция возвращает урон, умножаем его
                    if type(result) == "number" and result > 1 and result < 1000 then
                        return result * MULTIPLIER
                    end
                    
                    return result
                end)
                print("[✓] Перехвачена функция урона: " .. (info.name or "unknown"))
                return true
            end
        end
    end
    return false
end

-- Агрессивный поиск любых значений урона
local function aggressiveDamageSearch()
    local modified = false
    
    for _, obj in pairs(getgc()) do
        if type(obj) == "table" then
            -- Ищем любые поля связанные с уроном
            for key, value in pairs(obj) do
                local keyStr = tostring(key)
                if type(value) == "number" and value > 1 and value < 100 then
                    if keyStr:find("Damage") or keyStr:find("Multiplier") or keyStr:find("Dmg") then
                        obj[key] = value * MULTIPLIER
                        print("[✓] Изменен: " .. keyStr .. " = " .. (value * MULTIPLIER))
                        modified = true
                    end
                end
            end
        end
    end
    
    return modified
end

-- Основной цикл с фокусом на активные объекты
local attempts = 0
while task.wait(1) do
    attempts = attempts + 1
    
    local activeModified = pcall(findAndModifyActiveDrones)
    local controllerModified = pcall(modifyTowerControllers)
    local hookModified = pcall(hookDamageFunction)
    local aggressiveModified = pcall(aggressiveDamageSearch)
    
    if activeModified or controllerModified or hookModified or aggressiveModified then
        print("[⚡] Изменения применены к активным объектам! Проверь урон.")
    end
    
    if attempts % 10 == 0 then
        print("[ℹ] Мониторинг активен... (попытка " .. attempts .. ")")
    end
    
    -- Останавливаемся после 60 попыток
    if attempts >= 60 then
        print("[ℹ] Мониторинг завершен. Если не сработало, проблема может быть в:")
        print("    1. Серверной проверке урона")
        print("    2. Защите игры от модификаций")
        print("    3. Неправильном определении дрона")
        break
    end
end