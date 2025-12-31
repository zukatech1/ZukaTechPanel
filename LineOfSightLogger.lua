local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SETTINGS = {
    LOOK_THRESHOLD = 0.98,
    IN_VIEW_THRESHOLD = 0.7,
    CHECK_INTERVAL = 0.1,
    RAYCAST_PARAMS = RaycastParams.new()
}
SETTINGS.RAYCAST_PARAMS.FilterType = Enum.RaycastFilterType.Exclude

local UI = {}
local MonitoringActive = true
local LastLogged = {}

UI.ScreenGui = Instance.new("ScreenGui", PlayerGui)
UI.ScreenGui.ResetOnSpawn = false
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

UI.MainFrame = Instance.new("Frame", UI.ScreenGui)
UI.MainFrame.BorderSizePixel = 0
UI.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI.MainFrame.Size = UDim2.new(0, 750, 0, 420)
UI.MainFrame.Position = UDim2.new(0.5, -375, 0.5, -210)
UI.MainFrame.BackgroundTransparency = 0.4
UI.MainFrame.Active = true

Instance.new("UICorner", UI.MainFrame)

local function MakeDraggable(frame: Frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
MakeDraggable(UI.MainFrame)

UI.LogContainer = Instance.new("ScrollingFrame", UI.MainFrame)
UI.LogContainer.BorderSizePixel = 0
UI.LogContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.LogContainer.Size = UDim2.new(0, 726, 0, 340)
UI.LogContainer.Position = UDim2.new(0, 12, 0, 14)
UI.LogContainer.BackgroundTransparency = 1
UI.LogContainer.ScrollBarThickness = 4
UI.LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.LogContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout", UI.LogContainer)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

UI.InputBox = Instance.new("TextBox", UI.MainFrame)
UI.InputBox.Size = UDim2.new(0, 726, 0, 40)
UI.InputBox.Position = UDim2.new(0, 12, 0, 365)
UI.InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
UI.InputBox.BackgroundTransparency = 0.5
UI.InputBox.BorderSizePixel = 0
UI.InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.InputBox.PlaceholderText = "Commands: clear, toggle, stats..."
UI.InputBox.Text = ""
UI.InputBox.Font = Enum.Font.Code
UI.InputBox.TextSize = 14
UI.InputBox.TextXAlignment = Enum.TextXAlignment.Left
UI.InputBox.ClearTextOnFocus = true

local InputPadding = Instance.new("UIPadding", UI.InputBox)
InputPadding.PaddingLeft = UDim.new(0, 10)
Instance.new("UICorner", UI.InputBox)

UI.ExitButton = Instance.new("TextButton", UI.MainFrame)
UI.ExitButton.ZIndex = 5
UI.ExitButton.BorderSizePixel = 0
UI.ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.ExitButton.BackgroundColor3 = Color3.fromRGB(201, 0, 0)
UI.ExitButton.Size = UDim2.new(0, 62, 0, 24)
UI.ExitButton.Text = "EXIT"
UI.ExitButton.Position = UDim2.new(1, -62, 0, -30)

Instance.new("UICorner", UI.ExitButton)

local function AddToLog(text: string, color: Color3?)
    local logLabel = Instance.new("TextLabel")
    logLabel.Parent = UI.LogContainer
    logLabel.BackgroundTransparency = 1
    logLabel.Size = UDim2.new(1, -10, 0, 20)
    logLabel.Font = Enum.Font.Code
    logLabel.Text = "[" .. os.date("%X") .. "] " .. text
    logLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    logLabel.TextSize = 13
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.RichText = true
    UI.LogContainer.CanvasPosition = Vector2.new(0, UI.LogContainer.AbsoluteCanvasSize.Y)
end

local function IsVisible(source: Instance, target: Instance): boolean
    SETTINGS.RAYCAST_PARAMS.FilterDescendantsInstances = {source, target}
    local origin = (source:IsA("Model") and source:GetPivot().Position) or source.Position
    local dest = (target:IsA("Model") and target:GetPivot().Position) or target.Position
    local result = Workspace:Raycast(origin, dest - origin, SETTINGS.RAYCAST_PARAMS)
    return result == nil
end

local function MonitorViewers()
    if not MonitoringActive or not LocalPlayer.Character then return end
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then continue end

        local toMe = (myRoot.Position - head.Position).Unit
        local lookDir = head.CFrame.LookVector
        local dot = lookDir:Dot(toMe)

        if dot >= SETTINGS.LOOK_THRESHOLD then
            if not LastLogged[player] or tick() - LastLogged[player] > 5 then
                if IsVisible(char, myChar) then
                    AddToLog("ALERT: " .. player.Name .. " is looking DIRECTLY at you.", Color3.fromRGB(255, 50, 50))
                    LastLogged[player] = tick()
                end
            end
        elseif dot >= SETTINGS.IN_VIEW_THRESHOLD then
             if not LastLogged[player] or tick() - LastLogged[player] > 10 then
                if IsVisible(char, myChar) then
                    AddToLog("NOTICE: You are in " .. player.Name .. "'s field of view.", Color3.fromRGB(255, 200, 0))
                    LastLogged[player] = tick()
                end
            end
        end
    end
end

UI.InputBox.FocusLost:Connect(function(enter)
    if enter then
        local msg = UI.InputBox.Text:lower()
        if msg == "clear" then
            for _, v in ipairs(UI.LogContainer:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
        elseif msg == "toggle" then
            MonitoringActive = not MonitoringActive
            AddToLog("System: " .. (MonitoringActive and "ENABLED" or "DISABLED"), Color3.fromRGB(255, 255, 255))
        end
        UI.InputBox.Text = ""
    end
end)

UI.ExitButton.MouseButton1Click:Connect(function()
    UI.ScreenGui:Destroy()
end)

RunService.Heartbeat:Connect(MonitorViewers)

AddToLog("Player Awareness Forensic Monitor Online.", Color3.fromRGB(0, 255, 255))
AddToLog("Detecting direct gazes and frustum intersections.", Color3.fromRGB(150, 150, 150))