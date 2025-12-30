--{{This is a powerful in game module poisoner, it is still a WIP use at your own risk. ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

type PoisonData = {
	Original: (...any) -> ...any,
	Type: string,
	Count: number
}

local ACCENT_COLOR: Color3 = Color3.fromRGB(0, 170, 255)
local BG_DARK: Color3 = Color3.fromRGB(15, 15, 20)
local BG_MED: Color3 = Color3.fromRGB(25, 25, 30)
local TEXT_MAIN: Color3 = Color3.fromRGB(240, 240, 240)
local TEXT_DIM: Color3 = Color3.fromRGB(160, 160, 160)

local POISON_TYPES: {string} = {
	"Log Invocation",
	"Log Arguments",
	"Return Nil",
	"Return True",
	"Return False",
	"Infinite Yield",
	"Force Error",
	"No-Operation"
}

local poisonRegistry: {[string]: {[string]: PoisonData}} = {}
local foundModules: {ModuleScript} = {}
local selection = {
	Module = nil :: ModuleScript?,
	Table = nil :: {[any]: any}?,
	Function = nil :: string?,
	Poison = POISON_TYPES[1]
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = HttpService:GenerateGUID(false)
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.fromOffset(600, 420)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
mainFrame.BackgroundColor3 = BG_DARK
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = BG_MED
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = BG_MED
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.fromOffset(15, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ARCHITECT MODULE POISONER // V3"
titleText.Font = Enum.Font.RobotoMono
titleText.TextColor3 = TEXT_MAIN
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -110)
contentFrame.Position = UDim2.fromOffset(10, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local moduleContainer = Instance.new("ScrollingFrame")
moduleContainer.Size = UDim2.new(0.5, -5, 1, 0)
moduleContainer.BackgroundColor3 = BG_MED
moduleContainer.BorderSizePixel = 0
moduleContainer.ScrollBarThickness = 2
moduleContainer.ScrollBarImageColor3 = ACCENT_COLOR
moduleContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
moduleContainer.Parent = contentFrame

local functionContainer = Instance.new("ScrollingFrame")
functionContainer.Size = UDim2.new(0.5, -5, 1, 0)
functionContainer.Position = UDim2.new(0.5, 5, 0, 0)
functionContainer.BackgroundColor3 = BG_MED
functionContainer.BorderSizePixel = 0
functionContainer.ScrollBarThickness = 2
functionContainer.ScrollBarImageColor3 = ACCENT_COLOR
functionContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
functionContainer.Parent = contentFrame

local moduleLayout = Instance.new("UIListLayout")
moduleLayout.Padding = UDim.new(0, 2)
moduleLayout.Parent = moduleContainer

local functionLayout = Instance.new("UIListLayout")
functionLayout.Padding = UDim.new(0, 2)
functionLayout.Parent = functionContainer

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, -20, 0, 50)
footer.Position = UDim2.new(0, 10, 1, -60)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.2, -5, 1, 0)
scanBtn.BackgroundColor3 = BG_MED
scanBtn.Text = "SCAN ENV"
scanBtn.Font = Enum.Font.RobotoMono
scanBtn.TextColor3 = TEXT_MAIN
scanBtn.TextSize = 12
scanBtn.Parent = footer

local poisonTypeBtn = Instance.new("TextButton")
poisonTypeBtn.Size = UDim2.new(0.4, -5, 1, 0)
poisonTypeBtn.Position = UDim2.new(0.2, 5, 0, 0)
poisonTypeBtn.BackgroundColor3 = BG_MED
poisonTypeBtn.Text = "MODE: " .. selection.Poison
poisonTypeBtn.Font = Enum.Font.RobotoMono
poisonTypeBtn.TextColor3 = TEXT_MAIN
poisonTypeBtn.TextSize = 12
poisonTypeBtn.Parent = footer

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.2, -5, 1, 0)
applyBtn.Position = UDim2.new(0.6, 5, 0, 0)
applyBtn.BackgroundColor3 = ACCENT_COLOR
applyBtn.Text = "POISON"
applyBtn.Font = Enum.Font.RobotoMono
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.TextSize = 12
applyBtn.Parent = footer

local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(0.2, -5, 1, 0)
restoreBtn.Position = UDim2.new(0.8, 5, 0, 0)
restoreBtn.BackgroundColor3 = BG_MED
restoreBtn.Text = "PURGE"
restoreBtn.Font = Enum.Font.RobotoMono
restoreBtn.TextColor3 = TEXT_DIM
restoreBtn.TextSize = 12
restoreBtn.Parent = footer

local function applyUiDesign(obj: GuiObject)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 4)
	c.Parent = obj
end

applyUiDesign(moduleContainer)
applyUiDesign(functionContainer)
applyUiDesign(scanBtn)
applyUiDesign(poisonTypeBtn)
applyUiDesign(applyBtn)
applyUiDesign(restoreBtn)

local function clear(f: ScrollingFrame)
	for _, v in ipairs(f:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

local function scan()
	table.clear(foundModules)
	local roots = {game:GetService("ReplicatedStorage"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts"), game:GetService("ReplicatedFirst")}
	for _, root in ipairs(roots) do
		if not root then continue end
		for _, v in ipairs(root:GetDescendants()) do
			if v:IsA("ModuleScript") then table.insert(foundModules, v) end
		end
	end
end

local function updateFunctions(mod: ModuleScript)
	clear(functionContainer)
	local success, tbl = pcall(require, mod)
	if not success or type(tbl) ~= "table" then return end
	selection.Table = tbl
	
	local function add(key)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 25)
		b.BackgroundTransparency = 1
		b.Text = "  " .. tostring(key)
		b.Font = Enum.Font.RobotoMono
		b.TextColor3 = TEXT_DIM
		b.TextSize = 12
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Parent = functionContainer
		b.MouseButton1Click:Connect(function()
			selection.Function = tostring(key)
			for _, x in ipairs(functionContainer:GetChildren()) do
				if x:IsA("TextButton") then x.TextColor3 = TEXT_DIM end
			end
			b.TextColor3 = ACCENT_COLOR
		end)
	end
	
	for k, v in pairs(tbl) do if type(v) == "function" then add(k) end end
	local mt = getmetatable(tbl)
	if mt and type(mt.__index) == "table" then
		for k, v in pairs(mt.__index) do if type(v) == "function" then add(k) end end
	end
end

local function updateModules()
	clear(moduleContainer)
	for _, m in ipairs(foundModules) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 25)
		b.BackgroundTransparency = 1
		b.Text = "  " .. m.Name
		b.Font = Enum.Font.RobotoMono
		b.TextColor3 = TEXT_DIM
		b.TextSize = 12
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Parent = moduleContainer
		b.MouseButton1Click:Connect(function()
			selection.Module = m
			selection.Function = nil
			for _, x in ipairs(moduleContainer:GetChildren()) do
				if x:IsA("TextButton") then x.TextColor3 = TEXT_DIM end
			end
			b.TextColor3 = ACCENT_COLOR
			updateFunctions(m)
		end)
	end
end

local function wrap(original: (...any) -> ...any, name: string, modName: string)
	return function(...)
		local args = {...}
		local t = selection.Poison
		if t == "Log Invocation" then
			print(string.format("[!] %s -> %s invoked", modName, name))
			return original(...)
		elseif t == "Log Arguments" then
			print(string.format("[!] %s -> %s args:", modName, name), args)
			return original(...)
		elseif t == "Return Nil" then return nil
		elseif t == "Return True" then return true
		elseif t == "Return False" then return false
		elseif t == "Infinite Yield" then task.wait(9e9)
		elseif t == "Force Error" then error("Architect Poison: Critical Logic Fault")
		elseif t == "No-Operation" then return end
	end
end

scanBtn.MouseButton1Click:Connect(function()
	scan()
	updateModules()
end)

poisonTypeBtn.MouseButton1Click:Connect(function()
	local i = table.find(POISON_TYPES, selection.Poison) or 1
	selection.Poison = POISON_TYPES[(i % #POISON_TYPES) + 1]
	poisonTypeBtn.Text = "MODE: " .. selection.Poison
end)

applyBtn.MouseButton1Click:Connect(function()
	local m, f, t = selection.Module, selection.Function, selection.Table
	if not (m and f and t) then return end
	local path = m:GetFullName()
	if not poisonRegistry[path] then poisonRegistry[path] = {} end
	
	local target = t
	if not rawget(t, f) then
		local mt = getmetatable(t)
		if mt and type(mt.__index) == "table" and rawget(mt.__index, f) then target = mt.__index end
	end
	
	if not poisonRegistry[path][f] then
		poisonRegistry[path][f] = { Original = target[f], Type = selection.Poison, Count = 0 }
	end
	
	rawset(target, f, wrap(poisonRegistry[path][f].Original, f, m.Name))
	applyBtn.Text = "INJECTED"
	task.delay(0.5, function() applyBtn.Text = "POISON" end)
end)

restoreBtn.MouseButton1Click:Connect(function()
	local m, f, t = selection.Module, selection.Function, selection.Table
	if not (m and f and t) then return end
	local path = m:GetFullName()
	local d = poisonRegistry[path] and poisonRegistry[path][f]
	if d then
		local target = t
		if not rawget(t, f) then
			local mt = getmetatable(t)
			if mt and type(mt.__index) == "table" then target = mt.__index end
		end
		rawset(target, f, d.Original)
		poisonRegistry[path][f] = nil
	end
end)

local drag, dInput, dStart, sPos
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = true
		dStart = i.Position
		sPos = mainFrame.Position
		i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
	end
end)

UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then dInput = i end end)

RunService.RenderStepped:Connect(function()
	if drag and dInput then
		local delta = dInput.Position - dStart
		mainFrame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputBegan:Connect(function(i, g)
	if not g and i.KeyCode == Enum.KeyCode.RightAlt then screenGui.Enabled = not screenGui.Enabled end
end)

scan()
updateModules()
