type ModuleScript = any
type GuiObject = any
type GuiButton = any

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local customPoisons: {[string]: {[string]: (...any) -> ...any}} = {

}

local SCAN_TARGET: Instance = ReplicatedStorage

local BLACKLISTED_MODULE_NAMES: {[string]: boolean} = {
	["Settings"] = true, ["CoreScript"] = true, ["Action"] = true, ["PurchasePrompt"] = true,
	["PlayerSetting"] = true, ["Interaction"] = true, ["Camera"] = true, ["Keyboard"] = true,
	["Mouse"] = true, ["MasterControl"] = true, ["ControlModule"] = true, ["VehicleController"] = true
}

local TOGGLE_KEY: Enum.KeyCode = Enum.KeyCode.RightAlt
local GUI_ACCENT_COLOR: Color3 = Color3.fromRGB(255, 0, 85)
local GUI_BACKGROUND_COLOR: Color3 = Color3.fromRGB(35, 35, 45)
local GUI_ITEM_COLOR: Color3 = Color3.fromRGB(50, 50, 60)
local MIN_GUI_SIZE: Vector2 = Vector2.new(450, 300)

local POISON_TYPES = {"Log Call", "Return Nil", "Return True", "Return False", "No-Op"}

local foundModules: {ModuleScript} = {}
local selectedModule: ModuleScript? = nil
local selectedModuleTable: {[string]: any}? = nil
local selectedFunctionName: string? = nil
local selectedPoisonType: string = POISON_TYPES[1]
local originalFunctions: {[string]: {[string]: (...any) -> ...any}} = {}

local screenGui: ScreenGui = Instance.new("ScreenGui")
screenGui.Name = "ModulePoisonerv5"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.ResetOnSpawn = false

local mainFrame: Frame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 400)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
mainFrame.BackgroundColor3 = GUI_BACKGROUND_COLOR
mainFrame.BorderColor3 = GUI_ACCENT_COLOR
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local topBar: Frame = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = GUI_ACCENT_COLOR
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLabel: TextLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundColor3 = GUI_ACCENT_COLOR
titleLabel.Text = "meth n around v2"
titleLabel.Font = Enum.Font.Code
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 18
titleLabel.Parent = topBar

local moduleList: ScrollingFrame = Instance.new("ScrollingFrame")
moduleList.Name = "ModuleList"
moduleList.Size = UDim2.new(0.5, -10, 1, -85)
moduleList.Position = UDim2.new(0, 5, 0, 40)
moduleList.BackgroundColor3 = GUI_ITEM_COLOR
moduleList.BorderSizePixel = 0
moduleList.AutomaticCanvasSize = Enum.AutomaticSize.Y
moduleList.ScrollBarImageColor3 = GUI_ACCENT_COLOR
moduleList.Parent = mainFrame

local functionList: ScrollingFrame = Instance.new("ScrollingFrame")
functionList.Name = "FunctionList"
functionList.Size = UDim2.new(0.5, -10, 1, -85)
functionList.Position = UDim2.new(0.5, 5, 0, 40)
functionList.BackgroundColor3 = GUI_ITEM_COLOR
functionList.BorderSizePixel = 0
functionList.AutomaticCanvasSize = Enum.AutomaticSize.Y
functionList.ScrollBarImageColor3 = GUI_ACCENT_COLOR
functionList.Parent = mainFrame

local moduleListLayout = Instance.new("UIListLayout")
moduleListLayout.Padding = UDim.new(0, 5)
moduleListLayout.SortOrder = Enum.SortOrder.LayoutOrder
moduleListLayout.Parent = moduleList

local functionListLayout = Instance.new("UIListLayout")
functionListLayout.Padding = UDim.new(0, 5)
functionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
functionListLayout.Parent = functionList

local bottomBar = Instance.new("Frame")
bottomBar.Name = "BottomBar"
bottomBar.Size = UDim2.new(1, 0, 0, 45)
bottomBar.Position = UDim2.new(0, 0, 1, -45)
bottomBar.BackgroundTransparency = 1
bottomBar.Parent = mainFrame

local bottomBarPadding = Instance.new("UIPadding")
bottomBarPadding.PaddingLeft = UDim.new(0, 5)
bottomBarPadding.PaddingRight = UDim.new(0, 5)
bottomBarPadding.Parent = bottomBar

local bottomBarLayout = Instance.new("UIListLayout")
bottomBarLayout.FillDirection = Enum.FillDirection.Horizontal
bottomBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
bottomBarLayout.Padding = UDim.new(0, 5)
bottomBarLayout.Parent = bottomBar

local scanButton: TextButton = Instance.new("TextButton")
scanButton.Name = "ScanButton"
scanButton.LayoutOrder = 1
scanButton.Size = UDim2.new(0.3, 0, 1, 0)
scanButton.BackgroundColor3 = GUI_ACCENT_COLOR
scanButton.Text = "Scan"
scanButton.Font = Enum.Font.Code
scanButton.TextColor3 = Color3.new(1, 1, 1)
scanButton.TextSize = 16
scanButton.Parent = bottomBar

local poisonDropdownFrame = Instance.new("Frame")
poisonDropdownFrame.Name = "PoisonDropdownFrame"
poisonDropdownFrame.LayoutOrder = 2
poisonDropdownFrame.Size = UDim2.new(0.4, 0, 1, 0)
poisonDropdownFrame.BackgroundTransparency = 1
poisonDropdownFrame.ZIndex = 2
poisonDropdownFrame.Parent = bottomBar

local poisonDropdownButton = Instance.new("TextButton")
poisonDropdownButton.Name = "PoisonDropdownButton"
poisonDropdownButton.Size = UDim2.new(1, 0, 1, 0)
poisonDropdownButton.BackgroundColor3 = GUI_ITEM_COLOR
poisonDropdownButton.Text = selectedPoisonType
poisonDropdownButton.Font = Enum.Font.Code
poisonDropdownButton.TextColor3 = Color3.new(1, 1, 1)
poisonDropdownButton.TextSize = 14
poisonDropdownButton.Parent = poisonDropdownFrame

local poisonDropdownList = Instance.new("ScrollingFrame")
poisonDropdownList.Name = "PoisonDropdownList"
poisonDropdownList.Visible = false
poisonDropdownList.Size = UDim2.new(1, 0, 0, 120)
poisonDropdownList.AnchorPoint = Vector2.new(0, 1)
poisonDropdownList.Position = UDim2.new(0, 0, 0, -5)
poisonDropdownList.BackgroundColor3 = GUI_ITEM_COLOR
poisonDropdownList.BackgroundTransparency = 0.5
poisonDropdownList.BorderSizePixel = 0
poisonDropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
poisonDropdownList.ScrollBarImageColor3 = GUI_ACCENT_COLOR
poisonDropdownList.ZIndex = 4
poisonDropdownList.Parent = poisonDropdownFrame

local poisonListLayout = Instance.new("UIListLayout")
poisonListLayout.Parent = poisonDropdownList

for _, poisonType in ipairs(POISON_TYPES) do
	local optionButton = Instance.new("TextButton")
	optionButton.Name = poisonType
	optionButton.Size = UDim2.new(1, 0, 0, 25)
	optionButton.BackgroundColor3 = GUI_ITEM_COLOR
	optionButton.Text = poisonType
	optionButton.Font = Enum.Font.Code
	optionButton.TextColor3 = Color3.new(1, 1, 1)
	optionButton.TextSize = 12
	optionButton.Parent = poisonDropdownList
	
	optionButton.MouseButton1Click:Connect(function()
		selectedPoisonType = poisonType
		poisonDropdownButton.Text = poisonType
		poisonDropdownList.Visible = false
	end)
end

poisonDropdownButton.MouseButton1Click:Connect(function()
	poisonDropdownList.Visible = not poisonDropdownList.Visible
end)

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.LayoutOrder = 3
applyButton.Size = UDim2.new(0.15, 0, 1, 0)
applyButton.BackgroundColor3 = GUI_ITEM_COLOR
applyButton.Text = "Apply"
applyButton.Font = Enum.Font.Code
applyButton.TextColor3 = Color3.new(1, 1, 1)
applyButton.TextSize = 16
applyButton.Parent = bottomBar

local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreButton"
restoreButton.LayoutOrder = 4
restoreButton.Size = UDim2.new(0.15, 0, 1, 0)
restoreButton.BackgroundColor3 = GUI_ITEM_COLOR
restoreButton.Text = "Restore"
restoreButton.Font = Enum.Font.Code
restoreButton.TextColor3 = Color3.new(1, 1, 1)
restoreButton.TextSize = 16
restoreButton.Parent = bottomBar

local resizeHandle = Instance.new("ImageButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 15, 0, 15)
resizeHandle.AnchorPoint = Vector2.new(1, 1)
resizeHandle.Position = UDim2.new(1, 0, 1, 0)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Image = "rbxassetid://5970223694"
resizeHandle.ImageColor3 = GUI_ACCENT_COLOR
resizeHandle.ZIndex = 2
resizeHandle.Parent = mainFrame

local notificationLabel: TextLabel = Instance.new("TextLabel")
notificationLabel.Name = "NotificationLabel"
notificationLabel.Size = UDim2.new(1, 0, 0, 30)
notificationLabel.Position = UDim2.new(0, 0, -1, 0)
notificationLabel.BackgroundColor3 = GUI_ACCENT_COLOR
notificationLabel.BorderSizePixel = 0
notificationLabel.Font = Enum.Font.Code
notificationLabel.Text = "Notification"
notificationLabel.TextColor3 = Color3.new(1, 1, 1)
notificationLabel.TextSize = 16
notificationLabel.Visible = false
notificationLabel.ZIndex = 3
notificationLabel.Parent = mainFrame

local itemTemplate: TextButton = Instance.new("TextButton")
itemTemplate.Size = UDim2.new(1, -10, 0, 30)
itemTemplate.BackgroundColor3 = GUI_BACKGROUND_COLOR
itemTemplate.Font = Enum.Font.Code
itemTemplate.TextSize = 14
itemTemplate.TextColor3 = Color3.new(1, 1, 1)
itemTemplate.TextXAlignment = Enum.TextXAlignment.Left

local padding: UIPadding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 5)
padding.Parent = itemTemplate

local isResizing = false
local resizeStart: Vector2
local initialSize: Vector2

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isResizing = true
		resizeStart = UserInputService:GetMouseLocation()
		initialSize = mainFrame.AbsoluteSize
		
		local connection
		connection = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
				isResizing = false
				connection:Disconnect()
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouseLocation = UserInputService:GetMouseLocation()
		local delta = mouseLocation - resizeStart
		local newSize = initialSize + delta
		
		local clampedX = math.max(newSize.X, MIN_GUI_SIZE.X)
		local clampedY = math.max(newSize.Y, MIN_GUI_SIZE.Y)
		
		mainFrame.Size = UDim2.fromOffset(clampedX, clampedY)
	end
end)

local function showNotification(text: string)
	notificationLabel.Text = text
	notificationLabel.Visible = true
	notificationLabel.Position = UDim2.new(0, 0, -1, 0)
	notificationLabel.TextTransparency = 0
	
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local appearTween = TweenService:Create(notificationLabel, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
	appearTween:Play()
	
	task.wait(2)
	
	local fadeTween = TweenService:Create(notificationLabel, tweenInfo, {TextTransparency = 1})
	fadeTween:Play()
	fadeTween.Completed:Wait()
	notificationLabel.Visible = false
end

local function clearList(list: GuiObject): ()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function scanForModules(): ()
	table.clear(foundModules)
	local function search(instance: Instance): ()
		if BLACKLISTED_MODULE_NAMES[instance.Name] then return end
		local success, result = pcall(function()
			if instance:IsA("ModuleScript") then
				table.insert(foundModules, instance)
			end
			for _, child in ipairs(instance:GetChildren()) do
				search(child)
			end
		end)
	end
	search(SCAN_TARGET)
end

local function populateModuleList(): ()
	clearList(moduleList)
	clearList(functionList)
	selectedModule = nil
	selectedFunctionName = nil
	selectedModuleTable = nil

	for _, module in ipairs(foundModules) do
		local button: GuiButton = itemTemplate:Clone()
		local moduleFullName = module:GetFullName()
		button.Text = moduleFullName
		button.Parent = moduleList

		button.MouseButton1Click:Connect(function()
			selectedModule = module
			selectedFunctionName = nil
			clearList(functionList)
			
			local success, returned = pcall(require, module)
			if not success then return end

			local foundFunctions: {[string]: boolean} = {}
			local function addFunction(name: string)
				if foundFunctions[name] then return end
				foundFunctions[name] = true
				
				local funcButton: GuiButton = itemTemplate:Clone()
				funcButton.Text = tostring(name)
				funcButton.Parent = functionList
				
				funcButton.MouseButton1Click:Connect(function()
					selectedFunctionName = name
					for _, btn in ipairs(functionList:GetChildren()) do
						if btn:IsA("TextButton") then
							btn.BackgroundColor3 = GUI_BACKGROUND_COLOR
						end
					end
					funcButton.BackgroundColor3 = GUI_ACCENT_COLOR
				end)
			end
			
			local function findFunctionsInTable(tbl: {[string]: any})
				for name, value in pairs(tbl) do
					if type(value) == "function" then
						addFunction(tostring(name))
					end
				end
			end
			
			if type(returned) == "table" then
				selectedModuleTable = returned
				findFunctionsInTable(returned)
				local metatable = getmetatable(returned)
				if type(metatable) == "table" and type(metatable.__index) == "table" then
					findFunctionsInTable(metatable.__index)
				end
			end
		end)
	end
end

local function getTargetTable()
	if not selectedModuleTable or not selectedFunctionName then return nil end

	local originalTable = selectedModuleTable
	local metatable = getmetatable(originalTable)
	
	if rawget(originalTable, selectedFunctionName) then
		return originalTable
	elseif type(metatable) == "table" and type(metatable.__index) == "table" and rawget(metatable.__index, selectedFunctionName) then
		return metatable.__index
	end

	return nil
end

scanButton.MouseButton1Click:Connect(function()
	scanForModules()
	populateModuleList()
	showNotification("Scan complete. Found " .. #foundModules .. " modules in " .. SCAN_TARGET.Name .. ".")
end)

applyButton.MouseButton1Click:Connect(function()
	if not selectedModule or not selectedFunctionName then
		showNotification("Error: No module or function selected.")
		return
	end

	local targetTable = getTargetTable()
	if not targetTable then
		showNotification("Error: Could not find function in table.")
		return
	end

	local moduleFullName = selectedModule:GetFullName()
	if not originalFunctions[moduleFullName] then
		originalFunctions[moduleFullName] = {}
	end

	if not originalFunctions[moduleFullName][selectedFunctionName] then
		originalFunctions[moduleFullName][selectedFunctionName] = targetTable[selectedFunctionName]
	end

	local poisonFunction
	if selectedPoisonType == "Log Call" then
		poisonFunction = function(...)
			print("Poisoned function '" .. tostring(selectedFunctionName .. "' in " .. moduleFullName .. " was called."))
			return (originalFunctions[moduleFullName][selectedFunctionName](...))
		end
	elseif selectedPoisonType == "Return Nil" then
		poisonFunction = function(...) return nil end
	elseif selectedPoisonType == "Return True" then
		poisonFunction = function(...) return true end
	elseif selectedPoisonType == "Return False" then
		poisonFunction = function(...) return false end
	elseif selectedPoisonType == "No-Op" then
		poisonFunction = function(...) end
	end
	
	targetTable[selectedFunctionName] = poisonFunction
	showNotification("Applied '"..selectedPoisonType.."' to '" .. selectedFunctionName .. "'")
end)

restoreButton.MouseButton1Click:Connect(function()
	if not selectedModule or not selectedFunctionName then
		showNotification("Error: No module or function selected.")
		return
	end
	
	local targetTable = getTargetTable()
	if not targetTable then
		showNotification("Error: Could not find function in table.")
		return
	end
	
	local moduleFullName = selectedModule:GetFullName()
	local original = originalFunctions[moduleFullName] and originalFunctions[moduleFullName][selectedFunctionName]

	if original then
		targetTable[selectedFunctionName] = original
		showNotification("Restored function '" .. selectedFunctionName .. "'")
	else
		showNotification("Error: No original function saved for '" .. selectedFunctionName .. "'")
	end
end)

UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
	if not gameProcessed and input.KeyCode == TOGGLE_KEY then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

screenGui.Parent = CoreGui
showNotification("Module Poisoner v5 Loaded. Press RightAlt to toggle.")