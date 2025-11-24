local DAMAGE_MULTIPLIER = 15.0

-- Метод 1: Перехват RemoteEvents для урона
local function hookDamageEvents()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Ищем все RemoteEvents связанные с уроном
    for _, remote in pairs(replicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("damage") or remote.Name:lower():find("hit") or remote.Name:lower():find("attack")) then
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                
                -- Пробуем модифицировать данные урона перед отправкой на сервер
                for i, arg in ipairs(args) do
                    if type(arg) == "number" and arg > 1 and arg < 1000 then
                        -- Если это число похожее на урон - умножаем
                        args[i] = arg * DAMAGE_MULTIPLIER
                    elseif type(arg) == "table" then
                        -- Если это таблица, ищем поля с уроном
                        for k, v in pairs(arg) do
                            if type(v) == "number" and (k:find("Damage") or k:find("Dmg")) then
                                arg[k] = v * DAMAGE_MULTIPLIER
                            end
                        end
                    end
                end
                
                return oldFireServer(self, unpack(args))
            end
            print("[✓] Перехвачен RemoteEvent: " .. remote.Name)
        end
    end
end

-- Метод 2: Перехват функций урона
local function hookDamageFunctions()
    for _, func in pairs(getgc()) do
        if type(func) == "function" then
            local info = getinfo(func)
            if info.name and (info.name:lower():find("damage") or info.name:lower():find("hit") or info.name:lower():find("attack")) then
                local original = func
                hookfunction(func, function(...)
                    local args = {...}
                    local result = original(...)
                    
                    -- Если функция возвращает урон - умножаем
                    if type(result) == "number" and result > 1 and result < 10000 then
                        return result * DAMAGE_MULTIPLIER
                    end
                    
                    return result
                end)
                print("[✓] Перехвачена функция: " .. (info.name or "unknown"))
            end
        end
    end
end

-- Метод 3: Модификация данных в памяти перед отправкой
local function modifyDamageData()
    while task.wait(0.5) do
        -- Ищем таблицы с данными об уроне которые могут отправляться на сервер
        local damageTables = filtergc("table", {
            Keys = {"Damage", "BaseDamage", "HitDamage", "ProjectileDamage"}
        }, false)
        
        if damageTables then
            for _, tbl in next, damageTables do
                for key, value in pairs(tbl) do
                    if type(value) == "number" and value > 1 and value < 1000 then
                        rawset(tbl, key, value * DAMAGE_MULTIPLIER)
                    end
                end
            end
        end
    end
end

-- Запускаем все методы
print("[⚡] Запуск обхода серверной проверки урона...")

pcall(hookDamageEvents)
pcall(hookDamageFunctions)
coroutine.wrap(modifyDamageData)()

print("[✓] Все методы применены. Проверяй реальный урон!")
