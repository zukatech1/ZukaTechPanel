--[[
    Architect: Callum
    Project: Targeted Player ESP & Environment Manipulation
    Status: Optimized / Surgical Enhancement
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local UI_ACCENT = Color3.fromRGB(0, 170, 255)

local espTable = {}
local connections = {}
local currentTarget = nil

-- GUI CONSTRUCTION
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InputBox = Instance.new("TextBox")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "Callum_TargetUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(0, 200, 0, 25)
Title.Font = Enum.Font.Code
Title.Text = "CALLUM // TARGET ESP"
Title.TextColor3 = UI_ACCENT
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

InputBox.Name = "InputBox"
InputBox.Parent = MainFrame
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputBox.Position = UDim2.new(0, 10, 0, 35)
InputBox.Size = UDim2.new(0, 200, 0, 30)
InputBox.Font = Enum.Font.SourceSans
InputBox.PlaceholderText = "Enter Username..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 16

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 70)
StatusLabel.Size = UDim2.new(0, 200, 0, 20)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Target: None"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- CORE LOGIC
local function destroyPlayerESP(player)
    if not player or not espTable[player.UserId] then return end
    local data = espTable[player.UserId]
    if data.Highlight then data.Highlight:Destroy() end
    if data.NameTag then data.NameTag:Destroy() end
    espTable[player.UserId] = nil
end

local function createPlayerESP(player)
    if player == LocalPlayer then return end
    if espTable[player.UserId] then destroyPlayerESP(player) end
    
    local character = player.Character
    if not character then return end
    
    local humanRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanRootPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local nameTagGui = Instance.new("BillboardGui")
    nameTagGui.Size = UDim2.new(4, 0, 1, 0)
    nameTagGui.ExtentsOffsetWorldSpace = Vector3.new(0, 3, 0)
    nameTagGui.AlwaysOnTop = true
    nameTagGui.LightInfluence = 0
    nameTagGui.Adornee = humanRootPart
    nameTagGui.Parent = character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = string.format("[%s]", player.Name)
    nameLabel.TextColor3 = ESP_COLOR
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = false
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.Code
    nameLabel.Parent = nameTagGui

    espTable[player.UserId] = {
        Highlight = highlight,
        NameTag = nameTagGui
    }
end

-- TARGET MANAGEMENT
local function setTarget(name)
    local foundPlayer = nil
    local lowerName = name:lower()

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #lowerName) == lowerName then
            foundPlayer = p
            break
        end
    end

    -- Cleanup old target
    if currentTarget then
        destroyPlayerESP(currentTarget)
    end

    if foundPlayer and foundPlayer ~= LocalPlayer then
        currentTarget = foundPlayer
        StatusLabel.Text = "Target: " .. foundPlayer.Name
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        createPlayerESP(foundPlayer)
    else
        currentTarget = nil
        StatusLabel.Text = "Target: Not Found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

-- EVENT HANDLERS
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        setTarget(InputBox.Text)
    end
end)

connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
    -- If the target rejoins, re-apply
    if currentTarget and player.UserId == currentTarget.UserId then
        connections[player.UserId .. "CharacterAdded"] = player.CharacterAdded:Connect(function()
            task.wait(0.2)
            if currentTarget == player then
                createPlayerESP(player)
            end
        end)
    end
end)

connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
    if currentTarget and player == currentTarget then
        destroyPlayerESP(player)
        StatusLabel.Text = "Target: Left Game"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        currentTarget = nil
    end
end)

-- ENSURE TARGET PERSISTENCE
connections.RenderStepped = RunService.RenderStepped:Connect(function()
    if currentTarget and currentTarget.Character then
        local data = espTable[currentTarget.UserId]
        if not data then
            createPlayerESP(currentTarget)
        else
            -- Self-correction logic
            if data.Highlight.Adornee ~= currentTarget.Character then
                data.Highlight.Adornee = currentTarget.Character
            end
            local hrp = currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp and data.NameTag.Adornee ~= hrp then
                data.NameTag.Adornee = hrp
            end
        end
    end
end)

-- CharacterAdded listener for existing players (if target is already in game)
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        if currentTarget and player == currentTarget then
            createPlayerESP(player)
        end
    end)
end

-- Global variable and cleanup protocol
getgenv().CallumTarget_Cleanup = function()
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    if ScreenGui then ScreenGui:Destroy() end
    if currentTarget then destroyPlayerESP(currentTarget) end
end

print("Callum Targeted ESP: Initialized. Press Enter in GUI to lock target.")
