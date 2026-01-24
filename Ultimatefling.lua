local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local function getTargetPlayers(input: string): {Player}
    local targets: {Player} = {}
    local lowerInput = input:lower()
    local allPlayers = Players:GetPlayers()

    if lowerInput == "all" then
        for _, player in ipairs(allPlayers) do
            table.insert(targets, player)
        end
    elseif lowerInput == "others" then
        for _, player in ipairs(allPlayers) do
            if player ~= localPlayer then
                table.insert(targets, player)
            end
        end
    elseif lowerInput == "me" then
        table.insert(targets, localPlayer)
    else
        for _, player in ipairs(allPlayers) do
            if player.Name:lower():sub(1, #input) == lowerInput then
                table.insert(targets, player)
            end
        end
    end
    return targets
end

local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local uiCorner = Instance.new("UICorner")
local targetBox = Instance.new("TextBox")
local boxCorner = Instance.new("UICorner")
local flingButton = Instance.new("TextButton")
local buttonCorner = Instance.new("UICorner")

screenGui.Name = "ArchitectFlingUI"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Active = true
mainFrame.Draggable = true

uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

targetBox.Name = "TargetBox"
targetBox.Parent = mainFrame
targetBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
targetBox.Position = UDim2.new(0.1, 0, 0.2, 0)
targetBox.Size = UDim2.new(0.8, 0, 0, 30)
targetBox.Font = Enum.Font.SourceSans
targetBox.PlaceholderText = "Target Name..."
targetBox.Text = ""
targetBox.TextColor3 = Color3.new(1, 1, 1)
targetBox.TextScaled = true

boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = targetBox

flingButton.Name = "FlingButton"
flingButton.Parent = mainFrame
flingButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flingButton.Position = UDim2.new(0.1, 0, 0.6, 0)
flingButton.Size = UDim2.new(0.8, 0, 0, 35)
flingButton.Font = Enum.Font.SourceSansBold
flingButton.Text = "Auto Fling"
flingButton.TextColor3 = Color3.new(1, 1, 1)
flingButton.TextScaled = true

buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = flingButton

getgenv().FlingActive = false
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

local function applyFlingPhysics(targetPart: BasePart, rootPart: BasePart, humanoid: Humanoid)
    local flingVelocity = Vector3.new(9e7, 9e7, 9e7)
    local flingRotVelocity = Vector3.new(9e8, 9e8, 9e8)
    
    local rotationSpeed = 0
    local startTime = tick()
    
    repeat
        if not (rootPart and targetPart and targetPart.Parent) then break end
        rotationSpeed = rotationSpeed + 100
        
        rootPart.CFrame = targetPart.CFrame * CFrame.Angles(math.rad(rotationSpeed), 0, 0)
        rootPart.Velocity = flingVelocity
        rootPart.RotVelocity = flingRotVelocity
        
        task.wait()
        
        rootPart.CFrame = targetPart.CFrame * CFrame.new(0, -1.5, 0)
        task.wait()
        
    until not getgenv().FlingActive or (tick() - startTime > 2) or (targetPart.Velocity.Magnitude > 500)
end

local function executeFling()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = humanoid and humanoid.RootPart
    
    if not (character and humanoid and rootPart) then return end
    
    getgenv().OldPos = rootPart.CFrame
    workspace.FallenPartsDestroyHeight = 0/0
    
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "FlingStabilizer"
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Parent = rootPart
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local targets = getTargetPlayers(targetBox.Text)
    
    for _, target in ipairs(targets) do
        if not getgenv().FlingActive then break end
        if target == localPlayer then continue end
        
        local targetChar = target.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        
        if targetRoot then
            workspace.CurrentCamera.CameraSubject = targetRoot
            applyFlingPhysics(targetRoot, rootPart, humanoid)
        end
    end
    
    bodyVel:Destroy()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
    workspace.CurrentCamera.CameraSubject = humanoid
    
    rootPart.CFrame = getgenv().OldPos
    rootPart.Velocity = Vector3.new(0, 0, 0)
    rootPart.RotVelocity = Vector3.new(0, 0, 0)
end

flingButton.MouseButton1Click:Connect(function()
    if getgenv().FlingActive then
        getgenv().FlingActive = false
        flingButton.Text = "Auto Fling"
        flingButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        getgenv().FlingActive = true
        flingButton.Text = "Stop Fling"
        flingButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        
        task.spawn(function()
            while getgenv().FlingActive do
                local success, err = pcall(executeFling)
                if not success then warn("Fling Cycle Error: " .. err) end
                task.wait()
            end
        end)
    end
end)