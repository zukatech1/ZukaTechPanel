local CoreGui: CoreGui = game:GetService("CoreGui")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TweenService: TweenService = game:GetService("TweenService")
local RunService: RunService = game:GetService("RunService")
local HttpService: HttpService = game:GetService("HttpService")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst: ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players: Players = game:GetService("Players")

local ACCENT: Color3 = Color3.fromRGB(0, 255, 170)
local BG_DARK: Color3 = Color3.fromRGB(10, 10, 12)
local BG_LIGHT: Color3 = Color3.fromRGB(18, 18, 22)
local TEXT_PRIMARY: Color3 = Color3.fromRGB(255, 255, 255)
local TEXT_SECONDARY: Color3 = Color3.fromRGB(150, 150, 155)

local OFFICIAL_FILTER: {string} = {
	"Chat", "Roblox", "CorePackages", "CoreGui", "BubbleChat", "SocialPresence",
	"Roact", "Rodux", "Rhodium", "VoiceChat", "PlayerList", "InGameMenu"
}

local POISON_MODES: {string} = {
	"Log: Minimal", "Log: Deep (Args)", "Log: Traceback", 
	"Return: Nil", "Return: True", "Return: False", 
	"Logic: Infinite Yield", "Logic: Force Error", "Logic: No-Op"
}

local Registry: table = {
	Hooks = {},
	RemoteLogs = {},
	IgnoredRemotes = {},
	BlockedRemotes = {}
}

local State: table = {
	SelectedModule = nil,
	SelectedRemote = nil,
	SelectedTable = nil,
	SelectedFunction = nil,
	SelectedMode = POISON_MODES[1],
	FoundModules = {},
	ActiveTab = "Modules",
	Scanning = false,
	SpyEnabled = true
}

local screenGui: ScreenGui = Instance.new("ScreenGui")
screenGui.Name = HttpService:GenerateGUID(false)
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = CoreGui

local main: Frame = Instance.new("Frame")
main.Size = UDim2.fromOffset(850, 600)
main.Position = UDim2.new(0.5, -425, 0.5, -300)
main.BackgroundColor3 = BG_DARK
main.BorderSizePixel = 0
main.Parent = screenGui

local corner: UICorner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = main

local stroke: UIStroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(35, 35, 40)
stroke.Thickness = 1
stroke.Parent = main

local titleBar: Frame = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = BG_LIGHT
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleLabel: TextLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 250, 1, 0)
titleLabel.Position = UDim2.fromOffset(15, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ARCHITECT // OVERSEER V3"
titleLabel.Font = Enum.Font.RobotoMono
titleLabel.TextColor3 = ACCENT
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local tabContainer: Frame = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -260, 1, 0)
tabContainer.Position = UDim2.fromOffset(260, 0)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = titleBar

local tabLayout: UIListLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 20)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Parent = tabContainer

local function createTabBtn(name: string): TextButton
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.BackgroundTransparency = 1
	btn.Text = name:upper()
	btn.Font = Enum.Font.RobotoMono
	btn.TextColor3 = name == State.ActiveTab and ACCENT or TEXT_SECONDARY
	btn.TextSize = 12
	btn.Parent = tabContainer
	return btn
end

local modTab: TextButton = createTabBtn("Modules")
local remTab: TextButton = createTabBtn("Remotes")

local sidebar: Frame = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 260, 1, -45)
sidebar.Position = UDim2.fromOffset(0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local scanBtn: TextButton = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 35)
scanBtn.Position = UDim2.fromOffset(10, 10)
scanBtn.BackgroundColor3 = BG_LIGHT
scanBtn.Text = "REFRESH LIST"
scanBtn.Font = Enum.Font.RobotoMono
scanBtn.TextColor3 = ACCENT
scanBtn.TextSize = 11
scanBtn.Parent = sidebar

local listContainer: ScrollingFrame = Instance.new("ScrollingFrame")
listContainer.Size = UDim2.new(1, 0, 1, -65)
listContainer.Position = UDim2.fromOffset(0, 55)
listContainer.BackgroundTransparency = 1
listContainer.BorderSizePixel = 0
listContainer.ScrollBarThickness = 1
listContainer.ScrollBarImageColor3 = ACCENT
listContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
listContainer.Parent = sidebar

local listLayout: UIListLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = listContainer

local listPadding: UIPadding = Instance.new("UIPadding")
listPadding.PaddingLeft = UDim.new(0, 10)
listPadding.PaddingRight = UDim.new(0, 10)
listPadding.Parent = listContainer

local viewport: Frame = Instance.new("Frame")
viewport.Size = UDim2.new(1, -260, 1, -45)
viewport.Position = UDim2.fromOffset(260, 45)
viewport.BackgroundTransparency = 1
viewport.Parent = main

local modPanel: Frame = Instance.new("Frame")
modPanel.Size = UDim2.new(1, 0, 1, 0)
modPanel.BackgroundTransparency = 1
modPanel.Parent = viewport

local remPanel: Frame = Instance.new("Frame")
remPanel.Size = UDim2.new(1, 0, 1, 0)
remPanel.BackgroundTransparency = 1
remPanel.Visible = false
remPanel.Parent = viewport

local function createScrollList(parent: GuiObject, size: UDim2, pos: UDim2): ScrollingFrame
	local sf = Instance.new("ScrollingFrame")
	sf.Size = size
	sf.Position = pos
	sf.BackgroundColor3 = BG_LIGHT
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 1
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.Parent = parent
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, 2)
	l.Parent = sf
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, 8)
	p.PaddingTop = UDim.new(0, 5)
	p.Parent = sf
	return sf
end

local funcList: ScrollingFrame = createScrollList(modPanel, UDim2.new(0.5, -15, 0.6, -15), UDim2.fromOffset(10, 10))
local upList: ScrollingFrame = createScrollList(modPanel, UDim2.new(0.5, -15, 0.6, -15), UDim2.new(0.5, 5, 0, 10))
local modControl: Frame = Instance.new("Frame")
modControl.Size = UDim2.new(1, -20, 0.4, -20)
modControl.Position = UDim2.new(0, 10, 0.6, 10)
modControl.BackgroundColor3 = BG_LIGHT
modControl.BorderSizePixel = 0
modControl.Parent = modPanel

local remoteLogList: ScrollingFrame = createScrollList(remPanel, UDim2.new(1, -20, 0.5, -20), UDim2.fromOffset(10, 10))
local remoteControl: Frame = Instance.new("Frame")
remoteControl.Size = UDim2.new(1, -20, 0.5, -20)
remoteControl.Position = UDim2.new(0, 10, 0.5, 10)
remoteControl.BackgroundColor3 = BG_LIGHT
remoteControl.BorderSizePixel = 0
remoteControl.Parent = remPanel

local function applyStyle(obj: GuiObject): nil
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 4)
	c.Parent = obj
end

applyStyle(funcList)
applyStyle(upList)
applyStyle(modControl)
applyStyle(remoteLogList)
applyStyle(remoteControl)
applyStyle(scanBtn)

local injectBtn: TextButton = Instance.new("TextButton")
injectBtn.Size = UDim2.new(0.5, -15, 0, 45)
injectBtn.Position = UDim2.fromOffset(10, 10)
injectBtn.BackgroundColor3 = BG_DARK
injectBtn.Text = "INJECT POISON"
injectBtn.Font = Enum.Font.RobotoMono
injectBtn.TextColor3 = ACCENT
injectBtn.TextSize = 13
injectBtn.Parent = modControl
applyStyle(injectBtn)

local modeBtn: TextButton = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.5, -15, 0, 45)
modeBtn.Position = UDim2.new(0.5, 5, 0, 10)
modeBtn.BackgroundColor3 = BG_DARK
modeBtn.Text = State.SelectedMode
modeBtn.Font = Enum.Font.RobotoMono
modeBtn.TextColor3 = TEXT_PRIMARY
modeBtn.TextSize = 11
modeBtn.Parent = modControl
applyStyle(modeBtn)

local clearSpyBtn: TextButton = Instance.new("TextButton")
clearSpyBtn.Size = UDim2.new(0.5, -15, 0, 35)
clearSpyBtn.Position = UDim2.fromOffset(10, 10)
clearSpyBtn.BackgroundColor3 = BG_DARK
clearSpyBtn.Text = "CLEAR SPY LOGS"
clearSpyBtn.Font = Enum.Font.RobotoMono
clearSpyBtn.TextColor3 = ACCENT
clearSpyBtn.TextSize = 11
clearSpyBtn.Parent = remoteControl
applyStyle(clearSpyBtn)

local spyToggleBtn: TextButton = Instance.new("TextButton")
spyToggleBtn.Size = UDim2.new(0.5, -15, 0, 35)
spyToggleBtn.Position = UDim2.new(0.5, 5, 0, 10)
spyToggleBtn.BackgroundColor3 = BG_DARK
spyToggleBtn.Text = "SPY: ENABLED"
spyToggleBtn.Font = Enum.Font.RobotoMono
spyToggleBtn.TextColor3 = ACCENT
spyToggleBtn.TextSize = 11
spyToggleBtn.Parent = remoteControl
applyStyle(spyToggleBtn)

local blockBtn: TextButton = Instance.new("TextButton")
blockBtn.Size = UDim2.new(0.5, -15, 0, 40)
blockBtn.Position = UDim2.fromOffset(10, 55)
blockBtn.BackgroundColor3 = BG_DARK
blockBtn.Text = "BLOCK REMOTE"
blockBtn.Font = Enum.Font.RobotoMono
blockBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
blockBtn.TextSize = 12
blockBtn.Parent = remoteControl
applyStyle(blockBtn)

local fireBtn: TextButton = Instance.new("TextButton")
fireBtn.Size = UDim2.new(0.5, -15, 0, 40)
fireBtn.Position = UDim2.new(0.5, 5, 0, 55)
fireBtn.BackgroundColor3 = BG_DARK
fireBtn.Text = "FIRE REMOTE"
fireBtn.Font = Enum.Font.RobotoMono
fireBtn.TextColor3 = ACCENT
fireBtn.TextSize = 12
fireBtn.Parent = remoteControl
applyStyle(fireBtn)

local argInput: TextBox = Instance.new("TextBox")
argInput.Size = UDim2.new(1, -20, 0, 110)
argInput.Position = UDim2.fromOffset(10, 105)
argInput.BackgroundColor3 = BG_DARK
argInput.BorderSizePixel = 0
argInput.Text = "[ \"Argument1\", 100, true ]"
argInput.PlaceholderText = "Arguments (JSON Array)"
argInput.Font = Enum.Font.RobotoMono
argInput.TextColor3 = TEXT_PRIMARY
argInput.TextSize = 10
argInput.TextXAlignment = Enum.TextXAlignment.Left
argInput.TextYAlignment = Enum.TextYAlignment.Top
argInput.ClearTextOnFocus = false
argInput.MultiLine = true
argInput.Parent = remoteControl
applyStyle(argInput)

local function isOfficialModule(obj: Instance): boolean
	local fullName: string = obj:GetFullName()
	for _: number, pattern: string in ipairs(OFFICIAL_FILTER) do
		if fullName:find(pattern) then return true end
	end
	return false
end

local function logRemote(remote: Instance, method: string, args: table): nil
	if not State.SpyEnabled then return end
	local logFrame = Instance.new("Frame")
	logFrame.Size = UDim2.new(1, -10, 0, 60)
	logFrame.BackgroundColor3 = BG_DARK
	logFrame.BorderSizePixel = 0
	logFrame.Parent = remoteLogList
	applyStyle(logFrame)
	local rName = Instance.new("TextLabel")
	rName.Size = UDim2.new(1, -10, 0, 25)
	rName.Position = UDim2.fromOffset(10, 5)
	rName.BackgroundTransparency = 1
	rName.Text = string.format("[%s] %s", method, remote.Name)
	rName.Font = Enum.Font.RobotoMono
	rName.TextColor3 = ACCENT
	rName.TextSize = 11
	rName.TextXAlignment = Enum.TextXAlignment.Left
	rName.Parent = logFrame
	local rArgs = Instance.new("TextBox")
	rArgs.Size = UDim2.new(1, -20, 0, 20)
	rArgs.Position = UDim2.fromOffset(10, 30)
	rArgs.BackgroundTransparency = 1
	rArgs.Text = "Args: " .. HttpService:JSONEncode(args)
	rArgs.ClearTextOnFocus = false
	rArgs.TextEditable = false
	rArgs.Font = Enum.Font.RobotoMono
	rArgs.TextColor3 = TEXT_SECONDARY
	rArgs.TextSize = 10
	rArgs.TextXAlignment = Enum.TextXAlignment.Left
	rArgs.Parent = logFrame
end

local function hookRemotes(): nil
	local mt: table = getrawmetatable(game)
	local oldNamecall: any = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self: any, ...: any)
		local method: string = getnamecallmethod()
		local args: table = {...}
		if (method == "FireServer" or method == "InvokeServer") then
			if Registry.BlockedRemotes[self] then return nil end
			task.spawn(logRemote, self, method, args)
		end
		return oldNamecall(self, ...)
	end)
	setreadonly(mt, true)
end

local function updateFunctions(mod: ModuleScript): nil
	for _: number, v: Instance in ipairs(funcList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	local success: boolean, tbl: any = pcall(require, mod)
	if not success or type(tbl) ~= "table" then return end
	State.SelectedTable = tbl
	for k: any, v: any in pairs(tbl) do
		if type(v) == "function" then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, 0, 0, 30)
			b.BackgroundTransparency = 1
			b.Text = tostring(k)
			b.Font = Enum.Font.RobotoMono
			b.TextColor3 = TEXT_SECONDARY
			b.TextSize = 11
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.Parent = funcList
			b.MouseButton1Click:Connect(function()
				State.SelectedFunction = tostring(k)
				for _: number, x: Instance in ipairs(funcList:GetChildren()) do if x:IsA("TextButton") then x.TextColor3 = TEXT_SECONDARY end end
				b.TextColor3 = ACCENT
				for _: number, up: Instance in ipairs(upList:GetChildren()) do if up:IsA("TextLabel") then up:Destroy() end end
				local getUp = debug.getupvalues or getupvalues
				if getUp then
					pcall(function()
						for i, val in ipairs(getUp(v)) do
							local l = Instance.new("TextLabel")
							l.Size = UDim2.new(1, 0, 0, 20)
							l.BackgroundTransparency = 1
							l.Text = string.format("[%d] %s (%s)", i, tostring(val), type(val))
							l.Font = Enum.Font.RobotoMono
							l.TextColor3 = TEXT_SECONDARY
							l.TextSize = 10
							l.TextXAlignment = Enum.TextXAlignment.Left
							l.Parent = upList
						end
					end)
				end
			end)
		end
	end
end

local function refreshList(): nil
	if State.Scanning then return end
	State.Scanning = true
	scanBtn.Text = "FILTERING ENGINE..."
	for _: number, v: Instance in ipairs(listContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	task.spawn(function()
		local objects: {Instance} = {}
		local searchScope: {Instance} = {ReplicatedStorage, ReplicatedFirst, Players.LocalPlayer:WaitForChild("PlayerScripts")}
		
		for _: number, service: Instance in ipairs(searchScope) do
			for _: number, v: Instance in ipairs(service:GetDescendants()) do
				if not isOfficialModule(v) then
					if State.ActiveTab == "Modules" and v:IsA("ModuleScript") then
						table.insert(objects, v)
					elseif State.ActiveTab == "Remotes" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
						table.insert(objects, v)
					end
				end
			end
		end

		for _: number, obj: Instance in ipairs(objects) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, 0, 0, 32)
			b.BackgroundTransparency = 1
			b.Text = obj.Name
			b.Font = Enum.Font.RobotoMono
			b.TextColor3 = TEXT_SECONDARY
			b.TextSize = 10
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.Parent = listContainer
			b.MouseButton1Click:Connect(function()
				for _: number, x: Instance in ipairs(listContainer:GetChildren()) do if x:IsA("TextButton") then x.TextColor3 = TEXT_SECONDARY end end
				b.TextColor3 = ACCENT
				if State.ActiveTab == "Modules" then
					State.SelectedModule = obj
					updateFunctions(obj)
				else
					State.SelectedRemote = obj
					blockBtn.Text = Registry.BlockedRemotes[obj] and "UNBLOCK REMOTE" or "BLOCK REMOTE"
				end
			end)
		end
		scanBtn.Text = "REFRESH LIST"
		State.Scanning = false
	end)
end

modTab.MouseButton1Click:Connect(function()
	State.ActiveTab = "Modules"
	modPanel.Visible = true
	remPanel.Visible = false
	modTab.TextColor3 = ACCENT
	remTab.TextColor3 = TEXT_SECONDARY
	refreshList()
end)

remTab.MouseButton1Click:Connect(function()
	State.ActiveTab = "Remotes"
	modPanel.Visible = false
	remPanel.Visible = true
	modTab.TextColor3 = TEXT_SECONDARY
	remTab.TextColor3 = ACCENT
	refreshList()
end)

blockBtn.MouseButton1Click:Connect(function()
	if not State.SelectedRemote then return end
	Registry.BlockedRemotes[State.SelectedRemote] = not Registry.BlockedRemotes[State.SelectedRemote]
	blockBtn.Text = Registry.BlockedRemotes[State.SelectedRemote] and "UNBLOCK REMOTE" or "BLOCK REMOTE"
end)

fireBtn.MouseButton1Click:Connect(function()
	if not State.SelectedRemote then return end
	local success: boolean, args: table = pcall(function() return HttpService:JSONDecode(argInput.Text) end)
	if success and type(args) == "table" then
		if State.SelectedRemote:IsA("RemoteEvent") then
			State.SelectedRemote:FireServer(unpack(args))
		elseif State.SelectedRemote:IsA("RemoteFunction") then
			task.spawn(function() State.SelectedRemote:InvokeServer(unpack(args)) end)
		end
	end
end)

clearSpyBtn.MouseButton1Click:Connect(function()
	for _: number, v: Instance in ipairs(remoteLogList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
end)

spyToggleBtn.MouseButton1Click:Connect(function()
	State.SpyEnabled = not State.SpyEnabled
	spyToggleBtn.Text = State.SpyEnabled and "SPY: ENABLED" or "SPY: DISABLED"
	spyToggleBtn.TextColor3 = State.SpyEnabled and ACCENT or Color3.fromRGB(200, 50, 50)
end)

scanBtn.MouseButton1Click:Connect(refreshList)

injectBtn.MouseButton1Click:Connect(function()
	local m: ModuleScript, f: string, t: table = State.SelectedModule, State.SelectedFunction, State.SelectedTable
	if not (m and f and t) then return end
	local target: table = t
	if not rawget(t, f) then
		local mt: table = getmetatable(t)
		if mt and type(mt.__index) == "table" then target = mt.__index end
	end
	local setRO: any = setreadonly or (make_writeable and function(tbl: table, state: boolean) if state then make_writeable(tbl) else make_readonly(tbl) end end)
	if setRO then pcall(setRO, target, false) end
	target[f] = function(...: any)
		local args: table = {...}
		local mode: string = State.SelectedMode
		if mode == "Log: Minimal" then print("[ARCHITECT]", m.Name, "->", f) end
		if mode == "Return: Nil" then return nil end
		return target[f](unpack(args))
	end
	injectBtn.Text = "POISONED"
	task.delay(1, function() injectBtn.Text = "INJECT POISON" end)
end)

modeBtn.MouseButton1Click:Connect(function()
	local idx: number = table.find(POISON_MODES, State.SelectedMode) or 1
	State.SelectedMode = POISON_MODES[(idx % #POISON_MODES) + 1]
	modeBtn.Text = State.SelectedMode
end)

local function setupDraggable(): nil
	local dragging: boolean, dragInput: InputObject, dragStart: Vector3, startPos: UDim2
	titleBar.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	main.InputChanged:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input: InputObject)
		if input == dragInput and dragging then
			local delta: Vector3 = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

setupDraggable()
pcall(hookRemotes)
refreshList()

UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
	if not processed and input.KeyCode == Enum.KeyCode.RightAlt then
		screenGui.Enabled = not screenGui.Enabled
	end
end)
