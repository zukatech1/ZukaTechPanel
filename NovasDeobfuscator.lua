local Players: Players = game:GetService("Players") local CoreGui: CoreGui = game:GetService("CoreGui") local UserInputService: UserInputService = game:GetService("UserInputService") local TweenService: TweenService = game:GetService("TweenService") local LocalPlayer = Players.LocalPlayer

local Screen = Instance.new("ScreenGui") Screen.Name = "Nova_Deobfuscator_Integrated" Screen.Parent = CoreGui Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen) Main.Size = UDim2.new(0, 500, 0, 420) Main.Position = UDim2.new(0.5, -250, 0.5, -210) Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12) Main.BorderSizePixel = 0 Main.Active = true

local UICorner = Instance.new("UICorner", Main) UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", Main) UIStroke.Color = Color3.fromRGB(45, 45, 45) UIStroke.Thickness = 1.5

local TitleBar = Instance.new("Frame", Main) TitleBar.Size = UDim2.new(1, 0, 0, 35) TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18) TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner", TitleBar) TitleCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TitleBar) TitleLabel.Size = UDim2.new(1, -20, 1, 0) TitleLabel.Position = UDim2.new(0, 10, 0, 0) TitleLabel.BackgroundTransparency = 1 TitleLabel.Text = "NOVA DEOBFUSCATION ANALYZER" TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255) TitleLabel.Font = Enum.Font.Code TitleLabel.TextSize = 14 TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("Frame", Main) Container.Size = UDim2.new(1, -24, 1, -55) Container.Position = UDim2.new(0, 12, 0, 45) Container.BackgroundTransparency = 1

local InputBox = Instance.new("TextBox", Container) InputBox.Size = UDim2.new(1, 0, 0, 120) InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20) InputBox.BorderSizePixel = 0 InputBox.TextColor3 = Color3.fromRGB(220, 220, 220) InputBox.Text = "" InputBox.PlaceholderText = "-- PASTE OBFUSCATED SCRIPT HERE" InputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80) InputBox.Font = Enum.Font.Code InputBox.TextSize = 12 InputBox.TextXAlignment = Enum.TextXAlignment.Left InputBox.TextYAlignment = Enum.TextYAlignment.Top InputBox.MultiLine = true InputBox.ClearTextOnFocus = false

local InputCorner = Instance.new("UICorner", InputBox)

local AnalyzeBtn = Instance.new("TextButton", Container) AnalyzeBtn.Size = UDim2.new(1, 0, 0, 35) AnalyzeBtn.Position = UDim2.new(0, 0, 0, 130) AnalyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) AnalyzeBtn.Text = "EXECUTE ANALYSIS" AnalyzeBtn.Font = Enum.Font.Code AnalyzeBtn.TextColor3 = Color3.new(1, 1, 1) AnalyzeBtn.TextSize = 14 AnalyzeBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner", AnalyzeBtn)

local OutputFrame = Instance.new("ScrollingFrame", Container) OutputFrame.Size = UDim2.new(1, 0, 1, -175) OutputFrame.Position = UDim2.new(0, 0, 0, 175) OutputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) OutputFrame.BorderSizePixel = 0 OutputFrame.ScrollBarThickness = 4 OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIList = Instance.new("UIListLayout", OutputFrame) UIList.Padding = UDim.new(0, 3)

local function Log(text: string, color: Color3?) local Label = Instance.new("TextLabel", OutputFrame) Label.Size = UDim2.new(1, -10, 0, 20) Label.BackgroundTransparency = 1 Label.Text = " " .. text Label.TextColor3 = color or Color3.fromRGB(200, 200, 200) Label.Font = Enum.Font.Code Label.TextSize = 11 Label.TextXAlignment = Enum.TextXAlignment.Left OutputFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y) end

local function DeepAnalyze(source: string) local func, err = loadstring(source) if not func then Log("SYNTAX ERROR: " .. tostring(err), Color3.fromRGB(255, 80, 80)) return end

Log("INITIATING DYNAMIC SCAN...", Color3.fromRGB(0, 255, 150))

local cSuccess, constants = pcall(function() return debug.getconstants(func) end)
if cSuccess and constants then
	Log("--- CONSTANTS POOL ---", Color3.fromRGB(0, 200, 255))
	for i, v in pairs(constants) do
		Log(string.format("[%d] %s: %s", i, typeof(v), tostring(v)))
	end
end

local uSuccess, upvalues = pcall(function() return debug.getupvalues(func) end)
if uSuccess and upvalues then
	Log("--- UPVALUE REGISTRY ---", Color3.fromRGB(255, 200, 0))
	for i, v in pairs(upvalues) do
		Log(string.format("[%d] %s: %s", i, typeof(v), tostring(v)))
	end
end

local pSuccess, protos = pcall(function() return debug.getprotos(func) end)
if pSuccess and protos then
	Log("--- PROTOTYPE HIERARCHY ---", Color3.fromRGB(200, 100, 255))
	for i, p in pairs(protos) do
		local pConstants = debug.getconstants(p)
		Log(string.format("[%d] Proto detected (%d constants)", i, #pConstants))
	end
end

Log("SCAN FINISHED", Color3.fromRGB(0, 255, 0))
end

AnalyzeBtn.MouseButton1Click:Connect(function() for _, v in pairs(OutputFrame:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end DeepAnalyze(InputBox.Text) end)

local function EnableDrag(gui: Frame) local dragging, dragInput, dragStart, startPos gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = gui.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end

EnableDrag(Main)