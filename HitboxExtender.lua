local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local localPlayer: Player = Players.LocalPlayer
local mouse: PlayerMouse = localPlayer:GetMouse()

local screenGui: ScreenGui = Instance.new("ScreenGui")
screenGui.Name = "RootPartResizer"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame: Frame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner: UICorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleBar: TextLabel = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1
titleBar.Text = "Raycasting Bypass"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.TextSize = 18
titleBar.Font = Enum.Font.GothamBold
titleBar.Parent = mainFrame

local container: ScrollingFrame = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
container.CanvasSize = UDim2.new(0, 0, 0, 400)
container.Parent = mainFrame

local uiList: UIListLayout = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 10)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = container

local function createInput(placeholder: string, order: number): TextBox
    local textBox: TextBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 0, 35)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.LayoutOrder = order
    textBox.Parent = container
    
    local corner: UICorner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = textBox
    
    return textBox
end

local function createButton(text: string, color: Color3, order: number): TextButton
    local button: TextButton = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.LayoutOrder = order
    button.Parent = container
    
    local corner: UICorner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    return button
end

local xInput: TextBox = createInput("Width (X)", 1)
local yInput: TextBox = createInput("Height (Y)", 2)
local zInput: TextBox = createInput("Depth (Z)", 3)

local playerButton: TextButton = createButton("APPLY TO PLAYERS", Color3.fromRGB(40, 100, 200), 4)
local npcButton: TextButton = createButton("APPLY TO NPCS", Color3.fromRGB(40, 150, 100), 5)
local resetButton: TextButton = createButton("RESET ALL", Color3.fromRGB(150, 50, 50), 6)

local function getInputs(): Vector3
    local x: number = tonumber(xInput.Text) or 2
    local y: number = tonumber(yInput.Text) or 2
    local z: number = tonumber(zInput.Text) or 1
    return Vector3.new(x, y, z)
end

local function setRootSize(model: Model, size: Vector3): boolean
    local success: boolean, err: string = pcall(function()
        local rootPart: BasePart = model:FindFirstChild("HumanoidRootPart") :: BasePart
        if rootPart and rootPart:IsA("BasePart") then
            rootPart.Size = size
            rootPart.CanCollide = false
        end
    end)
    return success
end

playerButton.MouseButton1Click:Connect(function()
    local targetSize: Vector3 = getInputs()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            setRootSize(player.Character, targetSize)
        end
    end
end)

npcButton.MouseButton1Click:Connect(function()
    local targetSize: Vector3 = getInputs()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            setRootSize(obj, targetSize)
        end
    end
end)

resetButton.MouseButton1Click:Connect(function()
    local defaultSize: Vector3 = Vector3.new(2, 2, 1)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            setRootSize(obj, defaultSize)
        end
    end
end)

local isVisible: boolean = true
UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        isVisible = not isVisible
        mainFrame.Visible = isVisible
    end
end)
