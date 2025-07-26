-- Pulse Murder Mystery 2 Script v1.1 by @filecpp

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Settings (все по умолчанию выключены)
local settings = {
    espEnabled = false,
    espNickEnabled = false,
    espRoleEnabled = false,
    autoFarmEnabled = false,
    flyEnabled = false,
    noclipEnabled = false,
    speedHackEnabled = false,
    spinBotEnabled = false,
    spinSpeed = 10,
    walkSpeed = 16,
    tpToMurderer = false,
    tpToSheriff = false,
    -- Аимбот
    aimbotEnabled = false,
    aimbotFOV = 30,
    aimbotSmooth = 5,
    aimbotWallCheck = false,
}

local Murderer, Sheriff, Hero
local roles = {}

-- GUI

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PulseMenu"
ScreenGui.Enabled = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 520)
Frame.Position = UDim2.new(0.5, -175, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createToggle(name, settingKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    btn.AutoButtonColor = false

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(0,150,255) or Color3.fromRGB(45,45,45)
    end)

    btn.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        btn.Text = name .. ": " .. (settings[settingKey] and "ON" or "OFF")
        btn.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(0,150,255) or Color3.fromRGB(45,45,45)
    end)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.LayoutOrder = #UIListLayout:GetChildren() + 1
    btn.Parent = Frame
    return btn
end

local function createSlider(name, settingKey, min, max)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.LayoutOrder = #UIListLayout:GetChildren() + 1
    sliderFrame.Parent = Frame

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = name .. ": " .. tostring(settings[settingKey])

    local slider = Instance.new("TextButton", sliderFrame)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(45,45,45)
    slider.AutoButtonColor = false
    slider.Text = ""
    slider.TextColor3 = Color3.new(1,1,1)
    slider.ClipsDescendants = true

    local sliderBar = Instance.new("Frame", slider)
    sliderBar.Size = UDim2.new((settings[settingKey] - min) / (max - min), 1, 1, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(0,150,255)

    slider.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local function update()
            local relativeX = math.clamp(mouse.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            local percent = relativeX / slider.AbsoluteSize.X
            local value = math.floor(min + percent * (max - min))
            settings[settingKey] = value
            label.Text = name .. ": " .. tostring(value)
            sliderBar.Size = UDim2.new(percent, 0, 1, 0)
        end
        update()
        local conn
        conn = mouse.Move:Connect(update)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect()
            end
        end)
    end)

    return sliderFrame
end

-- Создаем элементы меню

createToggle("ESP (Highlight)", "espEnabled")
createToggle("ESP Никнеймы", "espNickEnabled")
createToggle("ESP Роли", "espRoleEnabled")
createToggle("Автофарм BeachBall", "autoFarmEnabled")
createToggle("Флай", "flyEnabled")
createToggle("Ноуклип", "noclipEnabled")
createToggle("Спидхак", "speedHackEnabled")
createSlider("Скорость спида", "walkSpeed", 16, 100)
createToggle("Спинбот", "spinBotEnabled")
createSlider("Скорость спинбота", "spinSpeed", 1, 50)
createToggle("Телепорт к Murderer", "tpToMurderer")
createToggle("Телепорт к Sheriff", "tpToSheriff")
createToggle("Аимбот на Sheriff", "aimbotEnabled")
createSlider("Аимбот FOV", "aimbotFOV", 10, 100)
createSlider("Аимбот Плавность", "aimbotSmooth", 1, 20)
createToggle("Аимбот WallCheck", "aimbotWallCheck")

-- Toggle GUI на U

local guiEnabled = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        guiEnabled = not guiEnabled
        ScreenGui.Enabled = guiEnabled
    end
end)

-- Вспомогательные функции

local Camera = workspace.CurrentCamera

local function WorldToScreenPoint(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

function IsAlive(player)
    for i,v in pairs(roles) do
        if i == player.Name then
            return not (v.Killed or v.Dead)
        end
    end
    return false
end

function UpdateRoles()
    local success, data = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if success and data then
        roles = data
        for i,v in pairs(data) do
            if v.Role == "Murderer" then
                Murderer = i
            elseif v.Role == "Sheriff" then
                Sheriff = i
            elseif v.Role == "Hero" then
                Hero = i
            end
        end
    end
end

function CreateHighlight(player)
    if player.Character and not player.Character:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

function UpdateHighlightColors()
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Highlight") then
            local hl = player.Character.Highlight
            if player.Name == Murderer and IsAlive(player) then
                hl.FillColor = Color3.new(1, 0, 0)
                hl.OutlineColor = Color3.new(1, 0, 0)
            elseif player.Name == Sheriff and IsAlive(player) then
                hl.FillColor = Color3.new(0, 0, 1)
                hl.OutlineColor = Color3.new(0, 0, 1)
            elseif player.Name == Hero and IsAlive(player) and not IsAlive(Players:FindFirstChild(Sheriff)) then
                hl.FillColor = Color3.new(1, 1, 0)
                hl.OutlineColor = Color3.new(1, 1, 0)
            else
                hl.FillColor = Color3.new(0, 1, 0)
                hl.OutlineColor = Color3.new(0, 1, 0)
            end
        end
    end
end

function UpdateBillboardESP()
    for _,player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local gui = head:FindFirstChild("ESPBillboard")
            if settings.espEnabled then
                if not gui then
                    gui = Instance.new("BillboardGui", head)
                    gui.Name = "ESPBillboard"
                    gui.Size = UDim2.new(0, 100, 0, 40)
                    gui.AlwaysOnTop = true
                    gui.Adornee = head

                    local textLabel = Instance.new("TextLabel", gui)
                    textLabel.Name = "ESPText"
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.new(1,1,1)
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                end

                local text = ""
                if settings.espNickEnabled then
                    text = player.Name
                end
                if settings.espRoleEnabled and roles[player.Name] then
                    text = text .. " [" .. roles[player.Name].Role .. "]"
                end
                gui.ESPText.Text = text

            else
                if gui then
                    gui:Destroy()
                end
            end
        end
    end
end

-- AutoFarm

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

coroutine.wrap(function()
    while true do
        if settings.autoFarmEnabled then
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            end

            local map = nil
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:GetAttribute("MapID") then
                    map = v
                    break
                end
            end
            if not map or not map:FindFirstChild("CoinContainer") then
                character.HumanoidRootPart.CFrame = CFrame.new(132, 140, 60)
                task.wait(1)
            else
                local coinToCollect = nil
                for _, coin in pairs(map.CoinContainer:GetChildren()) do
                    if coin:IsA("Part") and coin.Name == "Coin_Server" and coin:GetAttribute("CoinID") == "BeachBall" then
                        local cv = coin:FindFirstChild("CoinVisual")
                        if cv and cv.Transparency ~= 1 then
                            coinToCollect = coin
                            break
                        end
                    end
                end

                if coinToCollect then
                    character.HumanoidRootPart.CFrame = coinToCollect.CFrame
                    task.wait(1)
                    character.HumanoidRootPart.CFrame = CFrame.new(132, 140, 60)
                    task.wait(2)
                else
                    character.HumanoidRootPart.CFrame = CFrame.new(132, 140, 60)
                    task.wait(1)
                end
            end
        else
            task.wait(1)
        end
        task.wait()
    end
end)()

-- Fly & Noclip & SpeedHack

RunService.Stepped:Connect(function()
    if settings.flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

        hrp.Velocity = Vector3.new(0,0,0)
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveDir.Unit * 50 * RunService.Stepped:Wait()
        end
    end

    if settings.noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if settings.speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = settings.walkSpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

-- SpinBot

RunService.RenderStepped:Connect(function()
    if settings.spinBotEnabled and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        LocalPlayer.Character:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(settings.spinSpeed), 0))
    end
end)

-- Teleport to Murderer / Sheriff

coroutine.wrap(function()
    while true do
        if settings.tpToMurderer and Murderer and Players:FindFirstChild(Murderer) and Players[Murderer].Character and Players[Murderer].Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Murderer].Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
        if settings.tpToSheriff and Sheriff and Players:FindFirstChild(Sheriff) and Players[Sheriff].Character and Players[Sheriff].Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Sheriff].Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
        task.wait(0.5)
    end
end)()

-- Аимбот для Sheriff

local function GetClosestSheriffTarget()
    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("Head") then return nil end
    local localPos = Camera.CFrame.Position
    local mousePos = UserInputService:GetMouseLocation()

    local closestTarget = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == Sheriff and player.Character and player.Character:FindFirstChild("Head") and player ~= LocalPlayer then
            if IsAlive(player) then
                local headPos = player.Character.Head.Position
                local screenPos, onScreen = WorldToScreenPoint(headPos)
                if onScreen then
                    local distToMouse = (screenPos - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if distToMouse <= settings.aimbotFOV then
                        if settings.aimbotWallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local raycastResult = workspace:Raycast(localPos, (headPos - localPos), rayParams)
                            if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(player.Character) then
                                if distToMouse < closestDistance then
                                    closestDistance = distToMouse
                                    closestTarget = player
                                end
                            end
                        else
                            if distToMouse < closestDistance then
                                closestDistance = distToMouse
                                closestTarget = player
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function SmoothAim(targetPos, smoothness)
    local camera = workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local direction = (targetPos - camera.CFrame.Position).Unit
    local targetCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothness)
    camera.CFrame = newCFrame
end

-- Обновление ролей и ESP

RunService.RenderStepped:Connect(function()
    UpdateRoles()

    if settings.espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            CreateHighlight(player)
        end
        UpdateHighlightColors()
        UpdateBillboardESP()
    else
        -- Удаляем хайлайты и ESP, если выключено
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                local espGui = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("ESPBillboard")
                if espGui then espGui:Destroy() end
            end
        end
    end

    -- Аимбот на Sheriff
    if settings.aimbotEnabled and Sheriff then
        local target = GetClosestSheriffTarget()
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local headPos = target.Character.Head.Position
            SmoothAim(headPos, settings.aimbotSmooth)
        end
    end
end)

print("[PulseRage] Script loaded. Нажмите U для открытия меню.")
