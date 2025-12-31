local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local SETTINGS = {
	MAX_AIR_TIME = 8,
	TP_THRESHOLD = 150,
	TOOL_GRAB_COOLDOWN = 0.5,
	RAYCAST_PARAMS = RaycastParams.new()
}
SETTINGS.RAYCAST_PARAMS.FilterType = Enum.RaycastFilterType.Exclude

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UI = {}
local PlayerData = {}
local MonitoringActive = true

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

local function MakeDraggable(frame)
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
UI.InputBox.PlaceholderText = "Commands: toggle, clear, check [name], stats..."
UI.InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
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
	logLabel.Text = "> " .. text
	logLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	logLabel.TextSize = 13
	logLabel.TextXAlignment = Enum.TextXAlignment.Left
	logLabel.RichText = true
	UI.LogContainer.CanvasPosition = Vector2.new(0, UI.LogContainer.AbsoluteCanvasSize.Y)
end

local function ApplyESP(player: Player)
	if not player.Character then return end
	local character = player.Character
	if not character:FindFirstChild("ExploiterHighlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "ExploiterHighlight"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.Adornee = character
		highlight.Parent = character

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ExploiterTag"
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
		billboard.AlwaysOnTop = true
		billboard.ExtentsOffset = Vector3.new(0, 3, 0)
		billboard.Parent = character

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "[ EXPLOITER ]\n" .. player.Name
		label.TextColor3 = Color3.fromRGB(255, 0, 0)
		label.TextStrokeTransparency = 0
		label.Font = Enum.Font.Code
		label.TextSize = 14
		label.Parent = billboard
	end
end

local function InitPlayerData(player: Player)
	if player == LocalPlayer then return end
	PlayerData[player] = {
		LastPosition = nil,
		LastUpdate = tick(),
		AirTime = 0,
		IsFlagged = false,
		SpawnTime = tick(),
		LastToolTime = 0
	}

	local function CheckInventory(child)
		if child:IsA("Tool") then
			local data = PlayerData[player]
			if not data then return end
			local currentTime = tick()
			if currentTime - data.LastToolTime < SETTINGS.TOOL_GRAB_COOLDOWN then
				AddToLog("[SUSPICIOUS] " .. player.Name .. " acquired tool instantly: " .. child.Name, Color3.fromRGB(255, 200, 0))
			else
				AddToLog("[INFO] " .. player.Name .. " grabbed: " .. child.Name, Color3.fromRGB(200, 200, 200))
			end
			data.LastToolTime = currentTime
		end
	end

	player.CharacterAdded:Connect(function(char)
		char.ChildAdded:Connect(CheckInventory)
	end)

	local backpack = player:WaitForChild("Backpack", 5)
	if backpack then
		backpack.ChildAdded:Connect(CheckInventory)
	end
end

local function CheckNoclip(player: Player, startPos: Vector3, endPos: Vector3): boolean
	local direction = (endPos - startPos)
	if direction.Magnitude < 1.5 or direction.Magnitude > 30 then return false end
	SETTINGS.RAYCAST_PARAMS.FilterDescendantsInstances = {player.Character, Workspace.CurrentCamera}
	local result = Workspace:Raycast(startPos, direction, SETTINGS.RAYCAST_PARAMS)
	if result and result.Instance and result.Instance.CanCollide then
		local checkBack = Workspace:Raycast(endPos, -direction, SETTINGS.RAYCAST_PARAMS)
		if checkBack and checkBack.Instance == result.Instance then
			return true
		end
	end
	return false
end

local function MonitorPlayers()
	if not MonitoringActive then return end
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 then continue end
		local data = PlayerData[player]
		if not data then InitPlayerData(player) continue end
		if tick() - data.SpawnTime < 3 then 
			data.LastPosition = root.Position
			data.LastUpdate = tick()
			continue 
		end

		local currentPos = root.Position
		local currentTime = tick()
		local deltaTime = currentTime - data.LastUpdate
		
		if data.LastPosition and deltaTime > 0 and deltaTime < 0.5 then
			local distance = (currentPos - data.LastPosition).Magnitude
			local verticalDiff = math.abs(currentPos.Y - data.LastPosition.Y)

			if distance > SETTINGS.TP_THRESHOLD then
				AddToLog("[CRITICAL] " .. player.Name .. " DETECTED: CFrame Teleport (" .. math.floor(distance) .. " studs)", Color3.fromRGB(255, 50, 50))
				data.IsFlagged = true
			end

			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
				data.AirTime += deltaTime
				if data.AirTime > SETTINGS.MAX_AIR_TIME and verticalDiff < 1.5 and not humanoid.Sit then
					AddToLog("[CRITICAL] " .. player.Name .. " DETECTED: Abnormal Hover/Flight", Color3.fromRGB(255, 50, 50))
					data.IsFlagged = true
				end
			else
				data.AirTime = 0
			end

			if CheckNoclip(player, data.LastPosition, currentPos) and not humanoid.Sit then
				AddToLog("[CRITICAL] " .. player.Name .. " DETECTED: Noclip Logic", Color3.fromRGB(255, 50, 50))
				data.IsFlagged = true
			end
		end
		
		if data.IsFlagged then ApplyESP(player) end
		data.LastPosition = currentPos
		data.LastUpdate = currentTime
	end
end

UI.ExitButton.MouseButton1Click:Connect(function()
	UI.ScreenGui:Destroy()
end)

Players.PlayerAdded:Connect(InitPlayerData)
Players.PlayerRemoving:Connect(function(p) PlayerData[p] = nil end)
for _, player in ipairs(Players:GetPlayers()) do InitPlayerData(player) end

RunService.Heartbeat:Connect(MonitorPlayers)
AddToLog("Forensic CFrame & Inventory Monitor v3.1 Online.", Color3.fromRGB(0, 255, 255))