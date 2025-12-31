local CoreGui = game:GetService("CoreGui") local UserInputService = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local HttpService = game:GetService("HttpService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Players = game:GetService("Players")

local ACCENT = Color3.fromRGB(0, 255, 170) local BG_DARK = Color3.fromRGB(10, 10, 12) local BG_LIGHT = Color3.fromRGB(20, 20, 25) local TEXT_PRIMARY = Color3.fromRGB(255, 255, 255) local TEXT_SECONDARY = Color3.fromRGB(150, 150, 150)

local HEURISTIC_KEYWORDS = { ["Ban"] = 50, ["Kick"] = 50, ["Cheat"] = 40, ["Anti"] = 40, ["Damage"] = 30, ["Remote"] = 20, ["Network"] = 20, ["Admin"] = 45, ["Shop"] = 15, ["Purchase"] = 25, ["Inventory"] = 20, ["Cooldown"] = 15, ["Stamina"] = 10, ["Mana"] = 10, ["Health"] = 10, ["Speed"] = 15 }

local POISON_MODES = { "Log: Minimal", "Log: Deep (Args)", "Log: Network Trace", "Return: Nil", "Return: True", "Return: False", "Return: Empty Table", "Logic: Infinite Yield", "Logic: Force Error", "Logic: No-Op", "Dynamic: Spoof Args" }

local Registry = { Hooks = {} :: {[string]: {[string]: {Original: any, Mode: string}}}, Persistence = {} :: {[string]: boolean}, Remotes = {} :: {string}, Upvalues = {} :: {[string]: any} }

local State = { SelectedModule = nil :: ModuleScript?, SelectedTable = nil :: {[any]: any}?, SelectedFunction = nil :: string?, SelectedMode = POISON_MODES[1], FoundModules = {} :: {ModuleScript} }

local screenGui = Instance.new("ScreenGui") screenGui.Name = HttpService:GenerateGUID(false) screenGui.ResetOnSpawn = false screenGui.DisplayOrder = 100 screenGui.Parent = CoreGui

local main = Instance.new("Frame") main.Size = UDim2.fromOffset(700, 480) main.Position = UDim2.new(0.5, -350, 0.5, -240) main.BackgroundColor3 = BG_DARK main.BorderSizePixel = 0 main.Parent = screenGui

local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = main

local stroke = Instance.new("UIStroke") stroke.Color = BG_LIGHT stroke.Thickness = 1 stroke.Parent = main

local titleBar = Instance.new("Frame") titleBar.Size = UDim2.new(1, 0, 0, 35) titleBar.BackgroundColor3 = BG_LIGHT titleBar.BorderSizePixel = 0 titleBar.Parent = main

local titleLabel = Instance.new("TextLabel") titleLabel.Size = UDim2.new(1, -20, 1, 0) titleLabel.Position = UDim2.fromOffset(10, 0) titleLabel.BackgroundTransparency = 1 titleLabel.Text = "Zuka's Gem" titleLabel.Font = Enum.Font.RobotoMono titleLabel.TextColor3 = ACCENT titleLabel.TextSize = 13 titleLabel.TextXAlignment = Enum.TextXAlignment.Left titleLabel.Parent = titleBar

local sidebar = Instance.new("Frame") sidebar.Size = UDim2.new(0, 200, 1, -35) sidebar.Position = UDim2.fromOffset(0, 35) sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18) sidebar.BorderSizePixel = 0 sidebar.Parent = main

local scanBtn = Instance.new("TextButton") scanBtn.Size = UDim2.new(1, -10, 0, 30) scanBtn.Position = UDim2.fromOffset(5, 5) scanBtn.BackgroundColor3 = BG_LIGHT scanBtn.Text = "SCAN ENVIRONMENT" scanBtn.Font = Enum.Font.RobotoMono scanBtn.TextColor3 = ACCENT scanBtn.TextSize = 10 scanBtn.Parent = sidebar

local moduleList = Instance.new("ScrollingFrame") moduleList.Size = UDim2.new(1, -10, 1, -45) moduleList.Position = UDim2.fromOffset(5, 40) moduleList.BackgroundTransparency = 1 moduleList.ScrollBarThickness = 2 moduleList.ScrollBarImageColor3 = ACCENT moduleList.AutomaticCanvasSize = Enum.AutomaticSize.Y moduleList.CanvasSize = UDim2.new(0, 0, 0, 0) moduleList.Parent = sidebar

local moduleLayout = Instance.new("UIListLayout") moduleLayout.Padding = UDim.new(0, 2) moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder moduleLayout.Parent = moduleList

local viewport = Instance.new("Frame") viewport.Size = UDim2.new(1, -200, 1, -35) viewport.Position = UDim2.fromOffset(200, 35) viewport.BackgroundTransparency = 1 viewport.Parent = main

local functionList = Instance.new("ScrollingFrame") functionList.Size = UDim2.new(0.5, -10, 0.7, -10) functionList.Position = UDim2.fromOffset(5, 5) functionList.BackgroundColor3 = BG_LIGHT functionList.BorderSizePixel = 0 functionList.ScrollBarThickness = 2 functionList.AutomaticCanvasSize = Enum.AutomaticSize.Y functionList.Parent = viewport

local functionLayout = Instance.new("UIListLayout") functionLayout.Padding = UDim.new(0, 2) functionLayout.Parent = functionList

local upvalueList = Instance.new("ScrollingFrame") upvalueList.Size = UDim2.new(0.5, -10, 0.7, -10) upvalueList.Position = UDim2.new(0.5, 5, 0, 5) upvalueList.BackgroundColor3 = BG_LIGHT upvalueList.BorderSizePixel = 0 upvalueList.ScrollBarThickness = 2 upvalueList.AutomaticCanvasSize = Enum.AutomaticSize.Y upvalueList.Parent = viewport

local upvalueLayout = Instance.new("UIListLayout") upvalueLayout.Padding = UDim.new(0, 2) upvalueLayout.Parent = upvalueList

local controlPanel = Instance.new("Frame") controlPanel.Size = UDim2.new(1, -10, 0.3, -10) controlPanel.Position = UDim2.new(0, 5, 0.7, 5) controlPanel.BackgroundColor3 = BG_LIGHT controlPanel.BorderSizePixel = 0 controlPanel.Parent = viewport

local function applyStyle(obj: GuiObject) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 2) c.Parent = obj end

applyStyle(functionList) applyStyle(upvalueList) applyStyle(controlPanel) applyStyle(scanBtn)

local function getHeuristicScore(mod: ModuleScript): number local score = 0 for word, weight in pairs(HEURISTIC_KEYWORDS) do if string.find(mod.Name, word) then score += weight end end local success, result = pcall(function() return require(mod) end) if success and type(result) == "table" then for key, _ in pairs(result) do for word, weight in pairs(HEURISTIC_KEYWORDS) do if string.find(tostring(key), word) then score += weight end end end end return score end

local function setTableReadOnly(tbl: table, state: boolean) if setreadonly then setreadonly(tbl, state) elseif getrawmetatable then local mt = getrawmetatable(tbl) if mt then setreadonly(mt, state) end end end

local function updateUpvalues(func: any) for _, v in ipairs(upvalueList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end if type(func) ~= "function" or not debug.getupvalues then return end

for i, v in ipairs(debug.getupvalues(func)) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -5, 0, 25)
	b.BackgroundTransparency = 1
	b.Text = string.format("  [%d] %s: %s", i, tostring(v), type(v))
	b.Font = Enum.Font.RobotoMono
	b.TextColor3 = TEXT_SECONDARY
	b.TextSize = 11
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Parent = upvalueList
end
end

local function updateFunctions(mod: ModuleScript) for _, v in ipairs(functionList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end local success, tbl = pcall(require, mod) if not success or type(tbl) ~= "table" then return end State.SelectedTable = tbl

for k, v in pairs(tbl) do
	if type(v) == "function" then
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -5, 0, 25)
		b.BackgroundTransparency = 1
		b.Text = "  " .. tostring(k)
		b.Font = Enum.Font.RobotoMono
		b.TextColor3 = TEXT_SECONDARY
		b.TextSize = 11
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Parent = functionList
		
		b.MouseButton1Click:Connect(function()
			State.SelectedFunction = tostring(k)
			for _, x in ipairs(functionList:GetChildren()) do if x:IsA("TextButton") then x.TextColor3 = TEXT_SECONDARY end end
			b.TextColor3 = ACCENT
			updateUpvalues(v)
		end)
	end
end
end

local function updateModulesUI() for _, v in ipairs(moduleList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for i, m in ipairs(State.FoundModules) do local b = Instance.new("TextButton") b.Size = UDim2.new(1, -5, 0, 30) b.BackgroundTransparency = 1 b.Text = " " .. m.Name b.Font = Enum.Font.RobotoMono b.TextColor3 = TEXT_SECONDARY b.TextSize = 11 b.TextXAlignment = Enum.TextXAlignment.Left b.Parent = moduleList b.LayoutOrder = i

	b.MouseButton1Click:Connect(function()
		State.SelectedModule = m
		for _, x in ipairs(moduleList:GetChildren()) do if x:IsA("TextButton") then x.TextColor3 = TEXT_SECONDARY end end
		b.TextColor3 = ACCENT
		updateFunctions(m)
	end)
end
end

local function scan() scanBtn.Text = "SCANNING..." scanBtn.TextColor3 = TEXT_SECONDARY

task.spawn(function()
	table.clear(State.FoundModules)
	local temp = {}
	local roots = {ReplicatedStorage, Players.LocalPlayer:FindFirstChild("PlayerScripts"), game:GetService("ReplicatedFirst"), workspace}
	
	for _, root in ipairs(roots) do
		if not root then continue end
		for _, v in ipairs(root:GetDescendants()) do
			if v:IsA("ModuleScript") then
				local score = getHeuristicScore(v)
				table.insert(temp, {Obj = v, Score = score})
			end
		end
		task.wait()
	end
	
	table.sort(temp, function(a, b) return a.Score > b.Score end)
	for _, data in ipairs(temp) do table.insert(State.FoundModules, data.Obj) end
	
	updateModulesUI()
	scanBtn.Text = "SCAN ENVIRONMENT"
	scanBtn.TextColor3 = ACCENT
end)
end

local function createPoison(original: (...any) -> ...any, name: string, modName: string) return function(...) local args = {...} local mode = State.SelectedMode

	if mode == "Log: Minimal" then
		print("[!] ARCHITECT // Call:", modName, "->", name)
	elseif mode == "Log: Deep (Args)" then
		print("[!] ARCHITECT // Call:", modName, "->", name, "Args:", args)
	elseif mode == "Log: Network Trace" then
		print("[!] ARCHITECT // Tracing Traceback for", name, ":", debug.traceback())
	elseif mode == "Return: Nil" then return nil
	elseif mode == "Return: True" then return true
	elseif mode == "Return: False" then return false
	elseif mode == "Logic: Infinite Yield" then task.wait(9e9)
	elseif mode == "Logic: Force Error" then error("CRITICAL_LOGIC_FAULT")
	elseif mode == "Logic: No-Op" then return
	end
	
	return original(unpack(args))
end
end

local applyBtn = Instance.new("TextButton") applyBtn.Size = UDim2.new(0.5, -5, 0.4, -5) applyBtn.Position = UDim2.fromOffset(5, 5) applyBtn.BackgroundColor3 = BG_DARK applyBtn.Text = "INJECT POISON" applyBtn.Font = Enum.Font.RobotoMono applyBtn.TextColor3 = ACCENT applyBtn.TextSize = 12 applyBtn.Parent = controlPanel applyStyle(applyBtn)

local modeBtn = Instance.new("TextButton") modeBtn.Size = UDim2.new(0.5, -5, 0.4, -5) modeBtn.Position = UDim2.new(0.5, 5, 0, 5) modeBtn.BackgroundColor3 = BG_DARK modeBtn.Text = "MODE: " .. State.SelectedMode modeBtn.Font = Enum.Font.RobotoMono modeBtn.TextColor3 = TEXT_PRIMARY modeBtn.TextSize = 10 modeBtn.Parent = controlPanel applyStyle(modeBtn)

modeBtn.MouseButton1Click:Connect(function() local i = table.find(POISON_MODES, State.SelectedMode) or 1 State.SelectedMode = POISON_MODES[(i % #POISON_MODES) + 1] modeBtn.Text = "MODE: " .. State.SelectedMode end)

scanBtn.MouseButton1Click:Connect(function() scan() end)

applyBtn.MouseButton1Click:Connect(function() local m, f, t = State.SelectedModule, State.SelectedFunction, State.SelectedTable if not (m and f and t) then return end

local path = m:GetFullName()
if not Registry.Hooks[path] then Registry.Hooks[path] = {} end

local target = t
if not rawget(t, f) then
	local mt = getmetatable(t)
	if mt and type(mt.__index) == "table" then target = mt.__index end
end

setTableReadOnly(target, false)

if not Registry.Hooks[path][f] then
	Registry.Hooks[path][f] = {Original = target[f], Mode = State.SelectedMode}
end

target[f] = createPoison(Registry.Hooks[path][f].Original, f, m.Name)
Registry.Persistence[path .. f] = true
end)

local dragging, dInput, dStart, sPos titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dStart = i.Position sPos = main.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then dInput = i end end)

RunService.RenderStepped:Connect(function() if dragging and dInput then local delta = dInput.Position - dStart main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)

UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightAlt then screenGui.Enabled = not screenGui.Enabled end end)

scan()
