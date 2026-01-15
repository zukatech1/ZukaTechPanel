--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--// PLAYER
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// CONFIG
local VALID_KEY = "voidstar" -- CHANGE THIS
local DESTROY_ON_SUCCESS = true

--// GUI CREATION
local KeySystem = Instance.new("ScreenGui")
KeySystem.Name = "KeySystem"
KeySystem.ResetOnSpawn = false
KeySystem.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = KeySystem
Frame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Frame.BackgroundTransparency = 0.6
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.43, 0, 0.36, 0)
Frame.Size = UDim2.new(0, 294, 0, 283)

Instance.new("UICorner", Frame)

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Parent = Frame
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 0, -0.02, 0)
ImageLabel.Size = UDim2.new(0, 294, 0, 264)
ImageLabel.Image = "rbxassetid://86861658431277"
ImageLabel.ImageTransparency = 0.74
ImageLabel.ScaleType = Enum.ScaleType.Tile
Instance.new("UICorner", ImageLabel)
Instance.new("UIGradient", ImageLabel)

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeySystemBox"
KeyBox.Parent = Frame
KeyBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.BackgroundTransparency = 0.35
KeyBox.Position = UDim2.new(0.235, 0, 0.86, 0)
KeyBox.Size = UDim2.new(0, 155, 0, 30)
KeyBox.Font = Enum.Font.Arcade
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.TextWrapped = true
KeyBox.ClearTextOnFocus = false
Instance.new("UICorner", KeyBox)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.69, 0, -0.14, 0)
Title.Size = UDim2.new(0, 70, 0, 39)
Title.Text = "Zuka-Tech"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.TextTransparency = 0.39

local Status = Instance.new("TextLabel")
Status.Parent = Frame
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 1, 0)
Status.Size = UDim2.new(0, 294, 0, 21)
Status.Text = "Key Required"
Status.TextColor3 = Color3.new(1,1,1)
Status.TextSize = 20
Status.TextTransparency = 0.74

--// LOGIC
local function flashError()
	Status.Text = "Invalid Key"
	Status.TextColor3 = Color3.fromRGB(255, 80, 80)

	local t1 = TweenService:Create(
		KeyBox,
		TweenInfo.new(0.15),
		{BackgroundColor3 = Color3.fromRGB(120, 0, 0)}
	)
	t1:Play()

	task.delay(0.2, function()
		TweenService:Create(
			KeyBox,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
		):Play()
	end)
end

local function success()
	Status.Text = "Access Granted"
	Status.TextColor3 = Color3.fromRGB(0, 255, 140)

	local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	for _, v in ipairs(Frame:GetDescendants()) do
		if v:IsA("TextLabel") then
			TweenService:Create(v, fadeInfo, {TextTransparency = 1}):Play()
		elseif v:IsA("TextBox") then
			TweenService:Create(v, fadeInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		elseif v:IsA("ImageLabel") then
			TweenService:Create(v, fadeInfo, {ImageTransparency = 1}):Play()
		end
	end

	TweenService:Create(Frame, fadeInfo, {BackgroundTransparency = 1}):Play()

	task.delay(0.4, function()
		if DESTROY_ON_SUCCESS then
			KeySystem:Destroy()
		end
	end)

	-- 🔓 LOAD YOUR SCRIPT HERE
	print("Success!")

	loadstring(game:HttpGet("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Source.lua"))()
end

--// INPUT
KeyBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end

	local input = string.gsub(KeyBox.Text, "%s+", "")
	if input == VALID_KEY then
		success()
	else
		flashError()
	end
end)
