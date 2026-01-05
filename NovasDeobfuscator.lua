local players: Players = game:GetService("Players")
local coreGui: CoreGui = game:GetService("CoreGui")
local userInputService: UserInputService = game:GetService("UserInputService")
local tweenService: TweenService = game:GetService("TweenService")

local localPlayer: Player = players.LocalPlayer
local screenGui: ScreenGui = Instance.new("ScreenGui")
screenGui.Name = "Nova_Deobfuscator_Integrated"
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 450)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(45, 45, 45)
mainStroke.Thickness = 1.5

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "NOVA DEOBFUSCATION ANALYZER"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -24, 1, -55)
container.Position = UDim2.new(0, 12, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local inputScroll = Instance.new("ScrollingFrame")
inputScroll.Size = UDim2.new(1, 0, 0, 120)
inputScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputScroll.BorderSizePixel = 0
inputScroll.ScrollBarThickness = 4
inputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
inputScroll.Parent = container

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -10, 1, 0)
inputBox.Position = UDim2.new(0, 5, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
inputBox.Text = ""
inputBox.PlaceholderText = "-- PASTE OBFUSCATED SCRIPT HERE"
inputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 12
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputScroll

Instance.new("UICorner", inputScroll).CornerRadius = UDim.new(0, 6)

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 35)
buttonContainer.Position = UDim2.new(0, 0, 0, 130)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = container

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = buttonContainer

local function createButton(text: string, color: Color3, order: number)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.Parent = buttonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local analyzeBtn = createButton("EXECUTE ANALYSIS", Color3.fromRGB(0, 120, 120), 1)
local copyBtn = createButton("COPY ALL RESULTS", Color3.fromRGB(120, 80, 0), 2)

local outputFrame = Instance.new("ScrollingFrame")
outputFrame.Size = UDim2.new(1, 0, 1, -175)
outputFrame.Position = UDim2.new(0, 0, 0, 175)
outputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
outputFrame.BorderSizePixel = 0
outputFrame.ScrollBarThickness = 4
outputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
outputFrame.Parent = container

local outputLayout = Instance.new("UIListLayout")
outputLayout.Padding = UDim.new(0, 4)
outputLayout.Parent = outputFrame

local function log(text: string, color: Color3?)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -15, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Code
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = outputFrame
    
    outputFrame.CanvasSize = UDim2.new(0, 0, 0, outputLayout.AbsoluteContentSize.Y + 10)
end

local function deepAnalyze(source: string)
    local success, func = pcall(loadstring, source)
    if not success or not func then
        log("SYNTAX ERROR: Loadstring failed.", Color3.fromRGB(255, 80, 80))
        return
    end

    log("INITIATING DYNAMIC SCAN...", Color3.fromRGB(0, 255, 150))

    local cSuccess, constants = pcall(debug.getconstants, func)
    if cSuccess and constants then
        log("--- CONSTANTS POOL ---", Color3.fromRGB(0, 200, 255))
        for i, v in pairs(constants) do
            log(string.format("[%d] %s: %s", i, typeof(v), tostring(v)))
        end
    end

    local uSuccess, upvalues = pcall(debug.getupvalues, func)
    if uSuccess and upvalues then
        log("--- UPVALUE REGISTRY ---", Color3.fromRGB(255, 200, 0))
        for i, v in pairs(upvalues) do
            log(string.format("[%d] %s: %s", i, typeof(v), tostring(v)))
        end
    end

    local pSuccess, protos = pcall(debug.getprotos, func)
    if pSuccess and protos then
        log("--- PROTOTYPE HIERARCHY ---", Color3.fromRGB(200, 100, 255))
        for i, p in pairs(protos) do
            local pC = debug.getconstants(p)
            log(string.format("[%d] Proto detected (%d constants)", i, #pC))
        end
    end

    log("SCAN FINISHED", Color3.fromRGB(0, 255, 0))
end

analyzeBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(outputFrame:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
    deepAnalyze(inputBox.Text)
end)

copyBtn.MouseButton1Click:Connect(function()
    local combinedText = ""
    for _, v in ipairs(outputFrame:GetChildren()) do
        if v:IsA("TextLabel") then
            combinedText = combinedText .. v.Text .. "\n"
        end
    end
    if setclipboard then
        setclipboard(combinedText)
        log("RESULTS COPIED TO CLIPBOARD", Color3.fromRGB(255, 255, 255))
    else
        log("ERROR: setclipboard NOT SUPPORTED", Color3.fromRGB(255, 50, 50))
    end
end)

local function enableDrag(frame: Frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

enableDrag(mainFrame)
