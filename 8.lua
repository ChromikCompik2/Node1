-- PulseHack MM2 by @filecpp

local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- 🛡️ Безопасное GUI (не скрывает другие)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PulseESP_GUI"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999

-- 🪟 Главное меню
local frame = Instance.new("Frame", ScreenGui)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.Size = UDim2.new(0, 300, 0, 45)  -- начальная высота панели (будет изменяться динамически)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = false

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 8)

-- 🏷️ Заголовок
local title = Instance.new("TextLabel", frame)
title.Text = "PulseHack | MM2"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- 📦 Панель функций
local funcs = {
    esp = false,
    aimbot = false,
    fly = false,
    noclip = false,
    speed = false,
    infjump = false,
    autofarm = false,
    spinball = false,
    airwalk = false,
    teleport = false,
    spin = false,  -- новая функция для крутилки
}

local y = 45
local function makeCheck(name, var)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "[OFF] " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        funcs[var] = not funcs[var]
        btn.Text = (funcs[var] and "[ON] " or "[OFF] ") .. name

        -- Перерасчет высоты меню, если кнопки добавляются/удаляются
        local buttonCount = 0
        for _, value in pairs(funcs) do
            if value then
                buttonCount = buttonCount + 1
            end
        end

        frame.Size = UDim2.new(0, 300, 0, 45 + buttonCount * 35)
    end)

    y = y + 35
end

makeCheck("ESP", "esp")
makeCheck("Aimbot (на Murder)", "aimbot")
makeCheck("Fly", "fly")
makeCheck("NoClip", "noclip")
makeCheck("SpeedHack", "speed")
makeCheck("Infinite Jump", "infjump")
makeCheck("AutoFarm (монеты)", "autofarm")
makeCheck("SpinBall", "spinball")
makeCheck("AirWalk", "airwalk")
makeCheck("Teleport to Player", "teleport")
makeCheck("Spin (крутилка)", "spin")  -- Добавляем крутилку

-- 📌 Переменные
local noclip = false
local flyVelocity = Vector3.new()
local ball
local selectedPlayer = nil
local roles = {}

-- 🧲 ESP логика
function createESP(plr)
    if plr == lp then return end
    local billboard = Instance.new("BillboardGui", plr.Character:WaitForChild("Head"))
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = plr.Name

    return billboard
end

-- 🎯 Aimbot на Murder
function getMurder()
    for _, v in ipairs(players:GetPlayers()) do
        if v ~= lp and v.Character and v.Backpack:FindFirstChild("Knife") then
            return v
        end
    end
end

-- Усовершенствованный аимбот
function aimAt(target)
    if not target or not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if head then
        local targetPos = head.Position
        local lookAt = CFrame.new(camera.CFrame.Position, targetPos)
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos) * CFrame.Angles(0, math.rad(10), 0) -- Более быстрое поворачивание
    end
end

-- 💨 Speed + NoClip
game:GetService("RunService").Stepped:Connect(function()
    if funcs.noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end

    if funcs.speed and lp.Character then
        lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 30
    else
        if lp.Character then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

-- 🕊️ Fly как Airbrake
local flySpeed = 100
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space and funcs.fly then
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = lp.Character:FindFirstChild("HumanoidRootPart")
            humanoidRootPart.Velocity = Vector3.new(0, flySpeed, 0) -- Придает ускорение вверх
        end
    end
end)

-- 🚀 Infinite Jump
local jumping = false
uis.JumpRequest:Connect(function()
    if funcs.infjump and lp.Character then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 💰 AutoFarm
coroutine.wrap(function()
    while true do task.wait(0.1)
        if funcs.autofarm then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Coin" and v:IsA("BasePart") then
                    lp.Character:MoveTo(v.Position)
                    task.wait(0.1)
                end
            end
        end
    end
end)()

-- 🔄 SpinBall
coroutine.wrap(function()
    while task.wait() do
        if funcs.spinball and not ball then
            ball = Instance.new("Part", workspace)
            ball.Size = Vector3.new(1, 1, 1)
            ball.Shape = Enum.PartType.Ball
            ball.Anchored = true
            ball.CanCollide = false
            ball.Material = Enum.Material.Neon
            ball.Color = Color3.fromRGB(255, 0, 0)
        elseif not funcs.spinball and ball then
            ball:Destroy()
            ball = nil
        end

        if ball then
            local time = tick()
            local radius = 5
            ball.Position = lp.Character.Head.Position + Vector3.new(
                math.cos(time * 2) * radius,
                2,
                math.sin(time * 2) * radius
            )
        end
    end
end)()

-- 🧠 Aimbot Update
coroutine.wrap(function()
    while true do
        task.wait(0.1)
        if funcs.aimbot then
            local m = getMurder()
            if m then aimAt(m) end
        end
    end
end)()

-- 📌 ESP обновление
coroutine.wrap(function()
    while true do
        task.wait(1)
        if funcs.esp then
            for _, v in ipairs(players:GetPlayers()) do
                if v ~= lp and v.Character and not v.Character:FindFirstChild("PulseESP") then
                    local tag = createESP(v)
                    tag.Name = "PulseESP"
                end
            end
        else
            for _, v in ipairs(players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("PulseESP") then
                    v.Character:FindFirstChild("PulseESP"):Destroy()
                end
            end
        end
    end
end)()

-- 🎛️ Меню на Z
uis.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.Z then
        frame.Visible = not frame.Visible
    end
end)

-- Телепорт к игроку
uis.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.T and funcs.teleport and selectedPlayer then
        if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character:SetPrimaryPartCFrame(selectedPlayer.Character.HumanoidRootPart.CFrame)
        end
    end
end)

-- 🔄 Старт / Восстановление после смерти
lp.CharacterAdded:Connect(function(character)
    -- Перезапуск всех функций после смерти
    wait(1) -- небольшая задержка для возрождения

    -- Включение или выключение всех функций
    funcs.spin = false
    funcs.aimbot = false
    funcs.esp = false
    funcs.fly = false
    funcs.noclip = false
end)
