--[[
made by zuka @OverZuka on roblox
Loadstring Command - loadstring(game:HttpGet("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Source.lua"))()
--]]

local HttpService = game:GetService("HttpService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local PathService = game:GetService("PathfindingService")
local MarketplaceService = game:GetService("MarketplaceService")


do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    local ContentProvider = game:GetService("ContentProvider")

    local THEME = {
        Title = "Welcome back king.",
        Subtitle = "Made by @OverZuka — We're so back...",
        IconAssetId = "rbxassetid://7243158473",

        BackgroundColor = Color3.fromRGB(15, 15, 20),
        AccentColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(240, 240, 240),

        FadeInTime = 0.45,
        HoldTime = 1.2,
        FadeOutTime = 0.35
    }


    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "SplashScreen_" .. math.random(1000, 9999)
    splashGui.IgnoreGuiInset = true
    splashGui.ResetOnSpawn = false
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    splashGui.Parent = CoreGui


    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = THEME.BackgroundColor
    background.BackgroundTransparency = 1
    background.Parent = splashGui


    local blur = Instance.new("BlurEffect")
    blur.Size = 1
    blur.Parent = Lighting


    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(320, 260)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    card.BackgroundTransparency = 1
    card.Parent = background
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = THEME.AccentColor
    stroke.Transparency = 1
    stroke.Parent = card

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(96, 96)
    icon.Position = UDim2.fromScale(0.5, 0.32)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 0.5
    icon.ImageColor3 = THEME.AccentColor
    icon.Image = THEME.IconAssetId
    icon.Parent = card


    pcall(function()
        ContentProvider:PreloadAsync({ icon })
    end)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 36)
    title.Position = UDim2.fromScale(0.5, 0.62)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Oswald
    title.Text = THEME.Title
    title.TextSize = 27
    title.TextColor3 = THEME.TextColor
    title.TextTransparency = 0.6
    title.Parent = card

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 24)
    subtitle.Position = UDim2.fromScale(0.5, 0.75)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Bangers
    subtitle.Text = THEME.Subtitle
    subtitle.TextSize = 14
    subtitle.TextColor3 = THEME.TextColor
    subtitle.TextTransparency = 0
    subtitle.Parent = card

    -- Anim start scale
    card.Size = card.Size - UDim2.fromOffset(40, 40)

    local tweenIn = TweenInfo.new(THEME.FadeInTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tweenOut = TweenInfo.new(THEME.FadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    TweenService:Create(background, tweenIn, { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(blur, tweenIn, { Size = 16 }):Play()
    TweenService:Create(card, tweenIn, { Size = UDim2.fromOffset(320, 260) }):Play()
    TweenService:Create(icon, tweenIn, { ImageTransparency = 0 }):Play()
    TweenService:Create(title, tweenIn, { TextTransparency = 0 }):Play()
    TweenService:Create(subtitle, tweenIn, { TextTransparency = 0.25 }):Play()

    task.wait(THEME.FadeInTime + THEME.HoldTime)

    TweenService:Create(background, tweenOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(blur, tweenOut, { Size = 0 }):Play()
    TweenService:Create(icon, tweenOut, { ImageTransparency = 1 }):Play()
    TweenService:Create(title, tweenOut, { TextTransparency = 1 }):Play()
    TweenService:Create(subtitle, tweenOut, { TextTransparency = 1 }):Play()

    task.wait(THEME.FadeOutTime)

    blur:Destroy()
    splashGui:Destroy()
end


local Utilities = {}
function Utilities.findPlayer(inputName)
    local input = tostring(inputName):lower()
    if input == "" then return nil end
        local exactMatch = nil
        local partialMatch = nil
        if input == "me" then return Players.LocalPlayer end
            for _, player in ipairs(Players:GetPlayers()) do
                local username = player.Name:lower()
                local displayName = player.DisplayName:lower()
                if username == input or displayName == input then
                    exactMatch = player
                    break
                end
                if not partialMatch then
                    if username:sub(1, #input) == input or displayName:sub(1, #input) == input then
                        partialMatch = player
                    end
                end
            end
            return exactMatch or partialMatch
        end
        function Utilities.findPlayer(inputName)
    local input = tostring(inputName):lower()
    if input == "" then return nil end
    local exactMatch = nil
    local partialMatch = nil
    if input == "me" then return Players.LocalPlayer end
    for _, player in ipairs(Players:GetPlayers()) do
        local username = player.Name:lower()
        local displayName = player.DisplayName:lower()
        if username == input or displayName == input then
            exactMatch = player
            break
        end
        if not partialMatch then
            if username:sub(1, #input) == input or displayName:sub(1, #input) == input then
                partialMatch = player
            end
        end
    end
    return exactMatch or partialMatch
end

function Utilities.calculateLevenshteinDistance(s1: string, s2: string): number
    local len1, len2 = #s1, #s2
    if len1 == 0 then return len2 end
    if len2 == 0 then return len1 end

    local matrix = {}
    for i = 0, len1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (s1:sub(i, i) == s2:sub(j, j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )
        end
    end

    return matrix[len1][len2]
end
        local Prefix = ";"
        local Commands = {}
        local CommandInfo = {}
        local Modules = {}
        local NotificationManager = {}
        do
            local queue = {}
            local isActive = false
            local tweenService = game:GetService("TweenService")
            local coreGui = game:GetService("CoreGui")
            local textService = game:GetService("TextService")
            local notifGui = Instance.new("ScreenGui", coreGui)
            notifGui.Name = "ZukaNotifGui_v2"
            notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            notifGui.ResetOnSpawn = false
            local function processNext()
            if isActive or #queue == 0 then
                return
            end
            isActive = true
            local data = table.remove(queue, 1)
            local text, duration = data[1], data[2]
            local notif = Instance.new("TextLabel")
            notif.Font = Enum.Font.GothamSemibold
            notif.TextSize = 12
            notif.Text = text
            notif.TextWrapped = true
            notif.Size = UDim2.fromOffset(300, 0)
            local textBounds = textService:GetTextSize(notif.Text, notif.TextSize, notif.Font, Vector2.new(notif.Size.X.Offset, 1000))
            local verticalPadding = 20
            notif.Size = UDim2.fromOffset(300, textBounds.Y + verticalPadding)
            notif.Position = UDim2.new(0.5, -150, 0, -60)
            notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            local corner = Instance.new("UICorner", notif)
            corner.CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", notif)
            stroke.Color = Color3.fromRGB(80, 80, 100)
            notif.Parent = notifGui
            local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local goalIn = { Position = UDim2.new(0.5, -150, 0, 10) }
            local goalOut = { Position = UDim2.new(0.5, -150, 0, -60) }
            local inTween = tweenService:Create(notif, tweenInfoIn, goalIn)
            inTween:Play()
            inTween.Completed:Wait()
            task.wait(duration)
            local outTween = tweenService:Create(notif, tweenInfoOut, goalOut)
            outTween:Play()
            outTween.Completed:Wait()
            notif:Destroy()
            isActive = false
            task.spawn(processNext)
        end
        function NotificationManager.Send(text, duration)
            table.insert(queue, {tostring(text), duration or 1})
            task.spawn(processNext)
        end
    end
    function DoNotif(text, duration)
        NotificationManager.Send(text, duration)
    end
    function RegisterCommand(info, func)
        if not info or not info.Name or not func then
            warn("Command registration failed: Missing info, name, or function.")
            return
        end
        local name = info.Name:lower()
        if Commands[name] then
            warn("Command registration skipped: Command '" .. name .. "' already exists.")
            return
        end
        Commands[name] = func
        if info.Aliases then
            for _, alias in ipairs(info.Aliases) do
                local aliasLower = alias:lower()
                if Commands[aliasLower] then
                    warn("Alias '" .. aliasLower .. "' for command '" .. name .. "' conflicts with an existing command and was not registered.")
                else
                Commands[aliasLower] = func
            end
        end
    end
    table.insert(CommandInfo, info)
end

local function loadAimbotGUI(args)


	local CoreGui = game:GetService("CoreGui")

	if CoreGui:FindFirstChild("UTS_CGE_Suite") and not args then
		if DoNotif then
			DoNotif("Aimbot GUI is already open.", 2)
		else
			warn("Aimbot GUI is already open.")
		end
		return
	end
	
	if CoreGui:FindFirstChild("UTS_CGE_Suite") then
	end

	local success, err = pcall(function()
		-- Services
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local Players = game:GetService("Players")
		local Workspace = game:GetService("Workspace")
		local TweenService = game:GetService("TweenService")

		local LocalPlayer = Players.LocalPlayer
		local Camera = Workspace.CurrentCamera
		
		local janitor = {}

local function SetupSilentAimHook(): () -> ()
    if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then
        warn("Zuka's Analysis: Silent Aim dependencies (e.g., getrawmetatable) not found. Silent Aim will be disabled.")
        return function() end
    end

    local gameMetatable: {} = getrawmetatable(game)
    local originalNamecall = gameMetatable.__namecall
    
    local success, err = pcall(function()
        setreadonly(gameMetatable, false)
        gameMetatable.__namecall = newcclosure(function(...)
            local args: {any} = {...}
            local self: Instance = args[1]
            local method: string = getnamecallmethod()
            local targetPosition: Vector3 = getgenv().ZukaSilentAimTarget

            if getgenv().silentAimEnabled and targetPosition and self == Workspace then
                if method == "Raycast" then
                    local origin: any, direction: any = args[2], args[3]
                    if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                        local newDirection: Vector3 = (targetPosition - origin).Unit * direction.Magnitude
                        args[3] = newDirection
                    end
                elseif method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" then
                    local rayArg: any = args[2]
                    if typeof(rayArg) == "Ray" then
                        local newRay: Ray = Ray.new(rayArg.Origin, (targetPosition - rayArg.Origin).Unit * 1000)
                        args[2] = newRay
                    end
                end
            end
            
            return originalNamecall(unpack(args))
        end)
        setreadonly(gameMetatable, true)
    end)

    if not success then
        warn("Zuka's Analysis: Failed to hook __namecall.", err)
        pcall(setreadonly, gameMetatable, false)
        gameMetatable.__namecall = originalNamecall
        pcall(setreadonly, gameMetatable, true)
        return function() end
    end

    return function()
        pcall(function()
            setreadonly(gameMetatable, false)
            gameMetatable.__namecall = originalNamecall
            setreadonly(gameMetatable, true)
        end)
    end
end

		local cleanupSilentAimHook = SetupSilentAimHook()

		local function makeUICorner(element, cornerRadius)
			local corner = Instance.new("UICorner");
			corner.CornerRadius = UDim.new(0, cornerRadius or 6);
			corner.Parent = element
		end

		local MainScreenGui = CoreGui:FindFirstChild("UTS_CGE_Suite") or Instance.new("ScreenGui");
		MainScreenGui.Name = "UTS_CGE_Suite";
		MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		MainScreenGui.ResetOnSpawn = false;

		if not MainScreenGui.Parent then
			table.insert(janitor, MainScreenGui.Destroying:Connect(function()
				cleanupSilentAimHook()
				for _, connection in ipairs(janitor) do
					connection:Disconnect()
				end
			end))
			MainScreenGui.Parent = CoreGui;
		end
		
		local MainWindow = MainScreenGui:FindFirstChild("MainWindow")
		if MainWindow then MainWindow:Destroy() end -- Destroy old window to redraw

		getgenv().TargetScope = Workspace
		getgenv().TargetIndex = {}
		getgenv().silentAimEnabled = false
		getgenv().ZukaSilentAimTarget = nil
		
		local explorerWindow = nil
		local function createExplorerWindow(statusLabel, indexerUpdateSignal)
			-- This function remains unchanged
			if explorerWindow and explorerWindow.Parent then
				explorerWindow.Visible = not explorerWindow.Visible;
				return explorerWindow
			end
			local explorerFrame = Instance.new("Frame");
			explorerFrame.Name = "ExplorerWindow";
			explorerFrame.Size = UDim2.new(0, 300, 0, 450);
			explorerFrame.Position = UDim2.new(0.5, 305, 0.5, -225);
			explorerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45);
			explorerFrame.BorderSizePixel = 1;
			explorerFrame.BorderColor3 = Color3.fromRGB(80, 80, 80);
			explorerFrame.Draggable = true;
			explorerFrame.Active = true;
			explorerFrame.ClipsDescendants = true;
			explorerFrame.Parent = MainScreenGui;
			makeUICorner(explorerFrame, 8);
			local topBar = Instance.new("Frame", explorerFrame);
			topBar.Name = "TopBar";
			topBar.Size = UDim2.new(1, 0, 0, 30);
			topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35);
			makeUICorner(topBar, 8);
			local title = Instance.new("TextLabel", topBar);
			title.Size = UDim2.new(1, -30, 1, 0);
			title.Position = UDim2.new(0, 10, 0, 0);
			title.BackgroundTransparency = 1;
			title.Font = Enum.Font.Code;
			title.Text = "Game Explorer";
			title.TextColor3 = Color3.fromRGB(200, 220, 255);
			title.TextSize = 16;
			title.TextXAlignment = Enum.TextXAlignment.Left;
			local closeButton = Instance.new("TextButton", topBar);
			closeButton.Size = UDim2.new(0, 24, 0, 24);
			closeButton.Position = UDim2.new(1, -28, 0.5, -12);
			closeButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80);
			closeButton.Font = Enum.Font.Code;
			closeButton.Text = "X";
			closeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
			closeButton.TextSize = 14;
			makeUICorner(closeButton, 6);
			table.insert(janitor, closeButton.MouseButton1Click:Connect(function() explorerFrame.Visible = false end));
			local treeScrollView = Instance.new("ScrollingFrame", explorerFrame);
			treeScrollView.Position = UDim2.new(0,0,0,30);
			treeScrollView.Size = UDim2.new(1, 0, 1, -30);
			treeScrollView.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
			treeScrollView.BorderSizePixel = 0;
			local uiListLayout = Instance.new("UIListLayout", treeScrollView);
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			uiListLayout.Padding = UDim.new(0, 1);
			local contextMenu = nil;
			local function closeContextMenu() if contextMenu and contextMenu.Parent then contextMenu:Destroy() end end;
			table.insert(janitor, UserInputService.InputBegan:Connect(function(input) if not (contextMenu and contextMenu:IsAncestorOf(input.UserInputType)) and input.UserInputType ~= Enum.UserInputType.MouseButton2 then closeContextMenu() end end));
			local function createTree(parentInstance, parentUi, indentLevel) for _, child in ipairs(parentInstance:GetChildren()) do local itemFrame = Instance.new("Frame");itemFrame.Name = child.Name;itemFrame.Size = UDim2.new(1, 0, 0, 22);itemFrame.BackgroundTransparency = 1;itemFrame.Parent = parentUi;local hasChildren = #child:GetChildren() > 0;local toggleButton = Instance.new("TextButton");toggleButton.Size = UDim2.new(0, 20, 0, 20);toggleButton.Position = UDim2.fromOffset(indentLevel * 12, 1);toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100);toggleButton.Font = Enum.Font.Code;toggleButton.TextSize = 14;toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255);toggleButton.Text = hasChildren and "[+]" or "[-]";toggleButton.Parent = itemFrame;local nameButton = Instance.new("TextButton");nameButton.Size = UDim2.new(1, -((indentLevel * 12) + 22), 0, 20);nameButton.Position = UDim2.fromOffset((indentLevel * 12) + 22, 1);nameButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70);nameButton.Font = Enum.Font.Code;nameButton.TextSize = 14;nameButton.TextColor3 = Color3.fromRGB(220, 220, 220);nameButton.Text = " " .. child.Name .. " [" .. child.ClassName .. "]";nameButton.TextXAlignment = Enum.TextXAlignment.Left;nameButton.Parent = itemFrame;local childContainer = Instance.new("Frame", itemFrame);childContainer.Name = "ChildContainer";childContainer.Size = UDim2.new(1, 0, 0, 0);childContainer.Position = UDim2.new(0, 0, 1, 0);childContainer.BackgroundTransparency = 1;childContainer.ClipsDescendants = true;local childLayout = Instance.new("UIListLayout", childContainer);childLayout.SortOrder = Enum.SortOrder.LayoutOrder;table.insert(janitor, itemFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() childContainer.Size = UDim2.new(1, 0, 0, childLayout.AbsoluteContentSize.Y);itemFrame.Size = UDim2.new(1, 0, 0, 22 + childContainer.AbsoluteSize.Y) end));table.insert(janitor, childLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() childContainer.Size = UDim2.new(1, 0, 0, childLayout.AbsoluteContentSize.Y);itemFrame.Size = UDim2.new(1, 0, 0, 22 + childContainer.AbsoluteSize.Y) end));table.insert(janitor, toggleButton.MouseButton1Click:Connect(function() local isExpanded = childContainer:FindFirstChildOfClass("Frame") ~= nil;if not hasChildren then return end;if isExpanded then for _, v in ipairs(childContainer:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end;toggleButton.Text = "[+]" else createTree(child, childContainer, indentLevel + 1);toggleButton.Text = "[-]" end end));table.insert(janitor, nameButton.MouseButton2Click:Connect(function() closeContextMenu();if child:IsA("Folder") or child:IsA("Model") or child:IsA("Workspace") then contextMenu = Instance.new("Frame");contextMenu.Size = UDim2.new(0, 150, 0, 30);contextMenu.Position = UDim2.fromOffset(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y);contextMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35);contextMenu.BorderSizePixel = 1;contextMenu.BorderColor3 = Color3.fromRGB(80, 80, 80);contextMenu.Parent = MainScreenGui;local setScopeBtn = Instance.new("TextButton", contextMenu);setScopeBtn.Size = UDim2.new(1, 0, 1, 0);setScopeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60);setScopeBtn.TextColor3 = Color3.fromRGB(200, 220, 255);setScopeBtn.Font = Enum.Font.Code;setScopeBtn.Text = "Set as Target Scope";table.insert(janitor, setScopeBtn.MouseButton1Click:Connect(function() getgenv().TargetScope = child;statusLabel.Text = "Scope set to: " .. child.Name;indexerUpdateSignal:Fire();closeContextMenu() end)) end end)) end end;
			createTree(game, treeScrollView, 0);
			explorerWindow = explorerFrame;
			return explorerFrame
		end

		MainWindow = Instance.new("Frame");
		MainWindow.Name = "MainWindow";
		MainWindow.Size = UDim2.new(0, 520, 0, 420);
		MainWindow.Position = UDim2.new(0.5, -260, 0.5, -210);
		MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 45);
		MainWindow.BorderSizePixel = 0;
		MainWindow.Active = true;
		MainWindow.ClipsDescendants = true;
		MainWindow.Parent = MainScreenGui;
		makeUICorner(MainWindow, 8);

		local isDragging = false;
		local dragStart, startPosition;
		table.insert(janitor, MainWindow.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDragging = true;
				dragStart = input.Position;
				startPosition = MainWindow.Position;
				local changedConn;
				changedConn = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						isDragging = false
						if changedConn then changedConn:Disconnect() end
					end
				end)
			end
		end));
		table.insert(janitor, UserInputService.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
				local delta = input.Position - dragStart;
				MainWindow.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			end
		end));

		local TopBar = Instance.new("Frame");
		TopBar.Name = "TopBar";
		TopBar.Size = UDim2.new(1, 0, 0, 30);
		TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35);
		TopBar.BorderSizePixel = 0;
		TopBar.Parent = MainWindow;
		makeUICorner(TopBar, 8);

		local TitleLabel = Instance.new("TextLabel");
		TitleLabel.Name = "TitleLabel";
		TitleLabel.Size = UDim2.new(1, -90, 1, 0);
		TitleLabel.Position = UDim2.new(0, 10, 0, 0);
		TitleLabel.BackgroundTransparency = 1;
		TitleLabel.Font = Enum.Font.Code;
		TitleLabel.Text = "Gaming Chair v2.2";
		TitleLabel.TextColor3 = Color3.fromRGB(200, 220, 255);
		TitleLabel.TextSize = 16;
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
		TitleLabel.Parent = TopBar;

		local CloseButton = Instance.new("TextButton");
		CloseButton.Name = "CloseButton";
		CloseButton.Size = UDim2.new(0, 24, 0, 24);
		CloseButton.Position = UDim2.new(1, -28, 0.5, -12);
		CloseButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80);
		CloseButton.Font = Enum.Font.Code;
		CloseButton.Text = "X";
		CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		CloseButton.TextSize = 14;
		CloseButton.Parent = TopBar;
		makeUICorner(CloseButton, 6);
		table.insert(janitor, CloseButton.MouseButton1Click:Connect(function() MainScreenGui:Destroy() end));

		local MinimizeButton = Instance.new("TextButton");
		MinimizeButton.Name = "MinimizeButton";
		MinimizeButton.Size = UDim2.new(0, 24, 0, 24);
		MinimizeButton.Position = UDim2.new(1, -56, 0.5, -12);
		MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100);
		MinimizeButton.Font = Enum.Font.Code;
		MinimizeButton.Text = "-";
		MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		MinimizeButton.TextSize = 14;
		MinimizeButton.Parent = TopBar;
		makeUICorner(MinimizeButton, 6);

		local ExplorerButton = Instance.new("TextButton");
		ExplorerButton.Name = "ExplorerButton";
		ExplorerButton.Size = UDim2.new(0, 24, 0, 24);
		ExplorerButton.Position = UDim2.new(1, -84, 0.5, -12);
		ExplorerButton.BackgroundColor3 = Color3.fromRGB(80, 120, 180);
		ExplorerButton.Font = Enum.Font.Code;
		ExplorerButton.Text = "E";
		ExplorerButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		ExplorerButton.TextSize = 14;
		ExplorerButton.Parent = TopBar;
		makeUICorner(ExplorerButton, 6)

		local ContentContainer = Instance.new("Frame");
		ContentContainer.Name = "ContentContainer";
		ContentContainer.Size = UDim2.new(1, 0, 1, -30);
		ContentContainer.Position = UDim2.new(0, 0, 0, 30);
		ContentContainer.BackgroundTransparency = 1;
		ContentContainer.Parent = MainWindow;

		local isMinimized = false;
		table.insert(janitor, MinimizeButton.MouseButton1Click:Connect(function()
			isMinimized = not isMinimized;
			ContentContainer.Visible = not isMinimized;
			if isMinimized then
				local tween = TweenService:Create(MainWindow, TweenInfo.new(0.2), {Size = UDim2.new(0, 200, 0, 30)})
				tween:Play()
				MinimizeButton.Text = "+"
			else
				local tween = TweenService:Create(MainWindow, TweenInfo.new(0.2), {Size = UDim2.new(0, 520, 0, 420)})
				tween:Play()
				MinimizeButton.Text = "-"
			end
		end));

		do
			local statusLabel, selectLabel;
			
			local AimbotPage = Instance.new("Frame", ContentContainer)
			AimbotPage.Name = "AimbotPage"
			AimbotPage.Size = UDim2.new(1, 0, 1, -50)
			AimbotPage.BackgroundTransparency = 1;
			
			local PagePadding = Instance.new("UIPadding", AimbotPage)
			PagePadding.PaddingTop = UDim.new(0, 10)
			PagePadding.PaddingLeft = UDim.new(0, 10)
			PagePadding.PaddingRight = UDim.new(0, 10)

			local LeftColumn = Instance.new("Frame", AimbotPage)
			LeftColumn.Name = "LeftColumn"
			LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
			LeftColumn.BackgroundTransparency = 1
			local LeftLayout = Instance.new("UIListLayout", LeftColumn)
			LeftLayout.Padding = UDim.new(0, 8)
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local RightColumn = Instance.new("Frame", AimbotPage)
			RightColumn.Name = "RightColumn"
			RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
			RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
			RightColumn.BackgroundTransparency = 1
			local RightLayout = Instance.new("UIListLayout", RightColumn)
			RightLayout.Padding = UDim.new(0, 8)
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			
			local StatusBar = Instance.new("Frame", ContentContainer)
			StatusBar.Name = "StatusBar"
			StatusBar.Size = UDim2.new(1, -20, 0, 40)
			StatusBar.Position = UDim2.new(0, 10, 1, -45)
			StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
			makeUICorner(StatusBar, 6)
			local StatusLayout = Instance.new("UIListLayout", StatusBar)
			StatusLayout.Padding = UDim.new(0, 2)
			local StatusPadding = Instance.new("UIPadding", StatusBar)
			StatusPadding.PaddingLeft = UDim.new(0, 8)
			StatusPadding.PaddingRight = UDim.new(0, 8)

			local function createSectionHeader(parent, text) local header = Instance.new("TextLabel", parent) header.Size = UDim2.new(1, 0, 0, 24) header.BackgroundTransparency = 1 header.Font = Enum.Font.Code header.Text = text header.TextColor3 = Color3.fromRGB(200, 220, 255) header.TextSize = 16 header.TextXAlignment = Enum.TextXAlignment.Left return header end
			local function createSettingRow(parent, labelText) local row = Instance.new("Frame", parent) row.Size = UDim2.new(1, 0, 0, 24) row.BackgroundTransparency = 1 local label = Instance.new("TextLabel", row) label.Size = UDim2.new(0.4, 0, 1, 0) label.BackgroundTransparency = 1 label.Font = Enum.Font.Code label.Text = labelText..":" label.TextColor3 = Color3.fromRGB(180, 220, 255) label.TextSize = 15 label.TextXAlignment = Enum.TextXAlignment.Left return row end

			createSectionHeader(LeftColumn, "General Settings")
			local toggleKeyRow = createSettingRow(LeftColumn, "Toggle Key")
			local toggleKeyBox = Instance.new("TextBox", toggleKeyRow)
			toggleKeyBox.Size, toggleKeyBox.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			toggleKeyBox.BackgroundColor3, toggleKeyBox.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			toggleKeyBox.Font, toggleKeyBox.TextSize, toggleKeyBox.Text = Enum.Font.Code, 15, "MouseButton2"
			makeUICorner(toggleKeyBox, 6)
			local aimPartRow = createSettingRow(LeftColumn, "Aim Part")
			local partDropdown = Instance.new("TextButton", aimPartRow)
			partDropdown.Size, partDropdown.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			partDropdown.BackgroundColor3, partDropdown.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			partDropdown.Font, partDropdown.TextSize, partDropdown.Text = Enum.Font.Code, 15, "Head"
			makeUICorner(partDropdown, 6)
			createSectionHeader(LeftColumn, "Field of View")
			local fovRow = createSettingRow(LeftColumn, "FOV Radius")
			local fovValueLabel = Instance.new("TextLabel", fovRow)
			fovValueLabel.Size, fovValueLabel.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			fovValueLabel.BackgroundTransparency, fovValueLabel.TextColor3 = 1, Color3.fromRGB(255,255,255)
			fovValueLabel.Font, fovValueLabel.TextSize = Enum.Font.Code, 15
			fovValueLabel.TextXAlignment, fovValueLabel.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Center
			local sliderTrack = Instance.new("Frame", LeftColumn)
			sliderTrack.Size, sliderTrack.BackgroundColor3 = UDim2.new(1, 0, 0, 4), Color3.fromRGB(20,20,30)
			sliderTrack.BorderSizePixel = 0
			makeUICorner(sliderTrack, 2)
			local sliderHandle = Instance.new("TextButton", sliderTrack)
			sliderHandle.Size, sliderHandle.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0.5, -6)
			sliderHandle.BackgroundColor3, sliderHandle.BorderSizePixel = Color3.fromRGB(180, 220, 255), 0
			sliderHandle.Text = ""
			makeUICorner(sliderHandle, 6)
			createSectionHeader(LeftColumn, "Smoothing")
			local smoothingToggle = Instance.new("TextButton", LeftColumn)
			smoothingToggle.Size, smoothingToggle.Text = UDim2.new(1, 0, 0, 28), "Smoothing: OFF"
			smoothingToggle.BackgroundColor3, smoothingToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			smoothingToggle.Font, smoothingToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(smoothingToggle, 6)
			local smoothingRow = createSettingRow(LeftColumn, "Smoothness")
			local smoothingValueLabel = Instance.new("TextLabel", smoothingRow)
			smoothingValueLabel.Size, smoothingValueLabel.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			smoothingValueLabel.BackgroundTransparency, smoothingValueLabel.TextColor3 = 1, Color3.fromRGB(255,255,255)
			smoothingValueLabel.Font, smoothingValueLabel.TextSize = Enum.Font.Code, 15
			smoothingValueLabel.TextXAlignment, smoothingValueLabel.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Center
			local smoothingSliderTrack = Instance.new("Frame", LeftColumn)
			smoothingSliderTrack.Size, smoothingSliderTrack.BackgroundColor3 = UDim2.new(1, 0, 0, 4), Color3.fromRGB(20,20,30)
			smoothingSliderTrack.BorderSizePixel = 0
			makeUICorner(smoothingSliderTrack, 2)
			local smoothingSliderHandle = Instance.new("TextButton", smoothingSliderTrack)
			smoothingSliderHandle.Size, smoothingSliderHandle.Position = UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0.5, -6)
			smoothingSliderHandle.BackgroundColor3, smoothingSliderHandle.BorderSizePixel = Color3.fromRGB(180, 220, 255), 0
			smoothingSliderHandle.Text = ""
			makeUICorner(smoothingSliderHandle, 6)
			createSectionHeader(RightColumn, "Targeting")
			local playerRow = createSettingRow(RightColumn, "Target Player")
			local playerDropdown = Instance.new("TextButton", playerRow)
			playerDropdown.Size, playerDropdown.Position = UDim2.new(0.6, 0, 1, 0), UDim2.new(0.4, 0, 0, 0)
			playerDropdown.BackgroundColor3, playerDropdown.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			playerDropdown.Font, playerDropdown.TextSize, playerDropdown.Text = Enum.Font.Code, 15, "None"
			makeUICorner(playerDropdown, 6)
			local targetPlayerToggle = Instance.new("TextButton", RightColumn)
			targetPlayerToggle.Size = UDim2.new(1, 0, 0, 28)
			targetPlayerToggle.BackgroundColor3, targetPlayerToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			targetPlayerToggle.Font, targetPlayerToggle.TextSize, targetPlayerToggle.Text = Enum.Font.Code, 15, "Target Selected: OFF"
			makeUICorner(targetPlayerToggle, 6)
			createSectionHeader(RightColumn, "Modifiers")
			local silentAimToggle = Instance.new("TextButton", RightColumn)
			silentAimToggle.Size, silentAimToggle.Text = UDim2.new(1, 0, 0, 28), "Silent Aim: OFF"
			silentAimToggle.BackgroundColor3, silentAimToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			silentAimToggle.Font, silentAimToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(silentAimToggle, 6)
			local ignoreTeamToggle = Instance.new("TextButton", RightColumn)
			ignoreTeamToggle.Size, ignoreTeamToggle.Text = UDim2.new(1, 0, 0, 28), "Ignore Team: OFF"
			ignoreTeamToggle.BackgroundColor3, ignoreTeamToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			ignoreTeamToggle.Font, ignoreTeamToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(ignoreTeamToggle, 6)
			local wallCheckToggle = Instance.new("TextButton", RightColumn)
			wallCheckToggle.Size, wallCheckToggle.Text = UDim2.new(1, 0, 0, 28), "Wall Check: ON"
			wallCheckToggle.BackgroundColor3, wallCheckToggle.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255)
			wallCheckToggle.Font, wallCheckToggle.TextSize = Enum.Font.Code, 15
			makeUICorner(wallCheckToggle, 6)
			statusLabel = Instance.new("TextLabel", StatusBar)
			statusLabel.Size, statusLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 18), 1
			statusLabel.TextColor3, statusLabel.Font, statusLabel.TextSize = Color3.fromRGB(180,220,180), Enum.Font.Code, 14
			statusLabel.Text = "Aimbot ready. Hold toggle key to aim."
			statusLabel.TextXAlignment = Enum.TextXAlignment.Left
			selectLabel = Instance.new("TextLabel", StatusBar)
			selectLabel.Size, selectLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 18), 1
			selectLabel.TextColor3, selectLabel.Font, selectLabel.TextSize = Color3.fromRGB(220,220,180), Enum.Font.Code, 14
			selectLabel.Text = "Press V to delete any block/model under mouse."
			selectLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local parts = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"};
			local partDropdownOpen, partDropdownFrame = false, nil;
			local playerDropdownOpen, playerDropdownFrame = false, nil;
			
			table.insert(janitor, UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if partDropdownOpen and not (input.SourceUserInputProcessor and (input.SourceUserInputProcessor:IsDescendantOf(partDropdownFrame) or input.SourceUserInputProcessor == partDropdown)) then
						if partDropdownFrame then partDropdownFrame:Destroy() end
						partDropdownOpen = false;
					end
					if playerDropdownOpen and not (input.SourceUserInputProcessor and (input.SourceUserInputProcessor:IsDescendantOf(playerDropdownFrame) or input.SourceUserInputProcessor == playerDropdown)) then
						if playerDropdownFrame then playerDropdownFrame:Destroy() end;
						playerDropdownOpen = false;
					end
				end
			end))

			table.insert(janitor, partDropdown.MouseButton1Click:Connect(function()
				if partDropdownOpen then if partDropdownFrame then partDropdownFrame:Destroy() end; partDropdownOpen = false; return end;
				partDropdownOpen = true;
				partDropdownFrame = Instance.new("Frame", AimbotPage);
				local absolutePos = partDropdown.AbsolutePosition; local guiPos = MainWindow.AbsolutePosition;
				partDropdownFrame.Size = UDim2.new(0, partDropdown.AbsoluteSize.X, 0, #parts * 22)
				partDropdownFrame.Position = UDim2.new(0, absolutePos.X - guiPos.X, 0, absolutePos.Y - guiPos.Y + 22)
				partDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); partDropdownFrame.BackgroundTransparency = 0.2; partDropdownFrame.BorderSizePixel = 0; partDropdownFrame.ZIndex = 5;
				makeUICorner(partDropdownFrame, 6); local stroke = Instance.new("UIStroke", partDropdownFrame); stroke.Color = Color3.fromRGB(80, 80, 90); stroke.Thickness = 1;
				for i, part in ipairs(parts) do local btn = Instance.new("TextButton", partDropdownFrame); btn.Size, btn.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, (i-1)*22); btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255); btn.Font, btn.TextSize, btn.Text = Enum.Font.Code, 15, part; makeUICorner(btn, 6); table.insert(janitor, btn.MouseButton1Click:Connect(function() partDropdown.Text = part; if partDropdownFrame then partDropdownFrame:Destroy() end; partDropdownOpen = false end)) end
			end));
			
			local fovRadius = 55;
			local smoothingEnabled = false;
			local smoothingFactor = 0.2;
			local selectedPlayerTarget, selectedPart = nil, nil;
			local playerTargetEnabled = false;
			local aiming = false;
			local ignoreTeamEnabled = false;
			local wallCheckEnabled = true;
			local wallCheckParams = RaycastParams.new();
			wallCheckParams.FilterType = Enum.RaycastFilterType.Exclude;
			local activeESPs = {};

			local FovCircle = nil
			if Drawing and typeof(Drawing.new) == "function" then FovCircle = Drawing.new("Circle"); FovCircle.Visible = false; FovCircle.Thickness = 1; FovCircle.NumSides = 64; FovCircle.Color = Color3.fromRGB(255, 255, 255); FovCircle.Transparency = 0.5; FovCircle.Filled = false; else warn("Zuka's Log: 'Drawing' library not found. FOV circle visualization will be disabled.") end
			local minFov, maxFov = 50, 500;
			local function updateFovFromHandlePosition() local trackWidth = sliderTrack.AbsoluteSize.X; local handleX = sliderHandle.Position.X.Offset; local ratio = math.clamp(handleX / (trackWidth - sliderHandle.AbsoluteSize.X), 0, 1); fovRadius = minFov + (maxFov - minFov) * ratio; fovValueLabel.Text = tostring(math.floor(fovRadius)) .. "px"; if FovCircle then FovCircle.Radius = fovRadius end end;
			local function updateHandleFromFovValue() local trackWidth = sliderTrack.AbsoluteSize.X; if trackWidth == 0 then return end; local ratio = (fovRadius - minFov) / (maxFov - minFov); local handleX = ratio * (trackWidth - sliderHandle.AbsoluteSize.X); sliderHandle.Position = UDim2.new(0, handleX, 0.5, -6) end;
			local isDraggingSlider = false;
			table.insert(janitor, sliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSlider = true end end));
			table.insert(janitor, UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSlider = false end end));
			table.insert(janitor, UserInputService.InputChanged:Connect(function(input) if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then local mouseX = UserInputService:GetMouseLocation().X; local trackStartX = sliderTrack.AbsolutePosition.X; local handleWidth = sliderHandle.AbsoluteSize.X; local trackWidth = sliderTrack.AbsoluteSize.X; local newHandleX = mouseX - trackStartX - (handleWidth / 2); local clampedX = math.clamp(newHandleX, 0, trackWidth - handleWidth); sliderHandle.Position = UDim2.new(0, clampedX, 0.5, -6); updateFovFromHandlePosition() end end));
			table.insert(janitor, smoothingToggle.MouseButton1Click:Connect(function() smoothingEnabled = not smoothingEnabled; smoothingToggle.Text = "Smoothing: " .. (smoothingEnabled and "ON" or "OFF") end));
			local minSmooth, maxSmooth = 0.05, 1.0;
			local function updateSmoothFromHandlePosition() local trackWidth = smoothingSliderTrack.AbsoluteSize.X; local handleX = smoothingSliderHandle.Position.X.Offset; local ratio = math.clamp(handleX / (trackWidth - smoothingSliderHandle.AbsoluteSize.X), 0, 1); smoothingFactor = minSmooth + (maxSmooth - minSmooth) * ratio; smoothingValueLabel.Text = string.format("%.2f", smoothingFactor) end;
			local function updateHandleFromSmoothValue() local trackWidth = smoothingSliderTrack.AbsoluteSize.X; if trackWidth == 0 then return end; local ratio = (smoothingFactor - minSmooth) / (maxSmooth - minSmooth); local handleX = ratio * (trackWidth - smoothingSliderHandle.AbsoluteSize.X); smoothingSliderHandle.Position = UDim2.new(0, handleX, 0.5, -6) end;
			local isDraggingSmoothSlider = false;
			table.insert(janitor, smoothingSliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSmoothSlider = true end end));
			table.insert(janitor, UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDraggingSmoothSlider = false end end));
			table.insert(janitor, UserInputService.InputChanged:Connect(function(input) if isDraggingSmoothSlider and input.UserInputType == Enum.UserInputType.MouseMovement then local mouseX = UserInputService:GetMouseLocation().X; local trackStartX = smoothingSliderTrack.AbsolutePosition.X; local handleWidth = smoothingSliderHandle.AbsoluteSize.X; local trackWidth = smoothingSliderTrack.AbsoluteSize.X; local newHandleX = mouseX - trackStartX - (handleWidth / 2); local clampedX = math.clamp(newHandleX, 0, trackWidth - handleWidth); smoothingSliderHandle.Position = UDim2.new(0, clampedX, 0.5, -6); updateSmoothFromHandlePosition() end end));
			task.wait();
			updateHandleFromFovValue(); updateFovFromHandlePosition(); updateHandleFromSmoothValue(); updateSmoothFromHandlePosition();
			local function isTeammate(player) if not ignoreTeamEnabled or not player then return false end; if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then return true end; if LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then return true end; return false end;
			local function isPartVisible(targetPart) if not LocalPlayer.Character or not targetPart or not targetPart.Parent then return false end; local targetCharacter = targetPart:FindFirstAncestorOfClass("Model") or targetPart.Parent; local origin = Camera.CFrame.Position; wallCheckParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}; local result = Workspace:Raycast(origin, targetPart.Position - origin, wallCheckParams); return not result end;
			local function manageESP(part, color, name) if not part or not part.Parent then return end; if activeESPs[part] then activeESPs[part].Color3, activeESPs[part].Name, activeESPs[part].Adornee, activeESPs[part].Size = color, name, part, part.Size else local espBox = Instance.new("BoxHandleAdornment"); espBox.Name, espBox.Adornee, espBox.AlwaysOnTop = name, part, true; espBox.ZIndex, espBox.Size, espBox.Color3 = 10, part.Size, color; espBox.Transparency, espBox.Parent = 0.4, part; activeESPs[part] = espBox end end;
			local function clearESP(part) if part then if activeESPs[part] then activeESPs[part]:Destroy(); activeESPs[part] = nil end else for _, espBox in pairs(activeESPs) do pcall(function() espBox:Destroy() end) end; activeESPs = {} end end;
			local function getClosestTargetInScope() local mousePos = UserInputService:GetMouseLocation(); local minDist, closestTargetModel = math.huge, nil; local aimPartName = partDropdown.Text; for _, model in ipairs(getgenv().TargetIndex) do if model and model.Parent then local player = Players:GetPlayerFromCharacter(model); if not (player and player == LocalPlayer) and not (player and isTeammate(player)) then local targetPart = model:FindFirstChild(aimPartName); if targetPart and (not wallCheckEnabled or isPartVisible(targetPart)) then local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position); if onScreen then local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude; if dist < minDist and dist <= fovRadius then minDist, closestTargetModel = dist, model end end end end end end; return closestTargetModel end;
			
			local function buildPlayerDropdownFrame()
				if playerDropdownFrame then playerDropdownFrame:Destroy() end;
				local playersList = Players:GetPlayers();
				playerDropdownFrame = Instance.new("Frame", AimbotPage);
				local absolutePos = playerDropdown.AbsolutePosition
				local guiPos = MainWindow.AbsolutePosition
				playerDropdownFrame.Size = UDim2.new(0, playerDropdown.AbsoluteSize.X, 0, #playersList * 22)
				playerDropdownFrame.Position = UDim2.new(0, absolutePos.X - guiPos.X, 0, absolutePos.Y - guiPos.Y + 22)
				playerDropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
				playerDropdownFrame.BackgroundTransparency = 0.2
				playerDropdownFrame.BorderSizePixel = 0;
				playerDropdownFrame.ZIndex = 5
				makeUICorner(playerDropdownFrame, 6);
                local stroke = Instance.new("UIStroke", playerDropdownFrame)
                stroke.Color = Color3.fromRGB(80, 80, 90)
                stroke.Thickness = 1
				for i, plr in ipairs(playersList) do
					local btn = Instance.new("TextButton", playerDropdownFrame);
					btn.Size, btn.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, (i-1)*22);
					btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(40,40,40), Color3.fromRGB(255,255,255);
					btn.Font, btn.TextSize, btn.Text = Enum.Font.Code, 15, plr.Name;
					makeUICorner(btn, 6);
					table.insert(janitor, btn.MouseButton1Click:Connect(function()
						selectedPlayerTarget, playerDropdown.Text = plr, plr.Name;
						if playerDropdownFrame then playerDropdownFrame:Destroy() end;
						playerDropdownOpen = false;
						if playerTargetEnabled then statusLabel.Text = "Aimbot: Will target " .. plr.Name end
					end))
				end
			end
			
			table.insert(janitor, targetPlayerToggle.MouseButton1Click:Connect(function()
				playerTargetEnabled = not playerTargetEnabled;
				targetPlayerToggle.Text = "Target Selected: " .. (playerTargetEnabled and "ON" or "OFF");
				if not playerTargetEnabled then statusLabel.Text = "Aimbot ready. Hold toggle key to aim." elseif selectedPlayerTarget then statusLabel.Text = "Aimbot: Will target " .. selectedPlayerTarget.Name end
			end));
			
			table.insert(janitor, playerDropdown.MouseButton1Click:Connect(function()
				if playerDropdownOpen then if playerDropdownFrame then playerDropdownFrame:Destroy() end; playerDropdownOpen = false; return end;
				playerDropdownOpen = true; buildPlayerDropdownFrame()
			end));
			table.insert(janitor, Players.PlayerAdded:Connect(function() if playerDropdownOpen then buildPlayerDropdownFrame() end end));
			table.insert(janitor, Players.PlayerRemoving:Connect(function(plr)
				if selectedPlayerTarget == plr then selectedPlayerTarget, playerDropdown.Text = nil, "None"; if playerTargetEnabled then playerTargetEnabled = false; targetPlayerToggle.Text = "Target Selected: OFF" end end;
				if playerDropdownOpen then buildPlayerDropdownFrame() end
			end));
			
			table.insert(janitor, UserInputService.InputBegan:Connect(function(input, processed) if processed or toggleKeyBox:IsFocused() then return end; if input.KeyCode == Enum.KeyCode.V then local target = LocalPlayer:GetMouse().Target; if target and target.Parent then local modelAncestor = target:FindFirstAncestorOfClass("Model"); if (modelAncestor and modelAncestor == LocalPlayer.Character) or target:IsDescendantOf(LocalPlayer.Character) then statusLabel.Text = "Cannot delete your own character."; return end; if modelAncestor and modelAncestor ~= Workspace then local modelName = modelAncestor.Name; modelAncestor:Destroy(); statusLabel.Text = "Deleted model: " .. modelName else if target.Parent ~= Workspace then local targetName = target.Name; target:Destroy(); statusLabel.Text = "Deleted part: " .. targetName else statusLabel.Text = "Cannot delete baseplate or map." end end else statusLabel.Text = "No target under mouse to delete." end end; local key = toggleKeyBox.Text:upper(); if (key == "MOUSEBUTTON2" and input.UserInputType == Enum.UserInputType.MouseButton2) or (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name:upper() == key) then aiming = true; if FovCircle then FovCircle.Visible = true end end end));
			table.insert(janitor, UserInputService.InputEnded:Connect(function(input) local key = toggleKeyBox.Text:upper(); if (key == "MOUSEBUTTON2" and input.UserInputType == Enum.UserInputType.MouseButton2) or (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name:upper() == key) then aiming = false; if FovCircle then FovCircle.Visible = false end; clearESP() end end));
			
			local currentTarget = nil
			table.insert(janitor, RunService.RenderStepped:Connect(function(deltaTime)
				if FovCircle and FovCircle.Visible then FovCircle.Position = UserInputService:GetMouseLocation() end
				local isCurrentTargetValid = currentTarget and currentTarget.Parent and currentTarget:FindFirstChildOfClass("Humanoid") and currentTarget:FindFirstChildOfClass("Humanoid").Health > 0
				if aiming and not isCurrentTargetValid then currentTarget = getClosestTargetInScope() elseif not aiming then currentTarget = nil end
				local aimPart, targetPlayer, targetModel = nil, nil, nil;
				local partsToDrawESPFor = {}
				if playerTargetEnabled and selectedPlayerTarget and selectedPlayerTarget.Character and selectedPlayerTarget ~= LocalPlayer then
					if not isTeammate(selectedPlayerTarget) then targetModel, targetPlayer = selectedPlayerTarget.Character, selectedPlayerTarget else targetModel = nil end
				elseif aiming and currentTarget then targetModel = currentTarget; targetPlayer = Players:GetPlayerFromCharacter(targetModel) end
				if targetModel then aimPart = targetModel:FindFirstChild(partDropdown.Text) end
				getgenv().ZukaSilentAimTarget = nil
				if aiming and aimPart and targetModel then
					if not wallCheckEnabled or isPartVisible(aimPart) then
						table.insert(partsToDrawESPFor, {Part = aimPart, Color = Color3.fromRGB(255, 80, 80), Name = "AimbotESP"});
						local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude;
						local predictionFactor = (distance / 2000) * (1 + (math.random(-50, 50) / 1000));
						local predictedPosition = aimPart.Position + (aimPart.AssemblyLinearVelocity * predictionFactor);
						if getgenv().silentAimEnabled then getgenv().ZukaSilentAimTarget = predictedPosition elseif smoothingEnabled then local goalCFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition); local adjustedSmoothFactor = math.clamp(1 - (1 - smoothingFactor) ^ (60 * deltaTime), 0, 1); Camera.CFrame = Camera.CFrame:Lerp(goalCFrame, adjustedSmoothFactor) else Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition) end;
						statusLabel.Text = "Aimbot: Targeting " .. (targetPlayer and targetPlayer.Name or targetModel.Name)
					else statusLabel.Text = "Aimbot: Target is behind a wall"; currentTarget = nil end
				elseif aiming then statusLabel.Text = "Aimbot: No visible target in index" elseif not aiming then statusLabel.Text = "Aimbot ready. Hold toggle key to aim." end
				for part, espBox in pairs(activeESPs) do local found = false; for _, data in ipairs(partsToDrawESPFor) do if data.Part == part then found = true; break end end; if not found or not part.Parent then clearESP(part) end end
				for _, data in ipairs(partsToDrawESPFor) do manageESP(data.Part, data.Color, data.Name) end
			end));
			
			table.insert(janitor, silentAimToggle.MouseButton1Click:Connect(function() getgenv().silentAimEnabled = not getgenv().silentAimEnabled; silentAimToggle.Text = "Silent Aim: " .. (getgenv().silentAimEnabled and "ON" or "OFF") end))
			table.insert(janitor, ignoreTeamToggle.MouseButton1Click:Connect(function() ignoreTeamEnabled = not ignoreTeamEnabled; ignoreTeamToggle.Text = "Ignore Team: " .. (ignoreTeamEnabled and "ON" or "OFF") end))
			table.insert(janitor, wallCheckToggle.MouseButton1Click:Connect(function() wallCheckEnabled = not wallCheckEnabled; wallCheckToggle.Text = "Wall Check: " .. (wallCheckEnabled and "ON" or "OFF") end))
			
			local indexerUpdateSignal = Instance.new("BindableEvent")
			table.insert(janitor, ExplorerButton.MouseButton1Click:Connect(function() createExplorerWindow(statusLabel, indexerUpdateSignal) end))
			task.spawn(function()
				local function RebuildTargetIndex()
					local newIndex = {}
					if not getgenv().TargetScope or not getgenv().TargetScope.Parent then getgenv().TargetScope = Workspace end
					for _, descendant in ipairs(getgenv().TargetScope:GetDescendants()) do if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then table.insert(newIndex, descendant) end end
					getgenv().TargetIndex = newIndex
				end
				table.insert(janitor, indexerUpdateSignal.Event:Connect(RebuildTargetIndex))
				while task.wait(2) and MainScreenGui.Parent do RebuildTargetIndex() end
			end)
			indexerUpdateSignal:Fire()
			
			-- [NEW FEATURE] Handle command-line arguments for locking a target
			if args and args[1] then
				task.wait(0.1) -- Wait a brief moment for UI to be fully ready
				local targetName = args[1]
				if targetName:lower() == "clear" or targetName:lower() == "reset" or targetName:lower() == "off" then
					playerTargetEnabled = false
					selectedPlayerTarget = nil
					targetPlayerToggle.Text = "Target Selected: OFF"
					playerDropdown.Text = "None"
					statusLabel.Text = "Aimbot ready. Hold toggle key to aim."
					DoNotif("Aimbot target lock cleared.", 2)
				else
					local foundPlayer = Utilities.findPlayer(targetName)
					if foundPlayer then
						playerTargetEnabled = true
						selectedPlayerTarget = foundPlayer
						targetPlayerToggle.Text = "Target Selected: ON"
						playerDropdown.Text = foundPlayer.Name
						statusLabel.Text = "Aimbot: Will target " .. foundPlayer.Name
						DoNotif("Aimbot locked onto target: " .. foundPlayer.Name, 3)
					else
						DoNotif("Target player '" .. targetName .. "' not found.", 3)
					end
				end
			end
		end
	end)

	if not success then
		warn("Failed to load Aimbot GUI:", err)
		if DoNotif then DoNotif("Error loading Aimbot: " .. tostring(err), 5) end
		local gui = CoreGui:FindFirstChild("UTS_CGE_Suite")
		if gui then gui:Destroy() end
	end
end

RegisterCommand({ 
    Name = "aimbot", 
    Aliases = { "aim", "gamingchair", "a" }, 
    Description = "Loads the aimbot GUI. Optional: [player name] to lock target." 
}, function(args)
    -- Check if the GUI exists. If not, create it and pass the args.
    if not game:GetService("CoreGui"):FindFirstChild("UTS_CGE_Suite") then
        loadAimbotGUI(args)
    else
        -- If the GUI is already open, we can't easily pass new args into its scope in this structure.
        -- For simplicity, we just notify the user. A more advanced system would use BindableEvents.
        if args and args[1] then
            DoNotif("Aimbot is already open. Re-open to set a command-line target.", 4)
        else
            DoNotif("Aimbot GUI is already open.", 2)
        end
    end
end)


Modules.Performance = {
    State = {
        IsEnabled = false,
        OriginalProperties = {}
    }
}

function Modules.Performance:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    self.State.OriginalProperties = {} -- Reset cache

    -- Services
    local lighting = game:GetService("Lighting")
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local materialService = game:GetService("MaterialService")

    -- Cache and modify Lighting properties
    self.State.OriginalProperties.Lighting = {
        Technology = lighting.Technology,
        GlobalShadows = lighting.GlobalShadows,
        EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = lighting.EnvironmentSpecularScale
    }
    lighting.Technology = Enum.Technology.Compatibility
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0
    lighting.EnvironmentSpecularScale = 0

    -- Cache and modify Terrain properties if it exists
    if terrain then
        self.State.OriginalProperties.Terrain = {
            Decoration = terrain.Decoration
        }
        terrain.Decoration = false
    end

    -- Cache and modify MaterialService properties
    self.State.OriginalProperties.MaterialService = {
        MaterialQuality = materialService.MaterialQuality
    }
    materialService.MaterialQuality = Enum.MaterialQuality.Low
	
	-- Cache and disable atmospheric effects
	self.State.OriginalProperties.LightingEffects = {}
	for _, effect in ipairs(lighting:GetChildren()) do
		if effect:IsA("Atmosphere") or effect:IsA("Clouds") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
			self.State.OriginalProperties.LightingEffects[effect] = {
				Enabled = effect.Enabled
			}
			effect.Enabled = false
		end
	end

    DoNotif("Performance Mode: ENABLED. Shadows and effects disabled.", 2)
end

function Modules.Performance:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Services
    local lighting = game:GetService("Lighting")
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    local materialService = game:GetService("MaterialService")

    -- Restore Lighting properties safely
    if self.State.OriginalProperties.Lighting then
        for prop, value in pairs(self.State.OriginalProperties.Lighting) do
            pcall(function() lighting[prop] = value end)
        end
    end

    -- Restore Terrain properties safely
    if terrain and self.State.OriginalProperties.Terrain then
        for prop, value in pairs(self.State.OriginalProperties.Terrain) do
            pcall(function() terrain[prop] = value end)
        end
    end

    -- Restore MaterialService properties safely
    if self.State.OriginalProperties.MaterialService then
        for prop, value in pairs(self.State.OriginalProperties.MaterialService) do
            pcall(function() materialService[prop] = value end)
        end
    end
	
	-- Restore atmospheric effects
	if self.State.OriginalProperties.LightingEffects then
		for effect, props in pairs(self.State.OriginalProperties.LightingEffects) do
			if effect and effect.Parent then -- Check if effect still exists
				pcall(function() effect.Enabled = props.Enabled end)
			end
		end
	end

    self.State.OriginalProperties = {} -- Clear cache
    DoNotif("Performance Mode: DISABLED. Graphics restored.", 2)
end

function Modules.Performance:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "fpsboost", Aliases = { "noshadows", "performance" }, Description = "Toggles performance mode by disabling shadows and other intensive graphical features." }, function()
    Modules.Performance:Toggle()
end)

Modules.AstralProjection = {
    State = {
        isProjecting = false,
        isSpawning = false,
        originalHRP = nil,
        originalParent = nil,
        deathConnection = nil,
        positionMarker = nil
    },
    Config = {
        TOGGLE_KEY = Enum.KeyCode.P,
        SPAWN_PROTECTION_DURATION = 2
    },
    GUI = {},
    Services = {}
}
function Modules.AstralProjection:_makeDraggable(guiObject)
    local UIS = self.Services.UserInputService
    local dragging = false
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            update(input)
        end
    end)
end
function Modules.AstralProjection:_updateUIState()
    local button = self.GUI.astralButton
    if not button then return end
    if self.State.isSpawning then
        button.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif self.State.isProjecting then
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        button.TextColor3 = Color3.fromRGB(10, 10, 10)
    else
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        button.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end
function Modules.AstralProjection:_applyVisuals(character, isAstral)
    local highlight = character:FindFirstChild("AstralHighlight")
    if isAstral and not highlight then
        highlight = Instance.new("Highlight", character)
        highlight.Name = "AstralHighlight"
        highlight.FillColor = Color3.fromRGB(0, 200, 255)
        highlight.OutlineColor = Color3.fromRGB(200, 255, 255)
        highlight.FillTransparency = 0.5
    elseif not isAstral and highlight then
        highlight:Destroy()
    end
end
function Modules.AstralProjection:_setState(shouldProject)
    if self.State.isSpawning then return end
    if self.State.isProjecting == shouldProject then return end
    local character = self.Services.LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if shouldProject then
        if not hrp or not humanoid or not hrp.Parent then return end
        self.State.originalHRP = hrp
        self.State.originalParent = character
        local originalCFrame = hrp.CFrame
        hrp.Parent = nil
        self.State.isProjecting = true
        if self.State.positionMarker then
            self.State.positionMarker:Destroy()
        end
        local marker = Instance.new("Part")
        marker.Name = "PhysicalAnchor"
        marker.Size = Vector3.new(4, 5, 2)
        marker.CFrame = originalCFrame
        marker.Anchored = true
        marker.CanCollide = false
        marker.Transparency = 0.7
        marker.Parent = self.Services.Workspace
        self.State.positionMarker = marker
        local highlight = Instance.new("Highlight", marker)
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        self:_applyVisuals(character, true)
        DoNotif("Desync: ENABLED", 1.5)
    else
        if not self.State.originalHRP or not self.State.originalParent then
            self.State.isProjecting = false
            return
        end
        if self.State.positionMarker then
            self.State.positionMarker:Destroy()
            self.State.positionMarker = nil
        end
        self.State.originalHRP.Parent = self.State.originalParent
        self.State.originalHRP = nil
        self.State.originalParent = nil
        self.State.isProjecting = false
        self:_applyVisuals(character, false)
        DoNotif("Desync: DISABLED", 1.5)
    end
    self:_updateUIState()
end
function Modules.AstralProjection:_onDied()
    self:_setState(false)
end
function Modules.AstralProjection:_onCharacterAdded(character)
    self.State.isSpawning = true
    self:_updateUIState()
    if self.State.isProjecting then
        self:_setState(false)
    end
    if self.State.deathConnection then
        self.State.deathConnection:Disconnect()
    end
    local humanoid = character:WaitForChild("Humanoid")
    self.State.deathConnection = humanoid.Died:Connect(function()
        self:_onDied()
    end)
    task.wait(self.Config.SPAWN_PROTECTION_DURATION)
    self.State.isSpawning = false
    self:_updateUIState()
end
function Modules.AstralProjection:Toggle()
    self:_setState(not self.State.isProjecting)
end
function Modules.AstralProjection:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.UserInputService = game:GetService("UserInputService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer
    local PLAYER_GUI = self.Services.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AstralStatusGUI_V2"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PLAYER_GUI
    self.GUI.screenGui = screenGui
    local astralButton = Instance.new("TextButton")
    astralButton.Name = "AstralToggleButton"
    astralButton.Size = UDim2.fromOffset(64, 64)
    astralButton.AnchorPoint = Vector2.new(1, 1)
    astralButton.Position = UDim2.new(1, -20, 1, -100) 
    astralButton.Font = Enum.Font.GothamBold
    astralButton.Text = "DSYNC"
    astralButton.TextSize = 14
    astralButton.Parent = screenGui
    Instance.new("UICorner", astralButton).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", astralButton)
    stroke.Color = Color3.fromRGB(100, 100, 120)
    stroke.Thickness = 1.5
    self.GUI.astralButton = astralButton
    self:_updateUIState()
    self:_makeDraggable(astralButton)
    astralButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    self.Services.UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.Config.TOGGLE_KEY then
            self:Toggle()
        end
    end)
    if self.Services.LocalPlayer.Character then
        self:_onCharacterAdded(self.Services.LocalPlayer.Character)
    end
    self.Services.LocalPlayer.CharacterAdded:Connect(function(character)
        self:_onCharacterAdded(character)
    end)
end
RegisterCommand({
    Name = "astral",
    Aliases = {"desync", "unsync"},
    Description = "Toggles astral projection, desyncing yourself remaining invisible to others."
}, function()
    Modules.AstralProjection:Toggle()
end)

Modules.AnchorSelf = {
    State = {
        IsEnabled = false,
        CharacterAddedConnection = nil
    }
}

function Modules.AnchorSelf:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function applyAnchor(character)
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart", 2)
        if hrp then
            hrp.Anchored = true
        end
    end

    if LocalPlayer.Character then
        applyAnchor(LocalPlayer.Character)
    end

    self.State.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(applyAnchor)
    DoNotif("Self Anchor: ENABLED.", 2)
end

function Modules.AnchorSelf:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
    end

    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end
    DoNotif("Self Anchor: DISABLED.", 2)
end

function Modules.AnchorSelf:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "anchor", Aliases = { "lock", "lockpos" }, Description = "Toggles anchoring your character in place." }, function()
    Modules.AnchorSelf:Toggle()
end)

Modules.AutoComplete = {};
function Modules.AutoComplete:GetMatches(prefix)
    local matches = {}
    if typeof(prefix) ~= "string" or #prefix == 0 then return matches end
        prefix = prefix:lower()
        for cmdName, _ in pairs(Commands) do
            if cmdName:sub(1, #prefix) == prefix then
                table.insert(matches, cmdName)
            end
        end
        table.sort(matches)
        return matches
    end
Modules.CommandList = {
    State = {
        UI = nil,
        IsEnabled = false,
        IsMinimized = false,
        IsAnimating = false,
    },
}

function Modules.CommandList:Initialize()
    local self = self
    local ui = Instance.new("ScreenGui")
    ui.Name = "CommandListUI_v7_Radiant"
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.Enabled = false
    self.State.UI = ui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(450, 350)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(34, 32, 38)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local uiStroke = Instance.new("UIStroke", mainFrame)
    uiStroke.Color = Color3.fromRGB(255, 105, 180) -- Hot Pink
    uiStroke.Thickness = 2
    
    local glowConnection
    glowConnection = RunService.RenderStepped:Connect(function()
        if not (uiStroke and uiStroke.Parent) then
            glowConnection:Disconnect()
            return
        end
        local sine = math.sin(os.clock() * 4)
        uiStroke.Thickness = 2 + (sine * 0.5)
        uiStroke.Transparency = 0.3 + (sine * 0.2)
    end)
    
    local canvasGroup = Instance.new("CanvasGroup", mainFrame)
    canvasGroup.Name = "Canvas"
    canvasGroup.Size = UDim2.fromScale(1, 1)
    canvasGroup.BackgroundTransparency = 1
    canvasGroup.GroupTransparency = 1

    local title = Instance.new("TextLabel", canvasGroup)
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Command List"
    title.TextColor3 = Color3.fromRGB(255, 182, 193)
    title.TextSize = 20

    local closeButton = Instance.new("TextButton", canvasGroup)
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.fromOffset(25, 25)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -10, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.MouseButton1Click:Connect(function() self:Toggle() end)

    local minimizeButton = Instance.new("TextButton", canvasGroup)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.fromOffset(25, 25)
    minimizeButton.AnchorPoint = Vector2.new(1, 0)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 24

    local scrollingFrame = Instance.new("ScrollingFrame", canvasGroup)
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = UDim2.fromOffset(10, 40)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    -- [FIX] Removed invalid ScrollBarBackgroundColor3 property
    
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 5)

    local function drag(input)
        local dragStart = input.Position
        local startPos = mainFrame.Position
        local moveConn, endConn
        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = moveInput.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        endConn = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                moveConn:Disconnect()
                endConn:Disconnect()
            end
        end)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag(input) end
    end)

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    minimizeButton.MouseButton1Click:Connect(function()
        self.State.IsMinimized = not self.State.IsMinimized
        local goalSize
        if self.State.IsMinimized then
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 40)
            minimizeButton.Text = "+"
            scrollingFrame.Visible = false
        else
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 350)
            minimizeButton.Text = "-"
            scrollingFrame.Visible = true
        end
        TweenService:Create(mainFrame, tweenInfo, { Size = goalSize }):Play()
    end)
    ui.Parent = CoreGui
end

function Modules.CommandList:Populate()
    local scrollingFrame = self.State.UI.MainFrame.Canvas:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return end
    
    scrollingFrame:ClearAllChildren()
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 8)

    -- [FIX] This connection automatically updates the scrollable area to fit all content.
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
    end)

    table.sort(CommandInfo, function(a, b) return a.Name < b.Name end)

    for _, info in ipairs(CommandInfo) do
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = info.Name .. "_Entry"
        entryFrame.BackgroundTransparency = 0.8
        entryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        entryFrame.Size = UDim2.new(1, 0, 0, 0)
        entryFrame.AutomaticSize = Enum.AutomaticSize.Y
        entryFrame.Parent = scrollingFrame
        Instance.new("UICorner", entryFrame).CornerRadius = UDim.new(0, 6)
        local frameLayout = Instance.new("UIListLayout", entryFrame)
        frameLayout.Padding = UDim.new(0, 5)
        local framePadding = Instance.new("UIPadding", entryFrame)
        framePadding.PaddingLeft = UDim.new(0, 10)
        framePadding.PaddingRight = UDim.new(0, 10)
        framePadding.PaddingTop = UDim.new(0, 8)
        framePadding.PaddingBottom = UDim.new(0, 8)

        local entry = Instance.new("TextLabel")
        entry.Name = info.Name
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.BackgroundTransparency = 1
        entry.Font = Enum.Font.Gotham
        entry.TextSize = 15
        entry.RichText = true
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.TextWrapped = true
        entry.Parent = entryFrame

        local aliases = ""
        if info.Aliases and #info.Aliases > 0 then
            aliases = string.format("<font size='12' color='#AAAAAA'><i>(%s)</i></font>", table.concat(info.Aliases, ", "))
        end
        
        local description = info.Description or "No description provided."

        entry.Text = string.format(
            "<font face='GothamBold' color='#FF69B4'>;%s</font> %s\n<font face='Gotham' size='13' color='#E0E0E0'>  %s</font>",
            info.Name,
            aliases,
            description
        )
    end
end

function Modules.CommandList:Toggle()
    if self.State.IsAnimating then return end
    self.State.IsAnimating = true
    self.State.IsEnabled = not self.State.IsEnabled
    
    local mainFrame = self.State.UI.MainFrame
    local canvasGroup = mainFrame.Canvas
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if self.State.IsEnabled then
        self.State.UI.Enabled = true
        if self.State.IsMinimized then
            self.State.IsMinimized = false
            mainFrame.Size = UDim2.fromOffset(450, 350)
            mainFrame.Canvas.ScrollingFrame.Visible = true
            mainFrame.Canvas.MinimizeButton.Text = "-"
        end
        self:Populate()
        mainFrame.Size = UDim2.fromOffset(450, 320)
        canvasGroup.GroupTransparency = 1
        local sizeAnim = TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.fromOffset(450, 350) })
        local fadeAnim = TweenService:Create(canvasGroup, tweenInfo, { GroupTransparency = 0 })
        sizeAnim:Play()
        fadeAnim:Play()
        fadeAnim.Completed:Connect(function() self.State.IsAnimating = false end)
    else
        local sizeAnim = TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.fromOffset(450, 320) })
        local fadeAnim = TweenService:Create(canvasGroup, tweenInfo, { GroupTransparency = 1 })
        sizeAnim:Play()
        fadeAnim:Play()
        fadeAnim.Completed:Connect(function()
            self.State.UI.Enabled = false
            self.State.IsAnimating = false
        end)
    end
end


Modules.CommandBar = {
    State = {
        UI = nil,
        Container = nil,
        TextBox = nil,
        LogFrame = nil,
        SuggestionLabel = nil,
        PrefixKey = Enum.KeyCode.Semicolon,
        IsAnimating = false,
        IsEnabled = false,
        MaxLogs = 500,
        CurrentSuggestion = "",
        MinSize = Vector2.new(400, 250)
    },

    Theme = {
        Background = Color3.fromRGB(10, 10, 10),
        Accent = Color3.fromRGB(255, 105, 180),
        Text = Color3.fromRGB(220, 220, 220),
        Suggestion = Color3.fromRGB(120, 120, 120),
        Font = Enum.Font.Code
    }
}

function Modules.CommandBar:Toggle(): ()
    if self.State.IsAnimating then return end
    self.State.IsAnimating = true
    self.State.IsEnabled = not self.State.IsEnabled
    
    local isOpening: boolean = self.State.IsEnabled
    local tweenInfo: TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    if isOpening then
        self.State.UI.Enabled = true
        local goalPosition: UDim2 = UDim2.new(0.5, -self.State.Container.Size.X.Offset/2, 0.5, -self.State.Container.Size.Y.Offset/2)
        
        local anim = TweenService:Create(self.State.Container, tweenInfo, {
            Position = goalPosition,
            BackgroundTransparency = 0.3
        })
        anim:Play()
        self.State.TextBox:CaptureFocus()
        task.spawn(function()
            task.wait()
            if self.State.IsEnabled then 
                self.State.TextBox.Text = "" 
                self.State.SuggestionLabel.Text = ""
                self.State.CurrentSuggestion = ""
            end
        end)
        anim.Completed:Connect(function() self.State.IsAnimating = false end)
    else
        self.State.TextBox:ReleaseFocus()
        local anim = TweenService:Create(self.State.Container, tweenInfo, {
            Position = UDim2.new(0.5, -self.State.Container.Size.X.Offset/2, 1, 50),
            BackgroundTransparency = 1
        })
        anim:Play()
        anim.Completed:Connect(function()
            self.State.UI.Enabled = false
            self.State.IsAnimating = false
        end)
    end
end

function Modules.CommandBar:AddOutput(text: string, color: Color3?): ()
    if not self.State.LogFrame then return end
    
    local line: TextLabel = Instance.new("TextLabel")
    line.Name = "TerminalLine"
    line.Parent = self.State.LogFrame
    line.BackgroundTransparency = 1
    line.Size = UDim2.new(1, -15, 0, 0)
    line.AutomaticSize = Enum.AutomaticSize.Y
    line.Font = self.Theme.Font
    line.Text = " " .. text
    line.TextColor3 = color or self.Theme.Text
    line.TextSize = 13
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.RichText = true
    line.TextWrapped = true
    
    local children: {Instance} = self.State.LogFrame:GetChildren()
    if #children > self.State.MaxLogs then
        for i = 1, (#children - self.State.MaxLogs) do
            if children[i]:IsA("TextLabel") then children[i]:Destroy() end
        end
    end

    task.defer(function()
        if self.State.LogFrame then
            self.State.LogFrame.CanvasPosition = Vector2.new(0, self.State.LogFrame.AbsoluteCanvasSize.Y)
        end
    end)
end

function Modules.CommandBar:ListCommands(): ()
    self:AddOutput("--------------------------------------------", self.Theme.Accent)
    self:AddOutput("READING_LOCAL_SYSTEM_REGISTRY...", self.Theme.Accent)
    self:AddOutput("--------------------------------------------", self.Theme.Accent)

    local sorted: {any} = {}
    for _, info in ipairs(CommandInfo) do
        table.insert(sorted, info)
    end
    table.sort(sorted, function(a, b) return a.Name < b.Name end)

    for _, info in ipairs(sorted) do
        local aliasStr: string = ""
        if info.Aliases and #info.Aliases > 0 then
            aliasStr = " <font color='#888888'>[" .. table.concat(info.Aliases, ", ") .. "]</font>"
        end
        
        local desc: string = info.Description or "no_description_provided"
        self:AddOutput(string.format("<font color='#FF69B4'>%s</font>%s - %s", info.Name, aliasStr, desc))
    end
    
    self:AddOutput("--------------------------------------------", self.Theme.Accent)
    self:AddOutput("ACTIVE_MODULES_FOUND: " .. #sorted, self.Theme.Accent)
end

function Modules.CommandBar:UpdateSuggestions(): ()
    local input: string = self.State.TextBox.Text:lower()
    if input == "" then
        self.State.SuggestionLabel.Text = ""
        self.State.CurrentSuggestion = ""
        return
    end

    local match: string = ""
    for cmdName, _ in pairs(Commands) do
        if cmdName:lower():sub(1, #input) == input then
            match = cmdName:lower()
            break
        end
    end

    if match ~= "" then
        self.State.CurrentSuggestion = match
        self.State.SuggestionLabel.Text = match
    else
        self.State.CurrentSuggestion = ""
        self.State.SuggestionLabel.Text = ""
    end
end

function Modules.CommandBar:Initialize(): ()
    local CommandBarUI: ScreenGui = Instance.new("ScreenGui")
    CommandBarUI.Name = "ForensicTerminal_V10"
    CommandBarUI.Parent = CoreGui
    CommandBarUI.ResetOnSpawn = false
    CommandBarUI.Enabled = false
    
    local MainContainer: Frame = Instance.new("Frame")
    MainContainer.Name = "ShellFrame"
    MainContainer.Parent = CommandBarUI
    MainContainer.Size = UDim2.new(0, 600, 0, 350)
    MainContainer.Position = UDim2.new(0.5, -300, 1, 50)
    MainContainer.BackgroundColor3 = self.Theme.Background
    MainContainer.BackgroundTransparency = 0.4
    MainContainer.BorderSizePixel = 0
    MainContainer.Active = true
    
    Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 4)
    local UIStroke: UIStroke = Instance.new("UIStroke", MainContainer)
    UIStroke.Color = self.Theme.Accent
    UIStroke.Thickness = 1.2
    UIStroke.Transparency = 0.5

    local GlowEffect: UIStroke = Instance.new("UIStroke", MainContainer)
    GlowEffect.Color = self.Theme.Accent
    GlowEffect.Thickness = 2
    GlowEffect.Transparency = 0.4

    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.fromOffset(16, 16)
    ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Image = "rbxassetid://12134015093"
    ResizeHandle.ImageColor3 = self.Theme.Accent
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = MainContainer

    task.spawn(function()
        while RunService.RenderStepped:Wait() do
            if not MainContainer or not MainContainer.Parent then break end
            local sine: number = math.sin(os.clock() * 3)
            GlowEffect.Transparency = 0.7 + (sine * 0.2)
            GlowEffect.Thickness = 2 + (sine * 0.8)
        end
    end)

    local OutputLog: ScrollingFrame = Instance.new("ScrollingFrame")
    OutputLog.Name = "Buffer"
    OutputLog.Parent = MainContainer
    OutputLog.Position = UDim2.new(0, 10, 0, 10)
    OutputLog.Size = UDim2.new(1, -20, 1, -55)
    OutputLog.BackgroundTransparency = 1
    OutputLog.BorderSizePixel = 0
    OutputLog.ScrollBarThickness = 2
    OutputLog.ScrollBarImageColor3 = self.Theme.Accent
    OutputLog.CanvasSize = UDim2.new(0, 0, 0, 0)
    OutputLog.AutomaticCanvasSize = Enum.AutomaticSize.Y
    OutputLog.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local LogLayout: UIListLayout = Instance.new("UIListLayout", OutputLog)
    LogLayout.Padding = UDim.new(0, 2)
    LogLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local InputArea: Frame = Instance.new("Frame", MainContainer)
    InputArea.Position = UDim2.new(0, 10, 1, -35)
    InputArea.Size = UDim2.new(1, -20, 0, 25)
    InputArea.BackgroundTransparency = 0.8

    local Prompt: TextLabel = Instance.new("TextLabel", InputArea)
    Prompt.Size = UDim2.new(0, 130, 1, 0)
    Prompt.BackgroundTransparency = 1
    Prompt.Font = self.Theme.Font
    Prompt.Text = "zuka@kernel:~$ "
    Prompt.TextColor3 = self.Theme.Accent
    Prompt.TextSize = 14
    Prompt.TextXAlignment = Enum.TextXAlignment.Left

    local SuggestionLabel: TextLabel = Instance.new("TextLabel", InputArea)
    SuggestionLabel.Name = "Suggestion"
    SuggestionLabel.Position = UDim2.new(0, 135, 0, 0)
    SuggestionLabel.Size = UDim2.new(1, -140, 1, 0)
    SuggestionLabel.BackgroundTransparency = 1
    SuggestionLabel.Font = self.Theme.Font
    SuggestionLabel.Text = ""
    SuggestionLabel.TextColor3 = self.Theme.Suggestion
    SuggestionLabel.TextSize = 14
    SuggestionLabel.TextXAlignment = Enum.TextXAlignment.Left

    local InputField: TextBox = Instance.new("TextBox", InputArea)
    InputField.Name = "Prompt"
    InputField.Position = UDim2.new(0, 135, 0, 0)
    InputField.Size = UDim2.new(1, -140, 1, 0)
    InputField.BackgroundTransparency = 1
    InputField.Font = self.Theme.Font
    InputField.Text = ""
    InputField.TextColor3 = self.Theme.Text
    InputField.TextSize = 14
    InputField.TextXAlignment = Enum.TextXAlignment.Left
    InputField.ClearTextOnFocus = false
    InputField.ZIndex = 2

    self.State.UI = CommandBarUI
    self.State.Container = MainContainer
    self.State.TextBox = InputField
    self.State.LogFrame = OutputLog
    self.State.SuggestionLabel = SuggestionLabel

    local dragging, resizing = false, false
    local dragStart, resizeStart, startPos, startSize

    MainContainer.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                    conn:Disconnect()
                end
            end)
        end
    end)

    ResizeHandle.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = MainContainer.Size
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    resizing = false 
                    conn:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta: Vector3 = input.Position - dragStart
                MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local delta: Vector2 = Vector2.new(input.Position.X - resizeStart.X, input.Position.Y - resizeStart.Y)
                local newX = math.max(self.State.MinSize.X, startSize.X.Offset + delta.X)
                local newY = math.max(self.State.MinSize.Y, startSize.Y.Offset + delta.Y)
                MainContainer.Size = UDim2.new(0, newX, 0, newY)
            end
        end
    end)

    InputField:GetPropertyChangedSignal("Text"):Connect(function()
        self:UpdateSuggestions()
    end)

    InputField.FocusLost:Connect(function(enter: boolean)
        if enter then
            local raw: string = InputField.Text
            local cmd: string = string.match(raw, "^%s*(.-)%s*$")
            if cmd ~= "" then
                self:AddOutput("~$ " .. cmd, self.Theme.Text)
                
                if cmd:lower() == "cmds" or cmd:lower() == "help" then
                    self:ListCommands()
                else
                    local wasProcessed: boolean = processCommand(Prefix .. cmd)
                    if not wasProcessed then
                        self:AddOutput("ERR: command_not_found: " .. cmd, Color3.fromRGB(255, 80, 80))
                    end
                end
                
                InputField.Text = ""
            end
            self:Toggle()
        end
    end)

    UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
        if input.KeyCode == Enum.KeyCode.Tab and InputField:IsFocused() then
            if self.State.CurrentSuggestion ~= "" then
                InputField.Text = self.State.CurrentSuggestion
                InputField.CursorPosition = #InputField.Text + 1
            end
        end

        if not gpe and input.KeyCode == self.State.PrefixKey then self:Toggle() end
    end)

    self:AddOutput("ZUKATECH_V10_INITIALIZED", self.Theme.Accent)
    self:AddOutput("AUTH_TOKEN_ACCEPTED: " .. Players.LocalPlayer.Name, self.Theme.Accent)
    self:AddOutput("Type 'cmds' for documentation or ';' to toggle shell.", self.Theme.Text)
end

function DoNotif(text: string, duration: number?): ()
    NotificationManager.Send(text, duration)
    if Modules.CommandBar and Modules.CommandBar.AddOutput then
        Modules.CommandBar:AddOutput("[SYS]: " .. tostring(text), Modules.CommandBar.Theme.Accent)
    end
end


Modules.UnlockMouse = { State = { Enabled = false, Connection = nil } }
RegisterCommand({ Name = "unlockmouse", Aliases = {"unlockcursor", "freemouse", "um"}, Description = "Toggles a persistent loop to unlock the mouse cursor." }, function()
local State = Modules.UnlockMouse.State
State.Enabled = not State.Enabled
if State.Enabled then
    if State.Connection then State.Connection:Disconnect() end
        State.Connection = RunService.RenderStepped:Connect(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
    DoNotif("Mouse Unlock Enabled", 2)
else
if State.Connection then State.Connection:Disconnect(); State.Connection = nil end
    DoNotif("Mouse Unlock Disabled", 2)
end
end)


Modules.ESP = {
    State = {
        PlayersEnabled = false,
        Connections = {},
        TrackedPlayers = setmetatable({}, {__mode="k"})
    }
}

function Modules.ESP:_cleanup()
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    for _, data in pairs(self.State.TrackedPlayers) do
        pcall(function() data.Highlight:Destroy() end)
        pcall(function() data.Billboard:Destroy() end)
    end
    table.clear(self.State.Connections)
    table.clear(self.State.TrackedPlayers)
end

function Modules.ESP:_createPlayerEsp(player)
    if player == LocalPlayer or self.State.TrackedPlayers[player] then return end

    local function setupVisuals(character)
        if self.State.TrackedPlayers[player] then
            pcall(function() self.State.TrackedPlayers[player].Highlight:Destroy() end)
            pcall(function() self.State.TrackedPlayers[player].Billboard:Destroy() end)
        end

        local head = character:WaitForChild("Head", 2)
        if not head then return end

        local highlight = Instance.new("Highlight", character)
        highlight.FillColor = Color3.fromRGB(255, 60, 60)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.8
        highlight.OutlineTransparency = 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local billboard = Instance.new("BillboardGui", head)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 175, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local listLayout = Instance.new("UIListLayout", billboard)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, -2)

        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Text = player.Name
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.Code
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        
        local nameStroke = Instance.new("UIStroke", nameLabel)
        nameStroke.Color = Color3.new(0,0,0)
        nameStroke.Thickness = 1.25

        local teamLabel = Instance.new("TextLabel", billboard)
        teamLabel.Size = UDim2.new(1, 0, 0.5, 0)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Font = Enum.Font.Code
        teamLabel.TextScaled = true
        teamLabel.Text = player.Team and player.Team.Name or "No Team"
        teamLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(200, 200, 200)

        local teamStroke = Instance.new("UIStroke", teamLabel)
        teamStroke.Color = Color3.new(0,0,0)
        teamStroke.Thickness = 1.25

        self.State.TrackedPlayers[player] = { Highlight = highlight, Billboard = billboard, CharacterAddedConn = nil }
    end

    if player.Character then setupVisuals(player.Character) end
    local conn = player.CharacterAdded:Connect(setupVisuals)
    if self.State.TrackedPlayers[player] then self.State.TrackedPlayers[player].CharacterAddedConn = conn end
end

function Modules.ESP:_removePlayerEsp(player)
    if not self.State.TrackedPlayers[player] then return end
    pcall(function() self.State.TrackedPlayers[player].Highlight:Destroy() end)
    pcall(function() self.State.TrackedPlayers[player].Billboard:Destroy() end)
    if self.State.TrackedPlayers[player].CharacterAddedConn then self.State.TrackedPlayers[player].CharacterAddedConn:Disconnect() end
    self.State.TrackedPlayers[player] = nil
end

function Modules.ESP:Toggle(argument)
    argument = (argument or "players"):lower()

    if argument == "players" or argument == "p" or argument == "all" then
        self.State.PlayersEnabled = not self.State.PlayersEnabled
        DoNotif("Player ESP: " .. (self.State.PlayersEnabled and "ENABLED" or "DISABLED"), 2)
        if self.State.PlayersEnabled then
            for _, player in ipairs(Players:GetPlayers()) do self:_createPlayerEsp(player) end
            self.State.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(p) self:_createPlayerEsp(p) end)
            self.State.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p) self:_removePlayerEsp(p) end)
        else
            if self.State.Connections.PlayerAdded then self.State.Connections.PlayerAdded:Disconnect(); self.State.Connections.PlayerAdded = nil end
            if self.State.Connections.PlayerRemoving then self.State.Connections.PlayerRemoving:Disconnect(); self.State.Connections.PlayerRemoving = nil end
            for player, _ in pairs(self.State.TrackedPlayers) do self:_removePlayerEsp(player) end
        end
    else
        local targetPlayer = Utilities.findPlayer(argument)
        if not targetPlayer then
            return DoNotif("Player '" .. argument .. "' not found.", 3)
        end

        if self.State.TrackedPlayers[targetPlayer] then
            self:_removePlayerEsp(targetPlayer)
            DoNotif("ESP for " .. targetPlayer.Name .. ": DISABLED", 2)
        else
            self:_createPlayerEsp(targetPlayer)
            DoNotif("ESP for " .. targetPlayer.Name .. ": ENABLED", 2)
        end
    end
end

RegisterCommand({
    Name = "esp",
    Aliases = {},
    Description = "Toggles ESP for all players or a specific player."
}, function(args)
    Modules.ESP:Toggle(args[1])
end)

        Modules.ClickTP = { State = { IsActive = false, Connection = nil } };
        function Modules.ClickTP:Toggle()
            self.State.IsActive = not self.State.IsActive
            local UserInputService = game:GetService("UserInputService")
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            if self.State.IsActive then
                self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                        local camera = Workspace.CurrentCamera
                        local mousePos = UserInputService:GetMouseLocation()
                        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                        if result and result.Position then
                            hrp.CFrame = CFrame.new(result.Position) + Vector3.new(0, 3, 0)
                        end
                    end
                end)
                DoNotif("Click TP Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Click TP Disabled", 2)
        end
    end
    RegisterCommand({Name = "clicktp", Aliases = {}, Description = "Hold Left CTRL and click to teleport."}, function(args)
    Modules.ClickTP:Toggle(args)
end)
Modules.HighlightPlayer = { State = { TargetPlayer = nil, HighlightInstance = nil, CharacterAddedConnection = nil } }
local function findFirstPlayer(partialName)
local lowerPartialName = string.lower(partialName)
for _, player in ipairs(Players:GetPlayers()) do
    if string.lower(player.Name):sub(1, #lowerPartialName) == lowerPartialName then return player end
    end
    return nil
end
function Modules.HighlightPlayer:ApplyHighlight(character)
    if not character then return end
        if self.State.HighlightInstance then self.State.HighlightInstance:Destroy() end
            local highlight = Instance.new("Highlight", character)
            highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency, highlight.OutlineTransparency = 0.7, 0.2
            self.State.HighlightInstance = highlight
        end
        function Modules.HighlightPlayer:ClearHighlight()
            if self.State.HighlightInstance then self.State.HighlightInstance:Destroy(); self.State.HighlightInstance = nil end
                if self.State.CharacterAddedConnection then self.State.CharacterAddedConnection:Disconnect(); self.State.CharacterAddedConnection = nil end
                    if self.State.TargetPlayer then DoNotif("Highlight cleared from: " .. self.State.TargetPlayer.Name, 2); self.State.TargetPlayer = nil end
                    end
                    RegisterCommand({ Name = "highlight", Aliases = {"find", "findplayer"}, Description = "Highlights a player." }, function(args)
                    local argument = args[1]
                    if not argument then DoNotif("Usage: highlight <PlayerName|clear>", 3); return end
                        if string.lower(argument) == "clear" or string.lower(argument) == "reset" then Modules.HighlightPlayer:ClearHighlight(); return end
                            local targetPlayer = findFirstPlayer(argument)
                            if not targetPlayer then DoNotif("Player '" .. argument .. "' not found.", 3); return end
                                Modules.HighlightPlayer:ClearHighlight()
                                Modules.HighlightPlayer.State.TargetPlayer = targetPlayer
                                DoNotif("Now highlighting: " .. targetPlayer.Name, 2)
                                if targetPlayer.Character then Modules.HighlightPlayer:ApplyHighlight(targetPlayer.Character) end
                                    Modules.HighlightPlayer.State.CharacterAddedConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter) Modules.HighlightPlayer:ApplyHighlight(newCharacter) end)
                                end)
                                Modules.FovChanger = {
                                State = {
                                IsEnabled = false,
                                TargetFov = 70,
                                DefaultFov = 70,
                                Connection = nil
                                }
                                }
                                local function updateFovOnRenderStep()
                                local camera = Workspace.CurrentCamera
                                local state = Modules.FovChanger.State
                                if camera and state.IsEnabled and camera.FieldOfView ~= state.TargetFov then
                                    camera.FieldOfView = state.TargetFov
                                end
                            end
                            local function enableFovLock()
                            local state = Modules.FovChanger.State
                            if not state.Connection then
                                state.Connection = RunService.RenderStepped:Connect(updateFovOnRenderStep)
                            end
                            state.IsEnabled = true
                        end
                        local function disableFovLock()
                        local state = Modules.FovChanger.State
                        state.IsEnabled = false
                        if state.Connection then
                            state.Connection:Disconnect()
                            state.Connection = nil
                        end
                    end
                    pcall(function()
                    Modules.FovChanger.State.DefaultFov = Workspace.CurrentCamera.FieldOfView
                end)
                RegisterCommand({ Name = "fov", Aliases = {"fieldofview", "camfov"}, Description = "Changes and locks FOV." }, function(args)
                local camera = Workspace.CurrentCamera
                if not camera then
                    DoNotif("Could not find camera.", 3)
                    return
                end
                local argument = args[1]
                if not argument then
                    DoNotif("Current FOV is: " .. camera.FieldOfView, 3)
                    return
                end
                if string.lower(argument) == "reset" then
                    disableFovLock()
                    camera.FieldOfView = Modules.FovChanger.State.DefaultFov
                    DoNotif("FOV lock disabled and reset to " .. Modules.FovChanger.State.DefaultFov, 2)
                    return
                end
                local newFov = tonumber(argument)
                if not newFov then
                    DoNotif("Invalid argument. Provide a number or 'reset'.", 3)
                    return
                end
                local clampedFov = math.clamp(newFov, 1, 120)
                Modules.FovChanger.State.TargetFov = clampedFov
                enableFovLock()
                DoNotif("FOV locked to " .. clampedFov, 2)
            end)
            RegisterCommand({ Name = "cmds", Aliases = {"commands", "help"}, Description = "Opens a UI that lists all available commands." }, function()
            Modules.CommandList:Toggle()
        end)
        Modules.Fly = {
        State = {
        IsActive = false,
        Speed = 60,
        SprintMultiplier = 2.5,
        Connections = {},
        BodyMovers = {}
        }
        }
        function Modules.Fly:SetSpeed(s)
            local n = tonumber(s)
            if n and n > 0 then
                self.State.Speed = n
                DoNotif("Fly speed set to: " .. n, 1)
            else
            DoNotif("Invalid speed.", 1)
        end
    end
    function Modules.Fly:Disable()
        if not self.State.IsActive then return end
            self.State.IsActive = false
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.PlatformStand = false end
                for _, mover in pairs(self.State.BodyMovers) do
                    if mover and mover.Parent then
                        mover:Destroy()
                    end
                end
                for _, connection in ipairs(self.State.Connections) do
                    connection:Disconnect()
                end
                table.clear(self.State.BodyMovers)
                table.clear(self.State.Connections)
                DoNotif("Fly disabled.", 1)
            end
            function Modules.Fly:Enable()
                local self = self
                if self.State.IsActive then return end
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if not (hrp and humanoid) then
                        DoNotif("Character required.", 1)
                        return
                    end
                    self.State.IsActive = true
                    DoNotif("Fly Enabled.", 1)
                    humanoid.PlatformStand = true
                    local hrpAttachment = Instance.new("Attachment", hrp)
                    local worldAttachment = Instance.new("Attachment", workspace.Terrain)
                    worldAttachment.WorldCFrame = hrp.CFrame
                    local alignOrientation = Instance.new("AlignOrientation")
                    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    alignOrientation.Attachment0 = hrpAttachment
                    alignOrientation.Responsiveness = 200
                    alignOrientation.MaxTorque = math.huge
                    alignOrientation.Parent = hrp
                    local linearVelocity = Instance.new("LinearVelocity")
                    linearVelocity.Attachment0 = hrpAttachment
                    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                    linearVelocity.MaxForce = math.huge
                    linearVelocity.VectorVelocity = Vector3.zero
                    linearVelocity.Parent = hrp
                    self.State.BodyMovers.HRPAttachment = hrpAttachment
                    self.State.BodyMovers.WorldAttachment = worldAttachment
                    self.State.BodyMovers.AlignOrientation = alignOrientation
                    self.State.BodyMovers.LinearVelocity = linearVelocity
                    local keys = {}
                    local function onInput(input, gameProcessed)
                    if not gameProcessed then
                        keys[input.KeyCode] = (input.UserInputState == Enum.UserInputState.Begin)
                    end
                end
                table.insert(self.State.Connections, UserInputService.InputBegan:Connect(onInput))
                table.insert(self.State.Connections, UserInputService.InputEnded:Connect(onInput))
                local loop = RunService.RenderStepped:Connect(function()
                if not self.State.IsActive or not hrp.Parent then return end
                    local camera = workspace.CurrentCamera
                    alignOrientation.CFrame = camera.CFrame
                    local direction = Vector3.new()
                    if keys[Enum.KeyCode.W] then direction += camera.CFrame.LookVector end
                        if keys[Enum.KeyCode.S] then direction -= camera.CFrame.LookVector end
                            if keys[Enum.KeyCode.D] then direction += camera.CFrame.RightVector end
                                if keys[Enum.KeyCode.A] then direction -= camera.CFrame.RightVector end
                                    if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then direction += Vector3.yAxis end
                                        if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.Q] then direction -= Vector3.yAxis end
                                            local speed = keys[Enum.KeyCode.LeftShift] and self.State.Speed * self.State.SprintMultiplier or self.State.Speed
                                            linearVelocity.VectorVelocity = direction.Magnitude > 0 and direction.Unit * speed or Vector3.zero
                                        end)
                                        table.insert(self.State.Connections, loop)
                                    end
                                    function Modules.Fly:Toggle()
                                        if self.State.IsActive then
                                            self:Disable()
                                        else
                                        self:Enable()
                                    end
                                end
                                RegisterCommand({ Name = "fly", Aliases = {"flight"}, Description = "Toggles smooth flight mode." }, function()
                                Modules.Fly:Toggle()
                            end)
Modules.NoClip = {
    State = {
        IsEnabled = false,
        Connections = {},
        TrackedParts = setmetatable({}, {__mode = "k"})
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

function Modules.NoClip:_addPart(part)
    if not part:IsA("BasePart") then return end
    self.State.TrackedParts[part] = true
    part.CanCollide = false
end

function Modules.NoClip:_processCharacter(character)
    if not character then return end
    
    if self.State.Connections[character] then
        for _, conn in ipairs(self.State.Connections[character]) do conn:Disconnect() end
    end
    self.State.Connections[character] = {}

    for _, descendant in ipairs(character:GetDescendants()) do
        self:_addPart(descendant)
    end
    
    local descAddedConn = character.DescendantAdded:Connect(function(descendant)
        self:_addPart(descendant)
    end)
    
    local descRemovingConn = character.DescendantRemoving:Connect(function(descendant)
        if self.State.TrackedParts[descendant] then
            self.State.TrackedParts[descendant] = nil
        end
    end)
    
    table.insert(self.State.Connections[character], descAddedConn)
    table.insert(self.State.Connections[character], descRemovingConn)
end


function Modules.NoClip:_cleanup()
    -- Disconnect all active connections
    for key, conn in pairs(self.State.Connections) do
        if type(conn) == "table" then -- Character-specific connections
            for _, innerConn in ipairs(conn) do innerConn:Disconnect() end
        else -- Main connections (Stepped, CharacterAdded, etc.)
            conn:Disconnect()
        end
    end
    table.clear(self.State.Connections)
    
    -- Restore original collision properties
    for part in pairs(self.State.TrackedParts) do
        if part and part.Parent then

            part.CanCollide = true
        end
    end
    table.clear(self.State.TrackedParts)
end


function Modules.NoClip:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer

    -- Apply to the current character immediately
    if localPlayer.Character then
        self:_processCharacter(localPlayer.Character)
    end

    -- Set up listeners for character respawns
    self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char)
        self:_processCharacter(char)
    end)


    self.State.Connections.Enforcer = self.Services.RunService.Stepped:Connect(function()
        for part in pairs(self.State.TrackedParts) do
            if part and part.Parent and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)

    DoNotif("Persistent NoClip Enabled", 2)
end


function Modules.NoClip:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    self:_cleanup()
    
    DoNotif("NoClip Disabled", 2)
end


function Modules.NoClip:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

RegisterCommand({ Name = "noclip", Aliases = {"nc"}, Description = "Allows you to fly through walls and objects." }, function()
    Modules.NoClip:Toggle()
end)

                                    Modules.AnimationFreezer = {
                                    State = {
                                    IsEnabled = false,
                                    CharacterConnection = nil,
                                    Originals = {}
                                    }
                                    }
                                    function Modules.AnimationFreezer:_applyFreeze(character)
                                        if not character or self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
                                                local animator = humanoid:FindFirstChildOfClass("Animator")
                                                if not animator then return end
                                                    self.State.Originals[character] = animator
                                                    local fakeAnimationTrack = {
                                                    IsPlaying = false,
                                                    Length = 0,
                                                    TimePosition = 0,
                                                    Speed = 0,
                                                    Play = function() end,
                                                    Stop = function() end,
                                                    Pause = function() end,
                                                    AdjustSpeed = function() end,
                                                    GetMarkerReachedSignal = function() return { Connect = function() end } end,
                                                    GetTimeOfKeyframe = function() return 0 end,
                                                    Destroy = function() end
                                                    }
                                                    local animatorProxy = {}
                                                    local animatorMetatable = {
                                                    __index = function(t, key)
                                                    if tostring(key):lower() == "loadanimation" then
                                                        return function()
                                                        return fakeAnimationTrack
                                                    end
                                                else
                                                return self.State.Originals[character][key]
                                            end
                                        end
                                        }
                                        setmetatable(animatorProxy, animatorMetatable)
                                        animator.Parent = nil
                                        animatorProxy.Name = "Animator"
                                        animatorProxy.Parent = humanoid
                                    end
                                    function Modules.AnimationFreezer:_removeFreeze(character)
                                        if not character or not self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
                                                local proxy = humanoid:FindFirstChild("Animator")
                                                local original = self.State.Originals[character]
                                                if proxy then proxy:Destroy() end
                                                    if original then original.Parent = humanoid end
                                                        self.State.Originals[character] = nil
                                                    end
                                                    function Modules.AnimationFreezer:Toggle()
                                                        self.State.IsEnabled = not self.State.IsEnabled
                                                        if self.State.IsEnabled then
                                                            DoNotif("Animation Freezer Enabled", 2)
                                                            if LocalPlayer.Character then
                                                                self:_applyFreeze(LocalPlayer.Character)
                                                            end
                                                            self.State.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                                                            task.wait(0.1)
                                                            self:_applyFreeze(character)
                                                        end)
                                                    else
                                                    DoNotif("Animation Freezer Disabled", 2)
                                                    if LocalPlayer.Character then
                                                        self:_removeFreeze(LocalPlayer.Character)
                                                    end
                                                    if self.State.CharacterConnection then
                                                        self.State.CharacterConnection:Disconnect()
                                                        self.State.CharacterConnection = nil
                                                    end
                                                    for char, animator in pairs(self.State.Originals) do
                                                        self:_removeFreeze(char)
                                                    end
                                                end
                                            end
                                            RegisterCommand({
                                            Name = "freezeanim",
                                            Aliases = {"noanim", "fa"},
                                            Description = "Freezes all local character animations to skip delays (e.g., weapon swings)."
                                            }, function()
                                            Modules.AnimationFreezer:Toggle()
                                        end)

                                        Modules.AutoDecompiler = {
                                        State = {
                                        IsEnabled = false,
                                        IsReady = false,
                                        Connections = {},
                                        LastAPICall = 0
                                        },
                                        API_URL = "http://api.plusgiant5.com"
                                        }
                                        function Modules.AutoDecompiler:_prepareDecompiler()
                                            if self.State.IsReady then return true end
                                                if not getscriptbytecode or not request then
                                                    warn("AutoDecompiler Error: 'getscriptbytecode' and/or 'request' are not available in this environment.")
                                                    return false
                                                end
                                                print("AutoDecompiler: Executor dependencies found. Ready.")
                                                self.State.IsReady = true
                                                return true
                                            end
                                            function Modules.AutoDecompiler:_decompileViaAPI(scriptObject)
                                                local success, bytecode = pcall(getscriptbytecode, scriptObject)
                                                if not success then
                                                    warn("AutoDecompiler:", scriptObject:GetFullName(), "- Failed to get bytecode:", tostring(bytecode))
                                                    return nil
                                                end
                                                local timeElapsed = os.clock() - self.State.LastAPICall
                                                if timeElapsed < 0.5 then
                                                    task.wait(0.5 - timeElapsed)
                                                end
                                                local success, httpResult = pcall(request, {
                                                Url = self.API_URL .. "/konstant/decompile",
                                                Body = bytecode,
                                                Method = "POST",
                                                Headers = { ["Content-Type"] = "text/plain" }
                                                })
                                                self.State.LastAPICall = os.clock()
                                                if not success then
                                                    warn("AutoDecompiler: request() function failed:", tostring(httpResult))
                                                    return nil
                                                end
                                                if httpResult and httpResult.StatusCode == 200 then
                                                    return httpResult.Body
                                                else
                                                warn("AutoDecompiler: API returned non-200 status:", httpResult.StatusCode, httpResult.Body)
                                                return nil
                                            end
                                        end
                                        function Modules.AutoDecompiler:Disable()
                                            DoNotif("Auto Decompiler Disabled.", 3)
                                            for _, connection in ipairs(self.State.Connections) do
                                                if connection.Connected then
                                                    connection:Disconnect()
                                                end
                                            end
                                            table.clear(self.State.Connections)
                                        end
                                        function Modules.AutoDecompiler:Enable()
                                            if not self:_prepareDecompiler() then
                                                DoNotif("Decompiler dependencies not met. Check console.", 5)
                                                self.State.Enabled = false
                                                return
                                            end
                                            DoNotif("Auto Decompiler Enabled. Sweeping existing scripts...", 4)
                                            local function processScript(script)
                                            local decompiledSource = self:_decompileViaAPI(script)
                                            if decompiledSource then
                                                local success, err = pcall(function() script.Source = decompiledSource end)
                                                if not success then
                                                    warn("Could not set source for", script:GetFullName(), "- it may be read-only. Error:", err)
                                                end
                                            end
                                        end
                                        task.spawn(function()
                                        for _, descendant in ipairs(game:GetDescendants()) do
                                            if descendant:IsA("LuaSourceContainer") then
                                                processScript(descendant)
                                                task.wait()
                                            end
                                        end
                                        print("Initial script sweep completed.")
                                    end)
                                    local conn = game.DescendantAdded:Connect(function(descendant)
                                    if descendant:IsA("LuaSourceContainer") then
                                        print("New script detected:", descendant:GetFullName())
                                        processScript(descendant)
                                    end
                                end)
                                table.insert(self.State.Connections, conn)
                            end
                            function Modules.AutoDecompiler:Toggle()
                                self.State.Enabled = not self.State.Enabled
                                if self.State.Enabled then
                                    self:Enable()
                                else
                                self:Disable()
                            end
                        end
                        function Modules.AutoDecompiler:Initialize()
                            local module = self
                            RegisterCommand({
                            Name = "autodecompile",
                            Aliases = {"adecompile", "decompile"},
                            Description = "Automatically decompiles scripts using a bytecode API."
                            }, function(args)
                            module:Toggle()
                        end)
                    end

                    local Players = game:GetService("Players")
                    local RunService = game:GetService("RunService")
                    
                    Modules.RespawnAtDeath = {
                    State = {
                    Enabled = false,
                    LastDeathCFrame = nil,
                    DiedConnection = nil,
                    CharacterConnection = nil,
                    }
                    }
                    function Modules.RespawnAtDeath.OnDied()
                        local character = Players.LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then
                            Modules.RespawnAtDeath.State.LastDeathCFrame = root.CFrame
                            print("Death location saved.")
                        end
                    end
                    function Modules.RespawnAtDeath.OnCharacterAdded(character)
                        local humanoid = character:WaitForChild("Humanoid")
                        if Modules.RespawnAtDeath.State.DiedConnection then
                            Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
                        end
                        Modules.RespawnAtDeath.State.DiedConnection = humanoid.Died:Connect(Modules.RespawnAtDeath.OnDied)
                        local deathCFrame = Modules.RespawnAtDeath.State.LastDeathCFrame
                        if deathCFrame then
                            coroutine.wrap(function()
                            print("Teleporting to saved death location...")
                            task.wait(0.1)
                            local root = character:WaitForChild("HumanoidRootPart")
                            if not root then return end
                                local originalAnchored = root.Anchored
                                root.Anchored = true
                                root.CFrame = deathCFrame
                                RunService.Heartbeat:Wait()
                                root.Anchored = originalAnchored
                                Modules.RespawnAtDeath.State.LastDeathCFrame = nil
                                print("Teleport successful.")
                            end)()
                        end
                    end
                    function Modules.RespawnAtDeath.Toggle()
                        local localPlayer = Players.LocalPlayer
                        Modules.RespawnAtDeath.State.Enabled = not Modules.RespawnAtDeath.State.Enabled
                        if Modules.RespawnAtDeath.State.Enabled then
                            print("revert: ENABLED")
                            Modules.RespawnAtDeath.State.CharacterConnection = localPlayer.CharacterAdded:Connect(Modules.RespawnAtDeath.OnCharacterAdded)
                            if localPlayer.Character then
                                Modules.RespawnAtDeath.OnCharacterAdded(localPlayer.Character)
                            end
                        else
                        print("revert: DISABLED")
                        if Modules.RespawnAtDeath.State.DiedConnection then
                            Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
                            Modules.RespawnAtDeath.State.DiedConnection = nil
                        end
                        if Modules.RespawnAtDeath.State.CharacterConnection then
                            Modules.RespawnAtDeath.State.CharacterConnection:Disconnect()
                            Modules.RespawnAtDeath.State.CharacterConnection = nil
                        end
                        Modules.RespawnAtDeath.State.LastDeathCFrame = nil
                    end
                end
                RegisterCommand({
                Name = "revert",
                Aliases = {"deathspawn", "spawnondeath"},
                Description = "Toggles respawning at your last death location."
                }, function(args)
                Modules.RespawnAtDeath.Toggle()
            end)
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            Modules.RejoinServer = {
            State = {}
            }
            RegisterCommand({
            Name = "rejoin",
            Aliases = {"rj", "reconnect"},
            Description = "Teleports you back to the current server."
            }, function(args)
            local localPlayer = Players.LocalPlayer
            if not localPlayer then
                print("Error: Could not find LocalPlayer.")
                return
            end
            local placeId = game.PlaceId
            local jobId = game.JobId
            print("Rejoining server... Please wait.")
            local success, errorMessage = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
        end)
        if not success then
            print("Rejoin failed: " .. errorMessage)
        end
    end)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

Modules.AutoAttack = {
    State = {
        Enabled = false,
        ClickDelay = 0.1,
        Connection = nil,
        LastClickTime = 0,
        ToggleKey = Enum.KeyCode.H
    }
}

function Modules.AutoAttack:AttackLoop()
    if UserInputService:GetFocusedTextBox() then
        return
    end
    local currentTime = os.clock()
    if currentTime - self.State.LastClickTime > self.State.ClickDelay then
        mouse1press()
        task.wait()
        mouse1release()
        self.State.LastClickTime = currentTime
    end
end

function Modules.AutoAttack:Enable()
    self.State.Enabled = true
    self.State.LastClickTime = 0
    self.State.Connection = RunService.Heartbeat:Connect(function()
        self:AttackLoop()
    end)
    DoNotif("Auto-Attack: [Enabled] | Delay: " .. self.State.ClickDelay * 1000 .. "ms", 2)
end

function Modules.AutoAttack:Disable()
    self.State.Enabled = false
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    DoNotif("Auto-Attack: [Disabled]", 2)
end

function Modules.AutoAttack:Toggle()
    if self.State.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or UserInputService:GetFocusedTextBox() then
        return
    end
    if input.KeyCode == Modules.AutoAttack.State.ToggleKey then
        Modules.AutoAttack:Toggle()
    end
end)

RegisterCommand({
    Name = "autoattack",
    Aliases = {"aa", "autoclick"},
    Description = "Toggles auto-click. Usage: ;aa [delay_ms | key key_name]"
}, function(args)
    local subCommand = args[1] and args[1]:lower()
    local value = args[2]

    if subCommand == "key" then
        if value and Enum.KeyCode[value:upper()] then
            local newKey = Enum.KeyCode[value:upper()]
            Modules.AutoAttack.State.ToggleKey = newKey
            DoNotif("Auto-Attack toggle key set to: " .. value:upper(), 2)
        else
            DoNotif("Invalid key name. Example: E, Q, F, MouseButton1", 3)
        end
        return
    end
    
    local newDelay = tonumber(subCommand)
    if newDelay and newDelay > 0 then
        Modules.AutoAttack.State.ClickDelay = newDelay / 1000
        DoNotif("Auto-Attack delay set to: " .. newDelay .. "ms", 2)
        return
    end
    
    Modules.AutoAttack:Toggle()
end)

Modules.killbrick = {
State = {
Tracked = setmetatable({}, {__mode="k"}),
Originals = setmetatable({}, {__mode="k"}),
Signals = setmetatable({}, {__mode="k"}),
Connections = {}
}
}
local function cleanupAntiKillbrick()
local state = Modules.killbrick.State
for _, conn in ipairs(state.Connections) do
    if conn and typeof(conn.Disconnect) == "function" then
        conn:Disconnect()
    end
end
table.clear(state.Connections)
for _, signalTable in pairs(state.Signals) do
    if signalTable then
        for _, conn in ipairs(signalTable) do
            if conn and typeof(conn.Disconnect) == "function" then
                conn:Disconnect()
            end
        end
    end
end
for part, originalValue in pairs(state.Originals) do
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        part.CanTouch = (originalValue == nil) or originalValue
    end
end
table.clear(state.Signals)
table.clear(state.Tracked)
table.clear(state.Originals)
end
function Modules.killbrick.Enable()
    cleanupAntiKillbrick()
    local state = Modules.killbrick.State
    local localPlayer = Players.LocalPlayer
    local function applyProtection(part)
    if not (part and part:IsA("BasePart")) then return end
        if state.Originals[part] == nil then
            state.Originals[part] = part.CanTouch
        end
        part.CanTouch = false
        state.Tracked[part] = true
        if not state.Signals[part] then
            local connection = part:GetPropertyChangedSignal("CanTouch"):Connect(function()
            if part.CanTouch ~= false then
                part.CanTouch = false
            end
        end)
        state.Signals[part] = {connection}
    end
end
local function setupCharacter(character)
if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        applyProtection(descendant)
    end
    table.insert(state.Connections, character.DescendantAdded:Connect(applyProtection))
    table.insert(state.Connections, character.DescendantRemoving:Connect(function(descendant)
    if state.Signals[descendant] then
        for _, conn in ipairs(state.Signals[descendant]) do conn:Disconnect() end
            state.Signals[descendant] = nil
        end
        state.Tracked[descendant] = nil
        state.Originals[descendant] = nil
    end))
end
local function onCharacterAdded(character)
cleanupAntiKillbrick()
task.wait()
setupCharacter(character)
end
if localPlayer.Character then
    setupCharacter(localPlayer.Character)
end
table.insert(state.Connections, localPlayer.CharacterAdded:Connect(onCharacterAdded))
table.insert(state.Connections, localPlayer.CharacterRemoving:Connect(cleanupAntiKillbrick))
table.insert(state.Connections, RunService.Stepped:Connect(function()
if not localPlayer.Character then return end
    for part in pairs(state.Tracked) do
        if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent and part.CanTouch ~= false then
            part.CanTouch = false
        end
    end
end))
print("Anti-KillBrick Enabled.")
end
function Modules.killbrick.Disable()
    cleanupAntiKillbrick()
    print("Anti-KillBrick Disabled.")
end
RegisterCommand({
Name = "antikillbrick",
Aliases = {"antikb"},
Description = "Prevents kill bricks from killing you."
}, function(args)
Modules.killbrick.Enable(args)
end)
RegisterCommand({
Name = "unantikillbrick",
Aliases = {"unantikb"},
Description = "Allows kill bricks to kill you again."
}, function(args)
Modules.killbrick.Disable(args)
end)
Modules.FlingProtection = {
State = {
IsEnabled = false,
SteppedConnection = nil,
PlayerConnections = {}
},
Config = {
MAX_VELOCITY_MAGNITUDE = 200,
LOCAL_PLAYER_GROUP = "LocalPlayerCollisionGroup",
OTHER_PLAYERS_GROUP = "OtherPlayersCollisionGroup"
}
}
function Modules.FlingProtection:_setCollisionGroupForCharacter(character, groupName)
    if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CollisionGroup = groupName end)
            end
        end
    end
    function Modules.FlingProtection:_setupPlayerCollisions()
        local PhysicsService = game:GetService("PhysicsService")
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.LOCAL_PLAYER_GROUP) end)
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.OTHER_PLAYERS_GROUP) end)
        PhysicsService:CollisionGroupSetCollidable(self.Config.LOCAL_PLAYER_GROUP, self.Config.OTHER_PLAYERS_GROUP, false)
        for _, player in ipairs(Players:GetPlayers()) do
            local group = (player == LocalPlayer) and self.Config.LOCAL_PLAYER_GROUP or self.Config.OTHER_PLAYERS_GROUP
            if player.Character then
                self:_setCollisionGroupForCharacter(player.Character, group)
            end
            local conn = player.CharacterAdded:Connect(function(character)
            self:_setCollisionGroupForCharacter(character, group)
        end)
        table.insert(self.State.PlayerConnections, conn)
    end
    local conn = Players.PlayerAdded:Connect(function(player)
    local group = self.Config.OTHER_PLAYERS_GROUP
    local charConn = player.CharacterAdded:Connect(function(character)
    self:_setCollisionGroupForCharacter(character, group)
end)
table.insert(self.State.PlayerConnections, charConn)
end)
table.insert(self.State.PlayerConnections, conn)
end
function Modules.FlingProtection:_revertPlayerCollisions()
    for _, conn in ipairs(self.State.PlayerConnections) do
        conn:Disconnect()
    end
    self.State.PlayerConnections = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            self:_setCollisionGroupForCharacter(player.Character, "Default")
        end
    end
end
function Modules.FlingProtection:_enforceStability()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (hrp and not hrp.Anchored) then return end
        if hrp.AssemblyLinearVelocity.Magnitude > self.Config.MAX_VELOCITY_MAGNITUDE then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
    function Modules.FlingProtection:Toggle()
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            DoNotif("Fling & Player Collision Protection: ENABLED", 2)
            self:_setupPlayerCollisions()
            self.State.SteppedConnection = RunService.Stepped:Connect(function() self:_enforceStability() end)
        else
        DoNotif("Fling & Player Collision Protection: DISABLED", 2)
        self:_revertPlayerCollisions()
        if self.State.SteppedConnection then
            self.State.SteppedConnection:Disconnect()
            self.State.SteppedConnection = nil
        end
    end
end

do
	local ATTRIBUTE_OG_SIZE = "Zuka_OriginalSize"
	local SELECTION_BOX_NAME = "Zuka_ReachSelectionBox"

	local activeTool: Tool? = nil
	local modifiedPart: BasePart? = nil
	local persistentToolName: string? = nil
	local persistentPartName: string? = nil
	local currentReachSize: number = 20
	local currentReachType: "directional" | "box" = "directional"
	
	Modules.ReachController = {
		State = {
			IsEnabled = false,
			UI = nil,
			Connections = {}
		}
	}
	
	local function updatePartModification(part: BasePart, newSize: number?, reachType: string?)
		if not part or not part.Parent then return end
		local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)
		if not newSize then
			if originalSize then part.Size = originalSize; part:SetAttribute(ATTRIBUTE_OG_SIZE, nil) end
			local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
			if selectionBox then selectionBox:Destroy() end
			return
		end
		if not originalSize then part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size) end
		local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME) or Instance.new("SelectionBox")
		selectionBox.Name = SELECTION_BOX_NAME; selectionBox.Adornee = part; selectionBox.LineThickness = 0.02; selectionBox.Parent = part
		selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
		if reachType == "box" then part.Size = Vector3.one * newSize else part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize) end
		part.Massless = true
	end

	local function resetReach()
		if not modifiedPart and not persistentToolName then print("Reach is not active."); return end
		local tool; if persistentToolName then tool = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(persistentToolName)) or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(persistentToolName)) end
		local partToReset = modifiedPart or (tool and persistentPartName and tool:FindFirstChild(persistentPartName, true))
		if partToReset then updatePartModification(partToReset, nil, nil) end
		modifiedPart, persistentToolName, persistentPartName = nil, nil, nil
		print("Tool reach has been fully reset.")
	end

	function Modules.ReachController:Enable()
		if self.State.IsEnabled then return end
		self.State.IsEnabled = true
		
		local ui = Instance.new("ScreenGui"); ui.Name = "ReachController_Zuka"; ui.ZIndexBehavior = Enum.ZIndexBehavior.Global; ui.ResetOnSpawn = false
		self.State.UI = ui
		
		local mainFrame = Instance.new("Frame", ui); mainFrame.Size = UDim2.fromOffset(250, 320); mainFrame.Position = UDim2.fromScale(0, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); mainFrame.BorderSizePixel = 0; mainFrame.ClipsDescendants = true
		Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
		
		local titleBar = Instance.new("Frame", mainFrame); titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35); titleBar.BorderSizePixel = 0
		local title = Instance.new("TextLabel", titleBar); title.Size = UDim2.new(1, -30, 1, 0); title.Position = UDim2.fromOffset(10, 0); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamSemibold; title.Text = "Reach Controller"; title.TextColor3 = Color3.fromRGB(200, 220, 255); title.TextSize = 16; title.TextXAlignment = Enum.TextXAlignment.Left
		local contentFrame = Instance.new("Frame", mainFrame); contentFrame.Name = "Content"; contentFrame.Size = UDim2.new(1, 0, 1, -30); contentFrame.Position = UDim2.new(0, 0, 0, 30); contentFrame.BackgroundTransparency = 1
		local toggleButton = Instance.new("TextButton", titleBar); toggleButton.Size = UDim2.fromOffset(20, 20); toggleButton.Position = UDim2.new(1, -10, 0.5, 0); toggleButton.AnchorPoint = Vector2.new(1, 0.5); toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100); toggleButton.Text = "-"; toggleButton.Font = Enum.Font.GothamBold; toggleButton.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

		titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then local dragStart, startPos = input.Position, mainFrame.Position; local moveConn, endConn; moveConn = UserInputService.InputChanged:Connect(function(moveInput) if moveInput.UserInputType == Enum.UserInputType.MouseMovement then local delta = moveInput.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end); endConn = UserInputService.InputEnded:Connect(function(endInput) if endInput.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect(); endConn:Disconnect() end end) end end)
		local sizeLabel = Instance.new("TextLabel", contentFrame); sizeLabel.Size = UDim2.fromOffset(80, 20); sizeLabel.Position = UDim2.fromOffset(10, 10); sizeLabel.BackgroundTransparency = 1; sizeLabel.Font = Enum.Font.Gotham; sizeLabel.Text = "Reach Size:"; sizeLabel.TextColor3 = Color3.new(1, 1, 1); sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
		local sizeInput = Instance.new("TextBox", contentFrame); sizeInput.Size = UDim2.fromOffset(130, 30); sizeInput.Position = UDim2.fromOffset(110, 5); sizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65); sizeInput.Font = Enum.Font.Code; sizeInput.Text = tostring(currentReachSize); sizeInput.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 4)
		local directionalBtn = Instance.new("TextButton", contentFrame); directionalBtn.Size = UDim2.fromOffset(110, 30); directionalBtn.Position = UDim2.fromOffset(10, 40); directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); directionalBtn.Font = Enum.Font.GothamSemibold; directionalBtn.Text = "Directional"; directionalBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", directionalBtn).CornerRadius = UDim.new(0, 4)
		local boxBtn = Instance.new("TextButton", contentFrame); boxBtn.Size = UDim2.fromOffset(110, 30); boxBtn.Position = UDim2.fromOffset(130, 40); boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65); boxBtn.Font = Enum.Font.GothamSemibold; boxBtn.Text = "Box"; boxBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", boxBtn).CornerRadius = UDim.new(0, 4)
		local partsLabel = Instance.new("TextLabel", contentFrame); partsLabel.Size = UDim2.fromOffset(80, 20); partsLabel.Position = UDim2.fromOffset(10, 75); partsLabel.BackgroundTransparency = 1; partsLabel.Font = Enum.Font.Gotham; partsLabel.Text = "Tool Parts:"; partsLabel.TextColor3 = Color3.new(1, 1, 1); partsLabel.TextXAlignment = Enum.TextXAlignment.Left
		local scroll = Instance.new("ScrollingFrame", contentFrame); scroll.Size = UDim2.new(1, -20, 1, -140); scroll.Position = UDim2.fromOffset(10, 100); scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35); scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 6
		local resetBtn = Instance.new("TextButton", contentFrame); resetBtn.Size = UDim2.new(1, -20, 0, 30); resetBtn.Position = UDim2.new(0.5, 0, 1, -10); resetBtn.AnchorPoint = Vector2.new(0.5, 1); resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); resetBtn.Font = Enum.Font.GothamBold; resetBtn.Text = "Reset Reach"; resetBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 4)

		local function populatePartSelector()
			scroll:ClearAllChildren(); if not activeTool then return end
			local parts = {}; for _, d in ipairs(activeTool:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end
			if #parts == 0 then return end
			local listLayout = Instance.new("UIListLayout", scroll); listLayout.Padding = UDim.new(0, 5); listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			for _, part in ipairs(parts) do
				local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1, -10, 0, 30); btn.Position = UDim2.fromScale(0.5, 0); btn.AnchorPoint = Vector2.new(0.5, 0); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65); btn.TextColor3 = Color3.fromRGB(220, 220, 230); btn.Font = Enum.Font.Code; btn.Text = part.Name; btn.TextSize = 14; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
				btn.MouseButton1Click:Connect(function()
					if not part or not part.Parent or not activeTool then print("Reach Error: Part/tool missing."); return end
					persistentToolName, persistentPartName = activeTool.Name, part.Name
					if modifiedPart and modifiedPart ~= part then updatePartModification(modifiedPart, nil, nil) end
					modifiedPart = part; updatePartModification(part, currentReachSize, currentReachType)
					print(string.format("Reach set for '%s' on tool '%s'.", part.Name, activeTool.Name))
				end)
			end
		end

		sizeInput.FocusLost:Connect(function() local num = tonumber(sizeInput.Text); if num and num > 0 then currentReachSize = num else sizeInput.Text = tostring(currentReachSize) end end)
		directionalBtn.MouseButton1Click:Connect(function() currentReachType = "directional"; directionalBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); boxBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
		boxBtn.MouseButton1Click:Connect(function() currentReachType = "box"; boxBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100); directionalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
		resetBtn.MouseButton1Click:Connect(resetReach)
		toggleButton.MouseButton1Click:Connect(function() contentFrame.Visible = not contentFrame.Visible; toggleButton.Text = contentFrame.Visible and "-" or "+"; mainFrame.Size = contentFrame.Visible and UDim2.fromOffset(250, 320) or UDim2.fromOffset(250, 30) end)

		local function onToolEquipped(tool)
			activeTool = tool; populatePartSelector()
			if self.State.Connections.Unequipped then self.State.Connections.Unequipped:Disconnect() end
			self.State.Connections.Unequipped = tool.Unequipped:Connect(function() activeTool = nil; populatePartSelector() end)
		end

		local function onCharacterAdded(character)
			if persistentToolName and persistentPartName then
				local function reapply(tool) if tool and tool.Name == persistentToolName then local part = tool:WaitForChild(persistentPartName, 2); if part and part:IsA("BasePart") then updatePartModification(part, currentReachSize, currentReachType); modifiedPart = part end end end
				reapply(character:FindFirstChild(persistentToolName)); self.State.Connections["Reapply"..character.Name] = character.ChildAdded:Connect(function(child) if child:IsA("Tool") then reapply(child) end end)
			end
			self.State.Connections["ToolListener"..character.Name] = character.ChildAdded:Connect(function(child) if child:IsA("Tool") then onToolEquipped(child) end end)
			local firstTool = character:FindFirstChildOfClass("Tool"); if firstTool then onToolEquipped(firstTool) end
		end

		if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
		self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

		ui.Parent = CoreGui
		DoNotif("Reach Controller: ENABLED.", 2)
	end
	
	function Modules.ReachController:Disable()
		if not self.State.IsEnabled then return end
		self.State.IsEnabled = false
		resetReach()
		if self.State.UI and self.State.UI.Parent then self.State.UI:Destroy() end
		self.State.UI = nil
		for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
		table.clear(self.State.Connections)
		DoNotif("Reach Controller: DISABLED.", 2)
	end

	function Modules.ReachController:Toggle()
		if self.State.IsEnabled then self:Disable() else self:Enable() end
	end
end

RegisterCommand({ Name = "reachgui", Aliases = { "reachcontroller" }, Description = "Toggles a GUI for advanced tool reach modification." }, function() Modules.ReachController:Toggle() end)


RegisterCommand({
Name = "antifling",
Aliases = {"anf"},
Description = "Prevents flinging and disables collision with other players."
}, function()
Modules.FlingProtection:Toggle()
end)
Modules.Reach = {
Connections = {},
State = {
IsEnabled = false,
ActiveTool = nil,
ModifiedPart = nil,
PersistentToolName = nil,
PersistentPartName = nil,
ReachType = nil,
ReachSize = nil,
UI = {
ScreenGui = nil,
Frame = nil,
ScrollingFrame = nil,
CloseButton = nil
}
}
}
local ATTRIBUTE_OG_SIZE = "OriginalSize"
local SELECTION_BOX_NAME = "ReachSelectionBox"
function Modules.Reach:_updatePartModification(part, newSize, reachType)
    if not part or not part.Parent then return end
        local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)
        if not newSize then
            if originalSize then
                part.Size = originalSize
                part:SetAttribute(ATTRIBUTE_OG_SIZE, nil)
            end
            if part:FindFirstChild(SELECTION_BOX_NAME) then
                part[SELECTION_BOX_NAME]:Destroy()
            end
            return
        end
        if not originalSize then
            part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size)
        end
        local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
        if not selectionBox then
            selectionBox = Instance.new("SelectionBox", part)
            selectionBox.Name = SELECTION_BOX_NAME
            selectionBox.Adornee = part
            selectionBox.LineThickness = 0.02
        end
        selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
        if reachType == "box" then
            part.Size = Vector3.one * newSize
        else
        part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize)
    end
    part.Massless = true
end
function Modules.Reach:_populatePartSelector()
    local self = Modules.Reach
    local scroll = self.State.UI.ScrollingFrame
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    if not self.State.ActiveTool then return end
        local parts = {}
        for _, descendant in ipairs(self.State.ActiveTool:GetDescendants()) do
            if descendant:IsA("BasePart") then
                table.insert(parts, descendant)
            end
        end
        if #parts == 0 then
            DoNotif("Equipped tool has no physical parts.", 3)
            return
        end
        for _, part in ipairs(parts) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            btn.Font = Enum.Font.Code
            btn.Text = part.Name
            btn.TextSize = 14
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
            if not part or not part.Parent or not self.State.ActiveTool then
                self.State.UI.ScreenGui.Enabled = false
                return DoNotif("The selected part or tool no longer exists.", 3)
            end
            self.State.PersistentToolName = self.State.ActiveTool.Name
            self.State.PersistentPartName = part.Name
            if self.State.ModifiedPart and self.State.ModifiedPart ~= part then
                self:_updatePartModification(self.State.ModifiedPart)
            end
            self.State.IsEnabled = true
            self.State.ModifiedPart = part
            self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
            self.State.UI.ScreenGui.Enabled = false
            DoNotif("Persistently set reach for " .. part.Name .. " on " .. self.State.PersistentToolName, 3)
        end)
    end
end
function Modules.Reach:_onToolEquipped(tool)
    local self = Modules.Reach
    self.State.ActiveTool = tool
    self:_populatePartSelector()
    if self.Connections.Unequipped then self.Connections.Unequipped:Disconnect() end
        self.Connections.Unequipped = tool.Unequipped:Connect(function()
        self.State.ActiveTool = nil
        self.State.UI.ScreenGui.Enabled = false
    end)
end
function Modules.Reach:_onCharacterAdded(character)
    local self = Modules.Reach
    if self.State.PersistentToolName and self.State.PersistentPartName then
        local function reapplyModification(tool)
        if tool and tool.Name == self.State.PersistentToolName then
            local part = tool:WaitForChild(self.State.PersistentPartName, 5)
            if part then
                self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
                self.State.ModifiedPart = part
                self.State.IsEnabled = true
            end
        end
    end
    local equippedTool = character:FindFirstChild(self.State.PersistentToolName)
    reapplyModification(equippedTool)
    character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        reapplyModification(child)
    end
end)
end
character.ChildAdded:Connect(function(child)
if child:IsA("Tool") then self:_onToolEquipped(child) end
end)
local firstEquippedTool = character:FindFirstChildOfClass("Tool")
if firstEquippedTool then self:_onToolEquipped(firstEquippedTool) end
end
function Modules.Reach:Apply(reachType, size)
    local self = Modules.Reach
    if not self.State.ActiveTool then
        return DoNotif("You must have a tool equipped to select a part.", 3)
    end
    self.State.ReachType = reachType
    self.State.ReachSize = size
    self:_populatePartSelector()
    self.State.UI.ScreenGui.Enabled = true
end
function Modules.Reach:Reset()
    local self = Modules.Reach
    if not self.State.IsEnabled and not self.State.PersistentToolName then
        return DoNotif("Reach is not active and no part is set.", 3)
    end
    local tool
    if self.State.PersistentToolName then
        tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(self.State.PersistentToolName)
        if not tool then
            tool = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(self.State.PersistentToolName)
        end
    end
    if tool and self.State.PersistentPartName then
        local part = tool:FindFirstChild(self.State.PersistentPartName, true)
        if part then
            self:_updatePartModification(part)
        end
    end
    self.State.IsEnabled = false
    self.State.ModifiedPart = nil
    self.State.PersistentToolName = nil
    self.State.PersistentPartName = nil
    self.State.ReachType = nil
    self.State.ReachSize = nil
    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui.Enabled = false
    end
    DoNotif("Tool reach has been fully reset and persistence cleared.", 3)
end
function Modules.Reach:Initialize()
    local self = Modules.Reach
    local ui = Instance.new("ScreenGui")
    ui.Name = "ReachPartSelector_Persistent"
    ui.Parent = CoreGui
    ui.Enabled = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.ResetOnSpawn = false
    self.State.UI.ScreenGui = ui
    local frame = Instance.new("Frame", ui)
    frame.Size = UDim2.fromOffset(250, 220)
    frame.Position = UDim2.new(0.5, -125, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    self.State.UI.Frame = frame
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Code
    title.Text = "Select a Part to Modify"
    title.TextColor3 = Color3.fromRGB(200, 220, 255)
    title.TextSize = 16
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.fromOffset(10, 35)
    scroll.BackgroundColor3 = frame.BackgroundColor3
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    self.State.UI.ScrollingFrame = scroll
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
    closeBtn.MouseButton1Click:Connect(function() ui.Enabled = false end)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
    self.State.UI.CloseButton = closeBtn
    if LocalPlayer.Character then
        self:_onCharacterAdded(LocalPlayer.Character)
    end
    self.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(char)
    self:_onCharacterAdded(char)
end)
RegisterCommand({Name = "reach", Aliases = {"swordreach"}, Description = "Extends sword reach. ;reach [num]"}, function(args)
self:Apply("directional", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "boxreach", Aliases = {}, Description = "Creates a box hitbox. ;boxreach [num]"}, function(args)
self:Apply("box", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "resetreach", Aliases = {"unreach"}, Description = "Resets tool reach and clears persistent setting."}, function()
self:Reset()
end)
end
RegisterCommand({Name = "goto", Aliases = {}, Description = "Teleports to a player. ;goto [player]"}, function(args)
if not args[1] then
    return DoNotif("Specify a player's name.", 3)
end
local targetPlayer = Utilities.findPlayer(args[1])
if targetPlayer then
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if localHRP and targetHRP then
        localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        DoNotif("Teleported to " .. targetPlayer.Name, 3)
    else
    DoNotif("Target player's character could not be found.", 3)
end
else
DoNotif("Player not found.", 3)
end
end)
Modules.AdvancedFling = {
    State = {
        IsFlinging = false
    }
}

-- NOTE: The original findFlingTargets function is retained as it is more comprehensive
-- and already integrated with the command system's argument parsing.
local function findFlingTargets(targetName)
    local targets = {}
    local localPlayer = Players.LocalPlayer
    local lowerTargetName = targetName and targetName:lower() or "nil"

    if not targetName or lowerTargetName == "me" then
        return { localPlayer }
    end
    if lowerTargetName == "all" then
        return Players:GetPlayers()
    end
    if lowerTargetName == "others" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then table.insert(targets, p) end
        end
        return targets
    end
    if lowerTargetName == "random" then
        local allPlayers = Players:GetPlayers()
        if #allPlayers > 1 then
            local potentialTargets = {}
            for _, p in ipairs(allPlayers) do
                if p ~= localPlayer then table.insert(potentialTargets, p) end
            end
            if #potentialTargets > 0 then
                return { potentialTargets[math.random(1, #potentialTargets)] }
            end
        end
        return {}
    end
    if lowerTargetName == "nearest" then
        local nearestPlayer, minDist = nil, math.huge
        local localRoot = localPlayer.Character and localPlayer.Character.PrimaryPart
        if not localRoot then return {} end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character.PrimaryPart then
                local dist = (p.Character.PrimaryPart.Position - localRoot.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPlayer = p
                end
            end
        end
        if nearestPlayer then return { nearestPlayer } end
        return {}
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():match("^"..lowerTargetName) or p.DisplayName:lower():match("^"..lowerTargetName) then
            table.insert(targets, p)
        end
    end
    return targets
end

function Modules.AdvancedFling:Execute(targetPlayer)
    if self.State.IsFlinging then return DoNotif("Fling already in progress.", 2) end

    local localCharacter = LocalPlayer.Character
    local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
    local localRootPart = localHumanoid and localHumanoid.RootPart

    if not (localRootPart and targetPlayer.Character) then
        return DoNotif("Cannot fling: A required character is missing.", 3)
    end
    
    self.State.IsFlinging = true
    
    -- Store original state for restoration
    local originalPosition = localRootPart.CFrame
    local originalCameraSubject = Workspace.CurrentCamera.CameraSubject
    local originalDestroyHeight = Workspace.FallenPartsDestroyHeight

    task.spawn(function()
        local success, err = pcall(function()
            --// --- START: New "SkidFling" Logic Integration ---

            local TCharacter = targetPlayer.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")

            if not (TCharacter and THumanoid) then
                error("Target character or humanoid not found.")
            end

            if THumanoid.Sit then
                return DoNotif("Fling failed: Target is sitting.", 3)
            end

            -- Set camera subject
            if THead then
                Workspace.CurrentCamera.CameraSubject = THead
            elseif Handle then
                Workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid then
                Workspace.CurrentCamera.CameraSubject = THumanoid
            end

            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return -- Target has no parts, abort.
            end

            local function FPos(BasePart, Pos, Ang)
                localRootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                localCharacter:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                localRootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                localRootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            local function SFBasePart(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if localRootPart and THumanoid and BasePart and BasePart.Parent then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500
                    or not BasePart.Parent
                    or BasePart.Parent ~= TCharacter
                    or not targetPlayer.Parent
                    or THumanoid.Sit
                    or localHumanoid.Health <= 0
                    or tick() > Time + TimeToWait
            end

            Workspace.FallenPartsDestroyHeight = 0/0 -- NaN value to disable void
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            local primaryFlingPart
            if TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
                primaryFlingPart = THead
            elseif TRootPart then
                primaryFlingPart = TRootPart
            elseif THead then
                primaryFlingPart = THead
            elseif Handle then
                primaryFlingPart = Handle
            else
                return DoNotif("Fling failed: Target is missing critical parts.", 3)
            end
            
            SFBasePart(primaryFlingPart)

            --// --- END: New "SkidFling" Logic Integration ---
        end)

        -- This unified cleanup block will run regardless of success or failure.
        pcall(function()
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            Workspace.CurrentCamera.CameraSubject = localCharacter
            Workspace.FallenPartsDestroyHeight = originalDestroyHeight

            repeat
                if localRootPart and localRootPart.Parent then
                    localRootPart.CFrame = originalPosition
                    localRootPart.Velocity, localRootPart.RotVelocity = Vector3.new(), Vector3.new()
                end
                task.wait()
            until not self.State.IsFlinging or not localRootPart.Parent or (localRootPart.Position - originalPosition.Position).Magnitude < 25
        end)

        if not success then
            warn("AdvancedFling Error:", err)
            DoNotif("Fling failed. Target may have reset or left.", 3)
        else
            DoNotif("Fling sequence complete.", 2)
        end
        
        self.State.IsFlinging = false
    end)
end

RegisterCommand({ Name = "fling", Aliases = {"fl"}, Description = "Fling a player." }, function(args)
    local targetName = args[1]
    if not targetName then
        return DoNotif("Usage: ;fling <player|all|others|random|nearest>", 3)
    end
    
    local targets = findFlingTargets(targetName)
    if #targets == 0 then
        return DoNotif("No valid target found.", 3)
    end
    
    if #targets > 1 then
        DoNotif("Flinging multiple targets...", 2)
    else
        DoNotif("Target found: " .. targets[1].Name, 2)
    end

    for _, targetPlayer in ipairs(targets) do
        if targetPlayer ~= LocalPlayer then
            Modules.AdvancedFling:Execute(targetPlayer)
            task.wait(0.1) -- Stagger for multiple targets
        end
    end
end)
Modules.SetSpawnPoint = {
State = {
CustomSpawnCFrame = nil,
CharacterAddedConnection = nil
}
}
function Modules.SetSpawnPoint:OnCharacterAdded(newCharacter)
    if not self.State.CustomSpawnCFrame then return end
        local rootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)
        if rootPart then
            task.wait()
            rootPart.CFrame = self.State.CustomSpawnCFrame
        end
    end
    RegisterCommand({
    Name = "setspawnpoint",
    Aliases = {"setspawn", "ssp"},
    Description = "Sets your respawn point to your current location. Use 'clear' to reset."
    }, function(args)
    local localPlayer = Players.LocalPlayer
    local commandArg = args[1] and string.lower(args[1])
    if commandArg == "clear" or commandArg == "reset" then
        if Modules.SetSpawnPoint.State.CustomSpawnCFrame then
            Modules.SetSpawnPoint.State.CustomSpawnCFrame = nil
            print("Custom spawn point cleared. You will now use the default spawn.")
            if Modules.SetSpawnPoint.State.CharacterAddedConnection then
                Modules.SetSpawnPoint.State.CharacterAddedConnection:Disconnect()
                Modules.SetSpawnPoint.State.CharacterAddedConnection = nil
            end
        else
        print("No custom spawn point was set.")
    end
    return
end
local character = localPlayer and localPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
if not rootPart then
    print("Error: Could not set spawn point. Player character not found.")
    return
end
Modules.SetSpawnPoint.State.CustomSpawnCFrame = rootPart.CFrame
print("Custom spawn point set at: " .. tostring(rootPart.Position))
if not Modules.SetSpawnPoint.State.CharacterAddedConnection then
    Modules.SetSpawnPoint.State.CharacterAddedConnection = localPlayer.CharacterAdded:Connect(function(char)
    Modules.SetSpawnPoint:OnCharacterAdded(char)
end)
end
end)
Modules.NoclipStabilizer = {
State = {
Enabled = false,
Connection = nil
}
}
function Modules.NoclipStabilizer:_OnStepped()
    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end
function Modules.NoclipStabilizer:Enable()
    if self.State.Enabled then return end
        self.State.Enabled = true
        self.State.Connection = RunService.Stepped:Connect(function()
        self:_OnStepped()
    end)
    DoNotif("Noclip Stabilizer: [Enabled]", 3)
end
function Modules.NoclipStabilizer:Disable()
    if not self.State.Enabled then return end
        self.State.Enabled = false
        if self.State.Connection then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        DoNotif("Noclip Stabilizer: [Disabled]", 3)
    end
    RegisterCommand({
    Name = "antirubberband",
    Aliases = {"antirb", "arb"},
    Description = "Toggles the Noclip Stabilizer to prevent server-side rubberbanding."
    }, function(args)
    if Modules.NoclipStabilizer.State.Enabled then
        Modules.NoclipStabilizer:Disable()
    else
    Modules.NoclipStabilizer:Enable()
end
end)

Modules.AntiReset = {
    State = {
        IsEnabled = false,
        CharacterConnections = {}
    }
}

--- Enables the anti-reset system.
function Modules.AntiReset:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function applyAntiReset(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 2)
        local hrp = character:WaitForChild("HumanoidRootPart", 2)
        if not (humanoid and hrp) then return end

        for _, connection in pairs(self.State.CharacterConnections) do
            if connection then connection:Disconnect() end
        end
        table.clear(self.State.CharacterConnections)

        local isResetting = false

        -- [VECTOR 1] Health-Based Reset Protection
        self.State.CharacterConnections.HealthChanged = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 and not isResetting then
                isResetting = true
                humanoid.Health = humanoid.MaxHealth
                isResetting = false
            end
        end)

        -- [VECTOR 2] Void Reset Protection
        local lastSafePosition = hrp.Position
        local fallenPartsHeight = Workspace.FallenPartsDestroyHeight

        self.State.CharacterConnections.Heartbeat = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end

            if hrp.Position.Y < fallenPartsHeight then
                hrp.CFrame = CFrame.new(lastSafePosition)
                hrp.Velocity = Vector3.new(0, 0, 0)
            elseif humanoid.FloorMaterial ~= Enum.Material.Air then
                lastSafePosition = hrp.Position
            end
        end)
    end

    if LocalPlayer.Character then
        applyAntiReset(LocalPlayer.Character)
    end

    self.State.CharacterConnections.Added = LocalPlayer.CharacterAdded:Connect(applyAntiReset)
    
    DoNotif("Anti-Reset: ENABLED.", 2)
end

--- Disables the anti-reset system and cleans up all resources.
function Modules.AntiReset:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    for _, connection in pairs(self.State.CharacterConnections) do
        if connection then connection:Disconnect() end
    end
    table.clear(self.State.CharacterConnections)

    DoNotif("Anti-Reset: DISABLED.", 2)
end

--- Toggles the anti-reset state.
function Modules.AntiReset:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end


--[[

READ THIS TO KNOW HOW TO USE THE COMMAND BELOW, THIS WORKS FOR ANY GAME. A BUILT IN REMOTE FIRE AND EQUIPPER

use dex to find the paths,, after you found said path copy and paste it into the commandbar. below is an example

how to: ,setpath "game:GetService("ReplicatedStorage").Remotes.Shop.EquipWeapon" and then ,forceequip Shovel
use .settype "event" or settype "function" for the type you want to fire,

hell yeah this is an example that works for zombie game upd3, this can work for any game with low security, you'd be surprised how easy they can be to come across.

--]]

Modules.ForceEquip = {
    State = {
        IsRemoteFunction = false,
        RemotePath = nil
    },
    Dependencies = {"Players"}
}


function Modules.ForceEquip:_getInstanceFromPath(path)
    local current = game
    for component in string.gmatch(path, "[^%.]+") do
        if string.find(component, ":GetService") then
            local serviceName = component:match("'(.-)'") or component:match('"(.-)"')
            if serviceName then
                current = current:GetService(serviceName)
            else
                return nil
            end
        else
            if current then
                current = current:FindFirstChild(component)
            else
                return nil
            end
        end
    end
    return current
end

-- [Internal] The original execution logic for force equipping a single weapon.
function Modules.ForceEquip:Execute(weaponName)
    if not self.State.RemotePath then
        return DoNotif("Error: Remote path has not been set. Use ;setremotepath first.", 3)
    end
    if not weaponName then
        return DoNotif("Usage: ;forceequip <WeaponName>", 3)
    end

    -- For simplicity, this function now just calls the new generic one.
    self:ExecuteWithArgs({weaponName})
end

--- [NEW] Executes a fire/invoke on the configured remote with a variable number of arguments.
-- @param customArgs <table> An array of arguments to be sent.
function Modules.ForceEquip:ExecuteWithArgs(customArgs)
    if not self.State.RemotePath then
        return DoNotif("Error: Remote path has not been set. Use ;setremotepath first.", 3)
    end

    local remote = self:_getInstanceFromPath(self.State.RemotePath)
    if not remote then
        return DoNotif("Error: Remote not found at path: " .. self.State.RemotePath, 4)
    end

    -- Argument processing: Converts strings to their likely intended types.
    local fireArgs = {}
    for _, argStr in ipairs(customArgs or {}) do
        if tonumber(argStr) then
            table.insert(fireArgs, tonumber(argStr))
        elseif argStr:lower() == "true" then
            table.insert(fireArgs, true)
        elseif argStr:lower() == "false" then
            table.insert(fireArgs, false)
        elseif argStr:lower() == "nil" then
            table.insert(fireArgs, nil)
        else
            table.insert(fireArgs, argStr)
        end
    end

    -- Validate that the found remote matches the configured type.
    if self.State.IsRemoteFunction and not remote:IsA("RemoteFunction") then
        return DoNotif("Config Error: Remote is not a RemoteFunction. Use ;setremotetype.", 3)
    elseif not self.State.IsRemoteFunction and not remote:IsA("RemoteEvent") then
        return DoNotif("Config Error: Remote is not a RemoteEvent. Use ;setremotetype.", 3)
    end

    if self.State.IsRemoteFunction then
        DoNotif(string.format("Invoking with %d custom arguments...", #fireArgs), 2)
        local success, result = pcall(function() return remote:InvokeServer(unpack(fireArgs)) end)
        if not success then
            warn("--> [FireRemote] Invoke FAILED:", tostring(result))
            DoNotif("Invoke failed. See console (F9).", 3)
        else
            print("--> [FireRemote] Invoke SUCCESS. Result:", result)
            DoNotif("Invoke successful. Result printed to console.", 2)
        end
    else
        DoNotif(string.format("Firing with %d custom arguments...", #fireArgs), 2)
        local success, err = pcall(function() remote:FireServer(unpack(fireArgs)) end)
        if not success then
            warn("--> [FireRemote] Fire FAILED:", tostring(err))
            DoNotif("Fire failed. See console (F9).", 3)
        end
    end
end


-- Initializes the module and registers its commands.
function Modules.ForceEquip:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "forceequip",
        Aliases = {"give"},
        Description = "Fires the configured remote to equip a weapon."
    }, function(args)
        module:Execute(args[1])
    end)

    -- [NEW] Command for firing the same remote path with custom arguments.
    RegisterCommand({
        Name = "firepath",
        Aliases = {"fpath", "fire"},
        Description = "Fires the configured remote with custom arguments."
    }, function(args)
        module:ExecuteWithArgs(args)
    end)

    RegisterCommand({
        Name = "setremotepath",
        Aliases = {"setpath"},
        Description = "Sets the path for the ForceEquip module."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;setremotepath <path>", 3)
        end
        module.State.RemotePath = args[1]
        DoNotif("ForceEquip remote path set to: " .. args[1], 3)
    end)

    RegisterCommand({
        Name = "setremotetype",
        Aliases = {"settype"},
        Description = "Sets the remote type for ForceEquip."
    }, function(args)
        local typeStr = args[1] and args[1]:lower()
        if typeStr == "function" then
            module.State.IsRemoteFunction = true
            DoNotif("ForceEquip remote type set to: RemoteFunction", 3)
        elseif typeStr == "event" then
            module.State.IsRemoteFunction = false
            DoNotif("ForceEquip remote type set to: RemoteEvent", 3)
        else
            return DoNotif("Usage: ;setremotetype <event|function>", 3)
        end
    end)
end




Modules.NpcEsp = {
    State = {
        IsEnabled = false,
        Connections = {},
        TrackedNpcs = {} -- Key: Model, Value: {Highlight, Billboard, Humanoid, RootPart}
    },
    Dependencies = {"Players", "RunService", "Workspace"}
}

-- [Internal] Creates and manages the visual elements for a single NPC.
function Modules.NpcEsp:_createEspForNpc(npcModel)
    if self.State.TrackedNpcs[npcModel] then return end -- Already tracking

    local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
    local rootPart = npcModel:FindFirstChild("HumanoidRootPart") or npcModel.PrimaryPart
    
    if not (humanoid and rootPart and humanoid.Health > 0) then return end
    
    -- 1. Create the Highlight
    local highlight = Instance.new("Highlight", npcModel)
    highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for NPCs
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.4
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- 2. Create the Billboard GUI
    local billboard = Instance.new("BillboardGui", rootPart)
    billboard.Name = "NpcEspBillboard"
    billboard.Adornee = rootPart
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(150, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Text = npcModel.Name
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    
    -- Health & Distance Label
    local infoLabel = Instance.new("TextLabel", billboard)
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.Text = "" -- Will be updated by the loop
    infoLabel.Font = Enum.Font.Code
    infoLabel.TextSize = 14
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.BackgroundTransparency = 1

    -- 3. Store the created objects for tracking and cleanup
    self.State.TrackedNpcs[npcModel] = {
        Highlight = highlight,
        Billboard = billboard,
        InfoLabel = infoLabel,
        Humanoid = humanoid,
        RootPart = rootPart
    }
end

-- [Internal] Safely destroys the visual elements for a single NPC.
function Modules.NpcEsp:_removeEspForNpc(npcModel)
    local trackedData = self.State.TrackedNpcs[npcModel]
    if not trackedData then return end
    
    pcall(function() trackedData.Highlight:Destroy() end)
    pcall(function() trackedData.Billboard:Destroy() end)
    
    self.State.TrackedNpcs[npcModel] = nil
end

-- [Internal] The main loop that updates visuals and finds new NPCs.
function Modules.NpcEsp:_onHeartbeat()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    -- Update existing NPCs and clean up dead/removed ones
    for npcModel, data in pairs(self.State.TrackedNpcs) do
        if not (npcModel and npcModel.Parent and data.Humanoid and data.Humanoid.Health > 0) then
            self:_removeEspForNpc(npcModel)
        else
            -- Update distance and health
            local distance = math.floor((myRoot.Position - data.RootPart.Position).Magnitude)
            data.InfoLabel.Text = string.format("HP: %.0f | Dist: %d", data.Humanoid.Health, distance)
        end
    end
    
    -- Scan for new NPCs
    for _, model in ipairs(self.Services.Workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
            -- Check if it's not a player and not already tracked
            if not self.Services.Players:GetPlayerFromCharacter(model) and not self.State.TrackedNpcs[model] then
                self:_createEspForNpc(model)
            end
        end
    end
end

--- Enables the NPC ESP system.
function Modules.NpcEsp:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    
    DoNotif("NPC ESP: ENABLED.", 2)
end

--- Disables the NPC ESP system and cleans up all visuals.
function Modules.NpcEsp:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connections.Heartbeat then
        self.State.Connections.Heartbeat:Disconnect()
        self.State.Connections.Heartbeat = nil
    end
    
    for npcModel, _ in pairs(self.State.TrackedNpcs) do
        self:_removeEspForNpc(npcModel)
    end
    table.clear(self.State.TrackedNpcs)
    
    DoNotif("NPC ESP: DISABLED.", 2)
end

--- Toggles the NPC ESP state.
function Modules.NpcEsp:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module, loads services, and registers the command.
function Modules.NpcEsp:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    
    RegisterCommand({
        Name = "npcesp",
        Aliases = {"aiesp"},
        Description = "Toggles ESP for non-player characters (NPCs) in the workspace."
    }, function()
        module:Toggle()
    end)
end

RegisterCommand({
    Name = "antireset",
    Aliases = {"noreset", "ar"},
    Description = "Toggles a system that prevents your character from resetting."
}, function()
    Modules.AntiReset:Toggle()
end)

Modules.AntiCFrameTeleport = {
MAX_SPEED = 70,
MAX_STEP_DIST = 8,
REPEAT_THRESHOLD = 3,
LOCK_TIME = 0.1,
State = {
Enabled = false,
HeartbeatConnection = nil,
CharacterAddedConnection = nil,
LastCFrame = nil,
LastTimestamp = 0,
DetectionHits = 0
}
}
function Modules.AntiCFrameTeleport:_zeroVelocity(character)
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.zero
            descendant.AssemblyAngularVelocity = Vector3.zero
        end
    end
end
function Modules.AntiCFrameTeleport:_getFlyAllowances(deltaTime)
    local maxSpeed, maxDist = self.MAX_SPEED, self.MAX_STEP_DIST
    if not (getfenv(0).NAmanage and NAmanage._state and getfenv(0).FLYING) then
        return maxSpeed, maxDist
    end
    local mode = NAmanage._state.mode or "none"
    local flyVars = getfenv(0).flyVariables or {}
    if mode == "fly" then
        local speed = tonumber(flyVars.flySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "vfly" then
        local speed = tonumber(flyVars.vFlySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "cfly" then
        local speed = tonumber(flyVars.cFlySpeed) or 1
        local step = speed * 2
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.25)
    elseif mode == "tfly" then
        local speed = tonumber(flyVars.TflySpeed) or 1
        local step = speed * 2.5
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.5)
    end
    return maxSpeed, maxDist
end
function Modules.AntiCFrameTeleport:_onCharacterAdded(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if rootPart then
        self.State.LastCFrame = rootPart.CFrame
        self.State.LastTimestamp = os.clock()
        self.State.DetectionHits = 0
    end
end
function Modules.AntiCFrameTeleport:_onHeartbeat()
    local character = Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
        local now = os.clock()
        local deltaTime = math.max(now - (self.State.LastTimestamp or now), 1/240)
        local currentCFrame = rootPart.CFrame
        if not self.State.LastCFrame then
            self.State.LastCFrame, self.State.LastTimestamp = currentCFrame, now
            return
        end
        local distance = (currentCFrame.Position - self.State.LastCFrame.Position).Magnitude
        local speed = distance / deltaTime
        local maxAllowedSpeed, maxAllowedDistance = self:_getFlyAllowances(deltaTime)
        if distance > maxAllowedDistance or speed > maxAllowedSpeed then
            character:PivotTo(self.State.LastCFrame)
            self:_zeroVelocity(character)
            self.State.DetectionHits += 1
            if self.State.DetectionHits >= self.REPEAT_THRESHOLD then
                task.delay(self.LOCK_TIME, function()
                self.State.DetectionHits = 0
            end)
        end
    else
    self.State.DetectionHits = math.max(self.State.DetectionHits - 1, 0)
    self.State.LastCFrame = currentCFrame
end
self.State.LastTimestamp = now
end
function Modules.AntiCFrameTeleport:Enable()
    if self.State.Enabled then return end
        self.State.Enabled = true
        if Players.LocalPlayer.Character then
            self:_onCharacterAdded(Players.LocalPlayer.Character)
        end
        self.State.CharacterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(function(char)
        self:_onCharacterAdded(char)
    end)
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function()
    self:_onHeartbeat()
end)
DoNotif("Anti-CFrame Teleport: [Enabled]", 3)
end
function Modules.AntiCFrameTeleport:Disable()
    if not self.State.Enabled then return end
        self.State.Enabled = false
        if self.State.HeartbeatConnection then
            self.State.HeartbeatConnection:Disconnect()
            self.State.HeartbeatConnection = nil
        end
        if self.State.CharacterAddedConnection then
            self.State.CharacterAddedConnection:Disconnect()
            self.State.CharacterAddedConnection = nil
        end
        self.State.LastCFrame = nil
        self.State.LastTimestamp = 0
        self.State.DetectionHits = 0
        DoNotif("Anti-CFrame Teleport: [Disabled]", 3)
    end
    RegisterCommand({
    Name = "anticframetp",
    Aliases = {"acftp", "antiteleport"},
    Description = "Toggles a client-side anti-teleport to prevent CFrame changes."
    }, function(args)
    if Modules.AntiCFrameTeleport.State.Enabled then
        Modules.AntiCFrameTeleport:Disable()
    else
    Modules.AntiCFrameTeleport:Enable()
end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
Modules.FireRemotes = {
State = {
Enabled = false,
},
}
function Modules.FireRemotes:Initialize()
    RegisterCommand({
    Name = "fireremotes",
    Aliases = {"fremotes", "frem"},
    Description = "Attempts to fire every discoverable RemoteEvent and RemoteFunction."
    }, function(args)
    local CoreGui = game:GetService("CoreGui")
    local remoteCount = 0
    local failedCount = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not obj:IsDescendantOf(CoreGui) then
            task.spawn(function()
            local success, err
            if obj:IsA("RemoteEvent") then
                success, err = pcall(function()
                obj:FireServer()
            end)
        elseif obj:IsA("RemoteFunction") then
            success, err = pcall(function()
            obj:InvokeServer()
        end)
    end
    if success then
        remoteCount = remoteCount + 1
    else
    failedCount = failedCount + 1
end
end)
end
end
task.delay(2, function()
DoNotif("Fired " .. remoteCount .. " remotes.\nFailed: " .. failedCount .. " remotes.")
end)
end)
end
Modules.RemoveForces = {
State = {},
}
function Modules.RemoveForces:Initialize()
    RegisterCommand({
    Name = "deletevelocity",
    Aliases = {"dv", "removevelocity", "removeforces"},
    Description = "Removes all force/velocity instances from your character to counter flings or fix physics glitches."
    }, function(args)
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local forcesRemoved = 0
    for _, instance in ipairs(character:GetDescendants()) do
        if  instance:isA("BodyVelocity") or
            instance:isA("BodyGyro") or
            instance:isA("RocketPropulsion") or
            instance:isA("BodyAngularVelocity") or
            instance:isA("BodyForce") or
            instance:isA("BodyThrust") or
            instance:isA("VectorForce") or
            instance:isA("LineForce") or
            instance:isA("AngularVelocity")
            then
                instance:Destroy()
                forcesRemoved = forcesRemoved + 1
            end
        end
        DoNotif("Removed " .. forcesRemoved .. " force instances from your character.", 3)
    end)
end
Modules.TeleportToPlace = {
State = {},
}
function Modules.TeleportToPlace:Initialize()
    RegisterCommand({
    Name = "teleporttoplace",
    Aliases = {"toplace", "ttp"},
    Description = "Teleports you to a specific Roblox place using its ID."
    }, function(args)
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    if not args[1] then
        return DoNotif("Usage: teleporttoplace [PlaceId]", 5)
    end
    local placeId = tonumber(args[1])
    if not placeId then
        return DoNotif("Invalid PlaceId. It must be a number.", 5)
    end
    DoNotif("Attempting to teleport to " .. placeId .. "...", 3)
    local success, result = pcall(function()
    TeleportService:Teleport(placeId, localPlayer)
end)
if not success then
    DoNotif("Teleport failed: " .. tostring(result), 5)
end
end)
end
Modules.ToSpawn = {
State = {
Enabled = false,
},
}
function Modules.ToSpawn:Initialize()
    RegisterCommand({
    Name = "tospawn",
    Aliases = {"ts"},
    Description = "Teleports you to the nearest SpawnLocation."
    }, function(args)
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return DoNotif("HumanoidRootPart not found.", 3)
    end
    local closestSpawn = nil
    local shortestDistance = math.huge
    local rootPosition = root.Position
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("SpawnLocation") then
            local distance = (part.Position - rootPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestSpawn = part
            end
        end
    end
    if closestSpawn then
        root.CFrame = closestSpawn.CFrame * CFrame.new(0, 3, 0)
    else
    return DoNotif("No SpawnLocation found in workspace.", 3)
end
end)
end
Modules.TriggerRemoteTouch = {
    State = {
        IsExecuting = false,
        FoundParts = {}
    },
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService")
    }
}

function Modules.TriggerRemoteTouch:_triggerPart(targetPart)
    if not targetPart then return end

    local hrp = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    DoNotif("Triggering: " .. targetPart:GetFullName(), 1)

    if firetouchinterest then
        pcall(function()
            firetouchinterest(hrp, targetPart, 0)
            self.Services.RunService.Heartbeat:Wait()
            firetouchinterest(hrp, targetPart, 1)
        end)
    else
        warn("TriggerRemoteTouch: 'firetouchinterest' not found. Using CFrame fallback.")
        local originalCFrame = hrp.CFrame
        pcall(function()
            hrp.CFrame = targetPart.CFrame
            self.Services.RunService.Heartbeat:Wait()
            hrp.CFrame = originalCFrame
        end)
    end
end

function Modules.TriggerRemoteTouch:Scan()
    if self.State.IsExecuting then return DoNotif("An operation is already in progress.", 2) end
    self.State.IsExecuting = true

    DoNotif("Scanning for all touch-interactive parts...", 3)
    
    task.spawn(function()
        table.clear(self.State.FoundParts)
        local count = 0
        for i, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
            if descendant:IsA("TouchInterest") then
                local part = descendant.Parent
                if part and part:IsA("BasePart") then
                    table.insert(self.State.FoundParts, part)
                    count = count + 1
                end
            end
            if i % 200 == 0 then task.wait() end
        end
        DoNotif("Scan complete. Found " .. count .. " interactive parts.", 3)
        self.State.IsExecuting = false
    end)
end

function Modules.TriggerRemoteTouch:TriggerAll()
    if self.State.IsExecuting then return DoNotif("An operation is already in progress.", 2) end
    if #self.State.FoundParts == 0 then
        return DoNotif("No parts found. Run ';touch scan' first.", 3)
    end
    self.State.IsExecuting = true

    DoNotif("Beginning sequence to trigger all " .. #self.State.FoundParts .. " parts.", 3)

    task.spawn(function()
        for _, part in ipairs(self.State.FoundParts) do
            if not self.State.IsExecuting then break end
            self:_triggerPart(part)
            task.wait(0.5)
        end
        DoNotif("Trigger sequence finished.", 2)
        self.State.IsExecuting = false
    end)
end

function Modules.TriggerRemoteTouch:TriggerSingle(keyword)
    if not keyword then return DoNotif("Usage: ;touch single <keyword>", 3) end
    if self.State.IsExecuting then return DoNotif("An operation is already in progress.", 2) end
    if #self.State.FoundParts == 0 then
        return DoNotif("No parts found. Run ';touch scan' first.", 3)
    end

    local lowerKeyword = keyword:lower()
    for _, part in ipairs(self.State.FoundParts) do
        if part:GetFullName():lower():find(lowerKeyword, 1, true) then
            self:_triggerPart(part)
            return
        end
    end

    DoNotif("No scanned part found matching '" .. keyword .. "'.", 3)
end

function Modules.TriggerRemoteTouch:Initialize()
    local module = self
    RegisterCommand({
        Name = "touch",
        Aliases = {"remotetouch", "trigger"},
        Description = "Scans and triggers touch-interest parts."
    }, function(args)
        local subCommand = args[1] and args[1]:lower()
        if subCommand == "scan" then
            module:Scan()
        elseif subCommand == "all" then
            module:TriggerAll()
        elseif subCommand == "single" then
            module:TriggerSingle(args[2])
        else
            DoNotif("Usage: ;touch <scan|all|single> [keyword]", 4)
        end
    end)
end
Modules.ScriptHunter = {
    State = {
        IsScanning = false
    }
}

function Modules.ScriptHunter:Execute(keywords)
    local self = Modules.ScriptHunter
    if self.State.IsScanning then return DoNotif("A script scan is already in progress.", 2) end
    if not keywords or #keywords == 0 then return DoNotif("Usage: ;huntscript <keyword1> [keyword2] ...", 3) end

    self.State.IsScanning = true
    DoNotif("Beginning script hunt for keywords: " .. table.concat(keywords, ", "), 3)

    task.spawn(function()
        local findings = {}
        local scriptsScanned = 0
        for _, script in ipairs(game:GetDescendants()) do
            if script:IsA("LuaSourceContainer") then
                local success, source = pcall(function() return script.Source end)
                if success and source then
                    scriptsScanned = scriptsScanned + 1
                    local lowerSource = source:lower()
                    local allKeywordsFound = true
                    for _, keyword in ipairs(keywords) do
                        if not lowerSource:find(keyword:lower(), 1, true) then
                            allKeywordsFound = false
                            break
                        end
                    end
                    if allKeywordsFound then
                        table.insert(findings, script:GetFullName())
                    end
                end
            end
            if scriptsScanned % 100 == 0 then task.wait() end
        end

        if #findings > 0 then
            DoNotif("Scan complete. Found " .. #findings .. " matching script(s). Results printed to console (F9).", 4)
            -- ARCHITECT'S NOTE: Corrected the malformed multi-line print statements.
            print("--- [Zuka's ScriptHunter Report] ---")
            for _, path in ipairs(findings) do
                print("  [!] Match Found: " .. path)
            end
            print("--------------------------------------")
        else
            DoNotif("Scan complete. No scripts found containing all specified keywords.", 3)
        end
        self.State.IsScanning = false
    end)
end

function Modules.ScriptHunter:Initialize()
    local module = self
    RegisterCommand({
        Name = "huntscript",
        Aliases = {"findscript", "scripthunt"},
        Description = "Scans all client scripts for keywords."
    }, function(args)
        module:Execute(args)
    end)
end

local ContextActionService = game:GetService("ContextActionService")

Modules.AdvancedAirwalk = {
    State = {
        IsEnabled = false,
        AirwalkPart = nil,
        RenderConnection = nil,
        Connections = {},
        GUIs = {},
        -- Input state
        IsTyping = false,
        Increase = false,
        Decrease = false,
        -- Physics state
        Offset = 0
    },
    Config = {
        VerticalSpeed = 1.75,
        Keybinds = {
            Increase = Enum.KeyCode.Space, -- Or Enum.KeyCode.E
            Decrease = Enum.KeyCode.LeftControl -- Or Enum.KeyCode.Q
        }
    },
    -- Forward-declare services for robustness
    Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        CoreGui = game:GetService("CoreGui")
    }
}


function Modules.AdvancedAirwalk:Disable()
    if not self.State.IsEnabled then
        return
    end

    -- Disconnect the main render loop first
    if self.State.RenderConnection then
        self.State.RenderConnection:Disconnect()
        self.State.RenderConnection = nil
    end

    -- Destroy the invisible airwalk part
    if self.State.AirwalkPart and self.State.AirwalkPart.Parent then
        self.State.AirwalkPart:Destroy()
    end
    self.State.AirwalkPart = nil

    -- Disconnect all input and event connections
    for key, conn in pairs(self.State.Connections) do
        if conn then
            conn:Disconnect()
        end
        self.State.Connections[key] = nil
    end

    -- Destroy all GUI elements
    for key, gui in pairs(self.State.GUIs) do
        if gui and gui.Parent then
            gui:Destroy()
        end
        self.State.GUIs[key] = nil
    end

    -- Reset state variables
    self.State.IsEnabled = false
    self.State.IsTyping = false
    self.State.Increase = false
    self.State.Decrease = false
    self.State.Offset = 0

    DoNotif("Advanced Airwalk: OFF", 2)
end


function Modules.AdvancedAirwalk:Enable()
    if self.State.IsEnabled then
        self:Disable()
    end
    self.State.IsEnabled = true

    local localPlayer = self.Services.Players.LocalPlayer
    local uis = self.Services.UserInputService
    local isMobile = uis.TouchEnabled

    DoNotif(isMobile and "Advanced Airwalk: ON" or "Advanced Airwalk: ON (Space & LCtrl)", 2)

    local function createMobileButton(parent, text, position, callbackDown, callbackUp)
        local button = Instance.new("TextButton")
        button.Parent = parent
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Position = position
        button.Size = UDim2.new(0.08, 0, 0.12, 0)
        button.Font = Enum.Font.SourceSansBold
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true

        Instance.new("UICorner", button).CornerRadius = UDim.new(0.2, 0)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5

        -- Event connections for press and release
        button.MouseButton1Down:Connect(callbackDown)
        button.MouseButton1Up:Connect(callbackUp)
        button.TouchTap:Connect(callbackDown) -- Handle quick taps
        button.TouchEnded:Connect(callbackUp)

        return button
    end

    --// Setup Input Handling (Platform-Specific)
    if isMobile then
        local mobileGui = Instance.new("ScreenGui", self.Services.CoreGui)
        mobileGui.Name = "AdvancedAirwalkMobileControls"
        mobileGui.ResetOnSpawn = false
        self.State.GUIs.MobileControls = mobileGui

        -- Create UP and DOWN buttons
        createMobileButton(mobileGui, "UP", UDim2.new(0.9, 0, 0.55, 0),
            function() self.State.Increase = true end,
            function() self.State.Increase = false end)

        createMobileButton(mobileGui, "DOWN", UDim2.new(0.9, 0, 0.7, 0),
            function() self.State.Decrease = true end,
            function() self.State.Decrease = false end)
    else
        -- Desktop input handling
        self.State.Connections.Focused = uis.TextBoxFocused:Connect(function() self.State.IsTyping = true end)
        self.State.Connections.Released = uis.TextBoxFocusReleased:Connect(function() self.State.IsTyping = false end)

        self.State.Connections.InputBegan = uis.InputBegan:Connect(function(input, gpe)
            if gpe or self.State.IsTyping then return end
            if input.KeyCode == self.Config.Keybinds.Increase then self.State.Increase = true end
            if input.KeyCode == self.Config.Keybinds.Decrease then self.State.Decrease = true end
        end)

        self.State.Connections.InputEnded = uis.InputEnded:Connect(function(input)
            if input.KeyCode == self.Config.Keybinds.Increase then self.State.Increase = false end
            if input.KeyCode == self.Config.Keybinds.Decrease then self.State.Decrease = false end
        end)
    end

    --// Create the physical Airwalk Part
    local awPart = Instance.new("Part")
    awPart.Name = "Zuka_AirwalkPart"
    awPart.Size = Vector3.new(8, 1.5, 8) -- Wider base for stability
    awPart.Transparency = 1
    awPart.Anchored = true
    awPart.CanCollide = true
    awPart.CanQuery = false -- Important for performance
    awPart.Parent = self.Services.Workspace
    self.State.AirwalkPart = awPart

    --// Main Render Loop
    self.State.RenderConnection = self.Services.RunService.RenderStepped:Connect(function()
        if not (self.State.IsEnabled and self.State.AirwalkPart and self.State.AirwalkPart.Parent) then
            -- Failsafe in case part is destroyed externally
            self:Disable()
            return
        end

        local success, char, root, hum = pcall(function()
            local c = localPlayer.Character
            return c, c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
        end)

        if not (success and char and root and hum and hum.Health > 0) then
            -- Hide the part if the character is missing or dead
            self.State.AirwalkPart.CanCollide = false
            return
        end
        
        self.State.AirwalkPart.CanCollide = true

        local hrpHalf = root.Size.Y * 0.5
        local feetFromRoot
        if hum.RigType == Enum.HumanoidRigType.R6 then
            feetFromRoot = hrpHalf + (hum.HipHeight > 0 and hum.HipHeight or 2)
        else
            feetFromRoot = hrpHalf + (hum.HipHeight or 2)
        end
        local baseOffset = feetFromRoot + (self.State.AirwalkPart.Size.Y * 0.5)

        -- Determine vertical movement from input state
        local delta = 0
        if self.State.Increase then delta = -self.Config.VerticalSpeed end
        if self.State.Decrease then delta = self.Config.VerticalSpeed end
        
        -- Update the offset smoothly
        self.State.Offset = self.State.Offset + delta
        
        -- Apply the new position to the airwalk part
        local newY = root.Position.Y - baseOffset - self.State.Offset
        self.State.AirwalkPart.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
    end)
end

--// --- Command Registration ---
RegisterCommand({
    Name = "airwalk",
    Aliases = {"float", "aw"},
    Description = "Toggles an advanced airwalk. Use Space/LCtrl or GUI to move."
}, function()
    -- This single command will now toggle the state.
    if Modules.AdvancedAirwalk.State.IsEnabled then
        Modules.AdvancedAirwalk:Disable()
    else
        Modules.AdvancedAirwalk:Enable()
    end
end)

RegisterCommand({
    Name = "unairwalk",
    Aliases = {"unfloat", "unaw"},
    Description = "Explicitly disables the advanced airwalk."
}, function()
    Modules.AdvancedAirwalk:Disable()
end)


Modules.AntiDestroy = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        ProtectedNames = {} 
    }
}

function Modules.AntiDestroy:Enable(): ()
    if self.State.IsEnabled then return end

    local success, mt = pcall(getrawmetatable, game)
    if not success or typeof(mt) ~= "table" then
        warn("AntiDestroy: Failed to get game metatable. Hooking is not possible.")
        return
    end

    self.State.OriginalNamecall = mt.__namecall
    local original_nc = self.State.OriginalNamecall 

    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local selfArg: Instance = select(1, ...)
        local method: string = getnamecallmethod()

        if method == "Destroy" and self.State.ProtectedNames[selfArg.Name] then
            warn("AntiDestroy: Blocked Destroy() call on protected instance -> " .. selfArg:GetFullName())
            return
        end
        
        return original_nc(...)
    end)
    setreadonly(mt, true)

    self.State.IsEnabled = true
    DoNotif("Anti-Destroy Hook: ENABLED", 2)
end

function Modules.AntiDestroy:Disable(): ()
    if not self.State.IsEnabled then return end

    if self.State.OriginalNamecall then
        local success, err = pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = self.State.OriginalNamecall
            setreadonly(mt, true)
        end)
        if not success then
            warn("AntiDestroy: Failed to restore original __namecall.", err)
        end
    end

    self.State.IsEnabled = false
    self.State.OriginalNamecall = nil
    DoNotif("Anti-Destroy Hook: DISABLED", 2)
end

function Modules.AntiDestroy:Initialize(): ()
    self:Enable() 

    RegisterCommand({
        Name = "protect",
        Aliases = {"antidelete"},
        Description = "Protects an instance from being destroyed by its name."
    }, function(args: {string})
        local name = args[1]
        if not name then
            return DoNotif("Usage: ;protect <InstanceName>", 3)
        end
        self.State.ProtectedNames[name] = true
        DoNotif("Protection enabled for all instances named: " .. name, 3)
    end)

    RegisterCommand({
        Name = "unprotect",
        Aliases = {"allowdelete"},
        Description = "Removes destruction protection from an instance by its name."
    }, function(args: {string})
        local name = args[1]
        if not name then
            return DoNotif("Usage: ;unprotect <InstanceName>", 3)
        end
        if self.State.ProtectedNames[name] then
            self.State.ProtectedNames[name] = nil
            DoNotif("Protection removed for instances named: " .. name, 3)
        else
            DoNotif("No protection was active for that name.", 2)
        end
    end)
end

Modules.Blackhole = {
    State = {
        IsEnabled = false,
        IsForceActive = false,
        TargetCFrame = CFrame.new(),
        BlackholePart = nil,      -- The invisible anchor part in the workspace
        BlackholeAttachment = nil, -- The specific point movers are attracted to
        Connections = {},
        UI = {}
    },
    Config = {
        ForceResponsiveness = 200,
        TorqueMagnitude = 100000,
        MoveKey = Enum.KeyCode.E,
        -- A unique name to identify physics objects created by this script for easy cleanup.
        MoverName = "Zuka_BlackholeMover"
    },
    Dependencies = {"RunService", "UserInputService", "Players", "Workspace", "CoreGui"},
    Services = {}
}


function Modules.Blackhole:_cleanupForces()
    for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
        if descendant.Name == self.Config.MoverName and descendant:IsA("Instance") then
            -- This also implicitly destroys the AlignPosition and Torque as they are parented to the attachment.
            descendant:Destroy()
        end
        -- Restore collision for parts we might have modified
        if descendant:IsA("BasePart") and not descendant.CanCollide then
            pcall(function() descendant.CanCollide = true end)
        end
    end
end

---
-- [Private] Applies the black hole physics forces to a given part if eligible.
--
function Modules.Blackhole:_applyForce(part)
    -- Only apply forces if the black hole is active and the part is a valid target.
    if not self.State.IsForceActive or not (part and part:IsA("BasePart")) then return end
    if part.Anchored or part:FindFirstAncestorOfClass("Humanoid") then return end
    
    -- Failsafe to prevent movers from being added to our own character parts.
    if part:IsDescendantOf(self.Services.Players.LocalPlayer.Character) then return end

    -- Clean up any existing physics movers to ensure ours takes priority.
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyMover") or child:IsA("RocketPropulsion") then
            child:Destroy()
        end
        if child.Name == self.Config.MoverName then
            child:Destroy()
        end
    end
    
    part.CanCollide = false
    
    -- Create and configure the new physics movers.
    local attachment = Instance.new("Attachment", part)
    attachment.Name = self.Config.MoverName -- Tag our instances for cleanup
    
    local align = Instance.new("AlignPosition", attachment)
    align.Attachment0 = attachment
    align.Attachment1 = self.State.BlackholeAttachment
    align.MaxForce = 1e9
    align.MaxVelocity = math.huge
    align.Responsiveness = self.Config.ForceResponsiveness
    
    local torque = Instance.new("Torque", attachment)
    torque.Attachment0 = attachment
    torque.Torque = Vector3.new(self.Config.TorqueMagnitude, self.Config.TorqueMagnitude, self.Config.TorqueMagnitude)
end


function Modules.Blackhole:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect all event listeners
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Restore simulation radii to default behavior
    pcall(function()
        for _, plr in ipairs(self.Services.Players:GetPlayers()) do
            plr.MaximumSimulationRadius = -1 -- -1 resets to default
        end
    end)
    
    self:_cleanupForces()

    -- Destroy the core black hole part and the UI
    if self.State.BlackholePart and self.State.BlackholePart.Parent then
        self.State.BlackholePart:Destroy()
    end
    if self.State.UI.ScreenGui and self.State.UI.ScreenGui.Parent then
        self.State.UI.ScreenGui:Destroy()
    end

    -- Reset state
    self.State = {
        IsEnabled = false,
        IsForceActive = false,
        TargetCFrame = CFrame.new(),
        Connections = {},
        UI = {}
    }
    DoNotif("Blackhole destroyed.", 2)
end


function Modules.Blackhole:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer

    -- Create the central black hole part and attachment
    local bhPart = Instance.new("Part")
    bhPart.Name = "Zuka_BlackholeCore"
    bhPart.Anchored = true
    bhPart.CanCollide = false
    bhPart.Transparency = 1
    bhPart.Size = Vector3.one
    self.State.BlackholePart = bhPart
    
    self.State.BlackholeAttachment = Instance.new("Attachment", bhPart)
    
    local mouse = localPlayer:GetMouse()
    self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
    bhPart.Parent = self.Services.Workspace


    self.State.Connections.SimRadius = self.Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, plr in ipairs(self.Services.Players:GetPlayers()) do
                if plr ~= localPlayer then plr.MaximumSimulationRadius = 0 end
            end
            localPlayer.MaximumSimulationRadius = 1e9
        end)
    end)

    self.State.Connections.PositionUpdate = self.Services.RunService.RenderStepped:Connect(function()
        if self.State.BlackholeAttachment then
            self.State.BlackholeAttachment.WorldCFrame = self.State.TargetCFrame
        end
    end)

    self.State.Connections.DescendantAdded = self.Services.Workspace.DescendantAdded:Connect(function(desc)
        self:_applyForce(desc)
    end)

    self.State.Connections.Input = self.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Config.MoveKey then
            self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
        end
    end)

    
    local screenGui = Instance.new("ScreenGui", self.Services.CoreGui)
    screenGui.Name = "BlackholeControlGUI"
    screenGui.ResetOnSpawn = false
    self.State.UI.ScreenGui = screenGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Text = "Enable Blackhole"
    toggleBtn.AnchorPoint = Vector2.new(0.5, 1)
    toggleBtn.Size = UDim2.fromOffset(160, 40)
    toggleBtn.Position = UDim2.new(0.5, 0, 0.93, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 18
    toggleBtn.Parent = screenGui
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.25, 0)

    local moveBtn = toggleBtn:Clone()
    moveBtn.Name = "MoveButton"
    moveBtn.Text = "Move Blackhole (E)"
    moveBtn.Position = UDim2.new(0.5, 0, 0.99, 0)
    moveBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    moveBtn.Parent = screenGui

    -- UI Event Handlers
    toggleBtn.MouseButton1Click:Connect(function()
        self.State.IsForceActive = not self.State.IsForceActive
        toggleBtn.Text = self.State.IsForceActive and "Disable Blackhole" or "Enable Blackhole"
        
        if self.State.IsForceActive then
            DoNotif("Blackhole force enabled", 2)
            for _,v in ipairs(self.Services.Workspace:GetDescendants()) do self:_applyForce(v) end
        else
            self:_cleanupForces()
            DoNotif("Blackhole force disabled", 2)
        end
    end)

    moveBtn.MouseButton1Click:Connect(function()
        self.State.TargetCFrame = mouse.Hit + Vector3.new(0, 5, 0)
    end)
    
    DoNotif("Blackhole created. Tap button or press E to move.", 3)
end


function Modules.Blackhole:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "blackhole",
        Aliases = {"bhole"},
        Description = "Toggles a client-sided black hole that pulls all unanchored parts."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
end


Modules.PathfinderFollow = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        FollowConnection = nil,
        -- Pathfinding state
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        LastSourcePos = Vector3.new(),
        LastTargetPos = Vector3.new()
    },
    Config = {
        -- How often (in seconds) the path is allowed to be recalculated.
        RECALCULATION_INTERVAL = 0.5,
        -- How far the player or target must move to trigger a path recalculation.
        RECALCULATION_DISTANCE = 3,
        -- How close we need to get to a waypoint to advance to the next one.
        WAYPOINT_PROXIMITY = 4,
        -- Parameters for the pathfinding algorithm.
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },
    Dependencies = {"PathfindingService", "RunService", "Players"},
    Services = {}
}


function Modules.PathfinderFollow:_onHeartbeat()
    if not (self.State.IsEnabled and self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        self:Disable()
        return
    end

    -- 1. Get all necessary character components safely.
    local localPlayer = self.Services.Players.LocalPlayer
    local localChar = localPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local localHum = localChar and localChar:FindFirstChildOfClass("Humanoid")
    
    local targetChar = self.State.TargetPlayer.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not (localHrp and localHum and targetHrp and localHum.Health > 0) then
        return -- Do nothing if characters are not in a valid state.
    end

    local sourcePos = localHrp.Position
    local targetPos = targetHrp.Position

    -- 2. Check if the path needs to be recalculated.
    local timeSinceRecalc = os.clock() - self.State.LastPathRecalculation
    local sourceMoved = (sourcePos - self.State.LastSourcePos).Magnitude > self.Config.RECALCULATION_DISTANCE
    local targetMoved = (targetPos - self.State.LastTargetPos).Magnitude > self.Config.RECALCULATION_DISTANCE

    if timeSinceRecalc > self.Config.RECALCULATION_INTERVAL and (sourceMoved or targetMoved) then
        self.State.LastPathRecalculation = os.clock()
        self.State.LastSourcePos = sourcePos
        self.State.LastTargetPos = targetPos
        
        -- Compute the path asynchronously.
        local success = pcall(function() self.State.Path:ComputeAsync(sourcePos, targetPos) end)
        
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 1 -- Reset to the beginning of the new path.
        end
    end

    -- 3. Traverse the current path without blocking.
    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if #waypoints == 0 or self.State.CurrentWaypointIndex > #waypoints then return end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        -- Check if we've reached the current waypoint.
        local distanceToWaypoint = (localHrp.Position - currentWaypoint.Position).Magnitude
        if distanceToWaypoint < self.Config.WAYPOINT_PROXIMITY then
            self.State.CurrentWaypointIndex = self.State.CurrentWaypointIndex + 1
        else
            -- If not close enough, continue moving towards it.
            if currentWaypoint.Action == Enum.PathWaypointAction.Jump then
                localHum.Jump = true
            end
            localHum:MoveTo(currentWaypoint.Position)
        end
    end
end

---
-- Disables the pathfinding loop and cleans up all state.
--
function Modules.PathfinderFollow:Disable()
    if not self.State.IsEnabled then return end

    if self.State.FollowConnection then
        self.State.FollowConnection:Disconnect()
        self.State.FollowConnection = nil
    end

    -- Stop the character's current movement
    pcall(function()
        local char = self.Services.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:MoveTo(hum.RootPart.Position) end
    end)
    
    DoNotif("Pathfinder follow disabled.", 2)
    
    -- Reset state
    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
    self.State.Path = nil
end

---
-- Enables pathfinding to follow a specified target player.
-- @param targetPlayer <Player> The player object to follow.
--
function Modules.PathfinderFollow:Enable(targetPlayer)
    if not targetPlayer or targetPlayer == self.Services.Players.LocalPlayer then
        DoNotif("Invalid target for pathfinding.", 3)
        return
    end

    self:Disable() -- Ensure a clean state before starting a new follow.

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)
    self.State.LastPathRecalculation = 0 -- Force initial calculation.

    -- Connect the main logic loop.
    self.State.FollowConnection = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)

    DoNotif("Pathfinder following: " .. targetPlayer.Name, 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.PathfinderFollow:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "pathfind",
        Aliases = {"follow"},
        Description = "Follow a player using PathfindingService."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            module:Disable()
            return
        end

        local target = Utilities.findPlayer(argument)
        if target then
            module:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.CharacterMorph = {
    State = {
        IsMorphed = false,
        OriginalDescription = nil,
        -- Connection to disconnect CharacterAdded event after reverting
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}


function Modules.CharacterMorph:_resolveDescription(target)
    local targetId = tonumber(target)
    
    -- If the target is not a valid number, assume it's a username and get the ID.
    if not targetId then
        local success, idFromName = pcall(function()
            return self.Services.Players:GetUserIdFromNameAsync(target)
        end)
        if not success or not idFromName then
            DoNotif("Could not find a user with the name: " .. tostring(target), 3)
            return nil
        end
        targetId = idFromName
    end

    -- Now, fetch the HumanoidDescription using the resolved UserId.
    DoNotif("Loading avatar for ID: " .. targetId, 1.5)
    local success, description = pcall(function()
        return self.Services.Players:GetHumanoidDescriptionFromUserId(targetId)
    end)

    if not success or not description then
        DoNotif("Unable to load avatar description for that user.", 3)
        return nil
    end

    return description
end


function Modules.CharacterMorph:_applyAndRespawn(description)
    local localPlayer = self.Services.Players.LocalPlayer
    if not description then return end

    -- Disconnect any previous post-respawn event to prevent conflicts.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end

    -- Connect a one-time event to apply the description as soon as the new character spawns.
    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Once(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- Wrap in a pcall as ApplyDescription can sometimes fail.
            pcall(humanoid.ApplyDescription, humanoid, description)
        end
    end)
    
    -- Trigger the respawn.
    localPlayer:LoadCharacter()
end

---
-- Morphs the player's character into the target's appearance.
-- @param target <string> The username or UserId of the target.
--
function Modules.CharacterMorph:Morph(target)
    if not target then
        DoNotif("Usage: ;char <username/userid>", 3)
        return
    end

    -- Cache the player's original description if we haven't already.
    if not self.State.OriginalDescription then
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then
            self.State.OriginalDescription = originalDesc
        else
            warn("[CharacterMorph] Could not cache original character description.")
        end
    end

    task.spawn(function()
        local newDescription = self:_resolveDescription(target)
        if newDescription then
            self.State.IsMorphed = true
            self:_applyAndRespawn(newDescription)
            DoNotif("Applying character morph...", 2)
        end
    end)
end

---
-- Reverts the player's character to their original appearance.
--
function Modules.CharacterMorph:Revert()
    if not self.State.IsMorphed then
        DoNotif("You are not currently morphed.", 2)
        return
    end

    if not self.State.OriginalDescription then
        DoNotif("Could not find original avatar to revert to. Re-fetching...", 3)
        -- Attempt to re-fetch if the cache was lost.
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then self.State.OriginalDescription = originalDesc end
    end
    
    if self.State.OriginalDescription then
        self:_applyAndRespawn(self.State.OriginalDescription)
        self.State.IsMorphed = false
        DoNotif("Reverting to original character...", 2)
    else
        DoNotif("Failed to revert character: Original description is missing.", 4)
    end
end

---
-- Initializes the module and registers its commands.
--
function Modules.CharacterMorph:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "char",
        Aliases = {"character", "morph"},
        Description = "Change your character's appearance to someone else's."
    }, function(args)
        module:Morph(args[1])
    end)

    RegisterCommand({
        Name = "unchar",
        Aliases = {},
        Description = "Reverts your character's appearance to your own."
    }, function()
        module:Revert()
    end)
end

Modules.StalkerBot = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        HasLineOfSight = false,
        OriginalNeckC0 = nil,
        Connections = {}
    },

    Config = {
        FollowDistance = 25,
        StopDistance = 15,
        RecalculationInterval = 1.0,
        LineOfSightInterval = 0.25,
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },

    Services = {}
}

--// --- Private: Core Logic ---

function Modules.StalkerBot:_onRenderStepped()
    if not (self.State.IsEnabled and self.State.TargetPlayer) then return end
    
    local success, myChar, targetChar = pcall(function()
        return self.Services.LocalPlayer.Character, self.State.TargetPlayer.Character
    end)
    if not (success and myChar and targetChar) then return end

    local myHead = myChar:FindFirstChild("Head")
    local targetHead = targetChar:FindFirstChild("Head")
    local myTorso = myChar:FindFirstChild("HumanoidRootPart")
    local neck = myChar:FindFirstChild("Neck", true) or (myTorso and myTorso:FindFirstChild("Neck", true))

    if not (myHead and targetHead and neck and neck:IsA("Motor6D")) then return end
    
    if not self.State.OriginalNeckC0 then
        self.State.OriginalNeckC0 = neck.C0
    end
    

    local lookAtCFrame = CFrame.lookAt(neck.Part0.Position, targetHead.Position)
    
    local objectSpaceRotation = neck.Part0.CFrame:ToObjectSpace(lookAtCFrame)
    
    neck.C0 = CFrame.new(self.State.OriginalNeckC0.Position) * (objectSpaceRotation - objectSpaceRotation.Position)
end

function Modules.StalkerBot:_onHeartbeat()
    if not self.State.IsEnabled then return end

    if not (self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        return self:Disable()
    end
    
    local myChar = self.Services.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = self.State.TargetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and myHumanoid and targetRoot and myHumanoid.Health > 0) then
        return
    end

    local distanceToTarget = (myRoot.Position - targetRoot.Position).Magnitude

    if distanceToTarget < self.Config.StopDistance then
        myHumanoid:MoveTo(myRoot.Position)
        return
    end

    local now = os.clock()
    if (now - self.State.LastPathRecalculation) > self.Config.RecalculationInterval then
        self.State.LastPathRecalculation = now
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {myChar, targetChar}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = self.Services.Workspace:Raycast(myRoot.Position, (targetRoot.Position - myRoot.Position).Unit * 1000, raycastParams)
        
        self.State.HasLineOfSight = (not raycastResult or raycastResult.Instance:IsDescendantOf(targetChar))

        local success, err = pcall(function()
            self.State.Path:ComputeAsync(myRoot.Position, targetRoot.Position)
        end)
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 2
        else
            myHumanoid:MoveTo(myRoot.Position)
        end
    end

    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if self.State.CurrentWaypointIndex > #waypoints then
            myHumanoid:MoveTo(myRoot.Position)
            return
        end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        if not self.State.HasLineOfSight or distanceToTarget > self.Config.FollowDistance then
            myHumanoid:MoveTo(currentWaypoint.Position)
            if (currentWaypoint.Position - myRoot.Position).Magnitude < 6 then
                self.State.CurrentWaypointIndex += 1
            end
        else
            myHumanoid:MoveTo(targetRoot.Position)
        end
    end
end

--// --- Public: Control Methods ---

function Modules.StalkerBot:Enable(targetPlayer: Player)
    if not targetPlayer or targetPlayer == self.Services.LocalPlayer then
        return DoNotif("Invalid target for StalkerBot.", 3)
    end
    if self.State.IsEnabled then self:Disable() end

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)

    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function() self:_onRenderStepped() end)

    DoNotif("StalkerBot Enabled: Now following " .. targetPlayer.Name, 3)
end

function Modules.StalkerBot:Disable()
    if not self.State.IsEnabled then return end
    
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    table.clear(self.State.Connections)

    if self.State.OriginalNeckC0 then
        pcall(function()
            local myChar = self.Services.LocalPlayer.Character
            local myTorso = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local neck = myChar and (myChar:FindFirstChild("Neck", true) or (myTorso and myTorso:FindFirstChild("Neck", true)))
            if neck and neck:IsA("Motor6D") then
                neck.C0 = self.State.OriginalNeckC0
            end
        end)
    end

    pcall(function()
        local myHumanoid = self.Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHumanoid then myHumanoid:MoveTo(myHumanoid.RootPart.Position) end
    end)
    
    self.State = {
        IsEnabled = false, TargetPlayer = nil, Path = nil, CurrentWaypointIndex = 1,
        LastPathRecalculation = 0, HasLineOfSight = false, OriginalNeckC0 = nil,
        Connections = {}
    }
    
    DoNotif("StalkerBot Disabled.", 2)
end

function Modules.StalkerBot:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.RunService = game:GetService("RunService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.PathfindingService = game:GetService("PathfindingService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "stalk",
        Aliases = {},
        Description = "Follows a player with uncanny pathfinding."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            self:Disable()
            return
        end
        local target = Utilities.findPlayer(argument)
        if target then
            self:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.InfoPanel = {
    State = {
        IsEnabled = false,
        UI = {},
        Connections = {}
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui"),
        Workspace = game:GetService("Workspace")
    }
}

function Modules.InfoPanel:Toggle()
    if self.State.IsEnabled then
        if self.State.Connections.Updater then
            self.State.Connections.Updater:Disconnect()
        end
        if self.State.UI.ScreenGui then
            self.State.UI.ScreenGui:Destroy()
        end
        self.State = { IsEnabled = false, UI = {}, Connections = {} }
        DoNotif("Info Panel closed.", 2)
        return
    end

    self.State.IsEnabled = true
    DoNotif("Info Panel opened.", 2)

    local localPlayer = self.Services.Players.LocalPlayer

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InfoPanel_Zuka_Radiant"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.State.UI.ScreenGui = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(320, 450)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(34, 32, 38)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Draggable = true
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    
    local uiStroke = Instance.new("UIStroke", mainFrame)
    uiStroke.Color = Color3.fromRGB(255, 105, 180)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.3

    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.fromOffset(10, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = "Game & Player Information"
    titleLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local closeButton = Instance.new("TextButton", titleBar)
    closeButton.Size = UDim2.fromOffset(24, 24)
    closeButton.Position = UDim2.new(1, -28, 0.5, -12)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Parent = titleBar
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0, 0, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)

    local function createHeader(text: string)
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 24)
        header.BackgroundTransparency = 1
        header.Font = Enum.Font.GothamBold
        header.Text = text
        header.TextColor3 = Color3.fromRGB(255, 182, 193)
        header.TextSize = 18
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = scroll
    end

    local function createInfoEntry(key: string, value: any)
        local entry = Instance.new("TextLabel")
        entry.Size = UDim2.new(1, 0, 0, 18)
        entry.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        entry.BackgroundTransparency = 0.8
        entry.Font = Enum.Font.Code
        entry.TextSize = 14
        entry.TextColor3 = Color3.fromRGB(220, 220, 220)
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.RichText = true
        entry.Text = string.format("  <font color='#AAAAAA'>%s:</font> %s", key, tostring(value))
        entry.Parent = scroll
        Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 4)
        return entry
    end

    createHeader("Client Info")
    createInfoEntry("DisplayName", localPlayer.DisplayName)
    createInfoEntry("Username", localPlayer.Name)
    createInfoEntry("User ID", localPlayer.UserId)
    createInfoEntry("Account Age", localPlayer.AccountAge)
    local fpsLabel = createInfoEntry("Client FPS", "Calculating...")

    createHeader("Game Info")
    createInfoEntry("Place ID", game.PlaceId)
    createInfoEntry("Job ID", game.JobId)
    createInfoEntry("Creator Type", game.CreatorType.Name)
    createInfoEntry("Creator ID", game.CreatorId)

    createHeader("Server Players")
    local playerListFrame = Instance.new("Frame", scroll)
    playerListFrame.Size = UDim2.new(1, 0, 0, 0)
    playerListFrame.BackgroundTransparency = 1
    playerListFrame.AutomaticSize = Enum.AutomaticSize.Y
    local playerListLayout = Instance.new("UIListLayout", playerListFrame)
    playerListLayout.Padding = UDim.new(0, 2)

    local lastTick = 0
    self.State.Connections.Updater = self.Services.RunService.Heartbeat:Connect(function(step)
        if not screenGui.Parent then
            self:Toggle()
            return
        end

        local now = tick()
        if now - lastTick > 0.5 then
            lastTick = now
            fpsLabel.Text = string.format("  <font color='#AAAAAA'>Client FPS:</font> %.1f", 1 / step)
            
            for _, child in ipairs(playerListFrame:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            
            local players = self.Services.Players:GetPlayers()
            for _, player in ipairs(players) do
                local playerLabel = Instance.new("TextLabel", playerListFrame)
                playerLabel.Size = UDim2.new(1, 0, 0, 16)
                playerLabel.BackgroundTransparency = 1
                playerLabel.Font = Enum.Font.Code
                playerLabel.TextSize = 13
                playerLabel.TextColor3 = player.TeamColor.Color
                playerLabel.Text = string.format("- %s (@%s)", player.DisplayName, player.Name)
                playerLabel.TextXAlignment = Enum.TextXAlignment.Left
            end
        end
    end)
    
    screenGui.Parent = self.Services.CoreGui
end

RegisterCommand({
    Name = "infopanel",
    Aliases = {"info", "gameinfo", "serverinfo"},
    Description = "Toggles a panel with information about the game, server, and players."
}, function(args)
    Modules.InfoPanel:Toggle()
end)

Modules.StalkBot = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Path = nil,
        CurrentWaypointIndex = 1,
        LastPathRecalculation = 0,
        HasLineOfSight = false,
        Connections = {}
    },

    Config = {
        FollowDistance = 80,
        StopDistance = 15,
        RecalculationInterval = 1.0,
        LineOfSightInterval = 0.25,
        PATH_PARAMS = {
            AgentRadius = 3,
            AgentHeight = 6,
            AgentCanJump = true,
        }
    },

    Services = {}
}



function Modules.StalkerBot:_onRenderStepped()
    if not (self.State.IsEnabled and self.State.TargetPlayer) then return end
    
    local success, myChar, targetChar = pcall(function()
        return self.Services.LocalPlayer.Character, self.State.TargetPlayer.Character
    end)
    if not (success and myChar and targetChar) then return end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and targetRoot) then return end

    -- Calculate the CFrame that looks at the target's position from our position.
    local lookAtCFrame = CFrame.lookAt(myRoot.Position, targetRoot.Position)
    
    myRoot.CFrame = CFrame.fromMatrix(myRoot.Position, lookAtCFrame.XVector, myRoot.CFrame.YVector)
end

function Modules.StalkerBot:_onHeartbeat()
    if not self.State.IsEnabled then return end

    if not (self.State.TargetPlayer and self.State.TargetPlayer.Parent) then
        return self:Disable()
    end
    
    local myChar = self.Services.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = self.State.TargetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if not (myRoot and myHumanoid and targetRoot and myHumanoid.Health > 0) then
        return
    end

    local distanceToTarget = (myRoot.Position - targetRoot.Position).Magnitude

    if distanceToTarget < self.Config.StopDistance then
        myHumanoid:MoveTo(myRoot.Position)
        return
    end

    local now = os.clock()
    if (now - self.State.LastPathRecalculation) > self.Config.RecalculationInterval then
        self.State.LastPathRecalculation = now
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {myChar}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = self.Services.Workspace:Raycast(myRoot.Position, (targetRoot.Position - myRoot.Position), raycastParams)
        
        self.State.HasLineOfSight = (not raycastResult or raycastResult.Instance:IsDescendantOf(targetChar))

        local success, err = pcall(function()
            self.State.Path:ComputeAsync(myRoot.Position, targetRoot.Position)
        end)
        if success and self.State.Path.Status == Enum.PathStatus.Success then
            self.State.CurrentWaypointIndex = 2
        else
            myHumanoid:MoveTo(myRoot.Position)
        end
    end

    if self.State.Path and self.State.Path.Status == Enum.PathStatus.Success then
        local waypoints = self.State.Path:GetWaypoints()
        if self.State.CurrentWaypointIndex > #waypoints then
            myHumanoid:MoveTo(myRoot.Position)
            return
        end

        local currentWaypoint = waypoints[self.State.CurrentWaypointIndex]
        
        if not self.State.HasLineOfSight or distanceToTarget > self.Config.FollowDistance then
            myHumanoid:MoveTo(currentWaypoint.Position)
            if (currentWaypoint.Position - myRoot.Position).Magnitude < 6 then
                self.State.CurrentWaypointIndex += 1
            end
        else
            myHumanoid:MoveTo(targetRoot.Position)
        end
    end
end


function Modules.StalkerBot:Enable(targetPlayer: Player)
    if not targetPlayer or targetPlayer == self.Services.LocalPlayer then
        return DoNotif("Invalid target for StalkerBot.", 3)
    end
    if self.State.IsEnabled then self:Disable() end

    pcall(function()
        self.Services.LocalPlayer.Character.Humanoid.AutoRotate = false
    end)

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Path = self.Services.PathfindingService:CreatePath(self.Config.PATH_PARAMS)

    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function() self:_onRenderStepped() end)

    DoNotif("StalkBot Enabled: Now following " .. targetPlayer.Name, 3)
end

function Modules.StalkerBot:Disable()
    if not self.State.IsEnabled then return end
    
    for _, conn in pairs(self.State.Connections) do conn:Disconnect() end
    table.clear(self.State.Connections)

    -- [CRITICAL CHANGE] Give rotation control back to the Humanoid.
    pcall(function()
        local humanoid = self.Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
            humanoid:MoveTo(humanoid.RootPart.Position) -- Stop any movement
        end
    end)
    
    self.State = {
        IsEnabled = false, TargetPlayer = nil, Path = nil, CurrentWaypointIndex = 1,
        LastPathRecalculation = 0, HasLineOfSight = false, Connections = {}
    }
    
    DoNotif("StalkBot Disabled.", 2)
end

function Modules.StalkerBot:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.RunService = game:GetService("RunService")
    self.Services.Workspace = game:GetService("Workspace")
    self.Services.PathfindingService = game:GetService("PathfindingService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "null",
        Aliases = {},
        Description = "Stalks a player with uncanny pathfinding."
    }, function(args)
        local argument = args[1]
        if not argument or (argument:lower() == "stop" or argument:lower() == "off") then
            self:Disable()
            return
        end
        local target = Utilities.findPlayer(argument)
        if target then
            self:Enable(target)
        else
            DoNotif("Player '" .. argument .. "' not found.", 3)
        end
    end)
end

Modules.TimeStop = {
    State = {
        IsEnabled = false,
        Connections = {}
    },
    Dependencies = {"Players"},
    Services = {}
}

---
--
function Modules.TimeStop:_freezeCharacter(character)
    if not character then return end
    task.wait() 
    local success, err = pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
            end
        end
    end)
    if not success then warn("[TimeStop] Failed to freeze character:", err) end
end


function Modules.TimeStop:_unfreezeCharacter(character)
    if not character then return end
    pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = false
            end
        end
    end)
end

---
-- Disables the time stop effect and cleans up all resources.
--
function Modules.TimeStop:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect all event listeners to stop applying the freeze.
    for key, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Iterate through all players and unfreeze them.
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        if player.Character then
            self:_unfreezeCharacter(player.Character)
        end
    end

    self.State.IsEnabled = false
    DoNotif("Time has resumed.", 2)
end

---
-- Enables the time stop effect on all current and future players.
--
function Modules.TimeStop:Enable()
    if self.State.IsEnabled then return end
    -- It's good practice to call Disable first to ensure a clean state.
    self:Disable()
    self.State.IsEnabled = true

    -- [Helper] Sets up the freeze logic for a given player.
    local function setupPlayer(player)
        -- Don't freeze ourselves.
        if player == self.Services.Players.LocalPlayer then return end

        -- Freeze their current character if it exists.
        if player.Character then
            self:_freezeCharacter(player.Character)
        end
        
        -- Connect to their CharacterAdded event for future respawns.
        local conn = player.CharacterAdded:Connect(function(character)
            self:_freezeCharacter(character)
        end)
        
        -- Store the connection so we can disconnect it later.
        self.State.Connections[player.UserId] = conn
    end

    -- Apply to all existing players.
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        setupPlayer(player)
    end

    -- Connect to PlayerAdded to handle players who join while timestop is active.
    self.State.Connections.PlayerAdded = self.Services.Players.PlayerAdded:Connect(setupPlayer)
    
    DoNotif("ZA WARUDO! Time has been stopped.", 3)
end

function Modules.TimeStop:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "timestop",
        Aliases = {"tstop"},
        Description = "Toggles a client-sided freeze for all other players."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
    
    -- Keep the `untimestop` command for convenience, pointing it to the Disable function.
    RegisterCommand({
        Name = "untimestop",
        Aliases = {"untstop"},
        Description = "Explicitly disables the time stop effect."
    }, function()
        module:Disable()
    end)
end


Modules.AnimationSpeed = {
    State = {
        IsEnabled = false,
        TargetSpeed = 1,
        LoopConnection = nil
    },
    Dependencies = {"RunService", "Players"},
    Services = {}
}

---
-- Disables the animation speed override and cleans up resources.
--
function Modules.AnimationSpeed:Disable()
    if not self.State.IsEnabled then return end

    -- Disconnect the main loop to stop overriding the speed.
    if self.State.LoopConnection then
        self.State.LoopConnection:Disconnect()
        self.State.LoopConnection = nil
    end

    self.State.IsEnabled = false


    task.spawn(function()
        local char = self.Services.Players.LocalPlayer.Character
        if not char then return end
        
        local animator = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not animator then return end

        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(1)
            end
        end)
    end)
    
    DoNotif("Animation speed control disabled.", 2)
end

---
-- Enables or updates the animation speed override.
-- @param speed <number> The desired playback speed (e.g., 2 for double speed).
--
function Modules.AnimationSpeed:Enable(speed)
    local targetSpeed = tonumber(speed)
    if not targetSpeed or targetSpeed < 0 then
        DoNotif("Invalid speed. Must be a positive number.", 3)
        return
    end

    self.State.TargetSpeed = targetSpeed

    -- If the loop is already running, we just needed to update the speed value.
    if self.State.IsEnabled then
        DoNotif("Animation speed updated to " .. targetSpeed, 2)
        return
    end

    self.State.IsEnabled = true
    
    -- Connect the main loop to RunService.Stepped for physics-related updates.
    self.State.LoopConnection = self.Services.RunService.Stepped:Connect(function()
        local char = self.Services.Players.LocalPlayer.Character
        if not char then return end
        
        -- Find the Humanoid or AnimationController, which manages animations.
        local animator = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not animator then return end

        -- Use a pcall to prevent a single broken animation track from erroring the whole loop.
        local success, err = pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                -- Only adjust speed if it's not already at the target, to be efficient.
                if track.Speed ~= self.State.TargetSpeed then
                    track:AdjustSpeed(self.State.TargetSpeed)
                end
            end
        end)
        
        if not success then
            warn("[AnimationSpeed] Error during loop:", err)
            -- Automatically disable the module if a persistent error occurs.
            self:Disable()
        end
    end)

    DoNotif("Animation speed set to " .. targetSpeed, 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.AnimationSpeed:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "animspeed",
        Aliases = {},
        Description = "Adjusts local animation speed."
    }, function(args)
        local argument = args[1]
        
        if not argument or (argument:lower() == "off" or argument:lower() == "stop" or argument:lower() == "reset") then
            module:Disable()
        else
            module:Enable(argument)
        end
    end)

    -- Registering the "un" command for convenience, which simply calls the Disable function.
    RegisterCommand({
        Name = "unanimspeed",
        Aliases = {"unaspeed", "unanimationspeed"},
        Description = "Stops the animation speed adjustment loop."
    }, function()
        module:Disable()
    end)
end


Modules.Attacher = {
    State = {
        isGuiBuilt = false,
        followSpeed = 1,
        selectedPlayerName = "Nearest Player",
        isFollowing = false,
        isAttaching = false,
        
        -- UI and Connection Storage
        UI = {},
        Connections = {}
    },
    Services = {}
}

--// Deactivation Logic (Cleanup)
function Modules.Attacher:Deactivate()
    if not self.State.isGuiBuilt then return end

    -- Disconnect all active RunService/input connections
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Destroy all UI elements
    if self.State.UI.window and self.State.UI.window.Parent then
        self.State.UI.window:Destroy()
    end
    if self.State.UI.currentHighlight and self.State.UI.currentHighlight.Parent then
        self.State.UI.currentHighlight:Destroy()
    end
    table.clear(self.State.UI)
    
    self.State.isGuiBuilt = false
    DoNotif("Attacher module deactivated.", 2)
end

function Modules.Attacher:Activate()
    if self.State.isGuiBuilt then return end
    
    -- Localize self for easier access within functions
    local self = self

    self.Services.Players = self.Services.Players or game:GetService("Players")
    self.Services.RunService = self.Services.RunService or game:GetService("RunService")
    self.Services.StarterGui = self.Services.StarterGui or game:GetService("StarterGui")
    local LocalPlayer = self.Services.Players.LocalPlayer

    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
    local w = library:CreateWindow("Attacher")
    self.State.UI.window = w

    local function notify(title, text, duration)
        pcall(function()
            self.Services.StarterGui:SetCore("SendNotification", {
                Title = title; Text = text; Duration = duration or 3;
            })
        end)
    end

    local function clearHighlight()
        if self.State.UI.currentHighlight and self.State.UI.currentHighlight.Parent then
            self.State.UI.currentHighlight:Destroy()
            self.State.UI.currentHighlight = nil
        end
    end

    local function applyHighlight(targetPlayer)
        clearHighlight()
        if targetPlayer and targetPlayer.Character then
            local h = Instance.new("Highlight", targetPlayer.Character)
            h.Name = "TargetHighlight"
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.45
            h.Adornee = targetPlayer.Character
            self.State.UI.currentHighlight = h
        end
    end

    local function findPlayerByPartialName(partialName)
        -- This function remains the same as your previous version
        local localChar = LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos = localChar.HumanoidRootPart.Position
        local lowerPartialName = partialName:lower()
        local matches = {}
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if p.Name:lower():find(lowerPartialName, 1, true) or p.DisplayName:lower():find(lowerPartialName, 1, true) then
                    table.insert(matches, p)
                end
            end
        end
        if #matches == 0 then return nil end
        if #matches == 1 then return matches[1] end
        local closestPlayer, closestDist = nil, math.huge
        for _, matchedPlayer in ipairs(matches) do
            if matchedPlayer.Character and matchedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (matchedPlayer.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist, closestPlayer = dist, matchedPlayer
                end
            end
        end
        return closestPlayer
    end
    
    local function updateNearestPlayerButton()
        if not self.State.UI.nearestPlayerButton then return end
        if self.State.selectedPlayerName == "Nearest Player" then
            self.State.UI.nearestPlayerButton.Name = "-> Nearest Player"
        else
            self.State.UI.nearestPlayerButton.Name = "Nearest Player"
        end
    end

    -- Build the GUI
    local mainFolder = w:CreateFolder("Follow Settings")
    mainFolder:Slider("Speed", {min = 0; max = 5; precise = true;}, function(value)
        self.State.followSpeed = value
    end)
    mainFolder:Box("Enter Username", "string", function(value)
        if value == "" then notify("Input Error", "Please type a valid username.", 3) return end
        local found = findPlayerByPartialName(value)
        if found and found ~= LocalPlayer then
            self.State.selectedPlayerName = found.Name
            applyHighlight(found)
            notify("Player Selected", "Targeting " .. found.Name, 2)
            updateNearestPlayerButton()
        else
            self.State.selectedPlayerName = "Nearest Player"
            updateNearestPlayerButton()
            notify("Player Not Found", "Could not find player: " .. value, 3)
        end
    end)
    self.State.UI.nearestPlayerButton = mainFolder:Button("-> Nearest Player", function()
        self.State.selectedPlayerName = "Nearest Player"
        clearHighlight()
        notify("Player Selected", "Nearest Player", 2)
        updateNearestPlayerButton()
    end)
    mainFolder:Toggle("Enable Following", function(bool)
        self.State.isFollowing = bool
        notify("Following", bool and "Enabled" or "Disabled")
    end)
    mainFolder:Toggle("Attach", function(bool)
        self.State.isAttaching = bool
        notify("Attach", bool and "Enabled" or "Disabled")
    end)

    -- Helper functions for the main loop
    local function getNearestPlayer()
        local localChar = LocalPlayer.Character
        if not (localChar and localChar:FindFirstChild("HumanoidRootPart")) then return nil end
        local myPos = localChar.HumanoidRootPart.Position
        local closest, dist = nil, math.huge
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if d < dist then closest, dist = p, d end
            end
        end
        return closest
    end

    local function getSelectedPlayer()
        if self.State.selectedPlayerName == "Nearest Player" then
            local n = getNearestPlayer()
            if n then applyHighlight(n) else clearHighlight() end
            return n
        elseif self.State.selectedPlayerName and self.Services.Players:FindFirstChild(self.State.selectedPlayerName) then
            local p = self.Services.Players[self.State.selectedPlayerName]
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                return p
            end
        end
        clearHighlight()
        return nil
    end

    --// --- Event Connections ---
    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function()
        local target = getSelectedPlayer()
        if (self.State.isFollowing or self.State.isAttaching) and target then
            local localChar, targetChar = LocalPlayer.Character, target.Character
            if localChar and targetChar then
                local part, targetPart = localChar:FindFirstChild("HumanoidRootPart"), targetChar:FindFirstChild("HumanoidRootPart")
                if part and targetPart then
                    local hum = localChar:FindFirstChildOfClass("Humanoid")
                    if hum then hum.AutoRotate = false end

                    if self.State.isAttaching then
                        part.CFrame = part.CFrame:Lerp(targetPart.CFrame, self.State.followSpeed)
                        local thum = targetChar:FindFirstChildOfClass("Humanoid")
                        if thum and thum.Jump then hum.Jump = true end
                    elseif self.State.isFollowing then
                        part.CFrame = part.CFrame:Lerp(CFrame.new(part.Position, targetPart.Position), self.State.followSpeed)
                        hum:MoveTo(targetPart.Position)
                    end
                end
            end
        else
            local c = LocalPlayer.Character
            if c and c:FindFirstChildOfClass("Humanoid") then c:FindFirstChildOfClass("Humanoid").AutoRotate = true end
        end
    end)

    self.State.Connections.KeyDown = LocalPlayer:GetMouse().KeyDown:Connect(function(k)
        k = k:lower()
        if k == "x" then
            self.State.isFollowing = not self.State.isFollowing
            notify("Following", self.State.isFollowing and "Enabled" or "Disabled")
        elseif k == "z" then
            self.State.isAttaching = not self.State.isAttaching
            notify("Attach", self.State.isAttaching and "Enabled" or "Disabled")
        end
    end)
    
    self.State.isGuiBuilt = true
    DoNotif("Attacher module activated.", 2)
end

--// Main Toggle Function
function Modules.Attacher:Toggle()
    if self.State.isGuiBuilt then
        self:Deactivate()
    else
        self:Activate()
    end
end

RegisterCommand({
    Name = "attacher",
    Aliases = {"attachui", "followui"},
    Description = "Toggles the Player Attacher/Follower UI."
}, function()
    -- This ensures the module is initialized before being used
    if not Modules.Attacher.Toggle then
        -- Handle potential script reloads by re-attaching methods if necessary
        -- (This is an advanced robustness check)
        local originalFunctions = loadfile("path/to/your/AttacherModule.lua")()
        Modules.Attacher.Activate = originalFunctions.Activate
        Modules.Attacher.Deactivate = originalFunctions.Deactivate
        Modules.Attacher.Toggle = originalFunctions.Toggle
    end
    Modules.Attacher:Toggle()
end)


Modules.StaffSentry = {
    State = {
        IsEnabled = false,
        AutoJoinConnection = nil,
        StaffGroups = {1200769, 2868472, 4199740} 
    }
}

function Modules.StaffSentry:Scan()
    local found = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local isStaff = false
        for _, groupId in ipairs(self.State.StaffGroups) do
            if player:GetRankInGroup(groupId) > 0 then
                isStaff = true
                break
            end
        end
        
        if isStaff or player:IsFriendsWith(LocalPlayer.UserId) == false and (player.AccountAge < 5) then
            table.insert(found, player.Name)
        end
    end
    
    if #found > 0 then
        DoNotif("Staff/Suspects Found: " .. table.concat(found, ", "), 5)
    else
        DoNotif("No staff members detected in current server.", 3)
    end
end

function Modules.StaffSentry:Initialize()
    RegisterCommand({
        Name = "staffcheck",
        Aliases = {"scheck", "admins"},
        Description = "Scans the server for players in common staff groups or with suspicious account ages."
    }, function()
        self:Scan()
    end)
end

Modules.KnockbackNullifier = {
    State = {
        IsEnabled = false,
        Connection = nil
    }
}

function Modules.KnockbackNullifier:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    
    if self.State.IsEnabled then
        self.State.Connection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                if vel.Magnitude > 0 and not UserInputService:GetFocusedTextBox() then
                    local moveDir = char:FindFirstChildOfClass("Humanoid").MoveDirection
                    if moveDir.Magnitude == 0 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                    end
                end
            end
        end)
        DoNotif("Knockback Nullifier: ENABLED", 2)
    else
        if self.State.Connection then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        DoNotif("Knockback Nullifier: DISABLED", 2)
    end
end

function Modules.KnockbackNullifier:Initialize()
    RegisterCommand({
        Name = "noknockb",
        Aliases = {"noknockback", "steady"},
        Description = "Negates external physics impulses to prevent being pushed around."
    }, function()
        self:Toggle()
    end)
end

Modules.AntiCheatBypass = {
    State = {
        IsEnabled = false,
        HookedHumanoids = setmetatable({}, {__mode = "k"}), 
        Connections = {}
    },
    Config = {
        VANILLA_WALKSPEED = 16,
        VANILLA_JUMPPOWER = 50,
        TRUE_WALKSPEED_KEY = "AntiCheatBypass_TrueWalkSpeed",
        TRUE_JUMPPOWER_KEY = "AntiCheatBypass_TrueJumpPower"
    }
}

--- Applies the metatable hooks to a character's humanoid.
function Modules.AntiCheatBypass:_applyHooks(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or self.State.HookedHumanoids[humanoid] then
        return
    end

    local success, mt = pcall(getrawmetatable, humanoid)
    if not success or typeof(mt) ~= "table" then
        warn("AntiCheatBypass: Failed to get humanoid metatable. Environment may not be supported.")
        return
    end

    local originalIndex = mt.__index
    local originalNewIndex = mt.__newindex
    self.State.HookedHumanoids[humanoid] = { originalIndex, originalNewIndex }

    humanoid[self.Config.TRUE_WALKSPEED_KEY] = humanoid.WalkSpeed
    humanoid[self.Config.TRUE_JUMPPOWER_KEY] = humanoid.JumpPower

    setreadonly(mt, false)

    mt.__index = function(self, key)
        if key == "WalkSpeed" then
            return Modules.AntiCheatBypass.Config.VANILLA_WALKSPEED
        end
        if key == "JumpPower" then
            return Modules.AntiCheatBypass.Config.VANILLA_JUMPPOWER
        end
        return originalIndex(self, key)
    end

    mt.__newindex = function(self, key, value)
        if key == "WalkSpeed" then
            humanoid[Modules.AntiCheatBypass.Config.TRUE_WALKSPEED_KEY] = value
            return
        end
        if key == "JumpPower" then
            humanoid[Modules.AntiCheatBypass.Config.TRUE_JUMPPOWER_KEY] = value
            return
        end
        return originalNewIndex(self, key, value)
    end

    setreadonly(mt, true)
end

--- Removes the metatable hooks and restores original behavior.
function Modules.AntiCheatBypass:_removeHooks(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not self.State.HookedHumanoids[humanoid] then
        return
    end

    local success, mt = pcall(getrawmetatable, humanoid)
    if not success or typeof(mt) ~= "table" then
        return
    end

    local originalMeta = self.State.HookedHumanoids[humanoid]
    setreadonly(mt, false)
    mt.__index = originalMeta[1]
    mt.__newindex = originalMeta[2]
    setreadonly(mt, true)

    if humanoid[self.Config.TRUE_WALKSPEED_KEY] then
        humanoid.WalkSpeed = humanoid[self.Config.TRUE_WALKSPEED_KEY]
    end
    if humanoid[self.Config.TRUE_JUMPPOWER_KEY] then
        humanoid.JumpPower = humanoid[self.Config.TRUE_JUMPPOWER_KEY]
    end

    self.State.HookedHumanoids[humanoid] = nil
end

--- Enables the Anti-Cheat Bypass system.
function Modules.AntiCheatBypass:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    if LocalPlayer.Character then
        self:_applyHooks(LocalPlayer.Character)
    end

    self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
        self:_applyHooks(character)
    end)
    self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
        self:_removeHooks(character)
    end)

    DoNotif("Anti-Cheat Bypass: ENABLED. Humanoid properties sanitized.", 3)
end

--- Disables the Anti-Cheat Bypass system.
function Modules.AntiCheatBypass:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    if LocalPlayer.Character then
        self:_removeHooks(LocalPlayer.Character)
    end

    for humanoid, _ in pairs(self.State.HookedHumanoids) do
        if humanoid.Parent then
            self:_removeHooks(humanoid.Parent)
        end
    end

    DoNotif("Anti-Cheat Bypass: DISABLED. Humanoid properties restored.", 3)
end

--- Toggles the state of the bypass.
function Modules.AntiCheatBypass:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- [FIX]: This entire function call was missing, causing the syntax error on the next module.
RegisterCommand({
    Name = "acbypass",
    Aliases = {"anticheatbypass", "sanitize"},
    Description = "Toggles a bypass that makes your WalkSpeed and JumpPower appear normal to client-side anti-cheats."
}, function()
    Modules.AntiCheatBypass:Toggle()
end)

Modules.AntiVoid = {
    State = {
        IsEnabled = false,
        Connection = nil
    },
    Config = {
        -- How many studs above the void kill-height to trigger the teleport.
        -- A higher value is safer but might trigger on maps with very low areas.
        SafetyBuffer = 15 
    }
}

--- Finds a safe spawn point, with a fallback to a default coordinate.
-- @return CFrame - The CFrame of a safe location to teleport to.
function Modules.AntiVoid:_getSafeSpawnPoint()
    local spawnLocations = {}
    -- Search the entire workspace for any available SpawnLocation
    for _, descendant in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if descendant:IsA("SpawnLocation") then
            table.insert(spawnLocations, descendant)
        end
    end

    if #spawnLocations > 0 then
        -- Return the CFrame of the first valid spawn found, with a vertical offset.
        return spawnLocations[1].CFrame * CFrame.new(0, 3, 0)
    else
        -- Fallback in case no SpawnLocation objects exist in the game.
        return CFrame.new(0, 50, 0)
    end
end

--- Enables the anti-void check.
function Modules.AntiVoid:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    -- Bind the check to Heartbeat, which runs after every physics step.
    self.State.Connection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local voidLevel = Workspace.FallenPartsDestroyHeight
        
        -- Check if the player has fallen below the trigger height
        if hrp.Position.Y < (voidLevel + self.Config.SafetyBuffer) then
            local safeCFrame = self:_getSafeSpawnPoint()
            
            -- Teleport the character and reset their velocity to stabilize them.
            hrp.CFrame = safeCFrame
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end)

    DoNotif("Anti-Void: ENABLED.", 2)
end

--- Disables the anti-void check and cleans up connections.
function Modules.AntiVoid:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect the Heartbeat connection to prevent resource leaks.
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("Anti-Void: DISABLED.", 2)
end

--- Toggles the anti-void state.
function Modules.AntiVoid:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end
RegisterCommand({ Name = "antivoid", Aliases = { "novoid" }, Description = "Toggles an anti-void system that teleports you to spawn before you die." }, function() Modules.AntiVoid:Toggle() end)

Modules.AdvancedShiftLock = {
    State = {
        IsEnabled = false, 
        IsLocked = false,  
        UI = {},
        Connections = {},
        Originals = {} 
    },
    Config = {
        Icons = {
            On = "rbxasset://textures/ui/mouseLock_on.png",
            Off = "rbxasset://textures/ui/mouseLock_off.png"
        }
    },
    Dependencies = {"Players", "TweenService", "UserInputService", "RunService", "Workspace", "CoreGui"},
    Services = {}
}

---
-- [FIX] Added the missing _makeDraggable helper function.
--
function Modules.AdvancedShiftLock:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.AdvancedShiftLock:_faceCamera(state)
    if self.State.Connections.Rotation then
        self.State.Connections.Rotation:Disconnect()
        self.State.Connections.Rotation = nil
    end

    local char = self.Services.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if state then 
        self.State.Originals.AutoRotate = hum.AutoRotate
        hum.AutoRotate = false
        
        self.State.Connections.Rotation = self.Services.RunService.RenderStepped:Connect(function()
            local hrp = hum.RootPart
            local camera = self.Services.Workspace.CurrentCamera
            if not (hrp and camera) then return end
            
            local lookVector = camera.CFrame.LookVector
            local flatVector = Vector3.new(lookVector.X, 0, lookVector.Z)
            
            if flatVector.Magnitude > 1e-4 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flatVector.Unit)
            end
        end)
    else 
        if self.State.Originals.AutoRotate ~= nil then
            hum.AutoRotate = self.State.Originals.AutoRotate
            self.State.Originals.AutoRotate = nil
        end
    end
end

function Modules.AdvancedShiftLock:_lockMouse(state)
    if self.Services.UserInputService.MouseEnabled then
        self.Services.UserInputService.MouseBehavior = state and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
    end
end

function Modules.AdvancedShiftLock:_setLockState(newState)
    self.State.IsLocked = newState
    
    self:_lockMouse(newState)
    self:_faceCamera(newState)

    local ui = self.State.UI
    if not ui.Button then return end
    
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local targetColor = newState and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 140, 255)
    local targetThickness = newState and 3 or 2
    local targetBg = newState and Color3.fromRGB(38, 48, 60) or Color3.fromRGB(34, 34, 38)
    
    self.Services.TweenService:Create(ui.Stroke, tweenInfo, {Color = targetColor, Thickness = targetThickness}):Play()
    self.Services.TweenService:Create(ui.Button, tweenInfo, {BackgroundColor3 = targetBg}):Play()
    self.Services.TweenService:Create(ui.Icon, tweenInfo, {ImageColor3 = newState and targetColor or Color3.new(1,1,1)}):Play()
    ui.Icon.Image = newState and self.Config.Icons.On or self.Config.Icons.Off
end

function Modules.AdvancedShiftLock:_reapplyState()
    if not self.State.IsEnabled then return end
    task.defer(function()
        self:_setLockState(self.State.IsLocked)
    end)
end

function Modules.AdvancedShiftLock:Disable()
    if not self.State.IsEnabled then return end

    if self.State.IsLocked then self:_setLockState(false) end
    
    if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
    if self.State.Connections.CameraChanged then self.State.Connections.CameraChanged:Disconnect() end
    table.clear(self.State.Connections)

    if self.State.UI.ScreenGui then
        local ui = self.State.UI
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        self.Services.TweenService:Create(ui.Scale, tweenInfo, {Scale = 0}):Play()
        self.Services.TweenService:Create(ui.Button, tweenInfo, {BackgroundTransparency = 1}):Play()
        self.Services.TweenService:Create(ui.Stroke, TweenInfo.new(0.12), {Transparency = 1}):Play()
        task.delay(0.2, function()
            if ui.ScreenGui then ui.ScreenGui:Destroy() end
        end)
    end

    self.State.IsEnabled = false
    self.State.UI = {}
    DoNotif("Advanced Shift Lock disabled.", 2)
end

function Modules.AdvancedShiftLock:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local ui = {}
    self.State.UI = ui
    
    ui.ScreenGui = Instance.new("ScreenGui")
    ui.ScreenGui.Name = "AdvancedShiftLockUI_Module"
    ui.ScreenGui.ResetOnSpawn = false
    ui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.ScreenGui.DisplayOrder = 10000
    
    ui.Button = Instance.new("ImageButton")
    ui.Button.Name = "LockBtn"
    ui.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.Button.Size = UDim2.fromOffset(64, 64)
    ui.Button.Position = UDim2.new(1, -96, 1, -96)
    ui.Button.BackgroundColor3 = Color3.fromRGB(34, 34, 38)
    ui.Button.Parent = ui.ScreenGui
    Instance.new("UICorner", ui.Button).CornerRadius = UDim.new(1, 0)

    ui.Stroke = Instance.new("UIStroke", ui.Button)
    ui.Stroke.Thickness = 2
    ui.Stroke.Color = Color3.fromRGB(0, 140, 255)
    ui.Stroke.Transparency = 0.25

    ui.Icon = Instance.new("ImageLabel", ui.Button)
    ui.Icon.BackgroundTransparency = 1
    ui.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.Icon.Position = UDim2.fromScale(0.5, 0.5)
    ui.Icon.Size = UDim2.fromScale(0.62, 0.62)
    ui.Icon.Image = self.Config.Icons.Off
    
    local closeBtn = Instance.new("TextButton", ui.Button)
    closeBtn.Name = "CloseButton"
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, 6, 0, -6)
    closeBtn.Size = UDim2.fromOffset(22, 22)
    closeBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextScaled = true
    closeBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

    ui.Scale = Instance.new("UIScale", ui.Button)
    ui.Scale.Scale = 0
    self.Services.TweenService:Create(ui.Scale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
    
    self:_makeDraggable(ui.Button, ui.Button)

    ui.Button.Activated:Connect(function() self:_setLockState(not self.State.IsLocked) end)
    closeBtn.Activated:Connect(function() self:Disable() end)
    
    self.State.Connections.CharacterAdded = self.Services.Players.LocalPlayer.CharacterAdded:Connect(function() self:_reapplyState() end)
    self.State.Connections.CameraChanged = self.Services.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() self:_reapplyState() end)

    ui.ScreenGui.Parent = self.Services.CoreGui
    DoNotif("Advanced Shift Lock enabled.", 2)
end

function Modules.AdvancedShiftLock:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end
    
    RegisterCommand({
        Name = "shiftlock",
        Aliases = {"sl", "shiftlockui"},
        Description = "Toggles a custom UI for a client-sided shift lock."
    }, function()
        if module.State.IsEnabled then
            module:Disable()
        else
            module:Enable()
        end
    end)
end

Modules.AntiTrip = {
    State = {
        IsEnabled = false,
        -- Using a weak-keyed table for the cache ensures that if a character/humanoid
        -- is destroyed, its entry in the cache is automatically garbage collected.
        OriginalStateCache = setmetatable({}, {__mode = "k"}),
        -- Tracks all active connections for robust cleanup.
        Connections = {}
    },
    Config = {
        -- The humanoid states that this module will actively block.
        StatesToBlock = {
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.PlatformStanding
        }
    },
    Dependencies = {"Players", "RunService"},
    Services = {}
}

---
-- [Private] Forces a character to recover from a blocked state.
--
function Modules.AntiTrip:_forceRecovery(humanoid)
    if not humanoid then return end
    pcall(function()
        local character = humanoid.Parent
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.zero
        end
        humanoid.PlatformStand = false
        -- GettingUp is often more reliable for breaking out of physics states than Running.
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
end

---
-- [Private] Applies the anti-trip logic to a specific character.
--
function Modules.AntiTrip:_applyToCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    -- Cache the original state of the humanoid properties we are about to change.
    local savedStates = {}
    for _, stateType in ipairs(self.Config.StatesToBlock) do
        local success, isEnabled = pcall(humanoid.GetStateEnabled, humanoid, stateType)
        if success then
            savedStates[stateType] = isEnabled
            pcall(humanoid.SetStateEnabled, humanoid, stateType, false)
        end
    end
    self.State.OriginalStateCache[humanoid] = savedStates

    -- Create a single, efficient loop on Stepped (runs before physics simulation).
    local loopConnection = self.Services.RunService.Stepped:Connect(function()
        local currentState = humanoid:GetState()
        for _, blockedState in ipairs(self.Config.StatesToBlock) do
            if currentState == blockedState then
                self:_forceRecovery(humanoid)
                break -- No need to check other states in this frame
            end
        end
    end)
    
    -- Store the connection for this specific character.
    self.State.Connections[character] = loopConnection
end

---
-- [Private] Reverts all changes made to a specific character.
--
function Modules.AntiTrip:_revertForCharacter(character)
    if not character then return end
    
    -- Disconnect the recovery loop for this character.
    if self.State.Connections[character] then
        self.State.Connections[character]:Disconnect()
        self.State.Connections[character] = nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and self.State.OriginalStateCache[humanoid] then
        -- Restore the original humanoid state settings from our cache.
        for stateType, wasEnabled in pairs(self.State.OriginalStateCache[humanoid]) do
            pcall(humanoid.SetStateEnabled, humanoid, stateType, wasEnabled)
        end
        -- Remove the entry from the cache.
        self.State.OriginalStateCache[humanoid] = nil
    end
end

---
-- Enables the anti-trip module.
--
function Modules.AntiTrip:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local localPlayer = self.Services.Players.LocalPlayer
    
    -- Apply to the current character if it exists.
    if localPlayer.Character then
        self:_applyToCharacter(localPlayer.Character)
    end

    -- Hook into future character spawns and despawns.
    self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char) self:_applyToCharacter(char) end)
    self.State.Connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(char) self:_revertForCharacter(char) end)

    DoNotif("Anti-Trip Enabled", 2)
end

---
-- Disables the anti-trip module and cleans up all resources.
--
function Modules.AntiTrip:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect the main CharacterAdded/Removing hooks.
    if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
    if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
    self.State.Connections.CharacterAdded, self.State.Connections.CharacterRemoving = nil, nil

    -- Revert the effect for the current character.
    if self.Services.Players.LocalPlayer.Character then
        self:_revertForCharacter(self.Services.Players.LocalPlayer.Character)
    end
    
    DoNotif("Anti-Trip Disabled", 2)
end

function Modules.AntiTrip:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

---
-- Initializes the module and registers its commands.
--
function Modules.AntiTrip:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "antitrip",
        Description = "Toggles a system to prevent your character from tripping or ragdolling."
    }, function()
        module:Toggle()
    end)
end

Modules.AdBlock = {
    State = {
        IsEnabled = false,
        -- This connection will listen for new objects being added to the workspace.
        Connection = nil
    },
    Dependencies = {"Workspace"},
    Services = {}
}

---
-- [Private] The core logic to identify and destroy a potential ad object.
-- This function is designed to be called by both the initial scan and the event listener.
--
function Modules.AdBlock:_processObject(obj)
    -- The original script's entry point was checking for PackageLinks, which is a good heuristic.
    if obj:IsA("PackageLink") then
        local parent = obj.Parent
        if not parent then return end

        local success, err = pcall(function()
            if parent:FindFirstChild("ADpart") then
                -- Direct ad structure, destroy the parent model/part.
                parent:Destroy()
            elseif parent:FindFirstChild("AdGuiAdornee") then
                -- Indirect structure, likely where the ad is a child of a child.
                local grandParent = parent.Parent
                if grandParent and grandParent ~= self.Services.Workspace then
                    grandParent:Destroy()
                else
                    parent:Destroy()
                end
            end
        end)

        if not success then
            warn("[AdBlock] Failed to process a potential ad object:", err)
        end
    end
end

---
-- Enables the ad-blocking system.
--
function Modules.AdBlock:Enable()
    if self.State.IsEnabled then 
        DoNotif("AdBlock is already enabled.", 2)
        return 
    end
    self.State.IsEnabled = true
    DoNotif("AdBlock enabled. Performing initial scan...", 2)

    -- 1. Perform a one-time, full scan to clear any existing ads.
    -- This is the only time we run a full GetDescendants() loop.
    task.spawn(function()
        local existingAds = self.Services.Workspace:GetDescendants()
        for i, descendant in ipairs(existingAds) do
            -- Add a small delay every 500 parts to prevent freezing on huge maps.
            if i % 500 == 0 then task.wait() end
            self:_processObject(descendant)
        end
        DoNotif("Initial ad scan complete.", 2)
    end)
    
    -- 2. Connect to the DescendantAdded event. This is the efficient, long-term listener.
    -- From now on, we only check objects as they are added to the game.
    self.State.Connection = self.Services.Workspace.DescendantAdded:Connect(function(descendant)
        self:_processObject(descendant)
    end)
end

---
-- Disables the ad-blocking system and cleans up connections.
--
function Modules.AdBlock:Disable()
    if not self.State.IsEnabled then 
        DoNotif("AdBlock is not active.", 2)
        return 
    end
    self.State.IsEnabled = false

    -- Disconnect the listener to stop processing new objects.
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("AdBlock disabled.", 2)
end

---
-- Toggles the ad-blocking state.
--
function Modules.AdBlock:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

---
-- Initializes the module, loads services, and registers the command.
--
function Modules.AdBlock:Initialize()
    local module = self
    for _, serviceName in ipairs(self.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "adblock",
        Aliases = {"removeads"},
        Description = "Toggles a system to automatically remove billboard advertisements."
    }, function()
        module:Toggle()
    end)
end

Modules.Fakeout = {
    State = {
        IsExecuting = false
    },
    Dependencies = {"Players", "Workspace"},
    Services = {}
}

---
-- Executes the fakeout sequence.
--
function Modules.Fakeout:Execute()
    if self.State.IsExecuting then
        DoNotif("A fakeout is already in progress.", 1.5)
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then
        DoNotif("Fakeout failed: Character root not found.", 2)
        return
    end

    self.State.IsExecuting = true

    -- Safely run the sequence in a new thread to prevent yielding the main script.
    task.spawn(function()
        -- 1. PREPARATION: Save state and temporarily disable conflicting modules.
        local originalCFrame = rootPart.CFrame
        local originalDestroyHeight = self.Services.Workspace.FallenPartsDestroyHeight
        local wasAntiVoidEnabled = false

        -- Decoupled interaction with the AntiVoid module.
        if Modules.AntiVoid and Modules.AntiVoid.State.IsEnabled then
            wasAntiVoidEnabled = true
            Modules.AntiVoid:Disable()
        end

        -- 2. EXECUTION: Perform the fakeout. Use pcall for guaranteed cleanup.
        local success, err = pcall(function()
            -- A large negative number is more explicit than NaN for disabling the void.
            self.Services.Workspace.FallenPartsDestroyHeight = -1e9
            
            -- Teleport just below the original void height.
            rootPart.CFrame = CFrame.new(originalCFrame.Position.X, originalDestroyHeight - 50, originalCFrame.Position.Z)
            
            task.wait(1)
            
            -- If the character still exists, teleport back.
            if rootPart and rootPart.Parent then
                rootPart.CFrame = originalCFrame
            end
        end)

        if not success then
            warn("[Fakeout] Sequence failed:", err)
        end

        -- 3. CLEANUP: Restore all original states. This block runs regardless of success.
        self.Services.Workspace.FallenPartsDestroyHeight = originalDestroyHeight
        
        -- If the AntiVoid module was active before, re-enable it.
        if wasAntiVoidEnabled and Modules.AntiVoid then
            Modules.AntiVoid:Enable()
        end

        self.State.IsExecuting = false
    end)
end

---
-- Initializes the module, loads services, and registers the command.
--
function Modules.Fakeout:Initialize()
    local module = self
    for _, serviceName in ipairs(self.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "fakeout",
        Description = "Teleports you to the void and back"
    }, function()
        module:Execute()
    end)
end

Modules.R6Enforcer = {
    State = {
        IsEnabled = false,
        -- This connection is now the sole component that hooks the respawn process.
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}

--// --- Private Methods ---

---
-- [FIXED] Client-sided function to trigger a respawn by ending the character's life.
--
function Modules.R6Enforcer:_forceRespawn()
    local character = self.Services.Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
    end
end

--// --- Public Methods ---

function Modules.R6Enforcer:Enable()
    if self.State.IsEnabled then return end
    
    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return end

    self.State.IsEnabled = true

    -- Disconnect any previous hook to ensure a clean state.
    if self.State.CharacterAddedConnection then self.State.CharacterAddedConnection:Disconnect() end
    
    -- This is the core of the exploit: when the character respawns,
    -- we intercept it and apply a blank description to force R6.
    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Connect(function(character)
        -- We only apply this logic if the module is still enabled.
        if not self.State.IsEnabled then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- [CRITICAL FIX] Applying a new, empty HumanoidDescription forces
            -- the character to load with the default R6 rig and appearance.
            local r6Description = Instance.new("HumanoidDescription")
            humanoid:ApplyDescription(r6Description)
        end
    end)
    
    DoNotif("R6 Enforcer: ENABLED. Respawning to apply...", 3)
    
    -- Trigger the respawn, which our CharacterAdded connection will catch.
    self:_forceRespawn()
end

function Modules.R6Enforcer:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- [CRITICAL FIX] Disconnect the hook. Now, when the player respawns,
    -- nothing will intercept the process, and their normal avatar will load.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end

    DoNotif("R6 Enforcer: DISABLED. Respawning to revert...", 3)

    -- Trigger a respawn to revert to the default character.
    self:_forceRespawn()
end

function Modules.R6Enforcer:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Modules.R6Enforcer:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "forcer6",
        Aliases = {"r6", "classicavatar"},
        Description = "Forces your character to load as R6 via respawn."
    }, function()
        module:Toggle()
    end)
end



Modules.AntiPlayerPhysics = {
    State = {
        IsEnabled = false,
        SteppedConnection = nil,
        OriginalProperties = setmetatable({}, {__mode = "k"}) -- Automatically cleans up when a part is destroyed
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

--- [Private] Reverts physics properties for a character to their original state.
function Modules.AntiPlayerPhysics:_revertCharacter(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and self.State.OriginalProperties[part] then
            -- Restore from our cache
            part.CanCollide = self.State.OriginalProperties[part].CanCollide
            part.Massless = self.State.OriginalProperties[part].Massless
            -- Clear the cache entry for this part
            self.State.OriginalProperties[part] = nil
        end
    end
end

--- Enables the anti-physics protection loop.
function Modules.AntiPlayerPhysics:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    self.State.SteppedConnection = self.Services.RunService.Stepped:Connect(function()
        -- This loop must run continuously to fight against the server replicating the original properties back.
        for _, player in ipairs(self.Services.Players:GetPlayers()) do
            if player ~= self.Services.Players.LocalPlayer and player.Character then
                -- pcall to prevent errors if a character part is removed during the loop
                pcall(function()
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            -- Cache the original properties ONCE.
                            if not self.State.OriginalProperties[part] then
                                self.State.OriginalProperties[part] = {
                                    CanCollide = part.CanCollide,
                                    Massless = part.Massless
                                }
                            end

                            -- Apply anti-physics properties
                            part.CanCollide = false
                            if part.Name == "Torso" then -- Still effective on R6
                                part.Massless = true
                            end
                            part.Velocity = Vector3.new()
                            part.RotVelocity = Vector3.new()
                        end
                    end
                end)
            end
        end
    end)
    DoNotif("Anti-Player Physics: ENABLED.", 2)
end

--- Disables the anti-physics protection and cleans up all changes.
function Modules.AntiPlayerPhysics:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if self.State.SteppedConnection then
        self.State.SteppedConnection:Disconnect()
        self.State.SteppedConnection = nil
    end

    -- Restore all modified characters to their original state
    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        if player.Character then
            self:_revertCharacter(player.Character)
        end
    end
    table.clear(self.State.OriginalProperties) -- Clear the cache

    DoNotif("Anti-Player Physics: DISABLED.", 2)
end

--- Toggles the state of the system.
function Modules.AntiPlayerPhysics:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module and registers its command.
function Modules.AntiPlayerPhysics:Initialize()
    local module = self
    RegisterCommand({
        Name = "antiphysics",
        Aliases = {"nocol"},
        Description = "Toggles a powerful anti-fling that makes other players non-collidable."
    }, function()
        module:Toggle()
    end)
end

Modules.AntiKill = {
    State = {
        IsEnabled = false,
        RenderConnection = nil,
        CameraConnection = nil
    },
    Services = { -- Pre-loading services is a good pattern.
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Workspace = game:GetService("Workspace")
    }
}

--- Enables the Anti-Kill protection loop.
function Modules.AntiKill:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local Player = self.Services.Players.LocalPlayer
    local Camera = self.Services.Workspace.CurrentCamera

    -- A handler to ensure the Camera variable is always current.
    local function onCameraChanged()
       Camera = self.Services.Workspace.CurrentCamera
    end
    self.State.CameraConnection = self.Services.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCameraChanged)

    -- The core protection logic, connected to RenderStepped for high-frequency execution.
    local function protectionLoop()
        local Character = Player.Character
        if not Character then return end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")

        if not (Humanoid and RootPart) then return end

        -- [DEFENSE 1] If in shift-lock, lock character rotation to camera to prevent forced turning.
        if self.Services.UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            local _, cameraY, _ = Camera.CFrame:ToEulerAnglesYXZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, cameraY, 0)
        end
        
        -- [DEFENSE 2] Forcing the Sit state gives character physics higher network priority,
        -- making it highly resistant to external forces. We then disable the 'Seated'
        -- state so the character doesn't actually perform the sit animation.
        Humanoid.Sit = true
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    end

    self.State.RenderConnection = self.Services.RunService.RenderStepped:Connect(protectionLoop)
    DoNotif("Anti-Kill System: ENABLED.", 2)
end

--- Disables the Anti-Kill protection and cleans up resources.
function Modules.AntiKill:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    -- Disconnect connections to prevent memory leaks.
    if self.State.RenderConnection then
        self.State.RenderConnection:Disconnect()
        self.State.RenderConnection = nil
    end
    if self.State.CameraConnection then
        self.State.CameraConnection:Disconnect()
        self.State.CameraConnection = nil
    end

    -- Restore the character to a normal state.
    pcall(function()
        local Humanoid = self.Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Sit = false
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end
    end)

    DoNotif("Anti-Kill System: DISABLED.", 2)
end

--- Toggles the state of the Anti-Kill system.
function Modules.AntiKill:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Initializes the module and registers its command.
function Modules.AntiKill:Initialize()
    local module = self -- Capture self for the command function.
    RegisterCommand({
        Name = "antikill",
        Aliases = {"ak", "nofling"},
        Description = "Toggles a client-sided system to resist flings and character manipulation."
    }, function()
        module:Toggle()
    end)
end

Modules.SpectateController = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Connections = {}
    },
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace")
    }
}

function Modules.SpectateController:_cleanup()
    for _, conn in pairs(self.State.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(self.State.Connections)
    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
end

function Modules.SpectateController:Disable()
    if not self.State.IsEnabled then return end
    
    local localPlayer = self.Services.Players.LocalPlayer
    self:_cleanup()
    
    if self.Services.Workspace.CurrentCamera and localPlayer.Character then
        self.Services.Workspace.CurrentCamera.CameraSubject = localPlayer.Character
    end
    
    DoNotif("Spectate disabled.", 2)
end

function Modules.SpectateController:Enable(targetPlayer: Player)
    self:Disable()
    
    if not targetPlayer or targetPlayer == self.Services.Players.LocalPlayer then
        return DoNotif("Invalid or self-targeted player.", 3)
    end
    
    if not targetPlayer.Character then
        return DoNotif("Target player does not have a character to spectate.", 3)
    end
    
    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    
    local camera = self.Services.Workspace.CurrentCamera
    camera.CameraSubject = targetPlayer.Character
    
    local function resetView()
        if self.State.IsEnabled and self.State.TargetPlayer and self.State.TargetPlayer.Character then
            if camera.CameraSubject ~= self.State.TargetPlayer.Character then
                camera.CameraSubject = self.State.TargetPlayer.Character
            end
        else
            self:Disable()
        end
    end
    
    self.State.Connections.TargetRespawn = targetPlayer.CharacterAdded:Connect(function(newCharacter)
        task.wait()
        resetView()
    end)
    
    self.State.Connections.CameraGuard = camera:GetPropertyChangedSignal("CameraSubject"):Connect(resetView)
    self.State.Connections.LocalPlayerRespawn = self.Services.Players.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.1)
        resetView()
    end)
    
    DoNotif("Now spectating " .. targetPlayer.Name, 2)
end

function Modules.SpectateController:Initialize()
    RegisterCommand({
        Name = "view",
        Aliases = {"spectate"},
        Description = "Spectates a specified player."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;view <PlayerName>", 3)
        end
        local target = Utilities.findPlayer(args[1])
        if target then
            self:Enable(target)
        else
            DoNotif("Player '" .. args[1] .. "' not found.", 3)
        end
    end)

    RegisterCommand({
        Name = "unview",
        Aliases = {"unspectate"},
        Description = "Stops spectating and returns to your character."
    }, function()
        self:Disable()
    end)
end

Modules.AstralHead = {
State = {
IsEnabled = false,
OriginalProperties = {},
Connections = {}
}
}
function Modules.AstralHead:_getCharacterHeadParts(character)
    local parts = {}
    if not character then return parts end
        local head = character:FindFirstChild("Head")
        if head then table.insert(parts, head) end
            for _, accessory in ipairs(character:GetChildren()) do
                if accessory:IsA("Accessory") then
                    local handle = accessory:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        table.insert(parts, handle)
                    end
                end
            end
            return parts
        end
        function Modules.AstralHead:_enableForCharacter(character)
            local self = Modules.AstralHead
            if not character then return end
                local partsToModify = self:_getCharacterHeadParts(character)
                for _, part in ipairs(partsToModify) do
                    if not self.State.OriginalProperties[part] then
                        self.State.OriginalProperties[part] = {
                        Transparency = part.Transparency,
                        CanQuery = part.CanQuery,
                        CanTouch = part.CanTouch
                        }
                    end
                    part.Transparency = 1
                    part.CanQuery = false
                    part.CanTouch = false
                end
            end
            function Modules.AstralHead:_disableForCharacter(character)
                local self = Modules.AstralHead
                for part, properties in pairs(self.State.OriginalProperties) do
                    pcall(function()
                    if part and part.Parent then
                        part.Transparency = properties.Transparency
                        part.CanQuery = properties.CanQuery
                        part.CanTouch = properties.CanTouch
                    end
                end)
            end
            table.clear(self.State.OriginalProperties)
        end
        function Modules.AstralHead:Toggle()
            local self = Modules.AstralHead
            self.State.IsEnabled = not self.State.IsEnabled
            if self.State.IsEnabled then
                DoNotif("Astral Head Enabled. Head is now untargetable.", 2)
                if LocalPlayer.Character then
                    self:_enableForCharacter(LocalPlayer.Character)
                end
            else
            DoNotif("Astral Head Disabled. Head restored.", 2)
            if LocalPlayer.Character then
                self:_disableForCharacter(LocalPlayer.Character)
            else
            table.clear(self.State.OriginalProperties)
        end
    end
end
function Modules.AstralHead:Initialize()
    local module = self
    module.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if module.State.IsEnabled then
        module:_enableForCharacter(character)
    end
end)
module.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
if module.State.IsEnabled then
    module:_disableForCharacter(character)
end
end)
RegisterCommand({
Name = "astralhead",
Aliases = {"hidehead", "nohead"},
Description = "Toggles head invisibility to counter aimbots."
}, function()
module:Toggle()
end)
end
Modules.LocalAntiTeamChange = {
State = {
IsEnabled = false,
OriginalTeam = nil,
PropertyConnection = nil
},
Dependencies = {"Players"}
}
function Modules.LocalAntiTeamChange:Enable()
    if self.State.IsEnabled then return end
        local localPlayer = self.Services.Players.LocalPlayer
        if not localPlayer then
            warn("[LocalAntiTeamChange] Could not find LocalPlayer to monitor.")
            return
        end
        self.State.IsEnabled = true
        self.State.OriginalTeam = localPlayer.Team
        if self.State.PropertyConnection then self.State.PropertyConnection:Disconnect() end
            self.State.PropertyConnection = localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
            if self.State.IsEnabled and localPlayer.Team ~= self.State.OriginalTeam then
                pcall(function()
                localPlayer.Team = self.State.OriginalTeam
                DoNotif("Reverted personal team change.", 2)
            end)
        end
    end)
    DoNotif("Personal Team Lock: [Enabled]", 3)
end
function Modules.LocalAntiTeamChange:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        if self.State.PropertyConnection then
            self.State.PropertyConnection:Disconnect()
            self.State.PropertyConnection = nil
        end
        self.State.OriginalTeam = nil
        DoNotif("Personal Team Lock: [Disabled]", 3)
    end
    function Modules.LocalAntiTeamChange:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.LocalAntiTeamChange:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "lockteam",
    Aliases = {"localantiteamchange", "latc"},
    Description = "Toggles a lock that prevents YOUR team from being changed."
    }, function(args)
    module:Toggle()
end)
end
Modules.HumanoidIntegrity = {
State = {
IsEnabled = false,
Connections = {}
},
Dependencies = {"Players"}
}
function Modules.HumanoidIntegrity:_protectCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
        self:_cleanupCharacter(character)
        local charConnections = { Character = character }
        charConnections.StateChanged = humanoid.StateChanged:Connect(function(old, new)
        if not self.State.IsEnabled then return end
            if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.FallingDown then
                pcall(humanoid.ChangeState, humanoid, Enum.HumanoidStateType.GettingUp)
            end
        end)
        charConnections.JointRemoved = character.DescendantRemoving:Connect(function(descendant)
        if not self.State.IsEnabled then return end
            if descendant:IsA("Motor6D") then
                task.defer(humanoid.BuildRigFromAttachments, humanoid)
            end
        end)
        charConnections.PlatformStand = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not self.State.IsEnabled then return end
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end)
        self.State.Connections[character] = charConnections
    end
    function Modules.HumanoidIntegrity:_cleanupCharacter(character)
        if self.State.Connections[character] then
            for _, conn in pairs(self.State.Connections[character]) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
            self.State.Connections[character] = nil
        end
    end
    function Modules.HumanoidIntegrity:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            if localPlayer.Character then
                self:_protectCharacter(localPlayer.Character)
            end
            self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char)
            self:_protectCharacter(char)
        end)
        self.State.Connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(char)
        self:_cleanupCharacter(char)
    end)
    DoNotif("Humanoid Integrity System: [Enabled]", 3)
end
function Modules.HumanoidIntegrity:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for key, conn in pairs(self.State.Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif type(conn) == "table" then
                self:_cleanupCharacter(key)
            end
        end
        table.clear(self.State.Connections)
        DoNotif("Humanoid Integrity System: [Disabled]", 3)
    end
    function Modules.HumanoidIntegrity:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.HumanoidIntegrity:Initialize()
    local module = self
    module.Services = { Players = game:GetService("Players") }
    RegisterCommand({
    Name = "antiragdoll",
    Aliases = {"noragdoll", "integrity"},
    Description = "Toggles a system to aggressively counter character ragdolling and joint breaking."
    }, function()
    module:Toggle()
end)
end




Modules.TeleporterScanner = {
	State = {
		UI = nil, -- Will hold the ScreenGui instance
		IsScanning = false,
		Highlights = {} -- Module-specific highlight table
	}
}

function Modules.TeleporterScanner:ToggleGUI()
	local self = Modules.TeleporterScanner

	if self.State.UI and self.State.UI.Parent then
		for _, highlight in pairs(self.State.Highlights) do
			if highlight and highlight.Parent then highlight:Destroy() end
		end
		table.clear(self.State.Highlights)
		
		self.State.UI:Destroy()
		self.State.UI = nil
		DoNotif("Teleporter Scanner closed.", 2)
		return
	end

	DoNotif("Forensic Teleporter Scanner opened.", 2)
	
	local Workspace = game:GetService("Workspace")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")

	-- FIXED: Refined keywords for much higher accuracy
	local SCRIPT_KEYWORDS = { "TeleportService", ":Teleport(", ":TeleportToPlaceInstance(", "fireproximityprompt" }
	local NAME_KEYWORDS = { "teleport", "portal", "warp" }
	local DATA_PAYLOAD_NAMES = { "placeid", "gameid", "targetplace" }

	local CONFIDENCE_THRESHOLDS = { SCRIPT = 1.0, DATA_PAYLOAD = 0.8, NAME = 0.5 }

	local screenGui = Instance.new("ScreenGui")
	self.State.UI = screenGui
	screenGui.Name = "TeleporterScannerGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local mainFrame = Instance.new("Frame"); mainFrame.Name = "MainFrame"; mainFrame.Size = UDim2.new(0, 350, 0, 450); mainFrame.Position = UDim2.new(0, 10, 0.5, -225); mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 125); mainFrame.ClipsDescendants = true; mainFrame.Parent = screenGui
	local titleLabel = Instance.new("TextLabel"); titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 0, 30); titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55); titleLabel.Text = "Forensic Teleporter Scanner"; titleLabel.Font = Enum.Font.SourceSansBold; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.Parent = mainFrame
	local scanButton = Instance.new("TextButton"); scanButton.Name = "ScanButton"; scanButton.Size = UDim2.new(1, -10, 0, 30); scanButton.Position = UDim2.new(0.5, 0, 0, 35); scanButton.AnchorPoint = Vector2.new(0.5, 0); scanButton.BackgroundColor3 = Color3.fromRGB(80, 60, 200); scanButton.Font = Enum.Font.SourceSansBold; scanButton.TextColor3 = Color3.fromRGB(255, 255, 255); scanButton.Text = "Begin Workspace Scan"; scanButton.Parent = mainFrame
	local clearButton = Instance.new("TextButton"); clearButton.Name = "ClearButton"; clearButton.Size = UDim2.new(1, -10, 0, 20); clearButton.Position = UDim2.new(0.5, 0, 0, 70); clearButton.AnchorPoint = Vector2.new(0.5, 0); clearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60); clearButton.Font = Enum.Font.SourceSans; clearButton.TextColor3 = Color3.fromRGB(255, 255, 255); clearButton.Text = "Clear Highlights & Results"; clearButton.Parent = mainFrame
	local resultsFrame = Instance.new("ScrollingFrame"); resultsFrame.Name = "ResultsFrame"; resultsFrame.Size = UDim2.new(1, -10, 1, -95); resultsFrame.Position = UDim2.new(0, 5, 0, 90); resultsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); resultsFrame.Parent = mainFrame
	local listLayout = Instance.new("UIListLayout"); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 3); listLayout.Parent = resultsFrame

	local function highlightPart(part, confidence)
		if self.State.Highlights[part] then return end
		local highlight = Instance.new("Highlight")
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; highlight.FillColor = Color3.fromHSV(0.0, 0.8, 1); highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.FillTransparency = 0.5; highlight.Parent = part
		self.State.Highlights[part] = highlight
	end

	local function addResultToList(part, confidence, reason)
		local resultButton = Instance.new("TextButton")
		resultButton.Name = part.Name; resultButton.Text = `[{string.format("%.0f", confidence * 100)}%] {part:GetFullName()} ({reason})`; resultButton.Size = UDim2.new(1, 0, 0, 25); resultButton.BackgroundColor3 = Color3.fromHSV(0, 0.5, 0.5 + (confidence * 0.2)); resultButton.Font = Enum.Font.SourceSans; resultButton.TextXAlignment = Enum.TextXAlignment.Left; resultButton.TextColor3 = Color3.fromRGB(225, 225, 225); resultButton.LayoutOrder = -confidence; resultButton.Parent = resultsFrame
		resultButton.MouseButton1Click:Connect(function()
			local camera = Workspace.CurrentCamera; camera.CameraType = Enum.CameraType.Scriptable
			local targetCFrame = CFrame.new(part.Position + part.CFrame.LookVector * 10, part.Position)
			local tween = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = targetCFrame})
			tween:Play(); tween.Completed:Wait(); camera.CameraType = Enum.CameraType.Custom
		end)
	end

	local function clearResults()
		for _, highlight in pairs(self.State.Highlights) do
			if highlight and highlight.Parent then highlight:Destroy() end
		end
		table.clear(self.State.Highlights)
		for _, child in ipairs(resultsFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		scanButton.Text = "Begin Workspace Scan"; scanButton.Active = true
	end

	-- FIXED: Entirely new scanning logic for precision.
	local function scanWorkspace()
		self.State.IsScanning = true
		scanButton.Text = "Scanning... (This may take a moment)"; scanButton.Active = false
		local findings = {}

		task.spawn(function()
			for i, descendant in ipairs(Workspace:GetDescendants()) do
				if i % 500 == 0 then task.wait() end
				
				local part, confidence, reason = nil, 0, ""

				-- High-confidence check: Script source analysis
				if descendant:IsA("LuaSourceContainer") then
					local success, source = pcall(function() return descendant.Source end)
					if success and source then
						local lowerSource = source:lower()
						for _, keyword in ipairs(SCRIPT_KEYWORDS) do
							if lowerSource:find(keyword:lower(), 1, true) then
								part = descendant:FindFirstAncestorOfClass("Model") or descendant.Parent
								if part and part:IsA("BasePart") or part:IsA("Model") then
									confidence = CONFIDENCE_THRESHOLDS.SCRIPT
									reason = "Script Analysis"
									break
								end
							end
						end
					end
				end

				-- Medium/Low-confidence checks on BaseParts
				if descendant:IsA("BasePart") and not part then
					local currentConfidence, currentReason = 0, ""
					-- Check for data payloads
					for _, child in ipairs(descendant:GetChildren()) do
						if child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue") then
							for _, name in ipairs(DATA_PAYLOAD_NAMES) do
								if child.Name:lower() == name then
									currentConfidence = math.max(currentConfidence, CONFIDENCE_THRESHOLDS.DATA_PAYLOAD)
									currentReason = "Data Payload"
									break
								end
							end
						end
					end
					-- Check part name
					for _, keyword in ipairs(NAME_KEYWORDS) do
						if descendant.Name:lower():find(keyword, 1, true) then
							currentConfidence = math.max(currentConfidence, CONFIDENCE_THRESHOLDS.NAME)
							if currentReason == "" then currentReason = "Suspicious Name" end
							break
						end
					end
					if currentConfidence > 0 then
						part, confidence, reason = descendant, currentConfidence, currentReason
					end
				end

				if part and (not findings[part] or confidence > findings[part].confidence) then
					findings[part] = { confidence = confidence, reason = reason }
				end
			end
			
			-- Process all findings after the scan is complete
			local partsFound = 0
			for part, data in pairs(findings) do
				partsFound += 1
				highlightPart(part, data.confidence)
				addResultToList(part, data.confidence, data.reason)
			end

			scanButton.Text = `Scan Complete! Found {partsFound} potentials.`
			DoNotif(`Scan finished. Found {partsFound} points of interest.`, 3)
			self.State.IsScanning = false
		end)
	end

	scanButton.MouseButton1Click:Connect(function()
		if self.State.IsScanning then return end
		clearResults()
		scanWorkspace() -- No longer needs to be spawned in a new thread here
	end)
	clearButton.MouseButton1Click:Connect(clearResults)

	local isDragging, dragStart, startPosition = false, nil, nil
	titleLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true; dragStart = input.Position; startPosition = mainFrame.Position; end end)
	titleLabel.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end)

	screenGui.Parent = CoreGui
end

RegisterCommand({
	Name = "tpscan",
	Aliases = {"teleporterscan", "findtp"},
	Description = "Toggles a GUI that scans the workspace for potential teleporters."
}, function(args)
	Modules.TeleporterScanner:ToggleGUI()
end)

Modules.ToolPersistence = {
State = {
IsEnabled = false,
ToolCache = nil,
Connections = {}
},
Dependencies = {"Players", "CoreGui"}
}
function Modules.ToolPersistence:_initializeCache()
    if self.State.ToolCache and self.State.ToolCache.Parent then
        self.State.ToolCache:Destroy()
    end
    self.State.ToolCache = Instance.new("Folder")
    self.State.ToolCache.Name = "ToolCache_" .. math.random(1000, 9999)
    self.State.ToolCache.Parent = self.Services.CoreGui
end
function Modules.ToolPersistence:_cacheTool(tool)
    if not tool:IsA("Tool") then return end
        if self.State.ToolCache:FindFirstChild(tool.Name) then return end
            local success, result = pcall(function()
            local toolClone = tool:Clone()
            toolClone.Parent = self.State.ToolCache
        end)
        if not success then
            warn("[ToolPersistence] Failed to cache tool '" .. tool.Name .. "': " .. tostring(result))
        end
    end
    function Modules.ToolPersistence:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
            if not backpack then
                self.State.IsEnabled = false
                return warn("[ToolPersistence] Cannot enable: Backpack not found.")
            end
            self:_initializeCache()
            for _, tool in ipairs(backpack:GetChildren()) do
                self:_cacheTool(tool)
            end
            self.State.Connections.ChildAdded = backpack.ChildAdded:Connect(function(child)
            self:_cacheTool(child)
        end)
        self.State.Connections.ChildRemoved = backpack.ChildRemoved:Connect(function(child)
        if self.State.IsEnabled and child:IsA("Tool") then
            local cachedTool = self.State.ToolCache:FindFirstChild(child.Name)
            if cachedTool then
                task.defer(function()
                if backpack and backpack.Parent then
                    cachedTool:Clone().Parent = backpack
                end
            end)
        end
    end
end)
DoNotif("Tool Persistence: [Enabled]", 3)
end
function Modules.ToolPersistence:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for _, conn in pairs(self.State.Connections) do
            conn:Disconnect()
        end
        table.clear(self.State.Connections)
        if self.State.ToolCache then
            self.State.ToolCache:Destroy()
            self.State.ToolCache = nil
        end
        DoNotif("Tool Persistence: [Disabled]", 3)
    end
    function Modules.ToolPersistence:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.ToolPersistence:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "antitoolremove",
    Aliases = {"locktools", "atr"},
    Description = "Toggles a system that prevents your tools from being removed from your backpack."
    }, function(args)
    module:Toggle()
end)
end
Modules.GrabTools = {
State = {
IsEnabled = false,
Connection = nil
}
}
function Modules.GrabTools:_onHeartbeat()
    local localPlayerBackpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
    if not localPlayerBackpack then return end
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:IsA("Tool") and child:FindFirstChild("Handle") and not child.Handle.Anchored then
                child.Parent = localPlayerBackpack
                DoNotif("Grabbed Tool: " .. child.Name, 1.5)
            end
        end
    end
    function Modules.GrabTools:Toggle()
        local self = Modules.GrabTools
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            if self.State.Connection then self.State.Connection:Disconnect() end
                self.State.Connection = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
                DoNotif("Tool Grabber Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Tool Grabber Disabled", 2)
        end
    end
    function Modules.GrabTools:Initialize()
        local module = self
        RegisterCommand({
        Name = "grabtools",
        Aliases = {"gt", "toolgrab"},
        Description = "Toggles an auto-grabber for all dropped tools in the workspace."
        }, function(args)
        module:Toggle()
    end)
end
Modules.AdminSpoofDemonstration = {
    State = {
        IsSpoofing = false,
        SpoofedId = -1,
        OriginalIndex = nil,
        PlayerMetatable = nil
    },
    Dependencies = {"Players"} -- Declares required services for the Initialize function.
}


function Modules.AdminSpoofDemonstration:Enable(targetId)
    if self.State.IsSpoofing then
        DoNotif("Already spoofing UserId. Reset first.", 3)
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return end

    -- Using pcall for robustness as getrawmetatable is a debug function and can fail.
    local success, playerMetatable = pcall(getrawmetatable, localPlayer)
    if not success or typeof(playerMetatable) ~= "table" then
        DoNotif("Error: Could not get the player's metatable. Environment may not support this.", 4)
        return
    end

    -- Store the original metatable and __index for restoration upon disabling.
    self.State.PlayerMetatable = playerMetatable
    self.State.OriginalIndex = playerMetatable.__index
    local originalIndexCache = self.State.OriginalIndex -- Cache as an upvalue for the hook's closure.

    self.State.SpoofedId = tonumber(targetId) or -1
    self.State.IsSpoofing = true

    -- Hook the __index metamethod. This is the core of the exploit.
    playerMetatable.__index = function(self, key)
        -- If a script tries to get the "UserId" property, we intercept and return our fake ID.
        if key == "UserId" then
            return Modules.AdminSpoofDemonstration.State.SpoofedId
        end

        -- CRITICAL FIX: The original __index is a table. We must index it to get the real property.
        -- The previous code's attempt to call it (`OriginalIndex(self, key)`) caused the error.
        -- This correctly forwards the property lookup to the original table.
        if typeof(originalIndexCache) == "table" then
            return originalIndexCache[key]
        elseif typeof(originalIndexCache) == "function" then
            -- A defensive fallback in case __index is ever a function.
            return originalIndexCache(self, key)
        end
    end

    DoNotif("Local UserId spoof enabled. Now appearing as: " .. self.State.SpoofedId, 3)
end

--- Disables the UserId spoof and restores the original engine behavior.
function Modules.AdminSpoofDemonstration:Disable()
    if not self.State.IsSpoofing then return end

    -- Restore the original __index from our backup. This is crucial for cleanup.
    if self.State.PlayerMetatable and self.State.OriginalIndex then
        self.State.PlayerMetatable.__index = self.State.OriginalIndex
    end

    -- Reset all state variables to default values to prevent memory leaks and ensure a clean state.
    self.State.IsSpoofing = false
    self.State.SpoofedId = -1
    self.State.OriginalIndex = nil
    self.State.PlayerMetatable = nil
    DoNotif("Local UserId spoof disabled. Identity restored.", 3)
end

--- Initializes the module, loads services, and registers its command.
function Modules.AdminSpoofDemonstration:Initialize()
    local module = self

    -- Adhering to the framework's pattern of loading dependencies into a local Services table.
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "spoofid",
        Aliases = {"setid", "fakeid"},
        Description = "Locally spoofs your UserId for vulnerable scripts."
    }, function(args)
        local argument = args[1]
        if not argument then
            return DoNotif("Usage: ;spoofid username", 4)
        end

        if argument:lower() == "reset" or argument:lower() == "clear" then
            module:Disable()
        else
            local targetId = tonumber(argument)
            if targetId and targetId > 0 then
                module:Enable(targetId)
            else
                DoNotif("Invalid UserId. It must be a positive number.", 3)
            end
        end
    end)
end

Modules.OrbitController = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Rotation = 0,
        Connections = {}
    },
    Config = {
        DefaultSpeed = 0.2,
        DefaultDistance = 6
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

function Modules.OrbitController:Disable(shouldNotify: boolean)
    if not self.State.IsEnabled then return end

    for _, conn in pairs(self.State.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(self.State.Connections)

    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end

    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
    
    if shouldNotify then
        DoNotif("Orbit stopped.", 2)
    end
end

function Modules.OrbitController:Enable(targetPlayer: Player, speed: number?, distance: number?)
    self:Disable(false)

    local localPlayer = self.Services.Players.LocalPlayer
    local myChar = localPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = targetPlayer and targetPlayer.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not (myRoot and myHumanoid and targetRoot) then
        return DoNotif("Orbit failed: A character part could not be found.", 3)
    end

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    self.State.Rotation = 0
    myHumanoid.AutoRotate = false

    local orbitSpeed = tonumber(speed) or self.Config.DefaultSpeed
    local orbitDistance = tonumber(distance) or self.Config.DefaultDistance

    self.State.Connections.Heartbeat = self.Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            if not (self.State.IsEnabled and self.State.TargetPlayer and self.State.TargetPlayer.Character) then
                return self:Disable(true)
            end
            local currentTargetRoot = self.State.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not currentTargetRoot then return self:Disable(true) end

            self.State.Rotation = self.State.Rotation + orbitSpeed
            myRoot.CFrame = CFrame.new(currentTargetRoot.Position) * CFrame.Angles(0, self.State.Rotation, 0) * CFrame.new(orbitDistance, 0, 0)
        end)
    end)

    self.State.Connections.RenderStepped = self.Services.RunService.RenderStepped:Connect(function()
        pcall(function()
            if not (self.State.IsEnabled and self.State.TargetPlayer and self.State.TargetPlayer.Character) then
                return self:Disable(true)
            end
            local currentTargetRoot = self.State.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not currentTargetRoot then return self:Disable(true) end

            myRoot.CFrame = CFrame.new(myRoot.Position, currentTargetRoot.Position)
        end)
    end)

    self.State.Connections.Died = myHumanoid.Died:Connect(function() self:Disable(true) end)
    self.State.Connections.Seated = myHumanoid.Seated:Connect(function(isSeated)
        if isSeated then self:Disable(true) end
    end)

    DoNotif("Orbiting " .. targetPlayer.Name, 2)
end

function Modules.OrbitController:Initialize()
    RegisterCommand({
        Name = "orbit",
        Aliases = {},
        Description = "Orbits your character around a target player."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;orbit <PlayerName> [speed] [distance]", 3)
        end
        local target = Utilities.findPlayer(args[1])
        if target then
            self:Enable(target, args[2], args[3])
        else
            DoNotif("Player '" .. args[1] .. "' not found.", 3)
        end
    end)

    RegisterCommand({
        Name = "unorbit",
        Aliases = {},
        Description = "Stops orbiting the current target."
    }, function(args)
        local shouldNotify = not (args[1] and args[1]:lower() == "nonotify")
        self:Disable(shouldNotify)
    end)
end

Modules.MADGuardian = {
    State = {
        IsEnabled = false,
        HeartbeatConnection = nil,
        LastRetaliation = 0
    },
    Config = {
        -- The upward force of our retaliatory fling. Higher is more aggressive.
        COUNTER_FLING_FORCE = 300,
        -- How long the counter-fling effect lasts on the attacker, in seconds.
        COUNTER_FLING_DURATION = 2.5,
        -- How often to scan for hostile physics objects, in seconds.
        SCAN_INTERVAL_SECONDS = 0.1,
        -- A cooldown period after retaliating to prevent spamming the counter-attack.
        RETALIATION_COOLDOWN_SECONDS = 3,
        -- An attribute to mark our own physics objects so the script doesn't destroy them.
        COUNTER_ATTACK_TAG = "MAD_Counter"
    }
}

--- [Internal] Finds the player character closest to the local player.
-- @returns Player? The closest player object, or nil if none are found.
function Modules.MADGuardian:_findClosestPlayer()
    local closestPlayer, minDistance = nil, math.huge
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                if distance < minDistance then
                    minDistance, closestPlayer = distance, player
                end
            end
        end
    end
    return closestPlayer
end

--- [Internal] Initiates a retaliatory fling against a specified target.
-- @param targetCharacter Model The character model of the player to be flung.
function Modules.MADGuardian:_initiateCounterFling(targetCharacter)
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    DoNotif("MAD Guardian: Retaliating against '"..targetCharacter.Name.."'", 1.5)

    local counterVelocity = Instance.new("BodyVelocity")
    counterVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    counterVelocity.Velocity = Vector3.new(0, self.Config.COUNTER_FLING_FORCE, 0)
    counterVelocity.Parent = targetRoot
    counterVelocity:SetAttribute(self.Config.COUNTER_ATTACK_TAG, true)

    -- Schedule the self-destruction of our counter-attack object.
    task.delay(self.Config.COUNTER_FLING_DURATION, function()
        if counterVelocity and counterVelocity.Parent then
            counterVelocity:Destroy()
        end
    end)
end

--- [Internal] The main detection loop connected to RunService.Heartbeat.
function Modules.MADGuardian:_onHeartbeat()
    local character = LocalPlayer.Character
    if not character then return end

    -- Scan for hostile physics movers descendant to the character.
    for _, descendant in ipairs(character:GetDescendants()) do
        -- BodyMover is the base class for BodyVelocity, BodyPosition, etc.
        -- We ignore any movers that have our specific tag.
        if descendant:IsA("BodyMover") and not descendant:GetAttribute(self.Config.COUNTER_ATTACK_TAG) then
            DoNotif("MAD Guardian: Hostile BodyMover '"..descendant.ClassName.."' detected. Nullifying.", 1)
            
            -- Stage 1: Defend by destroying the object.
            descendant:Destroy()

            -- Stage 2: Check if we are off cooldown for retaliation.
            local now = os.clock()
            if now - self.State.LastRetaliation > self.Config.RETALIATION_COOLDOWN_SECONDS then
                self.State.LastRetaliation = now
                
                -- Stage 3: Find a target and retaliate.
                local attacker = self:_findClosestPlayer()
                if attacker then
                    self:_initiateCounterFling(attacker.Character)
                end
            end
            
            -- We only handle one object per frame to be safe.
            break
        end
    end
end

--- Enables the MAD Guardian.
function Modules.MADGuardian:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
    
    DoNotif("MAD Guardian: ENABLED. Fling retaliation is active.", 2)
end

--- Disables the MAD Guardian.
function Modules.MADGuardian:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.HeartbeatConnection then
        self.State.HeartbeatConnection:Disconnect()
        self.State.HeartbeatConnection = nil
    end
    
    DoNotif("MAD Guardian: DISABLED.", 2)
end

--- Toggles the MAD Guardian's state.
function Modules.MADGuardian:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Registers the command with your admin system.
function Modules.MADGuardian:Initialize()
    local module = self
    RegisterCommand({
        Name = "mad",
        Aliases = {"flingback", "antiflingretaliate"},
        Description = "Toggles a counter-fling system that retaliates against attackers."
    }, function()
        module:Toggle()
    end)
end

local function readTable(tbl: table): string
    local function serialize(value: any, indent: number, visited: {[table]: boolean}): string
        local valueType: string = typeof(value)

        if valueType == "string" then
            return string.format("%q", value)
        elseif valueType == "number" or valueType == "boolean" or valueType == "nil" then
            return tostring(value)
        elseif valueType == "function" or valueType == "thread" or valueType == "userdata" then
            return string.format("\"<%s>\"", valueType)
        elseif valueType == "Instance" then
            return string.format("\"%s (%s)\"", value, value.ClassName)
        elseif valueType == "table" then
            if visited[value] then
                return "\"*Circular Reference*\""
            end

            visited[value] = true
            local str: string = "{\n"
            local indentation: string = string.rep("    ", indent + 1)
            local isNumeric: boolean = true
            local count: number = 0

            for i: number = 1, #value do
                str ..= indentation .. serialize(value[i], indent + 1, visited) .. ",\n"
                count += 1
            end

            for k: any, v: any in pairs(value) do
                if type(k) ~= "number" or k < 1 or k > #value or k % 1 ~= 0 then
                    isNumeric = false
                    break
                end
            end

            if not isNumeric then
                for k: any, v: any in pairs(value) do
                     local keyStr: string
                     if typeof(k) == "string" then
                         keyStr = string.format("[\"%s\"]", k)
                     else
                         keyStr = string.format("[%s]", tostring(k))
                     end
                     str ..= indentation .. keyStr .. " = " .. serialize(v, indent + 1, visited) .. ",\n"
                 end
            end

            str ..= string.rep("    ", indent) .. "}"
            visited[value] = false
            return str
        else
            return tostring(value)
        end
    end

    return serialize(tbl, 0, {})
end

Modules.RemoteInterceptor = {
    State = {
        IsEnabled = false,
        InterceptedRemotes = {}
    },
    Dependencies = {"CoreGui"},
    Services = {}
}

function Modules.RemoteInterceptor:_getInstanceFromPath(path: string): Instance?
    local current = game
    for component in string.gmatch(path, "[^%.]+") do
        if not current then return nil end
        if string.find(component, ":GetService") then
            local serviceName = component:match("'(.-)'") or component:match('"(.-)"')
            current = serviceName and current:GetService(serviceName) or nil
        else
            current = current:FindFirstChild(component)
        end
    end
    return current
end

function Modules.RemoteInterceptor:_logCall(remote: Instance, ...: any)
    local args = {...}
    local log = {"--> [Interceptor] Call detected on: " .. remote:GetFullName()}
    
    for i, arg in ipairs(args) do
        local argType = typeof(arg)
        local serializedValue
        if argType == "table" then
            serializedValue = readTable(arg)
        else
            serializedValue = tostring(arg)
        end
        table.insert(log, string.format("    - Arg #%d [%s]: %s", i, argType, serializedValue))
    end
    
    print(table.concat(log, "\n"))
end

function Modules.RemoteInterceptor:Intercept(remotePath: string)
    if self.State.InterceptedRemotes[remotePath] then
        return DoNotif("This remote is already being intercepted.", 3)
    end

    local originalRemote = self:_getInstanceFromPath(remotePath)
    if not (originalRemote and (originalRemote:IsA("RemoteEvent") or originalRemote:IsA("RemoteFunction"))) then
        return DoNotif("Remote not found or invalid type at path: " .. remotePath, 4)
    end

    local originalParent = originalRemote.Parent
    local originalName = originalRemote.Name

    local proxy = {}
    local metatable = {
        __index = function(_, key)
            if key == "FireServer" and originalRemote:IsA("RemoteEvent") then
                return function(_, ...)
                    self:_logCall(originalRemote, ...)
                    return originalRemote:FireServer(...)
                end
            elseif key == "InvokeServer" and originalRemote:IsA("RemoteFunction") then
                return function(_, ...)
                    self:_logCall(originalRemote, ...)
                    return originalRemote:InvokeServer(...)
                end
            end
            return originalRemote[key]
        end,
        __newindex = function(_, key, value)
            originalRemote[key] = value
        end
    }
    setmetatable(proxy, metatable)
    
    local proxyInstance = Instance.new("RemoteEvent")
    proxyInstance.Name = originalName
    
    local success, err = pcall(function()
        for i = 1, 20 do
            if originalParent:FindFirstChild(originalName) == originalRemote then
                break
            end
            task.wait()
        end
        originalRemote.Parent = self.Services.CoreGui
        proxyInstance.Parent = originalParent
    end)

    if not success then
        DoNotif("Failed to swap remote. It may be protected.", 4)
        if originalRemote.Parent ~= originalParent then
            originalRemote.Parent = originalParent
        end
        return
    end

    self.State.InterceptedRemotes[remotePath] = {
        Original = originalRemote,
        Proxy = proxy,
        ProxyInstance = proxyInstance,
        Parent = originalParent,
        Name = originalName
    }

    proxyInstance.OnServerEvent:Connect(function(_, ...)
        if originalRemote:IsA("RemoteEvent") then
            self:_logCall(originalRemote, ...)
            originalRemote:FireServer(...)
        end
    end)
    
    DoNotif("Successfully intercepted: " .. originalName, 3)
end


function Modules.RemoteInterceptor:Restore(remotePath: string)
    local data = self.State.InterceptedRemotes[remotePath]
    if not data then
        return DoNotif("Remote is not currently intercepted.", 3)
    end

    if data.ProxyInstance and data.ProxyInstance.Parent then
        data.ProxyInstance:Destroy()
    end
    
    data.Original.Parent = data.Parent
    self.State.InterceptedRemotes[remotePath] = nil
    DoNotif("Restored original remote: " .. data.Name, 2)
end

function Modules.RemoteInterceptor:Initialize()
    for _, serviceName in ipairs(self.Dependencies) do
        self.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "intercept",
        Aliases = {"spy"},
        Description = "Intercepts a remote to spy on its arguments."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;intercept <path.to.remote>", 3)
        end
        self:Intercept(args[1])
    end)

    RegisterCommand({
        Name = "unintercept",
        Aliases = {"unspy"},
        Description = "Restores an intercepted remote."
    }, function(args)
        if not args[1] then
            return DoNotif("Usage: ;unintercept <path.to.remote>", 3)
        end
        self:Restore(args[1])
    end)

    RegisterCommand({
        Name = "intercepted",
        Description = "Lists all currently intercepted remotes."
    }, function()
        local count = 0
        print("--- [Active Interceptors] ---")
        for path, _ in pairs(self.State.InterceptedRemotes) do
            print("- " .. path)
            count = count + 1
        end
        DoNotif("Listed " .. count .. " intercepted remote(s) in the F9 console.", 2)
    end)
end

Modules.ClientCanary = {
    State = {
        IsEnabled = false,
        HeartbeatConnection = nil,
        ViolationData = {}, -- [Player] = { Level = number, LastCheck = number }
        HighlightedPlayers = {} -- [Player] = true
    },
    Config = {
        -- The horizontal speed (in studs/sec) above which behavior is considered suspicious.
        -- Normal walk speed is 16. This provides a generous buffer for normal game physics.
        MAX_REASONABLE_SPEED = 75,
        -- The number of violation "points" a player needs to accumulate before being flagged.
        VIOLATION_THRESHOLD = 8,
        -- How quickly (in seconds) a single violation point decays. This prevents false
        -- positives from single instances of high velocity (e.g., explosions).
        VIOLATION_DECAY_TIME = 2.5,
        -- How often (in seconds) the system checks players.
        CHECK_INTERVAL_SECONDS = 0.25
    }
}

--- [Internal] The main detection loop connected to RunService.Heartbeat.
function Modules.ClientCanary:_onHeartbeat(deltaTime)
    local now = os.clock()
    -- Iterate through all players and decay their violation levels over time.
    for player, data in pairs(self.State.ViolationData) do
        if now - data.LastCheck > self.Config.VIOLATION_DECAY_TIME then
            data.Level = math.max(0, data.Level - 1)
            data.LastCheck = now
        end
        if not player.Parent then -- Garbage collect data for players who left
            self.State.ViolationData[player] = nil
        end
    end

    -- Iterate through all players to check for new violations.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and self.State.HighlightedPlayers[player] == nil then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and rootPart and humanoid.Health > 0 then
                -- We check horizontal velocity to ignore high speeds from falling.
                local horizontalVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z)
                
                if horizontalVelocity.Magnitude > self.Config.MAX_REASONABLE_SPEED then
                    local data = self.State.ViolationData[player] or { Level = 0, LastCheck = now }
                    data.Level = data.Level + 1
                    data.LastCheck = now
                    self.State.ViolationData[player] = data
                    
                    -- If violation level exceeds the threshold, flag the player.
                    if data.Level >= self.Config.VIOLATION_THRESHOLD then
                        DoNotif(string.format("Exploiter Detected: %s (Reason: Sustained Speed)", player.Name), 4)
                        
                        -- Leverage the existing Highlight module to apply the visual.
                        pcall(function()
                            Modules.HighlightPlayer:ApplyHighlight(player.Character)
                        end)
                        
                        self.State.HighlightedPlayers[player] = true
                        self.State.ViolationData[player] = nil -- Reset their data to prevent re-flagging.
                    end
                end
            end
        end
    end
end

--- Enables the Client Canary.
function Modules.ClientCanary:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    local lastCheck = 0
    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        -- Throttle the main check for performance.
        if os.clock() - lastCheck > self.Config.CHECK_INTERVAL_SECONDS then
            self:_onHeartbeat(deltaTime)
            lastCheck = os.clock()
        end
    end)
    
    DoNotif("Client Canary: ENABLED. Automated exploiter detection is active.", 2)
end

--- Disables the Client Canary and clears any highlights it created.
function Modules.ClientCanary:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.HeartbeatConnection then
        self.State.HeartbeatConnection:Disconnect()
        self.State.HeartbeatConnection = nil
    end

    -- Clear all highlights that this module was responsible for.
    for player, _ in pairs(self.State.HighlightedPlayers) do
        -- We don't call ClearHighlight directly as it clears for all targets.
        -- Instead, we check if our highlight is still the active one.
        if Modules.HighlightPlayer.State.TargetPlayer == player then
            Modules.HighlightPlayer:ClearHighlight()
        end
    end
    
    table.clear(self.State.ViolationData)
    table.clear(self.State.HighlightedPlayers)
    
    DoNotif("Client Canary: DISABLED.", 2)
end

--- Toggles the Client Canary's state.
function Modules.ClientCanary:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

--- Registers the command with your admin system.
function Modules.ClientCanary:Initialize()
    local module = self
    RegisterCommand({
        Name = "autodetect",
        Aliases = {"canary", "watchdog"},
        Description = "Toggles the automated client-side exploiter detection system."
    }, function()
        module:Toggle()
    end)
end


Modules.TweenClickTP = {
	State = {
		IsEnabled = false,
		Connection = nil,
		IsTweening = false -- Prevents starting a new tween while one is active
	},
	Config = {
		-- The key to hold while clicking. LeftAlt is a good choice to avoid conflicts.
		MODIFIER_KEY = Enum.KeyCode.LeftAlt,
		-- The duration of the camera "dash" animation in seconds.
		TWEEN_DURATION = 0.25,
		-- The easing style for a smooth acceleration/deceleration effect.
		TWEEN_STYLE = Enum.EasingStyle.Quint
	}
}

--- [Internal] Executes the camera tween and subsequent teleport.
function Modules.TweenClickTP:_executeTween(destination)
	if self.State.IsTweening then return end
	self.State.IsTweening = true

	-- Services (scoped locally for encapsulation)
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	
	local localPlayer = Players.LocalPlayer
	local character = localPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera

	if not (hrp and camera) then
		self.State.IsTweening = false
		return
	end

	-- 1. Create a temporary, invisible "anchor" part for the camera to follow.
	local cameraAnchor = Instance.new("Part")
	cameraAnchor.Size = Vector3.one
	cameraAnchor.Transparency = 1
	cameraAnchor.Anchored = true
	cameraAnchor.CanCollide = false
	cameraAnchor.CFrame = camera.CFrame
	cameraAnchor.Parent = Workspace

	-- 2. Define the animation for the anchor part.
	local tweenInfo = TweenInfo.new(self.Config.TWEEN_DURATION, self.Config.TWEEN_STYLE)
	-- The camera should arrive looking from its previous orientation towards the destination.
	local targetCFrame = CFrame.lookAt(destination, destination + camera.CFrame.LookVector)
	local tween = TweenService:Create(cameraAnchor, tweenInfo, { CFrame = targetCFrame })

	-- 3. Force the camera to follow the anchor part's tween.
	camera.CameraType = Enum.CameraType.Scriptable
	local camConnection = RunService.RenderStepped:Connect(function()
		camera.CFrame = cameraAnchor.CFrame
	end)
	
	tween:Play()

	-- 4. When the animation finishes, perform the actual teleport and clean up resources.
	tween.Completed:Connect(function()
		camConnection:Disconnect()
		hrp.CFrame = CFrame.new(destination) + Vector3.new(0, 3, 0) -- Vertical offset to prevent clipping
		camera.CameraType = Enum.CameraType.Custom
		cameraAnchor:Destroy()
		self.State.IsTweening = false
	end)
end

--- Enables the input listener for the TweenClickTP.
function Modules.TweenClickTP:Enable()
	if self.State.IsEnabled then return end
	self.State.IsEnabled = true

	self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or self.State.IsTweening then return end

		-- Check for the specific hotkey combination (e.g., LeftAlt + Left Click)
		if UserInputService:IsKeyDown(self.Config.MODIFIER_KEY) and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = UserInputService:GetMouseLocation()
			local ray = Workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
			
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = { Players.LocalPlayer.Character }
			
			local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
			
			if result and result.Position then
				self:_executeTween(result.Position)
			end
		end
	end)

	DoNotif("Tween ClickTP: [Enabled]. Hold LeftAlt and click to teleport.", 3)
end

--- Disables the input listener and cleans up.
function Modules.TweenClickTP:Disable()
	if not self.State.IsEnabled then return end
	self.State.IsEnabled = false

	if self.State.Connection then
		self.State.Connection:Disconnect()
		self.State.Connection = nil
	end

	DoNotif("Tween ClickTP: [Disabled].", 2)
end

--- Toggles the state of the module.
function Modules.TweenClickTP:Toggle()
	if self.State.IsEnabled then
		self:Disable()
	else
		self:Enable()
	end
end

RegisterCommand({
	Name = "tweenclicktp",
	Aliases = {"tctp", "smoothtp", "blinktp"},
	Description = "Toggles a smooth, camera-animated teleport. Hold Left Alt and click to use."
}, function(args)
	Modules.TweenClickTP:Toggle()
end)

Modules.UniversalESP = {
    State = {
        ActiveFolders = {} :: {[Instance]: ESPData}
    },
    Config = {
        FILL_COLOR = Color3.fromRGB(147, 112, 219),
        OUTLINE_COLOR = Color3.fromRGB(255, 255, 255),
        FILL_TRANSPARENCY = 0.5,
        OUTLINE_TRANSPARENCY = 0,
        HIGHLIGHT_LIMIT = 31
    }
}

function Modules.UniversalESP:_resolvePath(path: string): Instance?
    local success, result = pcall(function()
        local segments = string.split(path, ".")
        local current: any = game

        for i, name in ipairs(segments) do
            if i == 1 then
                if name:lower() == "game" then
                    continue
                elseif name:lower() == "workspace" then
                    current = workspace
                    continue
                else
                    current = game:GetService(name) or game:FindFirstChild(name)
                end
            else
                current = current:FindFirstChild(name)
            end
            if not current then break end
        end
        return current
    end)
    return success and result or nil
end

function Modules.UniversalESP:_highlight(instance: Instance, storage: {[Instance]: Highlight}): ()
    if not (instance:IsA("BasePart") or instance:IsA("Model")) then return end
    if storage[instance] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Universal_ESP_Layer"
    highlight.Adornee = instance
    highlight.FillColor = self.Config.FILL_COLOR
    highlight.OutlineColor = self.Config.OUTLINE_COLOR
    highlight.FillTransparency = self.Config.FILL_TRANSPARENCY
    highlight.OutlineTransparency = self.Config.OUTLINE_TRANSPARENCY
    highlight.Parent = CoreGui
    
    storage[instance] = highlight
end

function Modules.UniversalESP:Disable(folder: Instance): ()
    local data = self.State.ActiveFolders[folder]
    if not data then return end

    if data.Added then data.Added:Disconnect() end
    if data.Removed then data.Removed:Disconnect() end

    for item, highlight in pairs(data.Highlights) do
        pcall(function() highlight:Destroy() end)
    end

    self.State.ActiveFolders[folder] = nil
    DoNotif("Deactivated ESP for: " .. folder.Name, 2)
end

function Modules.UniversalESP:Enable(folder: Instance): ()
    if self.State.ActiveFolders[folder] then return end

    local data: ESPData = {
        Highlights = {},
        Added = nil,
        Removed = nil
    }

    local function process(child: Instance)
        if child:IsA("BasePart") or child:IsA("Model") then
            self:_highlight(child, data.Highlights)
        elseif child:IsA("Folder") or child:IsA("Configuration") then
            for _, subChild in ipairs(child:GetChildren()) do
                process(subChild)
            end
        end
    end

    data.Added = folder.DescendantAdded:Connect(function(descendant)
        task.defer(process, descendant)
    end)

    data.Removed = folder.DescendantRemoving:Connect(function(descendant)
        if data.Highlights[descendant] then
            pcall(function() data.Highlights[descendant]:Destroy() end)
            data.Highlights[descendant] = nil
        end
    end)

    self.State.ActiveFolders[folder] = data
    
    for _, child in ipairs(folder:GetChildren()) do
        process(child)
    end
    
    DoNotif("Activated ESP for: " .. folder.Name, 2)
end

function Modules.UniversalESP:Initialize(): ()
    local module = self
    RegisterCommand({
        Name = "espfolder",
        Aliases = {"fesp", "highf"},
        Description = "Recursive highlight for objects in a specified path."
    }, function(args: {string})
        local path = args[1]
        if not path then return DoNotif("Argument Required: Path", 3) end

        local folder = module:_resolvePath(path)
        if not folder then return DoNotif("Invalid Object Path: " .. path, 3) end

        if module.State.ActiveFolders[folder] then
            module:Disable(folder)
        else
            module:Enable(folder)
        end
    end)
end

Modules.FolderAimbot = {
    State = {
        IsEnabled = false,
        IsAiming = false,
        TargetFolder = nil,
        Connection = nil,
        InputBegan = nil,
        InputEnded = nil
    },
    Config = {
        FOV = 200,
        SMOOTHING = 0.25,
        AIM_KEY = Enum.UserInputType.MouseButton2
    }
}

function Modules.FolderAimbot:_resolvePath(path: string): Instance?
    local current: Instance = game
    for component in string.gmatch(path, "[^%.]+") do
        if string.find(component, ":GetService") then
            local serviceName = component:match("'(.-)'") or component:match('"(.-)"')
            current = serviceName and game:GetService(serviceName) or current
        else
            current = current and current:FindFirstChild(component)
        end
    end
    return current
end

function Modules.FolderAimbot:_getTargetPos(model: Model): Vector3?
    local priority = {"Head", "HumanoidRootPart", "Torso", "UpperTorso"}
    for _, name in ipairs(priority) do
        local part = model:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part.Position
        end
    end
    return model.PrimaryPart and model.PrimaryPart.Position
end

function Modules.FolderAimbot:GetClosestTarget(): Model?
    local folder = self.State.TargetFolder
    if not folder then return nil end

    local closestTarget = nil
    local shortestDist = self.Config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Model") then
            local pos = self:_getTargetPos(child)
            if pos then
                local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = child
                    end
                end
            end
        end
    end
    return closestTarget
end

function Modules.FolderAimbot:Enable(folder: Instance, fov: number?): ()
    self:Disable()
    
    self.State.IsEnabled = true
    self.State.TargetFolder = folder
    if fov then self.Config.FOV = fov end

    self.State.InputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.UserInputType == self.Config.AIM_KEY then
            self.State.IsAiming = true
        end
    end)

    self.State.InputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == self.Config.AIM_KEY then
            self.State.IsAiming = false
        end
    end)

    self.State.Connection = RunService.RenderStepped:Connect(function()
        if not self.State.IsAiming then return end
        
        local target = self:GetClosestTarget()
        if target then
            local pos = self:_getTargetPos(target)
            if pos then
                local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local deltaX = (screenPos.X - mousePos.X) * self.Config.SMOOTHING
                    local deltaY = (screenPos.Y - mousePos.Y) * self.Config.SMOOTHING
                    
                    if mousemoverel then
                        mousemoverel(deltaX, deltaY)
                    end
                end
            end
        end
    end)

    DoNotif("Folder Aimbot: ENABLED for " .. folder.Name, 2)
end

function Modules.FolderAimbot:Disable(): ()
    self.State.IsEnabled = false
    self.State.IsAiming = false
    
    if self.State.Connection then self.State.Connection:Disconnect() end
    if self.State.InputBegan then self.State.InputBegan:Disconnect() end
    if self.State.InputEnded then self.State.InputEnded:Disconnect() end
    
    self.State.Connection = nil
    self.State.InputBegan = nil
    self.State.InputEnded = nil
    self.State.TargetFolder = nil
end

function Modules.FolderAimbot:Initialize(): ()
    local module = self
    RegisterCommand({
        Name = "faim",
        Aliases = {"folderamt", "targetfolder"},
        Description = "Aimbot for all models in a folder. Usage: ;faim Workspace.Zombies 300"
    }, function(args: {string})
        local path = args[1]
        local fov = tonumber(args[2])

        if not path then 
            if module.State.IsEnabled then
                module:Disable()
                return DoNotif("Folder Aimbot: DISABLED", 2)
            end
            return DoNotif("Usage: ;faim <Path> [FOV]", 3)
        end

        local folder = module:_resolvePath(path)
        if folder then
            module:Enable(folder, fov)
        else
            DoNotif("Error: Invalid path.", 3)
        end
    end)
end

Modules.RespawnOnPlayer = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Connection = nil
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

--// --- Private Methods ---

function Modules.RespawnOnPlayer:_onCharacterAdded(character)
    task.defer(function()
        if not self.State.IsEnabled or not self.State.TargetPlayer or not self.State.TargetPlayer.Parent then
            DoNotif("Respawn target lost. Disabling.", 3)
            self:Disable()
            return
        end

        local myRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        -- [NEW ARCHITECTURE] Create a resilient wait loop for the target's character.
        -- This waits up to 5 seconds for the target to spawn, preventing the race condition.
        local targetCharacter = self.State.TargetPlayer.Character
        local targetRoot = nil
        
        if not targetCharacter then
            DoNotif("Waiting for " .. self.State.TargetPlayer.Name .. " to spawn...", 2)
            for i = 1, 10 do -- Try for 5 seconds (10 * 0.5s)
                targetCharacter = self.State.TargetPlayer.Character
                if targetCharacter then break end
                task.wait(0.5)
            end
        end

        -- Final check after the wait.
        if targetCharacter then
            targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        end

        if targetRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            DoNotif("Respawned on " .. self.State.TargetPlayer.Name, 2)
        else
            DoNotif("Could not respawn on target: Character not found (they may be respawning or have left).", 3)
        end
    end)
end

--// --- Public Methods (No changes needed here, the logic is sound) ---

function Modules.RespawnOnPlayer:Enable(targetPlayer)
    if not targetPlayer or targetPlayer == self.Services.Players.LocalPlayer then
        return DoNotif("Invalid or self-targeted player.", 3)
    end

    self:Disable() 

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer

    local module = self
    self.State.Connection = self.Services.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        module:_onCharacterAdded(char)
    end)

    DoNotif("Respawn on Target: ENABLED. Will respawn on " .. targetPlayer.Name, 3)
end

function Modules.RespawnOnPlayer:Disable()
    if not self.State.IsEnabled then return end

    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    self.State.TargetPlayer = nil
    self.State.IsEnabled = false

    DoNotif("Respawn on Target: DISABLED.", 2)
end

--// --- Command Registration ---
RegisterCommand({
    Name = "respawnontarget",
    Aliases = {"spon", "respawnon"},
    Description = "Sets your respawn point to a target player's location."
}, function(args)
    -- [CRITICAL FIX] Join all arguments to allow for names with spaces.
    local argument = table.concat(args, " ")
    
    if not argument or argument == "" then
        return DoNotif("Usage: ;spon <PlayerName|clear>", 3)
    end

    if argument:lower() == "clear" or argument:lower() == "reset" or argument:lower() == "off" then
        Modules.RespawnOnPlayer:Disable()
        return
    end

    local targetPlayer = Utilities.findPlayer(argument)
    if targetPlayer then
        Modules.RespawnOnPlayer:Enable(targetPlayer)
    else
        -- This notification will now correctly show the full name you tried to find.
        DoNotif("Player not found: '" .. argument .. "'", 3)
    end
end)

Modules.VariableSniper = { State = { IsScanning = false } }

function Modules.VariableSniper:Search(varName, newValue)
    local foundCount = 0
    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" and rawget(obj, varName) ~= nil then
            rawset(obj, varName, newValue)
            foundCount = foundCount + 1
        end
    end
    DoNotif("Sniper: Patched " .. foundCount .. " instances of '" .. varName .. "'", 3)
end

RegisterCommand({
    Name = "snipe",
    Aliases = {"patchvar", "memedit"},
    Description = "Scans memory for a variable name and overwrites its value. ;snipe isAdmin true"
}, function(args)
    local var = args[1]
    local val = args[2]
    if val == "true" then val = true elseif val == "false" then val = false end
    Modules.VariableSniper:Search(var, val)
end)

Modules.NetworkGhost = {
    State = { IsEnabled = false, Offset = Vector3.new(0, 1000, 0) }
}

function Modules.NetworkGhost:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    local lp = game:GetService("Players").LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    
    if self.State.IsEnabled then
        Modules.HookCentral:AddHook("GhostBypass", "Namecall", 
            function(selfArg, method) return selfArg == hrp and (method == "CFrame" or method == "Position") end,
            function() return hrp.CFrame - self.State.Offset end
        )
        DoNotif("Network Ghost: ACTIVE (Identity Desynced)", 3)
    else
        Modules.HookCentral.State.Hooks["GhostBypass"] = nil
        DoNotif("Network Ghost: DISABLED", 2)
    end
end

RegisterCommand({ Name = "ghost", Aliases = {"desyncv4"}, Description = "Desyncs server-side physics from your local position." }, function()
    Modules.NetworkGhost:Toggle()
end)

--[[Modules.HookCentral = {
    State = {
        Hooks = {},
        OriginalNamecall = nil,
        OriginalIndex = nil,
        OriginalNewIndex = nil
    }
}

function Modules.HookCentral:Initialize()
    local mt = getrawmetatable(game)
    self.State.OriginalNamecall = mt.__namecall
    self.State.OriginalIndex = mt.__index
    self.State.OriginalNewIndex = mt.__newindex
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(selfArg, ...)
        local method = getnamecallmethod()
        for _, hook in pairs(Modules.HookCentral.State.Hooks) do
            if hook.Type == "Namecall" and hook.Check(selfArg, method, ...) then
                return hook.Callback(selfArg, ...)
            end
        end
        return Modules.HookCentral.State.OriginalNamecall(selfArg, ...)
    end)
    
    setreadonly(mt, true)
    DoNotif("Hook Central: Engine Initialized", 2)
end

function Modules.HookCentral:AddHook(id, type, checkFunc, callback)
    self.State.Hooks[id] = {Type = type, Check = checkFunc, Callback = callback}
end--]]

Modules.SignalRespawn = {
    State = {
        IsExecuting = false
    },
    Dependencies = {"Players", "Workspace", "ReplicateSignal"},
    Services = {}
}

function Modules.SignalRespawn:_getAllTools()
    local lp = self.Services.Players.LocalPlayer
    local tools = {}
    local backpack = lp:FindFirstChildOfClass("Backpack")
    local char = lp.Character

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(tools, tool) end
        end
    end
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then table.insert(tools, tool) end
        end
    end
    return tools
end

--[[
    Main Execution Logic.
--]]
function Modules.SignalRespawn:Execute()
    if self.State.IsExecuting then return end
    
    -- Feature Check: This method requires specific exploit APIs
    if not replicatesignal then
        return DoNotif("SignalRespawn: Your executor lacks 'replicatesignal'.", 4)
    end

    local lp = self.Services.Players.LocalPlayer
    local players = self.Services.Players
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = self.Services.Workspace.CurrentCamera

    if not hum or not root then
        return DoNotif("SignalRespawn: Character root not found.", 3)
    end

    self.State.IsExecuting = true
    DoNotif("Initiating signal-based respawn...", 1.5)

    -- 1. Trigger the Backend Signal
    pcall(function()
        replicatesignal(lp.ConnectDiedSignalBackend)
    end)

    -- 2. Store current state
    local savedCFrame = root.CFrame
    local savedTools = self:_getAllTools()

    -- 3. The Precision Timing Wait
    -- We wait slightly less than the game's RespawnTime to intercept the character load
    task.wait(players.RespawnTime - 0.165)

    -- 4. Force Death State
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Dead)
    end)

    -- 5. Wait for the new character to initialize
    local newChar = lp.CharacterAdded:Wait()
    local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)

    -- 6. Restore Position and Camera
    if newRoot then
        task.wait(0.1) -- Stability buffer
        newRoot.CFrame = savedCFrame
        self.Services.Workspace.CurrentCamera = cam
        DoNotif("Respawn complete. Position restored.", 2)
    end

    self.State.IsExecuting = false
end

--// Initialize the module and register the command
function Modules.SignalRespawn:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "signalrespawn",
        Aliases = {"instaspawn"},
        Description = "Advanced instant respawn using signal replication. Restores position."
    }, function()
        module:Execute()
    end)
end

Modules.ExternalChatter = {
    State = {
        IsEnabled = true
    },
    Dependencies = {"TextChatService", "ReplicatedStorage", "Players"},
    Services = {}
}

--[[
    Internal execution logic.
    Detects ChatVersion and fires the appropriate event/method.
--]]
function Modules.ExternalChatter:Say(args)
    local message = table.concat(args, " ")
    if not message or message == "" then 
        return DoNotif("External Chatter: No message provided.", 2) 
    end

    local textChatService = self.Services.TextChatService
    local replicatedStorage = self.Services.ReplicatedStorage

    -- Method 1: Modern TextChatService (2023+ games)
    if textChatService and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local generalChannel = textChatService.TextChannels:FindFirstChild("RBXGeneral")
        if generalChannel then
            pcall(function()
                generalChannel:SendAsync(message)
            end)
            return
        end
    end

    -- Method 2: Legacy Chat System (DefaultChatSystemChatEvents)
    local chatEvents = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local sayMessageRequest = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")

    if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
        pcall(function()
            sayMessageRequest:FireServer(message, "All")
        end)
    else
        -- Method 3: Direct fallback to the old chat method if remotes aren't found
        local lp = self.Services.Players.LocalPlayer
        if lp then
            pcall(lp.Chat, lp, message)
        end
    end
end

--// Initialize the module and register the command
function Modules.ExternalChatter:Initialize()
    local module = self
    
    -- Load services robustly
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "chat",
        Aliases = {"message"},
        Description = "Forces your character to chat. Bypasses some UI mutes."
    }, function(args)
        module:Say(args)
    end)
end

Modules.StareController = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Mode = nil, -- "Direct" or "Nearest"
        Connection = nil,
        PrevAutoRotate = true
    },
    Dependencies = {"Players", "RunService"},
    Services = {}
}

--// --- Private Utilities ---

--[[
    Calculates the CFrame to face a position while keeping the character upright.
--]]
function Modules.StareController:_facePosition(targetPos)
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        -- We only care about the direction on the X and Z axes to prevent tilting.
        local targetLook = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
        if (targetLook - root.Position).Magnitude > 0.01 then
            root.CFrame = CFrame.lookAt(root.Position, targetLook)
        end
    end
end

function Modules.StareController:_getClosestPlayer()
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest, dist = nil, math.huge
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                closest = p
            end
        end
    end
    return closest
end

--// --- Core Logic ---

function Modules.StareController:Disable()
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    local lp = self.Services.Players.LocalPlayer
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = self.State.PrevAutoRotate
    end

    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
    self.State.Mode = nil
end

function Modules.StareController:Enable(target, mode)
    self:Disable() -- Clean existing state

    local lp = self.Services.Players.LocalPlayer
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    self.State.PrevAutoRotate = hum.AutoRotate
    hum.AutoRotate = false
    self.State.IsEnabled = true
    self.State.Mode = mode

    if mode == "Direct" then
        self.State.TargetPlayer = target
        self.State.Connection = self.Services.RunService.RenderStepped:Connect(function()
            if target and target.Parent and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                self:_facePosition(target.Character.HumanoidRootPart.Position)
            else
                -- Auto-disable if target leaves or character is destroyed
                self:Disable()
                DoNotif("Stare: Target lost. Disabling.", 2)
            end
        end)
        DoNotif("Staring at: " .. target.Name, 2)
    elseif mode == "Nearest" then
        self.State.Connection = self.Services.RunService.RenderStepped:Connect(function()
            local closest = self:_getClosestPlayer()
            if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
                self:_facePosition(closest.Character.HumanoidRootPart.Position)
            end
        end)
        DoNotif("Staring at nearest player.", 2)
    end
end

--// --- Initialize ---

function Modules.StareController:Initialize()
    local module = self
    for _, s in ipairs(module.Dependencies) do module.Services[s] = game:GetService(s) end

    -- Command: Lookat
    RegisterCommand({
        Name = "lookat",
        Aliases = {"stare", "face"},
        Description = "Forces your character to persistently face a player."
    }, function(args)
        local target = Utilities.findPlayer(args[1] or "")
        if target then
            module:Enable(target, "Direct")
        else
            DoNotif("Stare: Player not found.", 3)
        end
    end)

    -- Command: Unlookat
    RegisterCommand({
        Name = "unlookat",
        Aliases = {"unstare", "unface"},
        Description = "Stops the stare effect and restores movement rotation."
    }, function()
        module:Disable()
        DoNotif("Stare disabled.", 2)
    end)

    -- Command: StareNearest
    RegisterCommand({
        Name = "starenear",
        Aliases = {"stareclosest", "snear"},
        Description = "Persistently stare at whoever is closest to you."
    }, function()
        module:Enable(nil, "Nearest")
    end)

    -- Command: UnstareNearest
    RegisterCommand({
        Name = "unstarenear",
        Aliases = {"unstareclosest"},
        Description = "Stops staring at the closest player."
    }, function()
        module:Disable()
        DoNotif("Nearest Stare disabled.", 2)
    end)
end

Modules.ProximityStalker = {
    State = {
        IsEnabled = false,
        IsFollowing = false,
        TargetPlayer = nil,
        LastDistances = {},
        Connections = {} -- [Key] = Connection
    },
    Config = {
        ProximityRadius = 25, -- The 'trigger' distance to start following
        StopDistance = 5      -- Distance to keep from the target
    },
    Dependencies = {"RunService", "Players"},
    Services = {}
}

--// --- Private Logic ---

function Modules.ProximityStalker:_cleanup()
    for key, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- Stop current movement
    local lp = self.Services.Players.LocalPlayer
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:MoveTo(lp.Character.PrimaryPart and lp.Character.PrimaryPart.Position or Vector3.zero)
    end

    self.State.LastDistances = {}
    self.State.IsFollowing = false
    self.State.TargetPlayer = nil
    self.State.IsEnabled = false
end

function Modules.ProximityStalker:_setupFollowLogic(target)
    local lp = self.Services.Players.LocalPlayer
    local myHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    
    if not myHum then return end

    -- Follow Loop
    self.State.Connections.FollowLoop = self.Services.RunService.Heartbeat:Connect(function()
        local tChar = target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local myChar = lp.Character
        
        if myChar and tRoot and tChar.Parent then
            -- Only move if further away than the StopDistance
            local dist = (tRoot.Position - myChar.PrimaryPart.Position).Magnitude
            if dist > self.Config.StopDistance then
                myHum:MoveTo(tRoot.Position)
            end
        else
            -- If target is lost (leaves or char destroyed), restart scanning
            if self.State.Connections.FollowLoop then
                self.State.Connections.FollowLoop:Disconnect()
            end
            self.State.IsFollowing = false
            self.State.TargetPlayer = nil
            DoNotif("Proximity Stalker: Target lost. Resuming scan.", 2)
        end
    end)

    -- Death Listener
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum then
        self.State.Connections.TargetDied = tHum.Died:Connect(function()
            if self.State.Connections.FollowLoop then self.State.Connections.FollowLoop:Disconnect() end
            self.State.IsFollowing = false
            self.State.TargetPlayer = nil
        end)
    end
end

--// --- Core Execution ---

function Modules.ProximityStalker:Start()
    self:_cleanup() -- Ensure fresh start
    self.State.IsEnabled = true
    
    local lp = self.Services.Players.LocalPlayer
    DoNotif("Proximity Stalker: ACTIVE (Radius: " .. self.Config.ProximityRadius .. ")", 2)

    self.State.Connections.Scanner = self.Services.RunService.Heartbeat:Connect(function()
        if self.State.IsFollowing or not self.State.IsEnabled then return end

        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        for _, plr in ipairs(self.Services.Players:GetPlayers()) do
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = plr.Character.HumanoidRootPart
                local currentDist = (myRoot.Position - tRoot.Position).Magnitude
                local lastDist = self.State.LastDistances[plr]

                -- Detection Logic: If they entered the radius and are moving towards us
                if lastDist and lastDist > self.Config.ProximityRadius and currentDist <= self.Config.ProximityRadius then
                    self.State.IsFollowing = true
                    self.State.TargetPlayer = plr
                    
                    DoNotif("Stalker: Locked onto " .. plr.Name, 2)
                    self:_setupFollowLogic(plr)
                    
                    -- Dynamic re-hook if they respawn
                    self.State.Connections.TargetRespawn = plr.CharacterAdded:Connect(function(newChar)
                        task.wait(0.5)
                        if self.State.IsEnabled and self.State.TargetPlayer == plr then
                            self:_setupFollowLogic(plr)
                        end
                    end)
                    
                    break -- Target locked, stop scanning for this frame
                end

                self.State.LastDistances[plr] = currentDist
            end
        end
    end)
end

--// --- Initialize ---

function Modules.ProximityStalker:Initialize()
    local module = self
    for _, s in ipairs(module.Dependencies) do module.Services[s] = game:GetService(s) end

    RegisterCommand({
        Name = "autofollow",
        Aliases = {"autostalk", "proxfollow", "stalkonapproach"},
        Description = "Automatically follows any player who walks into your proximity radius."
    }, function()
        module:Start()
    end)

    RegisterCommand({
        Name = "unautofollow",
        Aliases = {"stopautostalk", "unproxfollow"},
        Description = "Disables the proximity stalker and stops current movement."
    }, function()
        module:_cleanup()
        DoNotif("Proximity Stalker: DISABLED", 2)
    end)
end

Modules.BlockRemote = {
	State = {
		IsEnabled = false,
		OriginalNamecall = nil,
		BlockedRemotes = {}
	}
}

local function FindInstanceFromPath(path: string): Instance?
	local current: Instance = game
	for component in string.gmatch(path, "[^%.]+") do
		current = current:FindFirstChild(component)
		if not current then
			return nil
		end
	end
	return current
end

function Modules.BlockRemote:Enable(): ()
	if self.State.IsEnabled then return end

	local mt = getrawmetatable(game)
	if not (mt and getnamecallmethod and newcclosure) then
		return DoNotif("Executor does not support __namecall hooking.", 4)
	end

	self.State.OriginalNamecall = mt.__namecall

	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(...)
		local selfArg = ...
		local method = getnamecallmethod()

		if (method == "FireServer" or method == "InvokeServer") and self.State.BlockedRemotes[selfArg] then
			return nil
		end

		return self.State.OriginalNamecall(...)
	end)
	setreadonly(mt, true)

	self.State.IsEnabled = true
	DoNotif("Remote Blocking System: ENABLED.", 2)
end

function Modules.BlockRemote:Disable(): ()
	if not self.State.IsEnabled then return end

	pcall(function()
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		mt.__namecall = self.State.OriginalNamecall
		setreadonly(mt, true)
	end)

	self.State.IsEnabled = false
	self.State.OriginalNamecall = nil
	DoNotif("Remote Blocking System: DISABLED.", 2)
end

function Modules.BlockRemote:Initialize(): ()
	local module = self
	RegisterCommand({
		Name = "blockremote",
		Aliases = {"br", "block"},
		Description = "Blocks a remote by its full path."
	}, function(args)
		local path = args[1]
		if not path then return DoNotif("Usage: ;blockremote <path.to.remote>", 3) end
		if not module.State.IsEnabled then module:Enable() end

		local remote = FindInstanceFromPath(path)
		if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
			module.State.BlockedRemotes[remote] = true
			DoNotif("Added to block list: " .. remote:GetFullName(), 2)
		else
			DoNotif("Could not find a valid remote at: " .. path, 3)
		end
	end)

	RegisterCommand({
		Name = "unblockremote",
		Aliases = {"ubr"},
		Description = "Unblocks a remote by its full path."
	}, function(args)
		local path = args[1]
		if not path then return DoNotif("Usage: ;unblockremote <path.to.remote>", 3) end

		local remote = FindInstanceFromPath(path)
		if remote and module.State.BlockedRemotes[remote] then
			module.State.BlockedRemotes[remote] = nil
			DoNotif("Removed from block list: " .. remote:GetFullName(), 2)
		else
			DoNotif("That remote was not on the block list.", 2)
		end
	end)

	RegisterCommand({
		Name = "listblocked",
		Aliases = {"lsb"},
		Description = "Lists all currently blocked remotes in the F9 console."
	}, function()
		print("--- [Blocked Remotes] ---")
		local count = 0
		for remote, _ in pairs(module.State.BlockedRemotes) do
			if typeof(remote) == "Instance" then
				print(" - " .. remote:GetFullName())
				count += 1
			end
		end
		DoNotif("Printed " .. count .. " blocked remotes to the console.", 2)
	end)
end

Modules.ForceRespawn = {
    -- No state needed for this action-based module.
}

function Modules.ForceRespawn:Execute()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then
        DoNotif("Cannot respawn: LocalPlayer not found.", 3)
        return
    end

    DoNotif("Attempting to force respawn...", 2)

    local success, err = pcall(function()
        LocalPlayer:LoadCharacter()
    end)

    if not success then
        warn("[ForceRespawn] LoadCharacter failed:", err)
        DoNotif("Respawn request failed. The server may have rejected it.", 4)
    end
end

function Modules.ForceRespawn:Initialize()
    RegisterCommand({
        Name = "respawn",
        Aliases = {"rr"},
        Description = "Forces your character to respawn. Useful if you are stuck or punished."
    }, function()
        Modules.ForceRespawn:Execute()
    end)
end

Modules.ForensicExplorer = {
    State = {
        IsLoading = false
    },
    Dependencies = {"CoreGui", "Players", "ReplicatedStorage", "Workspace", "LocalPlayer", "StarterGui", "Lighting", "ReplicatedFirst", "RunService"},
    Services = {}
}

--[[
    Internal Utility: Generates a random string to obfuscate the UI name.
--]]
function Modules.ForensicExplorer:_generateObfuscatedName()
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local length = math.random(10, 20)
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        result = result .. charset:sub(rand, rand)
    end
    return result
end

--[[
    Internal Utility: Sets up the custom execution environment for Dex's internal scripts.
--]]
function Modules.ForensicExplorer:_applyEnvironment(func, scriptInstance)
    local fenv = {}
    local realFenv = {script = scriptInstance}
    local fenvMt = {}

    fenvMt.__index = function(_, key)
        return realFenv[key] or getfenv()[key]
    end

    fenvMt.__newindex = function(_, key, value)
        if realFenv[key] == nil then
            getfenv()[key] = value
        else
            realFenv[key] = value
        end
    end

    setmetatable(fenv, fenvMt)
    setfenv(func, fenv)
    return func
end

--[[
    Main Execution Logic.
--]]
function Modules.ForensicExplorer:Load()
    if self.State.IsLoading then return end
    self.State.IsLoading = true

    DoNotif("Fetching Dex assets from Roblox...", 2)

    task.spawn(function()
        local success, dexObjects = pcall(function()
            return game:GetObjects("rbxassetid://9553291002")
        end)

        if not success or not dexObjects or #dexObjects == 0 then
            self.State.IsLoading = false
            return DoNotif("Failed to fetch Dex. Asset may be down.", 3)
        end

        local dexUI = dexObjects[1]
        dexUI.Name = self:_generateObfuscatedName()

        -- UI Protection: Use Zuka's CoreGui pattern
        -- If your executor has a specific ProtectGUI function, it can be called here.
        if get_hidden_gui or (syn and syn.protect_gui) then
            local protect = get_hidden_gui or syn.protect_gui
            protect(dexUI)
        end
        dexUI.Parent = self.Services.CoreGui

        -- Recursive Script Loader
        local function loadScripts(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("LuaSourceContainer") then
                    task.spawn(function()
                        local func, err = loadstring(child.Source, "=" .. child:GetFullName())
                        if func then
                            self:_applyEnvironment(func, child)()
                        else
                            warn("--> [ForensicExplorer] Script Error in " .. child.Name .. ": " .. tostring(err))
                        end
                    end)
                end
                loadScripts(child)
            end
        end

        loadScripts(dexUI)
        DoNotif("Dex Explorer Loaded. UI Obfuscated.", 2)
        self.State.IsLoading = false
    end)
end

--// Initialize the module and register the command
function Modules.ForensicExplorer:Initialize()
    local module = self
    
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "synapsedex",
        Aliases = {"sdex", "dexv3", "explorer"},
        Description = "Loads an advanced instance of the SynapseX Dex Explorer."
    }, function()
        module:Load()
    end)
end

Modules.CreepSequence = {
    State = {
        IsExecuting = false
    },
    Dependencies = {"TweenService", "RunService", "Players",},
    Services = {}
}

function Modules.CreepSequence:Execute(targetName)
    if self.State.IsExecuting then return end
    
    local target = Utilities.findPlayer(targetName)
    if not target then
        return DoNotif("Creep: Target not found.", 3)
    end

    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    local tChar = target.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")

    if not root or not tRoot then
        return DoNotif("Creep: Character parts missing.", 3)
    end

    self.State.IsExecuting = true
    DoNotif("Executing creep sequence on " .. target.Name, 1.5)


    root.CFrame = tRoot.CFrame * CFrame.new(0, -10, 4)
    task.wait()


    local noclipConn
    noclipConn = self.Services.RunService.Stepped:Connect(function()
        if not char or not self.State.IsExecuting then 
            noclipConn:Disconnect()
            return 
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    -- 3. Rising Sequence
    root.Anchored = true
    task.wait()


    local tweenInfo = TweenInfo.new(1000, Enum.EasingStyle.Linear)

    local risingTween = self.Services.TweenService:Create(root, tweenInfo, {
        CFrame = CFrame.new(root.Position.X, 10000, root.Position.Z)
    })
    
    risingTween:Play()
    task.wait(1.5)
    risingTween:Pause()


    root.Anchored = false
    self.State.IsExecuting = false
    risingTween:Destroy()

    DoNotif("Sequence Complete.", 1)
end

function Modules.CreepSequence:Initialize()
    local module = self
    
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "creep",
        Aliases = {"stalkerjump", "underfloor"},
        Description = "Teleports you behind/under a player and rises through the floor."
    }, function(args)
        if #args == 0 then
            return DoNotif("Usage: ;creep <PlayerName>", 3)
        end
        module:Execute(args[1])
    end)
end

Modules.NextGenDesync = {
    State = {
        IsEnabled = false
    }
}

function Modules.NextGenDesync:Toggle()
    if type(setfflag) ~= "function" then
        return DoNotif("Architect Error: Executor does not support 'setfflag'.", 3)
    end

    if not self.State.IsEnabled then
        -- Enabling Sequence
        local success, err = pcall(function()
            setfflag("NextGenReplicatorEnabledWrite4", "false")
            setfflag("NextGenReplicatorEnabledWrite4", "true")
        end)

        if success then
            self.State.IsEnabled = true
            DoNotif("NextGen Desync: ENABLED. Replicator authority hijacked.", 4)
        else
            warn("--> [NextGenDesync] Enable Failed:", err)
            DoNotif("FFlag Error: Check F9 for details.", 4)
        end
    else
        -- Disabling/Syncing Sequence
        local success, err = pcall(function()
            setfflag("NextGenReplicatorEnabledWrite4", "true")
            setfflag("NextGenReplicatorEnabledWrite4", "false")
        end)

        if success then
            self.State.IsEnabled = false
            DoNotif("NextGen Desync: DISABLED. Re-synced with server.", 3)
        else
            warn("--> [NextGenDesync] Disable Failed:", err)
            DoNotif("FFlag Error: Check F9 for details.", 4)
        end
    end
end

--// Initialize the module and register the command
function Modules.NextGenDesync:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "ngdesync",
        Aliases = {"ngrep", "nextgendesync", "flagdesync"},
        Description = "Toggles NextGenReplicator desync via FFlags. (Server Authority Bypass)"
    }, function()
        module:Toggle()
    end)
end

Modules.MirrorMimic = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Delay = 0,
        UID = 0,
        AnimatePrevDisabled = nil,
        PrevAutoRotate = true,
        -- Buffers and Tracking
        PoseQueue = {},
        PoseHead = 1,
        AnimEvents = {},
        AnimHead = 1,
        ActiveSlots = {},
        Connections = {}
    },
    Dependencies = {"RunService", "Players", "Workspace"},
    Services = {}
}

--// --- Private Logic ---

function Modules.MirrorMimic:_cleanup()
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- 1. Disconnect all Zuka connections
    for key, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)

    -- 2. Restore Animations
    for _, slot in pairs(self.State.ActiveSlots) do
        if slot.mt then pcall(function() slot.mt:Stop(0) end) end
    end
    table.clear(self.State.ActiveSlots)

    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() tr:Stop(0) end)
            end
        end
        hum.AutoRotate = self.State.PrevAutoRotate
    end

    -- 3. Restore Animate Script
    local animate = char and char:FindFirstChild("Animate")
    if animate and self.State.AnimatePrevDisabled ~= nil then
        animate.Disabled = self.State.AnimatePrevDisabled
    end

    -- 4. Reset Buffers
    self.State.PoseQueue = {}
    self.State.PoseHead = 1
    self.State.AnimEvents = {}
    self.State.AnimHead = 1
    self.State.IsEnabled = false
    self.State.TargetPlayer = nil
end

function Modules.MirrorMimic:_scheduleAnim(track, kind, extra)
    local now = os.clock()
    table.insert(self.State.AnimEvents, {
        t = now + self.State.Delay,
        kind = kind,
        track = track,
        animId = track.Animation.AnimationId,
        speed = (type(track.Speed) == "number" and track.Speed) or 1,
        baseTP = track.TimePosition or 0,
        looped = track.Looped,
        data = extra
    })
end

--// --- Core Execution ---

function Modules.MirrorMimic:Enable(targetName, delayVal)
    local target = Utilities.findPlayer(targetName)
    if not target or not target.Character then
        return DoNotif("Mimic: Target not found or has no character.", 3)
    end

    local lp = self.Services.Players.LocalPlayer
    local myChar = lp.Character
    local tChar = target.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")

    if not (myHum and tHum) or myHum.RigType ~= tHum.RigType then
        return DoNotif("Mimic Error: Character rig types do not match.", 3)
    end

    self:_cleanup() -- Clear previous session
    
    self.State.IsEnabled = true
    self.State.TargetPlayer = target
    self.State.Delay = tonumber(delayVal) or 0
    self.State.PrevAutoRotate = myHum.AutoRotate
    myHum.AutoRotate = false

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    local myAnimator = myHum:FindFirstChildOfClass("Animator") or Instance.new("Animator", myHum)
    local tAnimator = tHum:FindFirstChildOfClass("Animator")

    -- Disable local animation script
    local animate = myChar:FindFirstChild("Animate")
    if animate then
        self.State.AnimatePrevDisabled = animate.Disabled
        animate.Disabled = true
    end

    --// Listeners: Animations
    self.State.Connections.AnimPlayed = tHum.AnimationPlayed:Connect(function(tt)
        self:_scheduleAnim(tt, "start")
        
        -- Hook speed changes and stops on the target track
        self.State.Connections["TrackSpd_"..tostring(tt)] = tt:GetPropertyChangedSignal("Speed"):Connect(function()
            self:_scheduleAnim(tt, "speed")
        end)
        self.State.Connections["TrackStop_"..tostring(tt)] = tt.Stopped:Connect(function()
            self:_scheduleAnim(tt, "stop")
        end)
    end)

    --// Listeners: Tools
    self.State.Connections.ToolEquip = tChar.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            local match = lp.Backpack:FindFirstChild(child.Name)
            if match then pcall(function() myHum:EquipTool(match) end) end
        end
    end)

    --// The Mirror Loop
    local lastLook = Vector3.new(0,0,-1)
    self.State.Connections.MainLoop = self.Services.RunService.Heartbeat:Connect(function()
        if not (tChar.Parent and tRoot.Parent and myChar.Parent) then
            return self:_cleanup()
        end

        local now = os.clock()
        
        -- 1. Physics & Position Mirroring
        local lv = tRoot.CFrame.LookVector
        local flat = Vector3.new(lv.X, 0, lv.Z)
        if flat.Magnitude >= 1e-4 then lastLook = flat.Unit end
        
        table.insert(self.State.PoseQueue, {
            t = now, 
            pos = tRoot.Position, 
            look = lastLook, 
            vel = tRoot.AssemblyLinearVelocity, 
            angY = tRoot.AssemblyAngularVelocity.Y
        })

        local snap
        while self.State.PoseHead <= #self.State.PoseQueue and self.State.PoseQueue[self.State.PoseHead].t <= (now - self.State.Delay) do
            snap = self.State.PoseQueue[self.State.PoseHead]
            self.State.PoseHead = self.State.PoseHead + 1
        end

        if snap then
            myRoot.CFrame = CFrame.lookAt(snap.pos, snap.pos + snap.look)
            myRoot.AssemblyLinearVelocity = snap.vel
            myRoot.AssemblyAngularVelocity = Vector3.new(0, snap.angY, 0)
            
            -- Buffer cleanup
            if self.State.PoseHead > 64 then
                local newBuf = {}
                for i = self.State.PoseHead, #self.State.PoseQueue do table.insert(newBuf, self.State.PoseQueue[i]) end
                self.State.PoseQueue, self.State.PoseHead = newBuf, 1
            end
        end

        -- 2. Animation Event Processing
        while self.State.AnimHead <= #self.State.AnimEvents and self.State.AnimEvents[self.State.AnimHead].t <= now do
            local e = self.State.AnimEvents[self.State.AnimHead]
            self.State.AnimHead = self.State.AnimHead + 1

            if e.kind == "start" and e.animId ~= "" then
                self.State.UID = self.State.UID + 1
                local animObj = Instance.new("Animation")
                animObj.AnimationId = e.animId
                local mt = myAnimator:LoadAnimation(animObj)
                
                pcall(function()
                    mt:Play(0, 1, 1)
                    mt:AdjustSpeed(0)
                    mt.TimePosition = e.baseTP
                end)

                self.State.ActiveSlots[self.State.UID] = {
                    mt = mt, 
                    track = e.track, 
                    baseTP = e.baseTP, 
                    segments = {{t = e.t, speed = e.speed}},
                    looped = e.looped,
                    alive = true
                }
            elseif e.kind == "speed" then
                for _, s in pairs(self.State.ActiveSlots) do
                    if s.alive and s.track == e.track then
                        table.insert(s.segments, {t = e.t, speed = e.speed})
                    end
                end
            elseif e.kind == "stop" then
                for id, s in pairs(self.State.ActiveSlots) do
                    if s.alive and s.track == e.track then
                        pcall(function() s.mt:Stop(0) end)
                        s.alive = false
                        self.State.ActiveSlots[id] = nil
                    end
                end
            end
        end

        -- 3. Precision Animation Sync (Manual Time Stepping)
        for _, s in pairs(self.State.ActiveSlots) do
            if s.alive and s.mt then
                local len = s.mt.Length
                if len > 0 then
                    local tp = s.baseTP
                    for i = 1, #s.segments do
                        local st = s.segments[i].t
                        local sp = s.segments[i].speed
                        local en = (i < #s.segments) and s.segments[i+1].t or now
                        if en > st then tp = tp + (en - st) * sp end
                    end
                    tp = s.looped and (tp % len) or math.clamp(tp, 0, len - 0.03)
                    pcall(function() s.mt.TimePosition = tp end)
                end
            end
        end
    end)

    DoNotif("Mirror Active: Mimicking " .. target.Name, 2)
end

--// Initialize the module and register commands
function Modules.MirrorMimic:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "mimic",
        Aliases = {"mirror", "mclone", "mcopy", "mimi"},
        Description = "Clones a player's movement and animations."
    }, function(args)
        if #args == 0 then return DoNotif("Usage: ;mimic <PlayerName> [delay]", 3) end
        module:Enable(args[1], args[2] or 0)
    end)

    RegisterCommand({
        Name = "unmimic",
        Aliases = {"mstop", "moff", "stopmimic"},
        Description = "Stops movement mirroring."
    }, function()
        module:_cleanup()
        DoNotif("Mimic Disabled.", 2)
    end)
end

Modules.ServerHopper = {
    State = {
        IsSearching = false
    },
    Dependencies = {"HttpService", "TeleportService", "Players"},
    Services = {}
}

--[[
    Internal logic: Fetches and sorts servers.
    Mode: "High" (Fullest servers) or "Low" (Emptiest servers)
--]]
function Modules.ServerHopper:Hop(mode)
    if self.State.IsSearching then return end
    self.State.IsSearching = true

    local http = self.Services.HttpService
    local tp = self.Services.TeleportService
    local placeId = game.PlaceId
    local jobId = game.JobId

    DoNotif("Searching for a " .. (mode == "High" and "large" or "small") .. " server...", 3)

    task.spawn(function()
        local success, result = pcall(function()
            -- Fetch the first 100 public servers
            -- Note: game:HttpGet is required for cross-domain API calls in most executors
            return game:HttpGet(string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId))
        end)

        if not success or not result then
            self.State.IsSearching = false
            return DoNotif("Server Hop Error: Failed to fetch server list.", 3)
        end

        local data = http:JSONDecode(result)
        if not data or not data.data then
            self.State.IsSearching = false
            return DoNotif("Server Hop Error: Empty API response.", 3)
        end

        local serverList = data.data
        local candidates = {}

        -- Filter: Remove current server and full servers
        for _, server in ipairs(serverList) do
            if server.id ~= jobId and server.playing < server.maxPlayers then
                table.insert(candidates, server)
            end
        end

        if #candidates == 0 then
            self.State.IsSearching = false
            return DoNotif("No valid servers found in this batch.", 3)
        end

        -- Sort based on mode
        if mode == "High" then
            table.sort(candidates, function(a, b) return a.playing > b.playing end)
        else
            table.sort(candidates, function(a, b) return a.playing < b.playing end)
        end

        local target = candidates[1]
        DoNotif(string.format("Joining server [%d/%d players]...", target.playing, target.maxPlayers), 3)
        
        task.wait(0.5)
        
        local tpSuccess, tpErr = pcall(function()
            tp:TeleportToPlaceInstance(placeId, target.id, self.Services.Players.LocalPlayer)
        end)

        if not tpSuccess then
            warn("--> [ServerHopper] Teleport Failed:", tpErr)
            DoNotif("Teleport failed. Check console.", 3)
        end

        self.State.IsSearching = false
    end)
end

--// Initialize the module and register commands
function Modules.ServerHopper:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    -- Regular Server Hop (High population)
    RegisterCommand({
        Name = "serverhop",
        Aliases = {"shop", "hop"},
        Description = "Teleports you to a different, populated server."
    }, function()
        module:Hop("High")
    end)

    -- Small Server Hop (Low population)
    RegisterCommand({
        Name = "smallserverhop",
        Aliases = {"sshop", "smallhop", "minihop"},
        Description = "Teleports you to a server with the fewest players."
    }, function()
        module:Hop("Low")
    end)
end

Modules.ForceSpawn = {}
function Modules.ForceSpawn:Execute()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local localPlayer = Players.LocalPlayer

    if localPlayer.Character then
        DoNotif("Your character already exists. Use '.respawn' to reset a broken character.", 4)
        return
    end

    DoNotif("Attempting to trigger server-side spawn from nil character...", 2)

    local success, err = pcall(function()
        local tempModel = Instance.new("Model")
        tempModel.Name = "ZukaSpawnTrigger"
        tempModel.Parent = Workspace

        localPlayer.Character = tempModel
        
        task.wait()

        localPlayer.Character = nil

        tempModel:Destroy()
    end)

    if not success then
        warn("[ForceSpawn] Spawn trigger logic failed:", err)
        DoNotif("Spawn trigger failed. See developer console for details.", 4)
    end
end

function Modules.ForceSpawn:Initialize()
    RegisterCommand({
        Name = "spawn",
        Aliases = {"forcespawn"},
        Description = "Forces your character to spawn if you are stuck as a camera (no character)."
    }, function()
        Modules.ForceSpawn:Execute()
    end)
end

Modules.SuperPush = {
State = {
IsEnabled = false,
Connections = {},
Originals = setmetatable({}, {__mode = "k"})
},
Config = {
PUSH_FORCE = 900,
DENSITY = 100,
COOLDOWN = 0,
lastPushTime = 0
}
}
local HEAVY_PROPERTIES = PhysicalProperties.new(Modules.SuperPush.Config.DENSITY, 0.5, 0.5)
function Modules.SuperPush:_cleanupCharacter(character)
    if not character then return end
        if self.State.Connections.Touch then
            self.State.Connections.Touch:Disconnect()
            self.State.Connections.Touch = nil
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and self.State.Originals[part] then
                part.CustomPhysicalProperties = self.State.Originals[part]
                self.State.Originals[part] = nil
            end
        end
    end
    function Modules.SuperPush:_applyToCharacter(character)
        if not character then return end
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if not hrp then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not self.State.Originals[part] then
                            self.State.Originals[part] = part.CustomPhysicalProperties
                        end
                        part.CustomPhysicalProperties = HEAVY_PROPERTIES
                    end
                end
                self.State.Connections.Touch = hrp.Touched:Connect(function(otherPart)
                if os.clock() - self.Config.lastPushTime < self.Config.COOLDOWN then return end
                    local targetModel = otherPart:FindFirstAncestorWhichIsA("Model")
                    if not targetModel then return end
                        local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
                        if not targetPlayer or targetPlayer == LocalPlayer then return end
                            local direction = hrp.CFrame.LookVector
                            hrp.AssemblyLinearVelocity = direction * self.Config.PUSH_FORCE
                            self.Config.lastPushTime = os.clock()
                            task.wait()
                            if hrp and hrp.Parent then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                            end
                        end)
                    end
                    function Modules.SuperPush:Toggle()
                        self.State.IsEnabled = not self.State.IsEnabled
                        if self.State.IsEnabled then
                            DoNotif("Super Push Enabled (Force: " .. self.Config.PUSH_FORCE .. ", Density: " .. self.Config.DENSITY .. ")", 3)
                            if LocalPlayer.Character then
                                self:_applyToCharacter(LocalPlayer.Character)
                            end
                            self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
                            self:_applyToCharacter(character)
                        end)
                        self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
                        self:_cleanupCharacter(character)
                    end)
                else
                DoNotif("Super Push Disabled", 2)
                if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
                    if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
                        table.clear(self.State.Connections)
                        if LocalPlayer.Character then
                            self:_cleanupCharacter(LocalPlayer.Character)
                        end
                    end
                end
                RegisterCommand({
                Name = "superpush",
                Aliases = {"bump", "heavy"},
                Description = "Increases your mass and adds a velocity push when you bump into players."
                }, function()
                Modules.SuperPush:Toggle()
            end)
Modules.Aura = {
    State = {
        IsEnabled = false,
        Distance = 20,
        Connection = nil,
        Visualizer = nil,
        LastAttack = 0
    },
    Config = {
        ATTACK_INTERVAL = 0.1,
        VISUAL_TRANSPARENCY = 0.8,
        VISUAL_COLOR = Color3.fromRGB(255, 50, 50)
    }
}

function Modules.Aura:_createVisualizer()
    if self.State.Visualizer then self.State.Visualizer:Destroy() end
    
    local sphere = Instance.new("Part")
    sphere.Name = "AuraVisualizer"
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.one * (self.State.Distance * 2)
    sphere.Transparency = self.Config.VISUAL_TRANSPARENCY
    sphere.Color = self.Config.VISUAL_COLOR
    sphere.Material = Enum.Material.Neon
    sphere.CanCollide = false
    sphere.CanTouch = false
    sphere.CanQuery = false
    sphere.Anchored = true
    sphere.Parent = Workspace
    
    self.State.Visualizer = sphere
end

function Modules.Aura:_getAttackPart(): BasePart?
    local char = Players.LocalPlayer.Character
    if not char then return nil end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return nil end
    
    return tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
end

function Modules.Aura:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    
    if self.State.Visualizer then
        self.State.Visualizer:Destroy()
        self.State.Visualizer = nil
    end
    
    DoNotif("Kill Aura: DISABLED", 2)
end

function Modules.Aura:Enable()
    if not firetouchinterest then
        return DoNotif("Executor does not support 'firetouchinterest'.", 4)
    end
    
    self:Disable()
    self.State.IsEnabled = true
    self:_createVisualizer()
    
    self.State.Connection = RunService.Heartbeat:Connect(function()
        local char = Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp or not self.State.Visualizer then return end
        
        self.State.Visualizer.CFrame = hrp.CFrame
        
        if os.clock() - self.State.LastAttack < self.Config.ATTACK_INTERVAL then
            return
        end
        
        local weapon = self:_getAttackPart()
        if not weapon then return end
        
        self.State.LastAttack = os.clock()
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                
                if targetHrp and targetHum and targetHum.Health > 0 then
                    local mag = (targetHrp.Position - hrp.Position).Magnitude
                    if mag <= self.State.Distance then
                        pcall(function()
                            firetouchinterest(weapon, targetHrp, 0)
                            firetouchinterest(weapon, targetHrp, 1)
                        end)
                    end
                end
            end
        end
    end)
    
    DoNotif("Kill Aura: ENABLED (" .. self.State.Distance .. " studs)", 2)
end

function Modules.Aura:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "aura",
        Aliases = {"killaura", "ka"},
        Description = "Toggles a touch-based kill aura. Optional: ;aura [distance]"
    }, function(args)
        local dist = tonumber(args[1])
        if dist then
            module.State.Distance = dist
            if module.State.IsEnabled then
                module:Enable()
            end
        else
            if module.State.IsEnabled then
                module:Disable()
            else
                module:Enable()
            end
        end
    end)
end

Modules.HandleKill = {
    State = {
        ActiveTargets = {},
        HeartbeatConnection = nil
    }
}

function Modules.HandleKill:_getKillTool(): (Tool?, BasePart?)
    local character = Players.LocalPlayer.Character
    if not character then return nil, nil end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return nil, nil end
    
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    return tool, handle
end

function Modules.HandleKill:_process()
    local tool, handle = self:_getKillTool()
    if not tool or not handle then return end

    for target, _ in pairs(self.State.ActiveTargets) do
        pcall(function()
            if not target or not target.Parent or not target.Character then
                self.State.ActiveTargets[target] = nil
                return
            end

            local character = target.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if not humanoid or humanoid.Health <= 0 then
                return
            end

            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    firetouchinterest(handle, part, 0)
                    firetouchinterest(handle, part, 1)
                end
            end
        end)
    end
end

function Modules.HandleKill:ToggleTarget(player: Player)
    if self.State.ActiveTargets[player] then
        self.State.ActiveTargets[player] = nil
        DoNotif("HandleKill: Stopped for " .. player.Name, 2)
    else
        self.State.ActiveTargets[player] = true
        DoNotif("HandleKill: Targeting " .. player.Name, 2)
        
        if not self.State.HeartbeatConnection then
            self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function()
                if next(self.State.ActiveTargets) == nil then
                    self.State.HeartbeatConnection:Disconnect()
                    self.State.HeartbeatConnection = nil
                    return
                end
                self:_process()
            end)
        end
    end
end

function Modules.HandleKill:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "handlekill",
        Aliases = {"hkill", "touchkill"},
        Description = "Toggles a continuous touch-kill loop on a target using your equipped tool."
    }, function(args)
        if not firetouchinterest then
            return DoNotif("Error: Your executor does not support 'firetouchinterest'.", 4)
        end

        local targetName = table.concat(args, " ")
        if #targetName == 0 then
            return DoNotif("Usage: ;hkill <PlayerName>", 3)
        end

        local targetPlayer = Utilities.findPlayer(targetName)
        if targetPlayer then
            module:ToggleTarget(targetPlayer)
        else
            DoNotif("Player '" .. targetName .. "' not found.", 3)
        end
    end)
end
Modules.RemoteSpy = {
    State = {
        IsEnabled = false,
        UI = nil,
        OriginalNamecall = nil,
        BlockedRemotes = {},
        LoggedRemotes = {},
        SelectedPath = nil,
        Minimized = false,
        IgnoreList = {
            ["CharacterSoundEvent"] = true,
            ["MovementUpdate"] = true,
            ["UpdatePhysics"] = true
        }
    },
    Config = {
        ACCENT = Color3.fromRGB(255, 105, 180),
        MAX_LOGS = 15
    }
}

function Modules.RemoteSpy:_serialize(value: any, visited: {[table]: boolean}?): string
    local history = visited or {}
    local valueType = typeof(value)
    if history[value] and valueType == "table" then return '"*Circular*"' end
    if valueType == "string" then return string.format("%q", value)
    elseif valueType == "number" or valueType == "boolean" or valueType == "nil" then return tostring(value)
    elseif valueType == "Instance" then return "game." .. value:GetFullName()
    elseif valueType == "table" then
        history[value] = true
        local parts = {}
        for k, v in pairs(value) do
            local key = (typeof(k) == "number") and "" or "[" .. self:_serialize(k, history) .. "] = "
            table.insert(parts, key .. self:_serialize(v, history))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return '"<' .. valueType .. '>"'
end

function Modules.RemoteSpy:_applyStyle(obj: GuiObject, radius: number)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 4)
    c.Parent = obj
end

function Modules.RemoteSpy:_makeDraggable(frame: Frame, handle: Frame)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Modules.RemoteSpy:_addRemoteToList(remote: Instance)
    if not self.State.UI then return end
    local path = remote:GetFullName()
    if self.State.LoggedRemotes[path] then return end
    
    self.State.LoggedRemotes[path] = {Remote = remote, Calls = {}}
    local btn = Instance.new("TextButton", self.State.UI.RemoteList)
    btn.Name = path
    btn.Size = UDim2.new(1, -5, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = " " .. remote.Name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ClipsDescendants = true
    self:_applyStyle(btn, 2)
    
    btn.MouseButton1Click:Connect(function()
        self.State.SelectedPath = path
        self.State.UI.SelectedLabel.Text = path
        self.State.UI.BlockBtn.Text = self.State.BlockedRemotes[path] and "UNBLOCK" or "BLOCK"
        self.State.UI.BlockBtn.BackgroundColor3 = self.State.BlockedRemotes[path] and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        self:_updateHistory()
    end)
end

function Modules.RemoteSpy:_updateHistory()
    local h = self.State.UI.HistoryFrame
    for _, v in ipairs(h:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    local data = self.State.LoggedRemotes[self.State.SelectedPath]
    if not data then return end
    for i, args in ipairs(data.Calls) do
        local log = Instance.new("TextButton", h)
        log.Size = UDim2.new(1, -5, 0, 20)
        log.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        log.Text = " Call #" .. i
        log.TextColor3 = Color3.fromRGB(200, 200, 200)
        log.Font = Enum.Font.Code
        log.TextSize = 9
        log.TextXAlignment = Enum.TextXAlignment.Left
        self:_applyStyle(log, 2)
        log.MouseButton1Click:Connect(function() self:_populateInteractor(args) end)
    end
end

function Modules.RemoteSpy:_populateInteractor(args: table)
    local f = self.State.UI.Interactor
    for _, v in ipairs(f:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    for _, arg in ipairs(args) do
        local input = Instance.new("TextBox", f)
        input.Size = UDim2.new(1, -5, 0, 25)
        input.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        input.Text = self:_serialize(arg)
        input.TextColor3 = self.Config.ACCENT
        input.Font = Enum.Font.Code
        input.TextSize = 10
        input.ClearTextOnFocus = false
        self:_applyStyle(input, 2)
    end
end

function Modules.RemoteSpy:_createUI()
    if self.State.UI then 
        self.State.UI.Main.Visible = true 
        return 
    end
    
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "ForensicSpy_V3"
    local main = Instance.new("Frame", sg); main.Size = UDim2.fromOffset(750, 480); main.Position = UDim2.fromScale(0.5, 0.5); main.AnchorPoint = Vector2.new(0.5, 0.5); main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.ClipsDescendants = true
    self:_applyStyle(main, 6)
    
    local header = Instance.new("Frame", main); header.Size = UDim2.new(1, 0, 0, 30); header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1, -120, 1, 0); title.Position = UDim2.fromOffset(10, 0); title.Text = "FORENSIC REMOTE ANALYZER"; title.TextColor3 = self.Config.ACCENT; title.Font = Enum.Font.Code; title.TextXAlignment = "Left"; title.BackgroundTransparency = 1
    
    local exit = Instance.new("TextButton", header); exit.Size = UDim2.fromOffset(25, 25); exit.Position = UDim2.new(1, -30, 0.5, -12); exit.Text = "X"; exit.BackgroundColor3 = Color3.fromRGB(200, 50, 50); exit.TextColor3 = Color3.new(1, 1, 1)
    local min = Instance.new("TextButton", header); min.Size = UDim2.fromOffset(25, 25); min.Position = UDim2.new(1, -60, 0.5, -12); min.Text = "-"; min.BackgroundColor3 = Color3.fromRGB(50, 50, 60); min.TextColor3 = Color3.new(1, 1, 1)
    self:_applyStyle(exit, 4); self:_applyStyle(min, 4)
    
    local content = Instance.new("Frame", main); content.Size = UDim2.new(1, 0, 1, -30); content.Position = UDim2.fromOffset(0, 30); content.BackgroundTransparency = 1
    local left = Instance.new("ScrollingFrame", content); left.Size = UDim2.new(0.35, 0, 1, -10); left.Position = UDim2.fromOffset(10, 5); left.BackgroundTransparency = 1; left.AutomaticCanvasSize = "Y"; left.ScrollBarThickness = 2
    Instance.new("UIListLayout", left).Padding = UDim.new(0, 3)
    
    local right = Instance.new("Frame", content); right.Size = UDim2.new(0.6, 0, 1, -10); right.Position = UDim2.fromScale(0.38, 0.01); right.BackgroundTransparency = 1
    local s_label = Instance.new("TextLabel", right); s_label.Size = UDim2.new(1, 0, 0, 20); s_label.Text = "SELECT REMOTE"; s_label.TextColor3 = Color3.fromRGB(100, 100, 100); s_label.Font = Enum.Font.Code; s_label.BackgroundTransparency = 1; s_label.TextSize = 8; s_label.TextXAlignment = "Left"
    
    local history = Instance.new("ScrollingFrame", right); history.Size = UDim2.new(1, 0, 0.35, 0); history.Position = UDim2.fromOffset(0, 25); history.BackgroundColor3 = Color3.fromRGB(15, 15, 20); history.AutomaticCanvasSize = "Y"; history.ScrollBarThickness = 2
    Instance.new("UIListLayout", history).Padding = UDim.new(0, 2)
    
    local interactor = Instance.new("ScrollingFrame", right); interactor.Size = UDim2.new(1, 0, 0.35, 0); interactor.Position = UDim2.fromScale(0, 0.45); interactor.BackgroundColor3 = Color3.fromRGB(15, 15, 20); interactor.AutomaticCanvasSize = "Y"; interactor.ScrollBarThickness = 2
    Instance.new("UIListLayout", interactor).Padding = UDim.new(0, 4)
    
    local fire = Instance.new("TextButton", right); fire.Size = UDim2.new(0.48, 0, 0, 30); fire.Position = UDim2.new(0, 0, 1, -35); fire.BackgroundColor3 = Color3.fromRGB(50, 150, 80); fire.Text = "FIRE"; fire.TextColor3 = Color3.new(1, 1, 1); fire.Font = Enum.Font.Code
    local block = Instance.new("TextButton", right); block.Size = UDim2.new(0.48, 0, 0, 30); block.Position = UDim2.new(0.52, 0, 1, -35); block.BackgroundColor3 = Color3.fromRGB(150, 50, 50); block.Text = "BLOCK"; block.TextColor3 = Color3.new(1, 1, 1); block.Font = Enum.Font.Code
    self:_applyStyle(fire, 4); self:_applyStyle(block, 4)
    
    self.State.UI = {Main = main, RemoteList = left, HistoryFrame = history, Interactor = interactor, SelectedLabel = s_label, BlockBtn = block}
    self:_makeDraggable(main, header)
    
    exit.MouseButton1Click:Connect(function() main.Visible = false end)
    min.MouseButton1Click:Connect(function()
        self.State.Minimized = not self.State.Minimized
        TweenService:Create(main, TweenInfo.new(0.3), {Size = self.State.Minimized and UDim2.fromOffset(750, 30) or UDim2.fromOffset(750, 480)}):Play()
        content.Visible = not self.State.Minimized
    end)
    
    block.MouseButton1Click:Connect(function()
        if not self.State.SelectedPath then return end
        self.State.BlockedRemotes[self.State.SelectedPath] = not self.State.BlockedRemotes[self.State.SelectedPath]
        block.Text = self.State.BlockedRemotes[self.State.SelectedPath] and "UNBLOCK" or "BLOCK"
        block.BackgroundColor3 = self.State.BlockedRemotes[self.State.SelectedPath] and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    end)
    
    fire.MouseButton1Click:Connect(function()
        local data = self.State.LoggedRemotes[self.State.SelectedPath]
        if not data then return end
        local args = {}
        for _, box in ipairs(interactor:GetChildren()) do
            if box:IsA("TextBox") then
                local success, result = pcall(function() 
                    local func = loadstring("return " .. box.Text)
                    return func()
                end)
                table.insert(args, success and result or box.Text)
            end
        end
        if data.Remote:IsA("RemoteEvent") then 
            data.Remote:FireServer(unpack(args)) 
        else 
            task.spawn(function() 
                local res = data.Remote:InvokeServer(unpack(args))
                print("[INVOKE RESULT]:", self:_serialize(res))
            end) 
        end
    end)
    
    task.spawn(function()
        local function scan(container)
            for _, v in ipairs(container:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then self:_addRemoteToList(v) end
                if _ % 100 == 0 then task.wait() end
            end
        end
        scan(ReplicatedStorage)
        scan(workspace)
    end)
end

function Modules.RemoteSpy:_hook()
    local success, mt = pcall(getrawmetatable, game)
    if not success then return end
    local old = mt.__namecall
    self.State.OriginalNamecall = old
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(selfArg, ...)
        local method = getnamecallmethod()
        if (method == "FireServer" or method == "InvokeServer") then
            local path = selfArg:GetFullName()
            if Modules.RemoteSpy.State.BlockedRemotes[path] then return nil end
            if not Modules.RemoteSpy.State.IgnoreList[selfArg.Name] then
                local args = {...}
                task.spawn(function() Modules.RemoteSpy:_logRemoteCall(selfArg, args) end)
            end
        end
        return old(selfArg, ...)
    end)
    setreadonly(mt, true)
end

function Modules.RemoteSpy:_logRemoteCall(remote: Instance, args: {any})
    if not self.State.UI then return end
    local path = remote:GetFullName()
    self:_addRemoteToList(remote)
    local data = self.State.LoggedRemotes[path]
    table.insert(data.Calls, 1, args)
    if #data.Calls > self.Config.MAX_LOGS then table.remove(data.Calls) end
    if self.State.SelectedPath == path then self:_updateHistory() end
end

function Modules.RemoteSpy:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self:_createUI()
        if not self.State.OriginalNamecall then self:_hook() end
        DoNotif("Remote Spy Enabled.", 2)
    else
        if self.State.UI then self.State.UI.Main.Visible = false end
    end
end

function Modules.RemoteSpy:Initialize()
    local module = self
    RegisterCommand({
        Name = "remotespy",
        Aliases = {"rspy"},
        Description = "Elite Network Interceptor and Blocker."
    }, function()
        module:Toggle()
    end)
end


Modules.HeuristicRemoteBruteforcer = {
    State = {
        IsEnabled = false,
        Connection = nil,
        TargetQueue = {},
        FiredHistory = {},
        IsScanning = false
    },
    Config = {
        FIRE_DELAY = 0.25, 
        MAX_CALLS_PER_REMOTE = 15,
        -- [NEW] Blacklist of services that house internal/core remotes.
        BlacklistedParents = {
            game:GetService("CoreGui"),
            game:GetService("StarterGui"),
            game:GetService("ReplicatedFirst"),
            game:GetService("Chat")
        }
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

function Modules.HeuristicRemoteBruteforcer:_getHeuristicPayloads(remote: Instance)
    local payloads = {}
    local remoteName = remote.Name:lower()
    local localPlayer = self.Services.Players.LocalPlayer
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    table.insert(payloads, {true})
    table.insert(payloads, {false})
    table.insert(payloads, {1})
    table.insert(payloads, {0})
    table.insert(payloads, {""})
    table.insert(payloads, {nil})
    table.insert(payloads, {localPlayer})
    table.insert(payloads, {remote.Name})

    if root then
        table.insert(payloads, {root.Position})
        table.insert(payloads, {root.CFrame})
    end

    if remoteName:find("buy") then
        table.insert(payloads, {"Gems", 100}); table.insert(payloads, {"Sword", 0})
    end
    if remoteName:find("sell") then
        table.insert(payloads, {"Rock", 999})
    end
    if remoteName:find("equip") then
        table.insert(payloads, {"Sword"})
    end
     if remoteName:find("teleport") or remoteName:find("tp") then
        table.insert(payloads, {Vector3.new(0, 100, 0)})
    end

    return payloads
end

function Modules.HeuristicRemoteBruteforcer:_scanAndQueue()
    if self.State.IsScanning then return end
    self.State.IsScanning = true
    DoNotif("Bruteforcer: Scanning for new, non-core remotes...", 2)

    task.spawn(function()
        local remotesFound = 0
        local descendants = game:GetDescendants()
        for i, remote in ipairs(descendants) do
            if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                local path = remote:GetFullName()
                if not self.State.FiredHistory[path] then
                    -- [CRITICAL FIX] Check if the remote is inside a blacklisted service.
                    local isBlacklisted = false
                    for _, parentService in ipairs(self.Config.BlacklistedParents) do
                        if remote:IsDescendantOf(parentService) then
                            isBlacklisted = true
                            break
                        end
                    end

                    if not isBlacklisted then
                        table.insert(self.State.TargetQueue, remote)
                        self.State.FiredHistory[path] = true
                        remotesFound = remotesFound + 1
                    end
                end
            end
            if i % 500 == 0 then task.wait() end -- Yield to prevent freezing
        end
        DoNotif(string.format("Bruteforcer: Queued %d new remotes.", remotesFound), 3)
        self.State.IsScanning = false
    end)
end

function Modules.HeuristicRemoteBruteforcer:_processQueue()
    if #self.State.TargetQueue == 0 then return end
    if not self.State.IsEnabled then return end

    local remote = table.remove(self.State.TargetQueue, 1)
    if not (remote and remote.Parent) then return end

    print("--> [Bruteforcer] Fuzzing Remote:", remote:GetFullName())
    
    local payloads = self:_getHeuristicPayloads(remote)
    
    task.spawn(function()
        for i = 1, math.min(#payloads, self.Config.MAX_CALLS_PER_REMOTE) do
            if not self.State.IsEnabled then break end 
            
            local payload = payloads[i]
            if remote:IsA("RemoteEvent") then
                pcall(remote.FireServer, remote, unpack(payload))
            elseif remote:IsA("RemoteFunction") then
                local success, result = pcall(remote.InvokeServer, remote, unpack(payload))
                if success then
                    print("    - Invoke SUCCESS. Result:", result)
                end
            end
            task.wait(self.Config.FIRE_DELAY)
        end
    end)
end

function Modules.HeuristicRemoteBruteforcer:Enable(): ()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self:_scanAndQueue()

    self.State.Connection = self.Services.RunService.Heartbeat:Connect(function()
        self:_processQueue()
    end)
    DoNotif("Heuristic Bruteforcer: ENABLED", 2)
end

function Modules.HeuristicRemoteBruteforcer:Disable(): ()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    
    self.State.TargetQueue = {}
    DoNotif("Heuristic Bruteforcer: DISABLED. Queue cleared.", 2)
end

function Modules.HeuristicRemoteBruteforcer:Initialize(): ()
    RegisterCommand({
        Name = "autofire",
        Aliases = {"bruteforce", "fuzz"},
        Description = "Toggles the heuristic remote bruteforcer to find insecure remotes."
    }, function()
        if self.State.IsEnabled then self:Disable() else self:Enable() end
    end)

    RegisterCommand({
        Name = "clearfiredhistory",
        Description = "Clears the history of fired remotes, allowing a new scan."
    }, function()
        self.State.FiredHistory = {}
        DoNotif("Bruteforcer history cleared. You can now scan again.", 2)
    end)
end


Modules.Strengthen = {
State = {
Enabled = false,
Density = 100,
OriginalProperties = {},
},
}
function Modules.Strengthen:ApplyToCharacter(character)
    table.clear(self.State.OriginalProperties)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.State.OriginalProperties[part] = part.CustomPhysicalProperties
            part.CustomPhysicalProperties = PhysicalProperties.new(self.State.Density, 0.3, 0.5)
        end
    end
end
function Modules.Strengthen:RevertForCharacter()
    local character = Players.LocalPlayer.Character
    if not character then return end
        for part, originalProperties in pairs(self.State.OriginalProperties) do
            if part and part.Parent and part:IsDescendantOf(character) then
                part.CustomPhysicalProperties = originalProperties
            end
        end
        table.clear(self.State.OriginalProperties)
    end
    function Modules.Strengthen:Initialize()
        local module = self
        RegisterCommand({
        Name = "strengthen",
        Aliases = {"buff", "density"},
        Description = "Toggles high character density to resist forces. Optional [density] argument."
        }, function(args)
        local character = Players.LocalPlayer.Character
        if not character then
            return DoNotif("Character not found.", 3)
        end
        local newDensity = tonumber(args[1])
        if newDensity and newDensity > 0 then
            module.State.Density = newDensity
            DoNotif("Strengthen density set to " .. module.State.Density, 2)
        end
        if module.State.Enabled then
            module:RevertForCharacter()
            module.State.Enabled = false
            DoNotif("Strengthen disabled. Character physics restored.", 2)
        else
        module:ApplyToCharacter(character)
        module.State.Enabled = true
        DoNotif("Strengthen enabled at density " .. module.State.Density, 2)
    end
end)
end

Modules.AntiAnchor = {
    State = {
        Enabled = false,
        TrackedParts = setmetatable({}, {__mode="k"}),
        OriginalProperties = setmetatable({}, {__mode="k"}),
        Signals = setmetatable({}, {__mode="k"}),
        CharacterConnections = {},
        FailsafeConnection = nil,
    },
    Dependencies = {"Players", "RunService"},
}

function Modules.AntiAnchor:Enforce(part)
    if not (part and part:IsA("BasePart")) then return end
    
    if self.State.OriginalProperties[part] == nil then
        self.State.OriginalProperties[part] = part.Anchored
    end
    
    self.State.TrackedParts[part] = true
    if part.Anchored then part.Anchored = false end
    
    if not self.State.Signals[part] then
        self.State.Signals[part] = part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if self.State.Enabled and part.Anchored then
                part.Anchored = false
            end
        end)
    end
end

function Modules.AntiAnchor:ProcessCharacter(character)
    for _, child in ipairs(character:GetDescendants()) do self:Enforce(child) end
    
    table.insert(self.State.CharacterConnections, character.DescendantAdded:Connect(function(child) self:Enforce(child) end))
    table.insert(self.State.CharacterConnections, character.DescendantRemoving:Connect(function(child)
        if self.State.Signals[child] then
            self.State.Signals[child]:Disconnect()
            self.State.Signals[child] = nil
        end
        self.State.TrackedParts[child] = nil
        self.State.OriginalProperties[child] = nil
    end))
end

function Modules.AntiAnchor:Enable()
    if self.State.Enabled then return end
    self.State.Enabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then self:ProcessCharacter(localPlayer.Character) end
    
    table.insert(self.State.CharacterConnections, localPlayer.CharacterAdded:Connect(function(char) self:ProcessCharacter(char) end))
    
    self.State.FailsafeConnection = self.Services.RunService.Stepped:Connect(function()
        for part in pairs(self.State.TrackedParts) do
            if part and part.Anchored then part.Anchored = false end
        end
    end)
    DoNotif("Anti-Anchor enabled.", 2)
end

function Modules.AntiAnchor:Disable()
    if not self.State.Enabled then return end
    self.State.Enabled = false
    
    for _, conn in ipairs(self.State.CharacterConnections) do conn:Disconnect() end
    for _, conn in pairs(self.State.Signals) do conn:Disconnect() end
    if self.State.FailsafeConnection then self.State.FailsafeConnection:Disconnect() end
    
    for part, originalValue in pairs(self.State.OriginalProperties) do
        if part and part.Parent then part.Anchored = originalValue end
    end
    
    table.clear(self.State.TrackedParts)
    table.clear(self.State.OriginalProperties)
    table.clear(self.State.Signals)
    table.clear(self.State.CharacterConnections)
    self.State.FailsafeConnection = nil
    
    DoNotif("Anti-Anchor disabled.", 2)
end

function Modules.AntiAnchor:Initialize()
    -- ARCHITECT'S NOTE: The 'Initialize' function is where dependencies should be loaded.
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "antianchor",
        Aliases = {"aanchor"},
        Description = "Toggles a robust defense against being anchored."
    }, function()
        -- The previous logic was slightly flawed; calling self:Enable/Disable directly is cleaner.
        if self.State.Enabled then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.TeleportTool = {
    State = {},
    Dependencies = {"Players"},
    Services = {}
}

function Modules.TeleportTool:Create()
    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then
        return DoNotif("Teleport Tool creation failed: LocalPlayer not found.", 3)
    end

    if localPlayer.Backpack:FindFirstChild("Teleport Tool") or (localPlayer.Character and localPlayer.Character:FindFirstChild("Teleport Tool")) then
        return DoNotif("You already have the Teleport Tool.", 2)
    end

    local tpTool = Instance.new("Tool")
    tpTool.Name = "Teleport Tool"
    tpTool.RequiresHandle = false
    tpTool.Parent = localPlayer.Backpack

    local mouse = localPlayer:GetMouse()

    tpTool.Activated:Connect(function()
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return DoNotif("Could not find HumanoidRootPart to teleport.", 3)
        end

        local success, hitPosition = pcall(function() return mouse.Hit.Position end)
        if not success or not hitPosition then
            return DoNotif("No valid target position under cursor.", 2)
        end
        
        local newPosition = hitPosition + Vector3.new(0, 3, 0)
        hrp.CFrame = CFrame.new(newPosition) * (hrp.CFrame - hrp.CFrame.Position)
    end)

    DoNotif("Teleport Tool has been added to your backpack.", 2)
end

function Modules.TeleportTool:Initialize()
    local module = self
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "tptool",
        Aliases = {"teleporttool"},
        Description = "Gives you a tool that teleports you to your mouse cursor on click."
    }, function()
        module:Create()
    end)
end

Modules.FakeLag = {
    State = {
        IsEnabled = false,
        LoopConnection = nil,
        IsCharacterAnchored = false, -- The current anchor state in the loop
        NextFlipTimestamp = 0,     -- The os.clock() time for the next state flip
        StartTime = 0              -- The time the effect was enabled, for duration checks
    },
    Config = {
        Interval = 0.05, -- The base time (in seconds) between anchoring/unanchoring
        Jitter = 0.02,   -- Random time added/subtracted from the interval
        Duration = nil   -- How long the effect should last in seconds (nil = infinite)
    },
    Dependencies = {"RunService", "Players"},
    Services = {}
}

---
-- [Private] The core logic loop that toggles the anchored state.
--
function Modules.FakeLag:_onHeartbeat()
    -- Failsafe: if the module is disabled but the loop is still running, kill it.
    if not self.State.IsEnabled then
        self:Disable()
        return
    end

    local localPlayer = self.Services.Players.LocalPlayer
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    -- If the character is gone, disable the module to clean up.
    if not hrp then
        self:Disable()
        return
    end

    -- Check if the duration has expired.
    if self.Config.Duration and (os.clock() - self.State.StartTime) > self.Config.Duration then
        self:Disable()
        return
    end

    -- The main toggle logic.
    local now = os.clock()
    if now >= self.State.NextFlipTimestamp then
        self.State.IsCharacterAnchored = not self.State.IsCharacterAnchored
        pcall(function() hrp.Anchored = self.State.IsCharacterAnchored end)

        -- Calculate the next interval with random jitter.
        local interval = self.Config.Interval
        local jitter = self.Config.Jitter
        local nextDelay = interval + (jitter > 0 and (math.random() * 2 * jitter - jitter) or 0)
        
        self.State.NextFlipTimestamp = now + math.max(0, nextDelay)
    end
end

---
-- Disables the fake lag effect and restores the character to a normal state.
--
function Modules.FakeLag:Disable()
    if not self.State.IsEnabled then return end

    if self.State.LoopConnection then
        self.State.LoopConnection:Disconnect()
        self.State.LoopConnection = nil
    end

    self.State.IsEnabled = false
    
    -- [CRITICAL] Ensure the player is unanchored upon disabling.
    task.spawn(function()
        local hrp = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function() hrp.Anchored = false end)
        end
    end)
    
    DoNotif("Fake Lag disabled.", 2)
end

---
-- Enables the fake lag effect, optionally updating its configuration.
--
function Modules.FakeLag:Enable(interval, jitter, duration)
    -- Always disable first to ensure a clean start and prevent duplicate loops.
    self:Disable()

    -- Safely parse and update config values.
    local newInterval = tonumber(interval)
    local newJitter = tonumber(jitter)
    local newDuration = tonumber(duration)

    if newInterval then self.Config.Interval = math.max(0, newInterval) end
    if newJitter then self.Config.Jitter = math.max(0, newJitter) end
    self.Config.Duration = (newDuration and newDuration > 0) and newDuration or nil

    -- Initialize state for the new session.
    self.State.IsEnabled = true
    self.State.StartTime = os.clock()
    self.State.NextFlipTimestamp = os.clock()
    self.State.IsCharacterAnchored = false

    -- Connect the core loop.
    self.State.LoopConnection = self.Services.RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)

    DoNotif("Fake Lag enabled.", 2)
end

---
-- Initializes the module and registers its commands.
--
function Modules.FakeLag:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "fakelag",
        Aliases = {"flag"},
        Description = "Toggles fake lag."
    }, function(args)
        local arg1 = args[1]
        
        if arg1 and (arg1:lower() == "off" or arg1:lower() == "stop") then
            module:Disable()
        else
            -- If already enabled and no new args, treat it as a toggle to turn it off.
            if module.State.IsEnabled and #args == 0 then
                module:Disable()
            else
                -- Enable with optional arguments.
                module:Enable(args[1], args[2], args[3])
            end
        end
    end)

    RegisterCommand({
        Name = "unfakelag",
        Aliases = {"unflag"},
        Description = "Stops the fake lag command."
    }, function()
        module:Disable()
    end)
end

Modules.ClickDetectorTools = {
    State = {},
    Dependencies = {"Workspace"},
    Services = {}
}

function Modules.ClickDetectorTools:Initialize()
    self.Services.Workspace = game:GetService("Workspace")

    RegisterCommand({
        Name = "noclickdetectorlimits",
        Aliases = {"nocdlimits", "removecdlimits"},
        Description = "Removes the distance limit for all ClickDetectors in the workspace."
    }, function()
        local count = 0
        for _, v in ipairs(self.Services.Workspace:GetDescendants()) do
            if v:IsA("ClickDetector") then
                v.MaxActivationDistance = math.huge
                count = count + 1
            end
        end
        DoNotif("Removed distance limits on " .. count .. " ClickDetectors.", 2)
    end)

    RegisterCommand({
        Name = "fireclickdetectors",
        Aliases = {"firecd", "firecds"},
        Description = "Fires all ClickDetectors in the workspace, or a specific one by name."
    }, function(args)
        if not fireclickdetector then
            return DoNotif("Environment does not support 'fireclickdetector'.", 4)
        end

        local count = 0
        if args[1] then
            local name = table.concat(args, " ")
            for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
                if descendant:IsA("ClickDetector") and (descendant.Name == name or descendant.Parent.Name == name) then
                    fireclickdetector(descendant)
                    count = count + 1
                end
            end
        else
            for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
                if descendant:IsA("ClickDetector") then
                    fireclickdetector(descendant)
                    count = count + 1
                end
            end
        end
        DoNotif("Fired " .. count .. " ClickDetector(s).", 2)
    end)
end

Modules.ProximityPromptTools = {
    State = {
        InstantPromptConnection = nil
    },
    Dependencies = {"Workspace", "ProximityPromptService"},
    Services = {}
}

function Modules.ProximityPromptTools:DisableInstantPrompts()
    if self.State.InstantPromptConnection then
        self.State.InstantPromptConnection:Disconnect()
        self.State.InstantPromptConnection = nil
        DoNotif("Instant Proximity Prompts: DISABLED", 2)
    end
end

function Modules.ProximityPromptTools:EnableInstantPrompts()
    if not fireproximityprompt then
        return DoNotif("Environment does not support 'fireproximityprompt'.", 4)
    end
    self:DisableInstantPrompts()
    
    self.State.InstantPromptConnection = self.Services.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        fireproximityprompt(prompt)
    end)
    DoNotif("Instant Proximity Prompts: ENABLED", 2)
end

function Modules.ProximityPromptTools:Initialize()
    for _, serviceName in ipairs(self.Dependencies) do
        self.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "noproximitypromptlimits",
        Aliases = {"nopplimits", "removepplimits"},
        Description = "Removes the distance limit for all ProximityPrompts."
    }, function()
        local count = 0
        for _, v in pairs(self.Services.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.MaxActivationDistance = math.huge
                count = count + 1
            end
        end
        DoNotif("Removed distance limits on " .. count .. " ProximityPrompts.", 2)
    end)

    RegisterCommand({
        Name = "fireproximityprompts",
        Aliases = {"firepp"},
        Description = "Fires all ProximityPrompts, or a specific one by name."
    }, function(args)
        if not fireproximityprompt then
            return DoNotif("Environment does not support 'fireproximityprompt'.", 4)
        end
        local count = 0
        if args[1] then
            local name = table.concat(args, " ")
            for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") and (descendant.Name == name or descendant.Parent.Name == name) then
                    fireproximityprompt(descendant)
                    count = count + 1
                end
            end
        else
            for _, descendant in ipairs(self.Services.Workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    fireproximityprompt(descendant)
                    count = count + 1
                end
            end
        end
        DoNotif("Fired " .. count .. " ProximityPrompt(s).", 2)
    end)

    RegisterCommand({
        Name = "instantproximityprompts",
        Aliases = {"instantpp"},
        Description = "Toggles instant triggering of proximity prompts."
    }, function()
        if self.State.InstantPromptConnection then
            self:DisableInstantPrompts()
        else
            self:EnableInstantPrompts()
        end
    end)

    RegisterCommand({
        Name = "uninstantproximityprompts",
        Aliases = {"uninstantpp"},
        Description = "Explicitly disables instant proximity prompts."
    }, function()
        self:DisableInstantPrompts()
    end)
end

Modules.RevealInvisible = {
    State = {
        Connection = nil,
        OriginalTransparency = setmetatable({}, {__mode="k"}),
    },
    Dependencies = {"RunService", "Workspace"},
}

function Modules.RevealInvisible:Disable()
    if not self.State.Connection then return end
    
    self.State.Connection:Disconnect()
    self.State.Connection = nil
    
    for part, originalValue in pairs(self.State.OriginalTransparency) do
        if part and part.Parent then
            part.Transparency = originalValue
        end
    end
    
    table.clear(self.State.OriginalTransparency)
    DoNotif("Invisible parts have been hidden again.", 2)
end

function Modules.RevealInvisible:Enable()
    self:Disable() -- Ensure any previous state is cleared before running.
    
    local partsRevealed = 0
    for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency > 0.95 then
            if self.State.OriginalTransparency[part] == nil then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
                partsRevealed = partsRevealed + 1
            end
        end
    end
    
    DoNotif("Initial scan revealed " .. partsRevealed .. " invisible parts.", 2)
    
    self.State.Connection = self.Services.RunService.RenderStepped:Connect(function()
        for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency > 0.95 and not self.State.OriginalTransparency[part] then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
            end
        end
    end)
end

function Modules.RevealInvisible:Initialize()
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "invisibleparts",
        Aliases = {"invisparts", "showinvisible"},
        Description = "Toggles the visibility of all invisible parts in the workspace."
    }, function()
        if self.State.Connection then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.GripEditor = {
    State = {
        UI = {}, -- Will hold all UI instances (ScreenGui, TextBoxes, etc.)
        GripConnection = nil -- Stores the RBXScriptConnection for the .Changed event
    },
    Dependencies = {"Players", "CoreGui", "UserInputService"},
    Services = {}
}


function Modules.GripEditor:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            -- Disconnect the drag on input release
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.GripEditor:_applyGrip()
    local localPlayer = self.Services.Players.LocalPlayer
    local char = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    local tool = char and char:FindFirstChildOfClass("Tool")

    if not (tool and backpack) then
        return DoNotif("You must be holding a tool to edit its grip.", 3)
    end
    
    -- Disconnect any previous connection to prevent stacking/leaks.
    if self.State.GripConnection then
        self.State.GripConnection:Disconnect()
        self.State.GripConnection = nil
    end

    -- Helper to safely get number values from textboxes
    local function getVal(name)
        return tonumber(self.State.UI.TextBoxes[name].Text) or 0
    end

    -- Construct the new CFrame from UI inputs
    local pos = Vector3.new(getVal("X"), getVal("Y"), getVal("Z"))
    local rot = Vector3.new(getVal("RX"), getVal("RY"), getVal("RZ"))
    local gripCFrame = CFrame.new(pos) * CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))

    -- Re-equip the tool to apply the new grip property
    tool.Parent = backpack
    task.wait()
    tool.Grip = gripCFrame
    tool.Parent = char

    -- This connection "fights" the game engine if it tries to reset the grip.
    self.State.GripConnection = tool.Changed:Connect(function(property)
        if property == "Grip" and tool.Grip ~= gripCFrame then
            tool.Grip = gripCFrame
        end
    end)

end


function Modules.GripEditor:CreateUI()
    if self.State.UI.ScreenGui then return end -- UI already exists

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GripEditorUI_Module"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = self.Services.CoreGui
    self.State.UI.ScreenGui = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 270)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Grip Position Editor"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = titleBar

    -- Create input boxes for Position and Rotation
    local labels = {"X", "Y", "Z", "RX", "RY", "RZ"}
    self.State.UI.TextBoxes = {}
    for i, label in ipairs(labels) do
        local xOffset = ((i - 1) % 3) * 100
        local yOffset = 40 + math.floor((i - 1) / 3) * 50

        local labelUI = Instance.new("TextLabel", frame)
        labelUI.Size = UDim2.fromOffset(40, 25)
        labelUI.Position = UDim2.fromOffset(10 + xOffset, yOffset)
        labelUI.BackgroundTransparency = 1
        labelUI.Text = label
        labelUI.TextColor3 = Color3.fromRGB(255, 255, 255)
        labelUI.Font = Enum.Font.Gotham
        labelUI.TextSize = 14

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.fromOffset(50, 25)
        box.Position = UDim2.fromOffset(50 + xOffset, yOffset)
        box.PlaceholderText = "0"
        box.Text = ""
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.ClearTextOnFocus = false
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        self.State.UI.TextBoxes[label] = box
    end
    
    -- Create control buttons
    local previewBtn = Instance.new("TextButton", frame)
    previewBtn.Size = UDim2.fromOffset(280, 28)
    previewBtn.Position = UDim2.fromOffset(20, 150)
    previewBtn.Text = "Preview Changes"
    previewBtn.Font = Enum.Font.GothamBold
    previewBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 95)
    previewBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", previewBtn).CornerRadius = UDim.new(0, 4)

    local applyBtn = Instance.new("TextButton", frame)
    applyBtn.Size = UDim2.fromOffset(135, 32)
    applyBtn.Position = UDim2.fromOffset(20, 200)
    applyBtn.Text = "Apply & Close"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    applyBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.fromOffset(135, 32)
    closeBtn.Position = UDim2.fromOffset(165, 200)
    closeBtn.Text = "Close"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    -- Connect button events
    previewBtn.MouseButton1Click:Connect(function() self:_applyGrip() end)
    applyBtn.MouseButton1Click:Connect(function() self:_applyGrip(); self:DestroyUI() end)
    closeBtn.MouseButton1Click:Connect(function() self:DestroyUI() end)

    -- Make it draggable
    self:_makeDraggable(frame, titleBar)
    DoNotif("Grip Editor opened.", 2)
end

---
-- Destroys the user interface and cleans up state.
--
function Modules.GripEditor:DestroyUI()
    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui:Destroy()
    end
    if self.State.GripConnection then
        self.State.GripConnection:Disconnect()
    end
    self.State = { UI = {} } -- Reset the state table
    DoNotif("Grip Editor closed.", 2)
end


function Modules.GripEditor:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "grippos",
        Aliases = {"setgrip", "gripeditor"},
        Description = "Toggles a UI to manually edit your tool's grip CFrame."
    }, function()
        -- This command now acts as a toggle.
        if module.State.UI.ScreenGui then
            module:DestroyUI()
        else
            module:CreateUI()
        end
    end)
end

Modules.AnimationBuilder = {
    State = {
        UI = nil, 
        OriginalAnimations = nil 
    },
    Dependencies = {"Players", "CoreGui", "TweenService", "UserInputService"},
    Services = {}
}

function Modules.AnimationBuilder:_makeDraggable(guiObject, dragHandle)
    local isDragging = false
    local dragStart, startPosition

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPosition = guiObject.Position
            
            local inputEndedConn
            inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == input.UserInputType then
                    isDragging = false
                    inputEndedConn:Disconnect()
                end
            end)
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end


function Modules.AnimationBuilder:DestroyUI()
    if not self.State.UI then return end

    local mainFrame = self.State.UI.main
    local tween = self.Services.TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        Size = UDim2.fromScale(0.01, 0.01),
        Position = UDim2.new(0.99, 0, 0.01, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Wait()
    
    self.State.UI.screenGui:Destroy()
    self.State.UI = nil
    DoNotif("Animation Builder closed.", 2)
end

function Modules.AnimationBuilder:CreateUI()
    if self.State.UI then return end

    local localPlayer = self.Services.Players.LocalPlayer
    local char = localPlayer.Character
    local animateScript = char and char:FindFirstChild("Animate")

    if not animateScript then
        return DoNotif("Could not find 'Animate' script in character.", 4)
    end
    
    if not self.State.OriginalAnimations then
        self.State.OriginalAnimations = {}
        for _, valueObject in ipairs(animateScript:GetChildren()) do
            if valueObject:IsA("StringValue") then
                local anim = valueObject:FindFirstChildOfClass("Animation")
                if anim then
                    self.State.OriginalAnimations[valueObject.Name:lower()] = anim.AnimationId
                end
            end
        end
    end

    self.State.UI = {}
    local ui = self.State.UI

    ui.screenGui = Instance.new("ScreenGui")
    ui.screenGui.Name = "AnimationBuilder_Module"
    ui.screenGui.ResetOnSpawn = false
    ui.screenGui.Parent = self.Services.CoreGui
    
    ui.main = Instance.new("Frame", ui.screenGui)
    ui.main.Size = UDim2.new(0, 400, 0, 450)
    ui.main.Position = UDim2.fromScale(0.5, 0.5)
    ui.main.AnchorPoint = Vector2.new(0.5, 0.5)
    ui.main.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    ui.main.BorderSizePixel = 0
    Instance.new("UICorner", ui.main).CornerRadius = UDim.new(0, 8)

    local header = Instance.new("Frame", ui.main)
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.fromOffset(15, 0)
    title.BackgroundTransparency = 1
    title.Text = "Animation Builder"
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.fromOffset(40, 40)
    closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20

    local scroll = Instance.new("ScrollingFrame", ui.main)
    scroll.Size = UDim2.new(1, 0, 1, -100)
    scroll.Position = UDim2.fromOffset(0, 40)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- [CRITICAL FIX] The incorrect UIPadding line has been replaced with the correct properties.
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingTop = UDim.new(0, 15)

    local footer = Instance.new("Frame", ui.main)
    footer.Size = UDim2.new(1, 0, 0, 60)
    footer.Position = UDim2.new(0, 0, 1, -60)
    footer.BackgroundTransparency = 1
    
    local saveBtn = Instance.new("TextButton", footer)
    saveBtn.Size = UDim2.new(0.5, -15, 0.7, 0)
    saveBtn.Position = UDim2.fromOffset(10, 10)
    saveBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 80)
    saveBtn.Text = "💾 Save"
    saveBtn.TextColor3 = Color3.new(1,1,1)
    saveBtn.Font = Enum.Font.GothamSemibold
    saveBtn.TextSize = 16
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

    local revertBtn = saveBtn:Clone()
    revertBtn.Position = UDim2.new(0.5, 5, 0, 10)
    revertBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
    revertBtn.Text = "↩️ Revert"
    revertBtn.Parent = footer
    
    ui.inputs = {}
    local states = {"Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Sit"}
    for _, name in ipairs(states) do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0.25, 0, 1, 0)
        label.Position = UDim2.fromOffset(10, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextSize = 15

        local box = Instance.new("TextBox", row)
        box.Size = UDim2.new(0.75, -20, 0.8, 0)
        box.Position = UDim2.new(0.25, 0, 0.5, 0)
        box.AnchorPoint = Vector2.new(0, 0.5)
        box.PlaceholderText = "rbxassetid://"
        box.ClearTextOnFocus = false
        box.TextColor3 = Color3.new(1,1,1)
        box.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        box.Font = Enum.Font.Code
        box.TextSize = 14
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        
        ui.inputs[name:lower()] = box
    end

    local function applyAnims(mode)
        local currentAnimate = localPlayer.Character and localPlayer.Character:FindFirstChild("Animate")
        if not currentAnimate then return DoNotif("Animate script not found.", 3) end

        for stateName, animId in pairs(mode == "save" and ui.inputs or self.State.OriginalAnimations) do
            local valueObj = currentAnimate:FindFirstChild(stateName, true)
            if valueObj then
                local anim = valueObj:FindFirstChildOfClass("Animation")
                if anim then
                    if mode == "save" then
                        local text = animId.Text 
                        if tonumber(text) then
                            anim.AnimationId = "rbxassetid://" .. text
                        end
                    else
                        anim.AnimationId = animId 
                        local num = animId:match("%d+")
                        if num and ui.inputs[stateName] then
                            ui.inputs[stateName].Text = num
                        end
                    end
                end
            end
        end
        DoNotif(mode == "save" and "Animations saved." or "Animations reverted.", 2)
    end
    
    for stateName, textBox in pairs(ui.inputs) do
        local originalId = self.State.OriginalAnimations[stateName]
        if originalId then
            local num = originalId:match("%d+")
            if num then textBox.Text = num end
        end
    end

    closeBtn.MouseButton1Click:Connect(function() self:DestroyUI() end)
    saveBtn.MouseButton1Click:Connect(function() applyAnims("save") end)
    revertBtn.MouseButton1Click:Connect(function() applyAnims("revert") end)
    
    self:_makeDraggable(ui.main, header)
    DoNotif("Animation Builder opened.", 2)
end

function Modules.AnimationBuilder:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "animbuilder",
        Aliases = {"abuilder"},
        Description = "Toggles a UI to edit your character's default animations."
    }, function()
        if module.State.UI then
            module:DestroyUI()
        else
            module:CreateUI()
        end
    end)
end

Modules.CharacterMorph = {
    State = {
        IsMorphed = false,
        OriginalDescription = nil,
        CharacterAddedConnection = nil
    },
    Dependencies = {"Players"},
    Services = {}
}


function Modules.CharacterMorph:_resolveDescription(target: string)
    local targetId = tonumber(target)
    
    -- If the target is not a valid number, assume it's a username and get the ID.
    if not targetId then
        local success, idFromName = pcall(function()
            return self.Services.Players:GetUserIdFromNameAsync(target)
        end)
        if not success or not idFromName then
            DoNotif("Could not find a user with the name: " .. tostring(target), 3)
            return nil
        end
        targetId = idFromName
    end
    
    -- Now, fetch the HumanoidDescription using the resolved UserId.
    DoNotif("Loading avatar for UserId: " .. targetId, 1.5)
    local success, description = pcall(function()
        return self.Services.Players:GetHumanoidDescriptionFromUserId(targetId)
    end)
    
    if not success or not description then
        DoNotif("Unable to load avatar description for that user.", 3)
        return nil
    end
    return description
end

--- [Internal] Applies a HumanoidDescription to the local player's character via respawn.
function Modules.CharacterMorph:_applyAndRespawn(description: HumanoidDescription)
    local localPlayer = self.Services.Players.LocalPlayer
    if not description then return end

    -- Disconnect any previous post-respawn event to prevent conflicts.
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end


    self.State.CharacterAddedConnection = localPlayer.CharacterAdded:Once(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            -- Wrap in a pcall as ApplyDescription can sometimes fail with invalid assets.
            pcall(humanoid.ApplyDescription, humanoid, description)
        end
    end)
    
    -- Trigger the respawn.
    localPlayer:LoadCharacter()
end


function Modules.CharacterMorph:Morph(target: string)
    if not target then
        return DoNotif("Usage: ;avatar <username/userid>", 3)
    end

    -- Cache the player's original description if we haven't already.
    if not self.State.OriginalDescription then
        local success, originalDesc = pcall(function()
            return self.Services.Players:GetHumanoidDescriptionFromUserId(self.Services.Players.LocalPlayer.UserId)
        end)
        if success then
            self.State.OriginalDescription = originalDesc
        else
            warn("[CharacterMorph] Could not cache original character description.")
        end
    end

    -- Run the asynchronous parts in a new thread to not lag the game.
    task.spawn(function()
        local newDescription = self:_resolveDescription(target)
        if newDescription then
            self.State.IsMorphed = true
            self:_applyAndRespawn(newDescription)
            DoNotif("Applying character morph...", 2)
        end
    end)
end

--- Reverts the player's character to their original appearance.
function Modules.CharacterMorph:Revert()
    if not self.State.IsMorphed then
        return DoNotif("You are not currently morphed.", 2)
    end
    
    if not self.State.OriginalDescription then
        return DoNotif("Failed to revert: Original avatar description is missing.", 4)
    end
    
    self:_applyAndRespawn(self.State.OriginalDescription)
    self.State.IsMorphed = false
    DoNotif("Reverting to original character...", 2)
end

--- Initializes the module and registers its commands.
function Modules.CharacterMorph:Initialize()
    local module = self
    for _, service in ipairs(self.Dependencies) do
        module.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "swapinto",
        Aliases = {"change"},
        Description = "Change your character's appearance to someone else's."
    }, function(args)
        module:Morph(args[1])
    end)

    RegisterCommand({
        Name = "default",
        Aliases = {},
        Description = "Reverts your character's appearance to your own."
    }, function()
        module:Revert()
    end)
end

Modules.AvatarEditor = {
    State = {
        IsEnabled = false,
        UI = nil,
        Connections = {},
        OriginalAssets = {} -- Cache to revert local previews
    },

    Config = {
        -- [CRITICAL] This MUST be changed to the path of the game's avatar remote.
        -- Finding this requires a remote spy tool. If no such remote exists, replication is impossible.
        REMOTE_PATH = "ReplicatedStorage.Events.Avatar.ChangeAsset"
    },
    
    Services = {}
}

--// --- Private: Core Logic ---

--- [Internal] Applies asset changes locally for preview purposes. NOT visible to others.
function Modules.AvatarEditor:_applyLocally()
    local character = self.Services.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Clear previous accessories before applying new ones
    for _, accessory in ipairs(humanoid:GetAccessories()) do
        accessory:Destroy()
    end
    
    for assetType, textBox in pairs(self.State.UI.Inputs) do
        local assetId = tonumber(textBox.Text)
        if assetId and assetId > 0 then
            pcall(function()
                if assetType == "Shirt" then
                    local shirt = character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", character)
                    shirt.ShirtTemplate = "rbxassetid://" .. assetId
                elseif assetType == "Pants" then
                    local pants = character:FindFirstChildOfClass("Pants") or Instance.new("Pants", character)
                    pants.PantsTemplate = "rbxassetid://" .. assetId
                elseif assetType == "Face" then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local face = head:FindFirstChildOfClass("Decal")
                        if face then face.Texture = "rbxassetid://" .. assetId end
                    end
                else -- Assume it's an accessory
                    self.Services.InsertService:LoadAsset(assetId).Parent = character
                end
            end)
        end
    end
end

--- [Internal] Attempts to apply asset changes via a RemoteEvent. This IS visible to others if the game is vulnerable.
function Modules.AvatarEditor:_applyToServer()
    local remote = self:_findRemote()
    if not remote then
        return DoNotif("Replication failed: RemoteEvent not found at path: " .. self.Config.REMOTE_PATH, 5)
    end
    
    local itemsFired = 0
    for assetType, textBox in pairs(self.State.UI.Inputs) do
        local assetId = textBox.Text
        if #assetId > 0 then
            -- Fire the remote with the asset type and ID. The exact format
            -- may need to be adjusted based on how the target game's remote works.
            local success, err = pcall(function()
                remote:FireServer(assetType, tonumber(assetId) or assetId)
            end)

            if success then
                itemsFired = itemsFired + 1
            else
                warn("[AvatarEditor] Failed to fire remote for", assetType, ":", err)
            end
        end
    end
    
    if itemsFired > 0 then
        DoNotif("Fired " .. itemsFired .. " asset changes to the server. Re-joining or respawning may be required to see changes.", 4)
    else
        DoNotif("No valid asset IDs were entered to send to the server.", 3)
    end
end


--- [Internal] Finds the remote event based on the configured path.
function Modules.AvatarEditor:_findRemote()
    local current = game
    for component in string.gmatch(self.Config.REMOTE_PATH, "[^%.]+") do
        if not current then return nil end
        current = current:FindFirstChild(component, true)
    end
    return (current and current:IsA("RemoteEvent")) and current or nil
end

--// --- Private: UI Creation & Management ---

function Modules.AvatarEditor:_createUI()
    if self.State.UI then return end
    
    local ui = {}
    self.State.UI = ui
    ui.Inputs = {}

    ui.ScreenGui = Instance.new("ScreenGui")
    ui.ScreenGui.Name = "AvatarEditor_Module"
    ui.ScreenGui.ResetOnSpawn = false
    ui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(250, 380)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.Draggable = true
    mainFrame.Active = true
    mainFrame.Parent = ui.ScreenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
    
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    title.Text = "Replicating Avatar Editor"
    title.Font = Enum.Font.GothamSemibold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1, -10, 1, -80)
    scroll.Position = UDim2.fromOffset(5, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    
    -- Function to create a labeled text box for an asset type
    local function createInput(assetType)
        local row = Instance.new("TextLabel", scroll)
        row.Size = UDim2.new(1, 0, 0, 25)
        row.BackgroundTransparency = 1
        row.Font = Enum.Font.Gotham
        row.Text = assetType .. ":"
        row.TextColor3 = Color3.fromRGB(200, 200, 200)
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextSize = 15

        local textBox = Instance.new("TextBox", row)
        textBox.Size = UDim2.new(0.6, 0, 1, 0)
        textBox.Position = UDim2.new(0.4, 0, 0, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Font = Enum.Font.Code
        textBox.TextSize = 14
        textBox.ClearTextOnFocus = false
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
        ui.Inputs[assetType] = textBox
    end
    
    -- Create inputs for common asset types
    createInput("Shirt")
    createInput("Pants")
    createInput("Face")
    createInput("Hat1")
    createInput("Hat2")
    createInput("Waist")
    createInput("Shoulder")
    createInput("Hair")

    local applyButton = Instance.new("TextButton", mainFrame)
    applyButton.Size = UDim2.new(1, -10, 0, 30)
    applyButton.Position = UDim2.new(0.5, 0, 1, -10)
    applyButton.AnchorPoint = Vector2.new(0.5, 1)
    applyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    applyButton.Font = Enum.Font.GothamBold
    applyButton.Text = "Apply to Server (Replicates)"
    applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", applyButton).CornerRadius = UDim.new(0, 4)
    
    local previewButton = applyButton:Clone()
    previewButton.Position = UDim2.new(0.5, 0, 1, -45)
    previewButton.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
    previewButton.Text = "Preview Locally (Client-Only)"
    previewButton.Parent = mainFrame
    
    applyButton.MouseButton1Click:Connect(function() self:_applyToServer() end)
    previewButton.MouseButton1Click:Connect(function() self:_applyLocally() end)

    ui.ScreenGui.Parent = CoreGui
end

--// --- Public: Control Methods ---

function Modules.AvatarEditor:Toggle()
    if self.State.IsEnabled then
        if self.State.UI and self.State.UI.ScreenGui then
            self.State.UI.ScreenGui:Destroy()
            self.State.UI = nil
        end
        self.State.IsEnabled = false
    else
        self:_createUI()
        self.State.IsEnabled = true
    end
end

function Modules.AvatarEditor:Initialize()
    self.Services.Players = game:GetService("Players")
    self.Services.InsertService = game:GetService("InsertService")
    self.Services.LocalPlayer = self.Services.Players.LocalPlayer

    RegisterCommand({
        Name = "avatareditor",
        Aliases = {"replicatedavatar", "ava"},
        Description = "Opens a UI to edit your avatar, with replication if the game is vulnerable."
    }, function()
        self:Toggle()
    end)
end

Modules.Chams = {
    State = {
        IsEnabled = false,
        TrackedCharacters = setmetatable({}, {__mode = "k"}),
        OriginalProperties = setmetatable({}, {__mode = "k"}),
        Connections = {}
    },
    Config = {
        VisibleColor = Color3.fromRGB(0, 255, 0),
        OccludedColor = Color3.fromRGB(255, 0, 0),
        Material = Enum.Material.Neon,
        HighlightTransparency = 0
    },
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
}

function Modules.Chams:_apply(character)
    if not character or self.State.TrackedCharacters[character] then return end
    
    local highlight = Instance.new("Highlight", character)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = self.Config.OccludedColor
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = self.Config.HighlightTransparency

    local innerHighlight = Instance.new("Highlight", character)
    innerHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
    innerHighlight.FillColor = self.Config.VisibleColor
    innerHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    innerHighlight.FillTransparency = self.Config.HighlightTransparency

    self.State.TrackedCharacters[character] = {highlight, innerHighlight}
end

function Modules.Chams:_revert(character)
    if not character or not self.State.TrackedCharacters[character] then return end
    
    for _, effect in ipairs(self.State.TrackedCharacters[character]) do
        pcall(function() effect:Destroy() end)
    end
    self.State.TrackedCharacters[character] = nil
end

function Modules.Chams:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function setupPlayer(player)
        if player == self.Services.Players.LocalPlayer then return end
        
        if player.Character then
            self:_apply(player.Character)
        end
        
        self.State.Connections[player] = {}
        self.State.Connections[player].CharacterAdded = player.CharacterAdded:Connect(function(char) self:_apply(char) end)
        self.State.Connections[player].CharacterRemoving = player.CharacterRemoving:Connect(function(char) self:_revert(char) end)
    end

    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        setupPlayer(player)
    end

    self.State.Connections.PlayerAdded = self.Services.Players.PlayerAdded:Connect(setupPlayer)
    self.State.Connections.PlayerRemoving = self.Services.Players.PlayerRemoving:Connect(function(player)
        if self.State.Connections[player] then
            for _, conn in pairs(self.State.Connections[player]) do
                conn:Disconnect()
            end
            self.State.Connections[player] = nil
        end
    end)
    
    DoNotif("Chams: ENABLED", 2)
end

function Modules.Chams:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    for player, conns in pairs(self.State.Connections) do
        if type(conns) == "table" then
            for _, conn in pairs(conns) do
                conn:Disconnect()
            end
        else
            conns:Disconnect()
        end
    end
    table.clear(self.State.Connections)

    for character, _ in pairs(self.State.TrackedCharacters) do
        self:_revert(character)
    end
    
    DoNotif("Chams: DISABLED", 2)
end

RegisterCommand({
    Name = "chams",
    Aliases = {},
    Description = "Toggles a solid color ESP on all other players."
}, function()
    if Modules.Chams.State.IsEnabled then
        Modules.Chams:Disable()
    else
        Modules.Chams:Enable()
    end
end)

Modules.InfiniteJump = {
    State = {
        IsEnabled = false,
        Connection = nil
    },
    Services = {
        Players = game:GetService("Players"),
        UserInputService = game:GetService("UserInputService")
    }
}

function Modules.InfiniteJump:OnInput(input, gameProcessed)
    if gameProcessed or not self.State.IsEnabled then return end

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        local character = self.Services.Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

function Modules.InfiniteJump:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.Connection = self.Services.UserInputService.JumpRequest:Connect(function()
        self:OnInput({UserInputType = Enum.UserInputType.Keyboard, KeyCode = Enum.KeyCode.Space}, false)
    end)

    DoNotif("Infinite Jump: ENABLED", 2)
end

function Modules.InfiniteJump:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("Infinite Jump: DISABLED", 2)
end

RegisterCommand({
    Name = "infjump",
    Aliases = {"infinitejump"},
    Description = "Toggles the ability to jump infinitely in the air."
}, function()
    if Modules.InfiniteJump.State.IsEnabled then
        Modules.InfiniteJump:Disable()
    else
        Modules.InfiniteJump:Enable()
    end
end)

Modules.Gravity = {
    State = {
        IsEnabled = false,
        OriginalGravity = nil
    },
    Services = {
        Workspace = game:GetService("Workspace")
    }
}

function Modules.Gravity:Enable(newGravityValue)
    if not self.State.IsEnabled then
        self.State.OriginalGravity = self.Services.Workspace.Gravity
    end
    self.State.IsEnabled = true
    
    local newGravity = tonumber(newGravityValue)
    if not newGravity or newGravity <= 0 then
        newGravity = 75
        DoNotif("No gravity value provided. Defaulting to " .. newGravity, 2)
    end
    
    self.Services.Workspace.Gravity = newGravity
    DoNotif("Client gravity set to: " .. newGravity, 2)
end

function Modules.Gravity:Disable()
    if not self.State.IsEnabled then return end
    
    if self.State.OriginalGravity then
        self.Services.Workspace.Gravity = self.State.OriginalGravity
    end
    
    self.State.IsEnabled = false
    self.State.OriginalGravity = nil
    DoNotif("Client gravity restored to default.", 2)
end

RegisterCommand({
    Name = "gravity",
    Aliases = {"grav"},
    Description = "Sets the client-sided workspace gravity. Use 'reset' to disable."
}, function(args)
    local argument = args[1]
    if argument and (argument:lower() == "reset" or argument:lower() == "off") then
        Modules.Gravity:Disable()
    else
        Modules.Gravity:Enable(argument)
    end
end)

Modules.FixCamera = {
    State = {
        Enabled = false,
        Connection = nil,
        OriginalMaxZoom = nil,
        OriginalOcclusionMode = nil,
    }
}

RegisterCommand({
    Name = "fixcam",
    Aliases = {"unlockcam"},
    Description = "Unlocks camera, allows zooming through walls, and forces third-person."
}, function(args)
    if not LocalPlayer then return end
    
    local self = Modules.FixCamera -- Reference the module table
    self.State.Enabled = not self.State.Enabled
    
    if self.State.Enabled then
        self.State.OriginalMaxZoom = LocalPlayer.CameraMaxZoomDistance
        self.State.OriginalOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        LocalPlayer.CameraMaxZoomDistance = 10000
        
        local success, err = pcall(function()
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.None
        end)
        if not success then
            warn("FixCamera: Failed to set DevCameraOcclusionMode via Enum. Falling back to 0. Error:", err)
            LocalPlayer.DevCameraOcclusionMode = 0
        end
        
        self.State.Connection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end)
        DoNotif("Camera override enabled (with wall-zoom).", 3)
    else
        if self.State.Connection and self.State.Connection.Connected then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        
        pcall(function()
            if self.State.OriginalOcclusionMode ~= nil then
                LocalPlayer.DevCameraOcclusionMode = self.State.OriginalOcclusionMode
            end
            if self.State.OriginalMaxZoom ~= nil then
                LocalPlayer.CameraMaxZoomDistance = self.State.OriginalMaxZoom
            end
        end)
        
        self.State.OriginalOcclusionMode = nil
        self.State.OriginalMaxZoom = nil
        DoNotif("Camera override disabled.", 3)
    end
end)

Modules.NoFog = {
    State = {
        IsEnabled = false,
        OriginalProperties = {}
    },
    Services = {
        Lighting = game:GetService("Lighting")
    }
}

function Modules.NoFog:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    self.State.OriginalProperties.FogEnd = self.Services.Lighting.FogEnd
    self.State.OriginalProperties.FogStart = self.Services.Lighting.FogStart

    local atmosphere = self.Services.Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        self.State.OriginalProperties.AtmosphereEnabled = atmosphere.Enabled
        atmosphere.Enabled = false
    end

    self.Services.Lighting.FogEnd = 1000000
    self.Services.Lighting.FogStart = 0
    
    DoNotif("No Fog: ENABLED.", 2)
end

function Modules.NoFog:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if self.State.OriginalProperties.FogEnd then
        self.Services.Lighting.FogEnd = self.State.OriginalProperties.FogEnd
    end
    if self.State.OriginalProperties.FogStart then
        self.Services.Lighting.FogStart = self.State.OriginalProperties.FogStart
    end

    local atmosphere = self.Services.Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere and self.State.OriginalProperties.AtmosphereEnabled ~= nil then
        atmosphere.Enabled = self.State.OriginalProperties.AtmosphereEnabled
    end

    self.State.OriginalProperties = {}
    DoNotif("No Fog: DISABLED.", 2)
end

function Modules.NoFog:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

RegisterCommand({
    Name = "nofog",
    Aliases = {"removefog", "antifog"},
    Description = "Toggles client-sided fog."
}, function()
    Modules.NoFog:Toggle()
end)

Modules.Waypoint = {
    State = {
        Waypoints = {},
        Visuals = {}
    },
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        CoreGui = game:GetService("CoreGui")
    }
}

function Modules.Waypoint:_cleanupVisual(name)
    local visual = self.State.Visuals[name:lower()]
    if visual then
        pcall(function()
            visual:Destroy()
        end)
        self.State.Visuals[name:lower()] = nil
    end
end

function Modules.Waypoint:_createVisual(name, cframe)
    self:_cleanupVisual(name)

    local container = Instance.new("Part")
    container.Name = "WaypointVisual_" .. name
    container.Size = Vector3.new(0.1, 0.1, 0.1)
    container.CFrame = cframe
    container.Anchored = true
    container.CanCollide = false
    container.Transparency = 1
    container.Parent = self.Services.Workspace

    local billboard = Instance.new("BillboardGui", container)
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(200, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = name
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextSize = 24
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.5

    local attachment1 = Instance.new("Attachment", container)
    local attachment2 = Instance.new("Attachment", container)
    attachment2.Position = Vector3.new(0, 1000, 0)

    local beam = Instance.new("Beam", container)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Width0 = 2
    beam.Width1 = 0
    beam.Transparency = NumberSequence.new(0.25)

    self.State.Visuals[name:lower()] = container
end

function Modules.Waypoint:Add(name)
    if not name or name == "" then
        return DoNotif("You must provide a name for the waypoint.", 3)
    end
    local character = self.Services.Players.LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return DoNotif("Cannot set waypoint: Character not found.", 3)
    end
    local key = name:lower()
    self.State.Waypoints[key] = hrp.CFrame
    self:_createVisual(name, hrp.CFrame)
    DoNotif("Waypoint '" .. name .. "' created at your position.", 2)
end

function Modules.Waypoint:Remove(name)
    if not name or name == "" then
        return DoNotif("You must provide a name to remove.", 3)
    end
    local key = name:lower()
    if not self.State.Waypoints[key] then
        return DoNotif("Waypoint '" .. name .. "' does not exist.", 3)
    end
    self.State.Waypoints[key] = nil
    self:_cleanupVisual(name)
    DoNotif("Waypoint '" .. name .. "' removed.", 2)
end

function Modules.Waypoint:Teleport(name)
    if not name or name == "" then
        return DoNotif("You must provide a name to teleport to.", 3)
    end
    local key = name:lower()
    local targetCFrame = self.State.Waypoints[key]
    if not targetCFrame then
        return DoNotif("Waypoint '" .. name .. "' does not exist.", 3)
    end
    local character = self.Services.Players.LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return DoNotif("Cannot teleport: Character not found.", 3)
    end
    hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    DoNotif("Teleported to '" .. name .. "'.", 2)
end

function Modules.Waypoint:List()
    local waypointNames = {}
    for name in pairs(self.State.Waypoints) do
        table.insert(waypointNames, name)
    end
    if #waypointNames == 0 then
        return DoNotif("No waypoints have been set.", 3)
    end
    local message = "Waypoints: " .. table.concat(waypointNames, ", ")
    DoNotif(message, 5)
end

function Modules.Waypoint:Clear()
    for name in pairs(self.State.Waypoints) do
        self:_cleanupVisual(name)
    end
    self.State.Waypoints = {}
    DoNotif("All waypoints cleared.", 2)
end

RegisterCommand({
    Name = "waypoint",
    Aliases = {"wp"},
    Description = "Manages waypoints."
}, function(args)
    local subCommand = args[1] and args[1]:lower()
    local name = args[2]

    if subCommand == "add" then
        Modules.Waypoint:Add(name)
    elseif subCommand == "remove" or subCommand == "del" then
        Modules.Waypoint:Remove(name)
    elseif subCommand == "tp" or subCommand == "goto" then
        Modules.Waypoint:Teleport(name)
    elseif subCommand == "list" then
        Modules.Waypoint:List()
    elseif subCommand == "clear" then
        Modules.Waypoint:Clear()
    else
        DoNotif("Usage: ;wp add,remove,tp,list", 4)
    end
end)

Modules.FpsMeter = {
    State = {
        IsEnabled = false,
        UI = {},
        Connection = nil
    },
    Services = {
        RunService = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    }
}

function Modules.FpsMeter:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FpsMeter_Zuka"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = self.Services.CoreGui
    self.State.UI.ScreenGui = screenGui

    local background = Instance.new("Frame", screenGui)
    background.Size = UDim2.fromOffset(140, 30)
    background.Position = UDim2.new(1, -150, 0, 10)
    background.AnchorPoint = Vector2.new(1, 0)
    background.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    background.BackgroundTransparency = 0.3
    
    local corner = Instance.new("UICorner", background)
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", background)
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(0, 255, 127)
    label.TextSize = 18
    label.Text = "FPS: ..."
    self.State.UI.Label = label

    local lastUpdate = 0
    local updateInterval = 0.25

    self.State.Connection = self.Services.RunService.Heartbeat:Connect(function(deltaTime)
        local now = os.clock()
        if now - lastUpdate > updateInterval then
            local fps = 1 / deltaTime
            label.Text = string.format("FPS: %.1f", fps)
            lastUpdate = now
        end
    end)

    DoNotif("FPS Meter: ENABLED", 2)
end

function Modules.FpsMeter:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui:Destroy()
    end
    
    self.State.UI = {}

    DoNotif("FPS Meter: DISABLED", 2)
end

function Modules.FpsMeter:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end


RegisterCommand({
    Name = "fpsmeter",
    Aliases = {"showfps", "fps"},
    Description = "Toggles a client-side FPS meter."
}, function()
    Modules.FpsMeter:Toggle()
end)

Modules.AntiSit = {
    State = {
        IsEnabled = false,
        CharacterConnections = {}
    },
    Services = {
        Players = game:GetService("Players")
    }
}

function Modules.AntiSit:_applyToCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 2)
    if not humanoid then return end

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local sitConnection = humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if humanoid.Sit == true then
            humanoid.Sit = false
        end
    end)
    self.State.CharacterConnections[character] = sitConnection
end

function Modules.AntiSit:_revertForCharacter(character)
    if not character then return end

    if self.State.CharacterConnections[character] then
        self.State.CharacterConnections[character]:Disconnect()
        self.State.CharacterConnections[character] = nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end)
    end
end

function Modules.AntiSit:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then
        self:_applyToCharacter(localPlayer.Character)
    end

    self.State.CharacterConnections.Added = localPlayer.CharacterAdded:Connect(function(char)
        self:_applyToCharacter(char)
    end)
    self.State.CharacterConnections.Removing = localPlayer.CharacterRemoving:Connect(function(char)
        self:_revertForCharacter(char)
    end)

    DoNotif("Anti-Sit: ENABLED", 2)
end

function Modules.AntiSit:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    if self.State.CharacterConnections.Added then
        self.State.CharacterConnections.Added:Disconnect()
    end
    if self.State.CharacterConnections.Removing then
        self.State.CharacterConnections.Removing:Disconnect()
    end

    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then
        self:_revertForCharacter(localPlayer.Character)
    end
    
    table.clear(self.State.CharacterConnections)
    DoNotif("Anti-Sit: DISABLED", 2)
end

function Modules.AntiSit:Toggle()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

RegisterCommand({
    Name = "antisit",
    Aliases = {"nosit"},
    Description = "Toggles a system to prevent your character from sitting."
}, function()
    Modules.AntiSit:Toggle()
end)

RegisterCommand({
    Name = "night",
    Aliases = {"setnight", "nighttime"},
    Description = "Sets the time to night on your client."
}, function(args)
    local Lighting = game:GetService("Lighting")
    
    local targetTime = tonumber(args[1])
    
    if not targetTime or targetTime < 0 or targetTime >= 24 then
        targetTime = 0 
    end
    
    Lighting.ClockTime = targetTime
    
    DoNotif(string.format("Client time set to %02d:00", targetTime), 2)
end)

RegisterCommand({
    Name = "day",
    Aliases = {"setday", "daytime"},
    Description = "Sets the time to day on your client."
}, function(args)
    -- Get the Lighting service robustly.
    local Lighting = game:GetService("Lighting")
    
    local targetTime = tonumber(args[1])
    
    if not targetTime or targetTime < 0 or targetTime >= 24 then
        targetTime = 14 
    end
    
    Lighting.ClockTime = targetTime
    
    DoNotif(string.format("Client time set to %02d:00", targetTime), 2)
end)

Modules.FullBright = {
    State = {
        IsEnabled = false,
        OriginalSettings = {}
    }
}

function Modules.FullBright:Enable(): ()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    self.State.OriginalSettings = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        GlobalShadows = Lighting.GlobalShadows
    }
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    self.State.Connection = Lighting.Changed:Connect(function()
        if self.State.IsEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        end
    end)
    DoNotif("FullBright: ENABLED", 2)
end

function Modules.FullBright:Disable(): ()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    local settings = self.State.OriginalSettings
    Lighting.Ambient = settings.Ambient
    Lighting.OutdoorAmbient = settings.OutdoorAmbient
    Lighting.Brightness = settings.Brightness
    Lighting.ClockTime = settings.ClockTime
    Lighting.GlobalShadows = settings.GlobalShadows
    DoNotif("FullBright: DISABLED", 2)
end

RegisterCommand({
    Name = "fullbright",
    Aliases = {"fb", "bright"},
    Description = "Removes all shadows and maximizes ambient light."
}, function()
    if Modules.FullBright.State.IsEnabled then
        Modules.FullBright:Disable()
    else
        Modules.FullBright:Enable()
    end
end)

Modules.ObjectESP = {
    State = {
        IsEnabled = false,
        Targets = {},
        Visuals = {}
    }
}

function Modules.ObjectESP:_apply(object: Instance): ()
    if not object:IsA("BasePart") or self.State.Visuals[object] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 170, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Parent = object
    local billboard = Instance.new("BillboardGui")
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(100, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = object.Name
    label.TextColor3 = Color3.fromRGB(255, 170, 0)
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.Parent = billboard
    billboard.Parent = object
    self.State.Visuals[object] = {highlight, billboard}
end

function Modules.ObjectESP:Toggle(name: string): ()
    if not name then return DoNotif("Usage: ;itemesp <name>", 3) end
    self.State.IsEnabled = true
    local count = 0
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant.Name:lower():find(name:lower()) and descendant:IsA("BasePart") then
            self:_apply(descendant)
            count = count + 1
        end
    end
    DoNotif("Found " .. count .. " items matching: " .. name, 3)
end

function Modules.ObjectESP:Clear(): ()
    for part, effects in pairs(self.State.Visuals) do
        for _, effect in ipairs(effects) do
            pcall(function() effect:Destroy() end)
        end
    end
    table.clear(self.State.Visuals)
    DoNotif("Object ESP Cleared", 2)
end

RegisterCommand({
    Name = "itemesp",
    Aliases = {"finditem", "iesp"},
    Description = "Highlights specific objects in the workspace by name."
}, function(args)
    local name = table.concat(args, " ")
    if name == "clear" or name == "off" then
        Modules.ObjectESP:Clear()
    else
        Modules.ObjectESP:Toggle(name)
    end
end)

Modules.InternalAntiAfk = {
    State = {
        IsEnabled = false,
        Connection = nil
    }
}

function Modules.InternalAntiAfk:Toggle(): ()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        local virtualUser = game:GetService("VirtualUser")
        self.State.Connection = LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
        DoNotif("Internal Anti-AFK: ENABLED", 2)
    else
        if self.State.Connection then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        DoNotif("Internal Anti-AFK: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "idlesaver",
    Aliases = {"afk", "antiafk"},
    Description = "Prevents being disconnected for inactivity via internal engine signals."
}, function()
    Modules.InternalAntiAfk:Toggle()
end)

Modules.CooldownBypass = {
    State = {
        IsEnabled = false,
        OriginalWait = nil,
        OriginalTaskWait = nil
    }
}

function Modules.CooldownBypass:Toggle(): ()
    if not getrawmetatable then return DoNotif("Executor missing getrawmetatable", 3) end
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self.State.OriginalWait = wait
        self.State.OriginalTaskWait = task.wait
        getgenv().wait = function(n: number?)
            return self.State.OriginalWait(n and n * 0.1 or 0)
        end
        getgenv().task.wait = function(n: number?)
            return self.State.OriginalTaskWait(n and n * 0.1 or 0)
        end
        DoNotif("Cooldown Bypass: ENABLED (10x Speed)", 2)
    else
        getgenv().wait = self.State.OriginalWait
        getgenv().task.wait = self.State.OriginalTaskWait
        DoNotif("Cooldown Bypass: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "nowait",
    Aliases = {"fastcooldown", "instant"},
    Description = "Locally accelerates all wait calls to bypass client-side timers."
}, function()
    Modules.CooldownBypass:Toggle()
end)

Modules.ToolSpy = {
    State = {
        IsEnabled = false
    }
}

function Modules.ToolSpy:Scan(): ()
    print("--- [Tool Spy Report] ---")
    local found = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local backpack = player:FindFirstChild("Backpack")
            local tools = {}
            if char then
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then
                        table.insert(tools, "[EQUIPPED] " .. item.Name)
                    end
                end
            end
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        table.insert(tools, item.Name)
                    end
                end
            end
            if #tools > 0 then
                found = found + 1
                print(string.format("Player: %s | Tools: %s", player.Name, table.concat(tools, ", ")))
            end
        end
    end
    print("--- End of Report ---")
    DoNotif("Tool Spy: Found inventory for " .. found .. " players. Check Console (F9).", 4)
end

RegisterCommand({
    Name = "toolspy",
    Aliases = {"invspy", "checktools"},
    Description = "Dumps the inventory of every player in the server to the developer console."
}, function()
    Modules.ToolSpy:Scan()
end)


Modules.EngineInterceptor = {
    State = {
        IsEnabled = false,
        IsLogging = true,
        ActiveHooks = {},
        CapturedLogs = {}, -- [Index] = {Name, Output, RawArgs}
        UI = nil,
        SelectedLog = nil
    },
    Config = {
        -- Functions to monitor
        TargetFunctions = {
            "debug.getconstants", "getconstants", "debug.getupvalues", "getupvalues",
            "getsenv", "getreg", "getgc", "getconnections", "firesignal",
            "fireclickdetector", "fireproximityprompt", "firetouchinterest",
            "gethiddenproperty", "sethiddenproperty", "hookmetamethod",
            "setnamecallmethod", "getrawmetatable", "setreadonly", "isreadonly"
        }
    },
    Dependencies = {"CoreGui", "UserInputService", "TweenService", "HttpService", "Players"},
    Services = {}
}

--// --- Private Utilities ---

function Modules.EngineInterceptor:_serialize(val)
    local t = typeof(val)
    if t == "string" then return string.format("%q", val)
    elseif t == "table" then
        local success, res = pcall(function() return self.Services.HttpService:JSONEncode(val) end)
        return success and res or "{Table: Opaque}"
    elseif t == "Instance" then return val:GetFullName()
    elseif t == "function" then
        local info = debug.getinfo(val)
        return string.format("function: %s (Line %d)", info.name or "anonymous", info.currentline)
    end
    return tostring(val)
end

function Modules.EngineInterceptor:_logCall(name, args)
    if not self.State.IsLogging then return end
    
    local timestamp = os.date("%H:%M:%S")
    local outputStr = string.format("[%s] Call detected on: %s\nArguments:\n", timestamp, name)
    
    for i, v in ipairs(args) do
        outputStr = outputStr .. string.format("  [%d] (%s): %s\n", i, typeof(v), self:_serialize(v))
    end

    local entry = {Name = name, Output = outputStr, Time = timestamp}
    table.insert(self.State.CapturedLogs, 1, entry) -- Newest first

    if self.State.UI then
        self:_updateList()
    end
end

--// --- UI Management ---

function Modules.EngineInterceptor:_createUI()
    if self.State.UI then self.State.UI.Main.Visible = true return end

    local sg = Instance.new("ScreenGui", self.Services.CoreGui)
    sg.Name = "Zuka_FunctionSpy"
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.fromOffset(550, 350)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)
    
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", header)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.fromOffset(10, 0)
    title.Text = "ENGINE INTERCEPTOR"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.Code
    title.TextXAlignment = "Left"
    title.BackgroundTransparency = 1

    local close = Instance.new("TextButton", header)
    close.Size = UDim2.fromOffset(25, 25)
    close.Position = UDim2.new(1, -30, 0.5, -12)
    close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", close)

    local list = Instance.new("ScrollingFrame", main)
    list.Size = UDim2.new(0.4, -10, 1, -40)
    list.Position = UDim2.fromOffset(5, 35)
    list.BackgroundTransparency = 1
    list.AutomaticCanvasSize = "Y"
    list.ScrollBarThickness = 2
    Instance.new("UIListLayout", list).Padding = UDim.new(0, 2)

    local display = Instance.new("TextBox", main)
    display.Size = UDim2.new(0.6, -10, 1, -80)
    display.Position = UDim2.fromScale(0.4, 0.1)
    display.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    display.TextColor3 = Color3.fromRGB(200, 200, 200)
    display.Font = Enum.Font.Code
    display.TextSize = 12
    display.Text = "Select a log to view details..."
    display.TextXAlignment = "Left"
    display.TextYAlignment = "Top"
    display.ClearTextOnFocus = false
    display.TextEditable = false
    Instance.new("UICorner", display)

    local copy = Instance.new("TextButton", main)
    copy.Size = UDim2.new(0.3, -5, 0, 30)
    copy.Position = UDim2.new(0.4, 0, 1, -35)
    copy.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
    copy.Text = "Copy Log"; copy.Font = Enum.Font.GothamBold
    Instance.new("UICorner", copy)

    local clear = Instance.new("TextButton", main)
    clear.Size = UDim2.new(0.3, -5, 0, 30)
    clear.Position = UDim2.new(0.7, 0, 1, -35)
    clear.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    clear.Text = "Clear All"; clear.Font = Enum.Font.GothamBold
    Instance.new("UICorner", clear)

    --// Interactions
    close.MouseButton1Click:Connect(function() main.Visible = false end)
    
    clear.MouseButton1Click:Connect(function()
        table.clear(self.State.CapturedLogs)
        display.Text = "Logs cleared."
        self:_updateList()
    end)

    copy.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(display.Text) end
    end)

    self.State.UI = {Main = main, List = list, Display = display}
end

function Modules.EngineInterceptor:_updateList()
    local list = self.State.UI.List
    for _, v in ipairs(list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end

    for i, entry in ipairs(self.State.CapturedLogs) do
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = string.format("[%s] %s", entry.Time, entry.Name)
        btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.Font = Enum.Font.Code
        btn.TextSize = 10
        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            self.State.UI.Display.Text = entry.Output
        end)
    end
end

--// --- Hooking Engine ---

function Modules.EngineInterceptor:ApplyHooks()
    if not hookfunction then return DoNotif("Executor does not support hookfunction.", 3) end

    for _, path in ipairs(self.Config.TargetFunctions) do
        local success, func = pcall(function()
            local segments = path:split(".")
            local target = _G
            if #segments > 1 then
                target = getrenv()[segments[1]] or _G[segments[1]]
                return target[segments[2]]
            end
            return getrenv()[path] or _G[path]
        end)

        if success and type(func) == "function" then
            local old; old = hookfunction(func, newcclosure(function(...)
                local args = {...}
                task.spawn(function() self:_logCall(path, args) end)
                return old(...)
            end))
            self.State.ActiveHooks[path] = old
        end
    end
    
    self.State.IsEnabled = true
    DoNotif("Engine Interceptor: Active. Monitoring Exploit APIs.", 3)
end

--// --- Initialize ---

function Modules.EngineInterceptor:Initialize()
    local module = self
    for _, s in ipairs(module.Dependencies) do module.Services[s] = game:GetService(s) end

    RegisterCommand({
        Name = "functionspy",
        Aliases = {"monitor"},
        Description = "Monitors and logs calls to sensitive environment functions."
    }, function()
        module:_createUI()
        if not module.State.IsEnabled then
            module:ApplyHooks()
        end
    end)
end

Modules.SoundNullifier = {
    State = {
        IsEnabled = false,
        OriginalIndex = nil
    }
}

function Modules.SoundNullifier:Toggle(): ()
    local mt = getrawmetatable(game)
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalIndex = mt.__index
        setreadonly(mt, false)

        mt.__index = newcclosure(function(selfArg, key)
            if self.State.IsEnabled and selfArg:IsA("Sound") then
                if key == "Volume" then
                    return 0
                elseif key == "Playing" then
                    return false
                end
            end
            return self.State.OriginalIndex(selfArg, key)
        end)

        setreadonly(mt, true)
        DoNotif("Sound Nullifier: ENABLED (All game audio muted via engine hook)", 3)
    else
        setreadonly(mt, false)
        mt.__index = self.State.OriginalIndex
        setreadonly(mt, true)
        DoNotif("Sound Nullifier: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "mutesounds",
    Aliases = {"nosound", "silence"},
    Description = "Forces all Sound instances to have 0 volume and appear as not playing."
}, function()
    Modules.SoundNullifier:Toggle()
end)

Modules.RaycastRedirector = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        TargetPart = "HumanoidRootPart",
        ExpansionRadius = 10,
        MaxDistance = 25
    }
}

function Modules.RaycastRedirector:_getClosestToRay(origin: Vector3, direction: Vector3)
    local closestPlayer, minProjection = nil, self.State.ExpansionRadius
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(self.State.TargetPart)
            if part then
                local toPart = (part.Position - origin)
                local projection = toPart:Dot(direction.Unit)
                if projection > 0 and projection < self.State.MaxDistance then
                    local perpendicular = (toPart - (direction.Unit * projection)).Magnitude
                    if perpendicular < minProjection then
                        minProjection = perpendicular
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

function Modules.RaycastRedirector:Enable()
    if self.State.IsEnabled then return end
    if not (getrawmetatable and getnamecallmethod and newcclosure) then
        return DoNotif("Metatable redirection not supported by executor.", 3)
    end
    self.State.IsEnabled = true
    local gameMetatable = getrawmetatable(game)
    self.State.OriginalNamecall = gameMetatable.__namecall
    local original = self.State.OriginalNamecall
    setreadonly(gameMetatable, false)
    gameMetatable.__namecall = newcclosure(function(selfArg, ...)
        local method = getnamecallmethod()
        local args = {...}
        if Modules.RaycastRedirector.State.IsEnabled and selfArg == Workspace and method == "Raycast" then
            local origin, direction = args[1], args[2]
            if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
                local target = Modules.RaycastRedirector:_getClosestToRay(origin, direction)
                if target and target.Character then
                    local hitPart = target.Character:FindFirstChild(Modules.RaycastRedirector.State.TargetPart)
                    if hitPart then
                        args[2] = (hitPart.Position - origin).Unit * direction.Magnitude
                    end
                end
            end
        end
        return original(selfArg, unpack(args))
    end)
    setreadonly(gameMetatable, true)
    DoNotif("Raycast Redirector: ENABLED", 2)
end

function Modules.RaycastRedirector:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    DoNotif("Raycast Redirector: DISABLED", 2)
end

Modules.AudioVisualizer = {
    State = {
        IsEnabled = false,
        Markers = {},
        Connection = nil
    }
}

function Modules.AudioVisualizer:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self.State.Connection = Workspace.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                local marker = Instance.new("BillboardGui")
                marker.AlwaysOnTop = true
                marker.Size = UDim2.fromOffset(20, 20)
                local frame = Instance.new("Frame", marker)
                frame.Size = UDim2.fromScale(1, 1)
                frame.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
                Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
                local function update()
                    if desc.IsPlaying then
                        marker.Enabled = true
                        marker.Adornee = desc.Parent:IsA("BasePart") and desc.Parent or nil
                    else
                        marker.Enabled = false
                    end
                end
                desc:GetPropertyChangedSignal("IsPlaying"):Connect(update)
                marker.Parent = CoreGui
                table.insert(self.State.Markers, marker)
            end
        end)
        DoNotif("Audio ESP: ENABLED", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        for _, m in ipairs(self.State.Markers) do m:Destroy() end
        table.clear(self.State.Markers)
        self.State.IsEnabled = false
        DoNotif("Audio ESP: DISABLED", 2)
    end
end

Modules.LightingLock = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        Properties = {
            Brightness = 2,
            ClockTime = 14,
            FogEnd = 100000,
            GlobalShadows = false
        }
    }
}

function Modules.LightingLock:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        local mt = getrawmetatable(game)
        self.State.OriginalNamecall = mt.__newindex
        local original = self.State.OriginalNamecall
        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(t, k, v)
            if t == Lighting and Modules.LightingLock.State.IsEnabled then
                if Modules.LightingLock.State.Properties[k] ~= nil then
                    return
                end
            end
            return original(t, k, v)
        end)
        setreadonly(mt, true)
        for k, v in pairs(self.State.Properties) do
            pcall(function() Lighting[k] = v end)
        end
        DoNotif("Lighting Lock: ENABLED", 2)
    else
        self.State.IsEnabled = false
        DoNotif("Lighting Lock: DISABLED", 2)
    end
end

Modules.PromptAura = {
    State = {
        IsEnabled = false,
        Connection = nil,
        Distance = 15
    }
}

function Modules.PromptAura:Toggle(dist)
    self.State.IsEnabled = not self.State.IsEnabled
    self.State.Distance = tonumber(dist) or 15
    if self.State.IsEnabled then
        self.State.Connection = RunService.Heartbeat:Connect(function()
            local char = Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local part = prompt.Parent
                    if part and part:IsA("BasePart") then
                        if (hrp.Position - part.Position).Magnitude <= self.State.Distance then
                            if fireproximityprompt then fireproximityprompt(prompt) end
                        end
                    end
                end
            end
        end)
        DoNotif("Prompt Aura: ENABLED", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        self.State.IsEnabled = false
        DoNotif("Prompt Aura: DISABLED", 2)
    end
end

Modules.SafeTeleport = {
    State = {
        IsEnabled = false
    }
}

function Modules.SafeTeleport:Execute(targetName: string)
    local target = Utilities.findPlayer(targetName)
    if not target or not target.Character then return DoNotif("Target not found.", 2) end
    local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and targetHrp then
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {Players.LocalPlayer.Character, target.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = Workspace:Raycast(targetHrp.Position, Vector3.new(0, 5, 0), rayParams)
        local finalPos = result and result.Position or (targetHrp.Position + Vector3.new(0, 3, 0))
        hrp.CFrame = CFrame.new(finalPos)
        DoNotif("Safe Teleport to " .. target.Name, 2)
    end
end

RegisterCommand({
    Name = "raybox",
    Aliases = {"meleebypass", "rb"},
    Description = "Redirects raycasts to the nearest target to bypass melee accuracy checks."
}, function(args)
    if args[1] == "off" then Modules.RaycastRedirector:Disable() else Modules.RaycastRedirector:Enable() end
end)

RegisterCommand({
    Name = "audioesp",
    Aliases = {"soundesp", "ae"},
    Description = "Visualizes the source of playing sounds in the world."
}, function()
    Modules.AudioVisualizer:Toggle()
end)

RegisterCommand({
    Name = "locklighting",
    Aliases = {"lightlock", "ll"},
    Description = "Prevents the server from changing your local lighting settings."
}, function()
    Modules.LightingLock:Toggle()
end)

RegisterCommand({
    Name = "promptaura",
    Aliases = {"pa"},
    Description = "Automatically triggers proximity prompts in a radius."
}, function(args)
    Modules.PromptAura:Toggle(args[1])
end)

RegisterCommand({
    Name = "stp",
    Aliases = {"safeteleport"},
    Description = "Teleports to a player while checking for ceiling/wall obstructions."
}, function(args)
    Modules.SafeTeleport:Execute(args[1])
end)

Modules.StateSpoofer = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        TargetState = Enum.HumanoidStateType.Running
    }
}

function Modules.StateSpoofer:Toggle(requestedState: string?): ()
    local mt = getrawmetatable(game)
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        if requestedState and Enum.HumanoidStateType[requestedState] then
            self.State.TargetState = Enum.HumanoidStateType[requestedState]
        end

        self.State.OriginalNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(selfArg, ...)
            local method = getnamecallmethod()
            if self.State.IsEnabled and method == "GetState" and selfArg:IsA("Humanoid") then
                return self.State.TargetState
            end
            return self.State.OriginalNamecall(selfArg, ...)
        end)

        setreadonly(mt, true)
        DoNotif("State Spoofer: ENABLED (Spoofing state to " .. self.State.TargetState.Name .. ")", 3)
    else
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
        DoNotif("State Spoofer: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "spoofstate",
    Aliases = {"fakestate", "fs"},
    Description = "Spoofs your Humanoid state (e.g. Running) to prevent detection of falling/jumping."
}, function(args)
    Modules.StateSpoofer:Toggle(args[1])
end)

Modules.HitboxExtender = {
    State = {
        IsEnabled = false,
        TrackedCharacters = setmetatable({}, {__mode = "k"}),
        OriginalSizes = setmetatable({}, {__mode = "k"}),
        Connections = {}
    },
    Config = {
        TargetPartName = "HumanoidRootPart",
        SizeMultiplier = 3
    },
    Services = {
        Players = game:GetService("Players")
    }
}

function Modules.HitboxExtender:_apply(character)
    if not character or self.State.TrackedCharacters[character] then return end

    local targetPart = character:FindFirstChild(self.Config.TargetPartName)
    if not targetPart then return end

    if not self.State.OriginalSizes[targetPart] then
        self.State.OriginalSizes[targetPart] = targetPart.Size
    end

    targetPart.Size = self.State.OriginalSizes[targetPart] * self.Config.SizeMultiplier
    targetPart.Transparency = 1
    targetPart.CanCollide = false
    self.State.TrackedCharacters[character] = true
end

function Modules.HitboxExtender:_revert(character)
    if not character or not self.State.TrackedCharacters[character] then return end

    local targetPart = character:FindFirstChild(self.Config.TargetPartName)
    if targetPart and self.State.OriginalSizes[targetPart] then
        targetPart.Size = self.State.OriginalSizes[targetPart]
        targetPart.Transparency = self.State.OriginalSizes[targetPart].Transparency or 0
        targetPart.CanCollide = self.State.OriginalSizes[targetPart].CanCollide or true
        self.State.OriginalSizes[targetPart] = nil
    end

    self.State.TrackedCharacters[character] = nil
end

function Modules.HitboxExtender:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function setupPlayer(player)
        if player == self.Services.Players.LocalPlayer then return end

        if player.Character then
            self:_apply(player.Character)
        end
        
        self.State.Connections[player] = {}
        self.State.Connections[player].CharacterAdded = player.CharacterAdded:Connect(function(char) self:_apply(char) end)
        self.State.Connections[player].CharacterRemoving = player.CharacterRemoving:Connect(function(char) self:_revert(char) end)
    end

    for _, player in ipairs(self.Services.Players:GetPlayers()) do
        setupPlayer(player)
    end

    self.State.Connections.PlayerAdded = self.Services.Players.PlayerAdded:Connect(setupPlayer)
    self.State.Connections.PlayerRemoving = self.Services.Players.PlayerRemoving:Connect(function(player)
        if self.State.Connections[player] then
            for _, conn in pairs(self.State.Connections[player]) do
                conn:Disconnect()
            end
            self.State.Connections[player] = nil
        end
    end)

    DoNotif("Hitbox Extender: ENABLED", 2)
end

function Modules.HitboxExtender:Disable()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false

    for player, conns in pairs(self.State.Connections) do
        if type(conns) == "table" then
            for _, conn in pairs(conns) do conn:Disconnect() end
        else
            conns:Disconnect()
        end
    end
    table.clear(self.State.Connections)

    for character in pairs(self.State.TrackedCharacters) do
        self:_revert(character)
    end
    
    table.clear(self.State.OriginalSizes)
    DoNotif("Hitbox Extender: DISABLED", 2)
end

RegisterCommand({
    Name = "hitbox",
    Aliases = {"enlarge", "bighitbox"},
    Description = "Enlarges other players' hitboxes locally for easier melee hits."
}, function(args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier > 0 then
        Modules.HitboxExtender.Config.SizeMultiplier = multiplier
        DoNotif("Hitbox multiplier set to " .. multiplier, 2)
    end

    if Modules.HitboxExtender.State.IsEnabled then
        if not multiplier then
            Modules.HitboxExtender:Disable()
        end
    else
        Modules.HitboxExtender:Enable()
    end
end)


Modules.ModulePoisoner = { State = { IsEnabled = false, ActivePatches = {}, SelectedModule = nil, CurrentTable = nil, PathStack = {}, Minimized = false, ViewingCode = false, UI = nil, SidebarButtons = {} }, Config = { ACCENT_COLOR = Color3.fromRGB(0, 255, 170), BG_COLOR = Color3.fromRGB(10, 10, 12), HEADER_COLOR = Color3.fromRGB(15, 15, 18), SECONDARY_COLOR = Color3.fromRGB(18, 18, 22) } }

function Modules.ModulePoisoner:_applyStyle(obj: GuiObject, radius: number) local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, radius or 4) corner.Parent = obj end
function Modules.ModulePoisoner:_setClipboard(txt: string) if setclipboard then setclipboard(txt) end end
function Modules.ModulePoisoner:_applyPatch(tbl: table, key: any, val: any, isFunc: boolean) if not self.State.ActivePatches[tbl] then self.State.ActivePatches[tbl] = {} end

self.State.ActivePatches[tbl][key] = {Value = val, Locked = true, IsFunction = isFunc}

pcall(function()
    if setreadonly then setreadonly(tbl, false) elseif make_writeable then make_writeable(tbl) end
    if isFunc then
        if val == "TRUE" then
            rawset(tbl, key, function() return true end)
        elseif val == "FALSE" then
            rawset(tbl, key, function() return false end)
        end
    else
        rawset(tbl, key, val)
    end
    if setreadonly then setreadonly(tbl, true) end
end)
end

local c_check = clonefunction(checkcaller)
local c_rawset = clonefunction(rawset)
local c_getmt = clonefunction(getrawmetatable)

function Modules.ModulePoisoner:_getUpvalues(func: (...any) -> ...any, depth: number, maxDepth: number)
    depth = depth or 0
    maxDepth = maxDepth or 5
    if depth > maxDepth then return {} end
    
    local upvalues = {}
    local success, result = pcall(debug.getupvalues, func)
    
    if success and result then
        for i, uv in ipairs(result) do
            local uvType = type(uv)
            upvalues[i] = {
                Index = i,
                Value = uv,
                Type = uvType,
                IsFunction = uvType == "function",
                IsTable = uvType == "table",
                ChildUpvalues = uvType == "function" and self:_getUpvalues(uv, depth + 1, maxDepth) or {}
            }
        end
    end
    return upvalues
end

function Modules.ModulePoisoner:_patchUpvalue(func: (...any) -> ...any, uvIndex: number, newValue: any)
    if not debug.getupvalues or not debug.setupvalue then return false end
    
    local success = pcall(function()
        if setreadonly then setreadonly(func, false) elseif make_writeable then make_writeable(func) end
        debug.setupvalue(func, uvIndex, newValue)
        if setreadonly then setreadonly(func, true) end
    end)
    
    return success
end

function Modules.ModulePoisoner:_scanMetatable(tbl: table)
    if not getrawmetatable then return nil end
    
    local mt = c_getmt(tbl)
    if not mt then return nil end
    
    -- Force metatable to be writeable
    if setreadonly then setreadonly(mt, false) elseif make_writeable then make_writeable(mt) end
    
    local metamethods = {}
    for k, v in pairs(mt) do
        if type(v) == "function" then
            metamethods[k] = {
                Value = v,
                Type = "function",
                Upvalues = self:_getUpvalues(v),
                OriginalUpvalues = self:_getUpvalues(v)
            }
        else
            metamethods[k] = {Value = v, Type = type(v)}
        end
    end
    
    return {
        Metatable = mt,
        Methods = metamethods
    }
end

function Modules.ModulePoisoner:_createUpvalueRow(uvIndex: number, uvData: any, parentFunc: ((...any) -> ...any)?, ui: any)
    local row = Instance.new("Frame", ui.Grid)
    row.Size = UDim2.new(1, -10, 0, 35)
    row.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = "  [" .. uvIndex .. "] " .. uvData.Type
    label.TextColor3 = Color3.fromRGB(100, 200, 255)
    label.Font = Enum.Font.Code
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.ClipsDescendants = true
    
    if uvData.IsTable then
        local diveBtn = Instance.new("TextButton", row)
        diveBtn.Size = UDim2.new(0, 100, 0, 24)
        diveBtn.Position = UDim2.fromScale(0.42, 0.15)
        diveBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 80)
        diveBtn.Text = "DIVE UV >"
        diveBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
        diveBtn.Font = Enum.Font.Code
        diveBtn.TextSize = 8
        self:_applyStyle(diveBtn, 2)
        
        diveBtn.MouseButton1Click:Connect(function()
            table.insert(self.State.PathStack, self.State.CurrentTable)
            self.State.CurrentTable = uvData.Value
            self:PopulateGrid(uvData.Value, "[UV:" .. uvIndex .. "]")
        end)
    elseif uvData.IsFunction then
        local uvBtn = Instance.new("TextButton", row)
        uvBtn.Size = UDim2.new(0, 80, 0, 24)
        uvBtn.Position = UDim2.fromScale(0.42, 0.15)
        uvBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
        uvBtn.Text = "UVALS"
        uvBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
        uvBtn.Font = Enum.Font.Code
        uvBtn.TextSize = 8
        self:_applyStyle(uvBtn, 2)
        
        uvBtn.MouseButton1Click:Connect(function()
            self:_showUpvaluesUI(uvData.Value, "[UV:" .. uvIndex .. "] Function")
        end)
        
        local viewBtn = Instance.new("TextButton", row)
        viewBtn.Size = UDim2.new(0, 60, 0, 24)
        viewBtn.Position = UDim2.fromScale(0.55, 0.15)
        viewBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 60)
        viewBtn.Text = "VIEW"
        viewBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
        viewBtn.Font = Enum.Font.Code
        viewBtn.TextSize = 8
        self:_applyStyle(viewBtn, 2)
        
        viewBtn.MouseButton1Click:Connect(function() self:_showSource(uvData.Value) end)
    else
        local box = Instance.new("TextBox", row)
        box.Size = UDim2.new(0, 100, 0, 24)
        box.Position = UDim2.fromScale(0.42, 0.15)
        box.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        box.Text = tostring(uvData.Value)
        box.TextColor3 = Color3.fromRGB(100, 200, 255)
        box.Font = Enum.Font.Code
        box.TextSize = 9
        self:_applyStyle(box, 2)
        
        box.FocusLost:Connect(function(enter)
            if enter and parentFunc then
                local newVal = tonumber(box.Text) or box.Text
                self:_patchUpvalue(parentFunc, uvIndex, newVal)
                box.Text = tostring(newVal)
            end
        end)
    end
end

function Modules.ModulePoisoner:_showUpvaluesUI(func: (...any) -> ...any, funcName: string)
    local ui = self.State.UI
    
    self.State.ViewingCode = true
    ui.Grid.Visible = false
    ui.CodeFrame.Visible = true
    ui.Title.Text = "UPVALUES: " .. funcName
    ui.CodeBox.Text = "-- Scanning upvalues..."
    
    task.spawn(function()
        -- Clear grid for upvalue display
        for _, v in ipairs(ui.Grid:GetChildren()) do
            if not v:IsA("UIListLayout") then v:Destroy() end
        end
        
        ui.CodeFrame.Visible = false
        ui.Grid.Visible = true
        
        local upvalues = self:_getUpvalues(func)
        if #upvalues == 0 then
            local noUvLabel = Instance.new("TextLabel", ui.Grid)
            noUvLabel.Size = UDim2.new(1, 0, 0, 20)
            noUvLabel.Text = "  -- NO UPVALUES FOUND -- "
            noUvLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
            noUvLabel.BackgroundTransparency = 1
            noUvLabel.Font = Enum.Font.Code
            noUvLabel.TextSize = 9
        else
            for _, uvData in ipairs(upvalues) do
                self:_createUpvalueRow(uvData.Index, uvData, func, ui)
                
                -- Show nested upvalues if function
                if uvData.IsFunction and #uvData.ChildUpvalues > 0 then
                    for _, childUv in ipairs(uvData.ChildUpvalues) do
                        local childRow = Instance.new("Frame", ui.Grid)
                        childRow.Size = UDim2.new(1, -30, 0, 35)
                        childRow.BackgroundTransparency = 1
                        childRow.Position = UDim2.new(0, 20, 0, 0)
                        
                        local childLabel = Instance.new("TextLabel", childRow)
                        childLabel.Size = UDim2.new(1, 0, 1, 0)
                        childLabel.Text = "    └─[" .. childUv.Index .. "] " .. childUv.Type
                        childLabel.TextColor3 = Color3.fromRGB(150, 150, 100)
                        childLabel.Font = Enum.Font.Code
                        childLabel.TextSize = 8
                        childLabel.TextXAlignment = Enum.TextXAlignment.Left
                        childLabel.BackgroundTransparency = 1
                    end
                end
            end
        end
    end)
end

function Modules.ModulePoisoner:_showSource(target: any) local decompiler = (decompile or decompile_script or function() return "-- [ERROR] Decompiler not supported." end) local ui = self.State.UI

self.State.ViewingCode = true
ui.Grid.Visible = false
ui.CodeFrame.Visible = true
ui.CodeFrame.Name = "ViewMode"
ui.Title.Text = "DECOMPILING: " .. (target.Name or "Closure")
ui.CodeBox.Text = "-- Generating Source, please wait..."

task.spawn(function()
    local success, src = pcall(decompiler, target)
    ui.CodeBox.Text = success and src or "-- [FAILURE] Decompilation error."
end)
end

function Modules.ModulePoisoner:_showEditUI(target: any, targetName: string)
    local decompiler = (decompile or decompile_script or function() return "-- [ERROR] Decompiler not supported." end)
    local ui = self.State.UI
    
    self.State.ViewingCode = true
    ui.Grid.Visible = false
    ui.CodeFrame.Visible = true
    ui.CodeFrame.Name = "EditMode"
    ui.Title.Text = "EDIT: " .. targetName
    ui.CodeBox.Text = "-- Loading source..."
    ui.CodeBox.TextEditable = true
    ui.CodeBox.ClearTextOnFocus = true
    
    task.spawn(function()
        local success, src = pcall(decompiler, target)
        if success then
            ui.CodeBox.Text = src
        else
            ui.CodeBox.Text = "-- [ERROR] Failed to decompile source\n-- Attempting fallback..."
        end
    end)
end

function Modules.ModulePoisoner:_createRow(k: any, v: any, src: table) local ui = self.State.UI local row = Instance.new("Frame", ui.Grid) row.Size = UDim2.new(1, -10, 0, 35) row.BackgroundTransparency = 1

local label = Instance.new("TextLabel", row)
label.Size = UDim2.new(0.4, 0, 1, 0)
label.Text = " " .. tostring(k)
label.TextColor3 = Color3.fromRGB(150, 150, 150)
label.Font = Enum.Font.Code
label.TextSize = 9
label.TextXAlignment = Enum.TextXAlignment.Left
label.BackgroundTransparency = 1
label.ClipsDescendants = true

if type(v) == "table" then
    local diveBtn = Instance.new("TextButton", row)
    diveBtn.Size = UDim2.new(0, 100, 0, 24)
    diveBtn.Position = UDim2.fromScale(0.42, 0.15)
    diveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    diveBtn.Text = "DIVE >"
    diveBtn.TextColor3 = self.Config.ACCENT_COLOR
    diveBtn.Font = Enum.Font.Code
    diveBtn.TextSize = 8
    self:_applyStyle(diveBtn, 2)
    
    diveBtn.MouseButton1Click:Connect(function()
        table.insert(self.State.PathStack, src)
        self:PopulateGrid(v, tostring(k))
    end)
elseif type(v) == "function" then
    local spoofBtn = Instance.new("TextButton", row)
    spoofBtn.Size = UDim2.new(0, 45, 0, 24)
    spoofBtn.Position = UDim2.fromScale(0.42, 0.15)
    spoofBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    spoofBtn.Text = "SPOOF"
    spoofBtn.TextColor3 = Color3.new(1, 1, 1)
    spoofBtn.Font = Enum.Font.Code
    spoofBtn.TextSize = 7
    self:_applyStyle(spoofBtn, 2)
    
    local uvBtn = Instance.new("TextButton", row)
    uvBtn.Size = UDim2.new(0, 45, 0, 24)
    uvBtn.Position = UDim2.fromScale(0.495, 0.15)
    uvBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
    uvBtn.Text = "UVALS"
    uvBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
    uvBtn.Font = Enum.Font.Code
    uvBtn.TextSize = 7
    self:_applyStyle(uvBtn, 2)
    
    uvBtn.MouseButton1Click:Connect(function() 
        self:_showUpvaluesUI(v, tostring(k))
    end)
    
    local viewBtn = Instance.new("TextButton", row)
    viewBtn.Size = UDim2.new(0, 35, 0, 24)
    viewBtn.Position = UDim2.fromScale(0.565, 0.15)
    viewBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 60)
    viewBtn.Text = "V"
    viewBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
    viewBtn.Font = Enum.Font.Code
    viewBtn.TextSize = 7
    self:_applyStyle(viewBtn, 2)
    
    viewBtn.MouseButton1Click:Connect(function() 
        self.State.EditTarget = src
        self:_showSource(v) 
    end)
    
    local editBtn = Instance.new("TextButton", row)
    editBtn.Size = UDim2.new(0, 35, 0, 24)
    editBtn.Position = UDim2.fromScale(0.615, 0.15)
    editBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
    editBtn.Text = "E"
    editBtn.TextColor3 = Color3.fromRGB(255, 180, 100)
    editBtn.Font = Enum.Font.Code
    editBtn.TextSize = 7
    self:_applyStyle(editBtn, 2)
    
    editBtn.MouseButton1Click:Connect(function()
        self.State.EditTarget = src
        self:_showEditUI(v, tostring(k) .. "()")
    end)

    local modes = {"NORMAL", "TRUE", "FALSE"}
    local cur = 1
    spoofBtn.MouseButton1Click:Connect(function()
        cur = (cur % 3) + 1
        local mode = modes[cur]
        spoofBtn.Text = "F" .. string.sub(mode, 1, 1)
        spoofBtn.BackgroundColor3 = (mode == "TRUE" and Color3.fromRGB(0, 200, 100)) or (mode == "FALSE" and Color3.fromRGB(200, 50, 50)) or Color3.fromRGB(50, 50, 70)
        if mode == "NORMAL" then
            if self.State.ActivePatches[src] then self.State.ActivePatches[src][k] = nil end
        else
            self:_applyPatch(src, k, mode, true)
        end
    end)
else
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0, 100, 0, 24)
    box.Position = UDim2.fromScale(0.42, 0.15)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    box.Text = tostring(v)
    box.TextColor3 = self.Config.ACCENT_COLOR
    box.Font = Enum.Font.Code
    box.TextSize = 9
    self:_applyStyle(box, 2)
    
    box.FocusLost:Connect(function(enter)
        if enter then
            self:_applyPatch(src, k, tonumber(box.Text) or box.Text, false)
        end
    end)
end
end

function Modules.ModulePoisoner:PopulateGrid(targetTable: table, name: string) local ui = self.State.UI self.State.CurrentTable = targetTable ui.Title.Text = "PATH: " .. (name or "Main")

for _, v in ipairs(ui.Grid:GetChildren()) do
    if not v:IsA("UIListLayout") then v:Destroy() end
end

for k, v in pairs(targetTable) do
    self:_createRow(k, v, targetTable)
end

local mt = getrawmetatable and getrawmetatable(targetTable)
if mt then
    -- Force metatable to be writeable
    if setreadonly then setreadonly(mt, false) elseif make_writeable then make_writeable(mt) end
    
    if mt.__index and type(mt.__index) == "table" then
        local ghostLabel = Instance.new("TextLabel", ui.Grid)
        ghostLabel.Size = UDim2.new(1, 0, 0, 20)
        ghostLabel.Text = " -- GHOST INDEX (__index) -- "
        ghostLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
        ghostLabel.BackgroundTransparency = 1
        ghostLabel.Font = Enum.Font.Code
        ghostLabel.TextSize = 9
        for k, v in pairs(mt.__index) do
            self:_createRow(k, v, mt.__index)
        end
    end
    
    -- Check for other metamethods
    local metamethods = {}
    for mmKey, mmVal in pairs(mt) do
        if mmKey ~= "__index" and type(mmVal) == "function" then
            table.insert(metamethods, {Key = mmKey, Value = mmVal})
        end
    end
    
    if #metamethods > 0 then
        local mmLabel = Instance.new("TextLabel", ui.Grid)
        mmLabel.Size = UDim2.new(1, 0, 0, 20)
        mmLabel.Text = " -- METAMETHODS -- "
        mmLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        mmLabel.BackgroundTransparency = 1
        mmLabel.Font = Enum.Font.Code
        mmLabel.TextSize = 9
        
        for _, mmData in ipairs(metamethods) do
            local mmRow = Instance.new("Frame", ui.Grid)
            mmRow.Size = UDim2.new(1, -10, 0, 35)
            mmRow.BackgroundTransparency = 1
            
            local mmLabel2 = Instance.new("TextLabel", mmRow)
            mmLabel2.Size = UDim2.new(0.4, 0, 1, 0)
            mmLabel2.Text = " " .. mmData.Key .. "()"
            mmLabel2.TextColor3 = Color3.fromRGB(255, 200, 100)
            mmLabel2.Font = Enum.Font.Code
            mmLabel2.TextSize = 9
            mmLabel2.TextXAlignment = Enum.TextXAlignment.Left
            mmLabel2.BackgroundTransparency = 1
            mmLabel2.ClipsDescendants = true
            
            local uvBtn = Instance.new("TextButton", mmRow)
            uvBtn.Size = UDim2.new(0, 65, 0, 24)
            uvBtn.Position = UDim2.fromScale(0.42, 0.15)
            uvBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
            uvBtn.Text = "UVALS"
            uvBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
            uvBtn.Font = Enum.Font.Code
            uvBtn.TextSize = 8
            self:_applyStyle(uvBtn, 2)
            
            uvBtn.MouseButton1Click:Connect(function()
                self:_showUpvaluesUI(mmData.Value, mmData.Key .. "() metamethod")
            end)
            
            local viewBtn = Instance.new("TextButton", mmRow)
            viewBtn.Size = UDim2.new(0, 65, 0, 24)
            viewBtn.Position = UDim2.fromScale(0.54, 0.15)
            viewBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 60)
            viewBtn.Text = "VIEW"
            viewBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
            viewBtn.Font = Enum.Font.Code
            viewBtn.TextSize = 8
            self:_applyStyle(viewBtn, 2)
            
            viewBtn.MouseButton1Click:Connect(function()
                self:_showSource(mmData.Value)
            end)
        end
    end
end
end



function Modules.ModulePoisoner:AddModuleToList(mod: ModuleScript) local n = mod.Name:lower() if n:find("chat") or n:find("roblox") then return end

local ui = self.State.UI
local container = Instance.new("Frame", ui.Sidebar)
container.Size = UDim2.new(1, -5, 0, 25)
container.BackgroundTransparency = 1

local b = Instance.new("TextButton", container)
b.Size = UDim2.new(0.65, 0, 1, 0)
b.Text = " " .. mod.Name
b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
b.Font = Enum.Font.Code
b.TextXAlignment = Enum.TextXAlignment.Left
b.ClipsDescendants = true
self:_applyStyle(b, 2)

local srcB = Instance.new("TextButton", container)
srcB.Size = UDim2.new(0.175, 0, 1, 0)
srcB.Position = UDim2.fromScale(0.65, 0)
srcB.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
srcB.Text = "V"
srcB.TextColor3 = Color3.fromRGB(100, 200, 255)
srcB.Font = Enum.Font.Code
srcB.TextSize = 8
self:_applyStyle(srcB, 2)

local editB = Instance.new("TextButton", container)
editB.Size = UDim2.new(0.175, 0, 1, 0)
editB.Position = UDim2.fromScale(0.825, 0)
editB.BackgroundColor3 = Color3.fromRGB(50, 40, 30)
editB.Text = "E"
editB.TextColor3 = Color3.fromRGB(255, 180, 100)
editB.Font = Enum.Font.Code
editB.TextSize = 8
self:_applyStyle(editB, 2)

self.State.SidebarButtons[container] = mod.Name

b.MouseButton1Click:Connect(function()
    self.State.SelectedModule = mod
    self.State.PathStack = {}
    local success, result = pcall(require, mod)
    if success then
        self:PopulateGrid(result, mod.Name)
    end
end)

srcB.MouseButton1Click:Connect(function()
    self.State.EditTarget = mod
    self:_showSource(mod)
end)

editB.MouseButton1Click:Connect(function()
    self.State.EditTarget = mod
    self:_showEditUI(mod, mod.Name)
end)
end

function Modules.ModulePoisoner:CreateUI() if self.State.UI then self.State.UI.Main.Visible = true return end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "Callum_Poisoner_V1"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.fromOffset(850, 550)
main.Position = UDim2.new(0.5, -425, 0.5, -275)
main.BackgroundColor3 = self.Config.BG_COLOR
main.BorderSizePixel = 0
main.ClipsDescendants = true
self:_applyStyle(main, 6)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = self.Config.HEADER_COLOR

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -220, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.Text = "Overseer";
title.TextColor3 = self.Config.ACCENT_COLOR
title.Font = Enum.Font.Code
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local backBtn = Instance.new("TextButton", header)
backBtn.Size = UDim2.new(0, 60, 0, 24)
backBtn.Position = UDim2.new(1, -195, 0.5, -12)
backBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
backBtn.Text = "< BACK"
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.Code
backBtn.TextSize = 10
self:_applyStyle(backBtn, 2)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.Code

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.fromOffset(0, 35)
content.BackgroundTransparency = 1

local searchInput = Instance.new("TextBox", content)
searchInput.Size = UDim2.new(0, 230, 0, 30)
searchInput.Position = UDim2.fromOffset(10, 10)
searchInput.BackgroundColor3 = self.Config.SECONDARY_COLOR
searchInput.PlaceholderText = "SEARCH MODULES..."
searchInput.Text = ""
searchInput.TextColor3 = self.Config.ACCENT_COLOR
searchInput.Font = Enum.Font.Code
searchInput.TextSize = 10
self:_applyStyle(searchInput, 4)

local sidebar = Instance.new("ScrollingFrame", content)
sidebar.Size = UDim2.new(0, 230, 1, -60)
sidebar.Position = UDim2.fromOffset(10, 50)
sidebar.BackgroundTransparency = 1
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 2
local sidebarList = Instance.new("UIListLayout", sidebar)
sidebarList.Padding = UDim.new(0, 4)

local grid = Instance.new("ScrollingFrame", content)
grid.Size = UDim2.new(1, -270, 1, -20)
grid.Position = UDim2.fromOffset(260, 10)
grid.BackgroundColor3 = self.Config.SECONDARY_COLOR
grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
grid.ScrollBarThickness = 2
self:_applyStyle(grid, 4)
local gridList = Instance.new("UIListLayout", grid)
gridList.SortOrder = Enum.SortOrder.LayoutOrder

local codeFrame = Instance.new("Frame", content)
codeFrame.Size = grid.Size
codeFrame.Position = grid.Position
codeFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
codeFrame.Visible = false
self:_applyStyle(codeFrame, 4)

local codeScroller = Instance.new("ScrollingFrame", codeFrame)
codeScroller.Size = UDim2.new(1, -20, 1, -60)
codeScroller.Position = UDim2.fromOffset(10, 10)
codeScroller.BackgroundTransparency = 1
codeScroller.ScrollBarThickness = 2
codeScroller.AutomaticCanvasSize = Enum.AutomaticSize.XY

local codeBox = Instance.new("TextBox", codeScroller)
codeBox.Size = UDim2.new(1, 0, 1, 0)
codeBox.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
codeBox.TextColor3 = Color3.fromRGB(200, 200, 200)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 10
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.TextEditable = false
codeBox.MultiLine = true
codeBox.AutomaticSize = Enum.AutomaticSize.XY
self:_applyStyle(codeBox, 4)

local copyBtn = Instance.new("TextButton", codeFrame)
copyBtn.Size = UDim2.new(0, 90, 0, 30)
copyBtn.Position = UDim2.new(1, -280, 1, -40)
copyBtn.BackgroundColor3 = self.Config.ACCENT_COLOR
copyBtn.Text = "COPY"
copyBtn.TextColor3 = Color3.new(0, 0, 0)
copyBtn.Font = Enum.Font.Code
copyBtn.TextSize = 10
self:_applyStyle(copyBtn, 4)

local editBtn = Instance.new("TextButton", codeFrame)
editBtn.Size = UDim2.new(0, 90, 0, 30)
editBtn.Position = UDim2.new(1, -185, 1, -40)
editBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
editBtn.Text = "EDIT"
editBtn.TextColor3 = Color3.fromRGB(255, 180, 100)
editBtn.Font = Enum.Font.Code
editBtn.TextSize = 10
self:_applyStyle(editBtn, 4)

local applyBtn = Instance.new("TextButton", codeFrame)
applyBtn.Size = UDim2.new(0, 90, 0, 30)
applyBtn.Position = UDim2.new(1, -280, 1, -40)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
applyBtn.Text = "APPLY"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.Code
applyBtn.TextSize = 10
applyBtn.Visible = false
self:_applyStyle(applyBtn, 4)

local discardBtn = Instance.new("TextButton", codeFrame)
discardBtn.Size = UDim2.new(0, 90, 0, 30)
discardBtn.Position = UDim2.new(1, -185, 1, -40)
discardBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
discardBtn.Text = "DISCARD"
discardBtn.TextColor3 = Color3.new(1, 1, 1)
discardBtn.Font = Enum.Font.Code
discardBtn.TextSize = 10
discardBtn.Visible = false
self:_applyStyle(discardBtn, 4)

local closeCode = Instance.new("TextButton", codeFrame)
closeCode.Size = UDim2.new(0, 90, 0, 30)
closeCode.Position = UDim2.new(0, 10, 1, -40)
closeCode.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeCode.Text = "EXIT"
closeCode.TextColor3 = Color3.new(1, 1, 1)
closeCode.Font = Enum.Font.Code
closeCode.TextSize = 10
self:_applyStyle(closeCode, 4)

self.State.UI = {
    ScreenGui = screenGui,
    Main = main,
    Title = title,
    Grid = grid,
    Sidebar = sidebar,
    CodeFrame = codeFrame,
    CodeBox = codeBox,
    Search = searchInput,
    EditMode = false,
    EditTarget = nil,
    OriginalCode = ""
}

--// --- RESCAN BUTTON ---
local scannedModules = {}

local function RescanModules()
    -- Clear the sidebar
    for btn, _ in pairs(self.State.SidebarButtons) do
        btn:Destroy()
    end
    self.State.SidebarButtons = {}
    
    -- Clear scanned modules
    scannedModules = {}
    
    -- Re-scan everything
    local function scan(root)
        for _, m in ipairs(root:GetDescendants()) do
            if m:IsA("ModuleScript") and not scannedModules[m] then
                scannedModules[m] = true
                self:AddModuleToList(m)
            end
        end
    end
    
    scan(ReplicatedStorage)
    scan(Players.LocalPlayer)
    
    if getloadedmodules then
        for _, m in ipairs(getloadedmodules()) do
            if not scannedModules[m] then
                scannedModules[m] = true
                self:AddModuleToList(m)
            end
        end
    end
end

local rescanBtn = Instance.new("TextButton")
rescanBtn.Size = UDim2.new(0, 70, 0, 22)
rescanBtn.Position = UDim2.new(1, -140, 0.5, -11)  -- Positioned left of the back button
rescanBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 40)
rescanBtn.Text = "RESCAN"
rescanBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
rescanBtn.Font = Enum.Font.Code
rescanBtn.TextSize = 10
self:_applyStyle(rescanBtn, 3)
rescanBtn.Parent = header

rescanBtn.MouseButton1Click:Connect(RescanModules)

backBtn.MouseButton1Click:Connect(function()
    if #self.State.PathStack > 0 then
        local prev = table.remove(self.State.PathStack)
        self:PopulateGrid(prev, "Parent")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

closeCode.MouseButton1Click:Connect(function()
    self.State.ViewingCode = false
    codeFrame.Visible = false
    grid.Visible = true
    ui.CodeBox.TextEditable = false
    copyBtn.Visible = true
    editBtn.Visible = true
    applyBtn.Visible = false
    discardBtn.Visible = false
    self.State.UI.EditMode = false
    title.Text = "PATH: " .. (self.State.SelectedModule and self.State.SelectedModule.Name or "Main")
end)

copyBtn.MouseButton1Click:Connect(function()
    self:_setClipboard(ui.CodeBox.Text)
    copyBtn.Text = "COPIED!"
    task.wait(1)
    copyBtn.Text = "COPY"
end)

editBtn.MouseButton1Click:Connect(function()
    self.State.UI.EditMode = true
    self.State.UI.OriginalCode = ui.CodeBox.Text
    ui.CodeBox.TextEditable = true
    copyBtn.Visible = false
    editBtn.Visible = false
    applyBtn.Visible = true
    discardBtn.Visible = true
    ui.Title.Text = ui.Title.Text .. " [EDITING]"
end)

applyBtn.MouseButton1Click:Connect(function()
    local editedCode = ui.CodeBox.Text
    
    -- Try to compile and execute the edited code
    local success, result = pcall(function()
        local compiled = load(editedCode, "EditedModule")
        if compiled then
            compiled()
            return true
        end
        return false
    end)
    
    if success and result then
        applyBtn.Text = "APPLIED!"
        applyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(1.5)
        applyBtn.Text = "APPLY"
        applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        
        -- Store patch info
        if self.State.EditTarget then
            self.State.ActivePatches[self.State.EditTarget] = self.State.ActivePatches[self.State.EditTarget] or {}
            self.State.ActivePatches[self.State.EditTarget]["_EditedCode"] = {
                Value = editedCode,
                Locked = false,
                IsFunction = false,
                IsEdit = true
            }
        end
    else
        applyBtn.Text = "ERROR!"
        applyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ui.CodeBox.Text = "-- [ERROR] " .. tostring(result) .. "\n\n" .. editedCode
        task.wait(2)
        applyBtn.Text = "APPLY"
        applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    end
end)

discardBtn.MouseButton1Click:Connect(function()
    self.State.UI.EditMode = false
    ui.CodeBox.Text = self.State.UI.OriginalCode
    ui.CodeBox.TextEditable = false
    copyBtn.Visible = true
    editBtn.Visible = true
    applyBtn.Visible = false
    discardBtn.Visible = false
    ui.Title.Text = ui.Title.Text:gsub(" %[EDITING%]", "")
end)

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = searchInput.Text:lower()
    for container, name in pairs(self.State.SidebarButtons) do
        container.Visible = name:lower():find(filter) ~= nil
    end
end)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

task.spawn(function()
    local paths = {ReplicatedStorage, Players.LocalPlayer, Workspace}
    for _, p in ipairs(paths) do
        for _, m in ipairs(p:GetDescendants()) do
            if m:IsA("ModuleScript") then
                self:AddModuleToList(m)
            end
        end
        task.wait()
    end
end)
end

function Modules.ModulePoisoner:Initialize() local module = self

RunService.Heartbeat:Connect(function()
    for tbl, keys in pairs(module.State.ActivePatches) do
        for key, data in pairs(keys) do
            if data.Locked then
                pcall(function()
                    if setreadonly then setreadonly(tbl, false) elseif make_writeable then make_writeable(tbl) end
                    if data.IsFunction then
                        if data.Value == "TRUE" then
                            rawset(tbl, key, function() return true end)
                        elseif data.Value == "FALSE" then
                            rawset(tbl, key, function() return false end)
                        end
                    else
                        rawset(tbl, key, data.Value)
                    end
                    if setreadonly then setreadonly(tbl, true) end
                end)
            end
        end
    end
end)

RegisterCommand({
    Name = "poisoner",
    Aliases = {"meta", "modulepoison", "mp"},
    Description = "Opens the high-tier Module Poisoner and Logic Hijacking UI."
}, function()
    module:CreateUI()
end)
end

--[[Modules.CallumAI = {
    State = {
        IsEnabled = true,
        LastResponse = "",
        LastGeneratedCode = "",
        IsProcessing = false,
        ExplorationBuffer = {}
    },
    Config = {
        -- REPLACEMENT REQUIRED: Insert your OpenRouter key here
        API_KEY = "", 
        MODEL = "tngtech/deepseek-r1t-chimera:free",
        ACCENT_COLOR = Color3.fromRGB(0, 255, 200),
        SCAN_KEYWORDS = {"network", "remote", "data", "store", "inventory", "purchase", "handler", "event", "admin", "combat", "security", "anti", "function", "state", "check", "weapon", "skill", "mana", "stamina", "health", "damage"},
        MAX_CONTEXT_LINES = 150
    }
}

-- Private utility: Formulates the capability manifest for the AI
function Modules.CallumAI:_getPanelContext(): string
    local manifest: string = "Exploit Panel Capability Manifest:\n"
    for name: string, _ in pairs(Modules) do
        manifest ..= "- " .. tostring(name) .. "\n"
    end
    return manifest
end

function Modules.CallumAI:_extractCode(text: string): string?
    return text:match("```lua\n?(.-)```") or text:match("```\n?(.-)```")
end

function Modules.CallumAI:_decompileScript(scriptInstance: Instance): string
    local decompiler: any = (decompile or decompile_script or (syn and syn.decompile) or function() return nil end)
    local success: boolean, result: any = pcall(decompiler, scriptInstance)
    
    if success and typeof(result) == "string" then
        local lines: {string} = result:split("\n")
        if #lines > self.Config.MAX_CONTEXT_LINES then
            local truncated: {string} = {}
            for i: number = 1, self.Config.MAX_CONTEXT_LINES do
                table.insert(truncated, lines[i])
            end
            return table.concat(truncated, "\n") .. "\n-- [TRUNCATED DUE TO SIZE]"
        end
        return result
    end
    return "Decompilation failed or not supported by current executor."
end

-- Private utility: Resolves string paths to game instances
function Modules.CallumAI:_getInstanceFromPath(path: string): Instance?
    local current: Instance = game
    for component: string in string.gmatch(path, "[^%.]+") do
        if not current then return nil end
        if string.find(component, ":GetService") then
            local serviceName: string? = component:match("'(.-)'") or component:match('"(.-)"')
            current = serviceName and game:GetService(serviceName) or nil
        else
            current = current:FindFirstChild(component)
        end
    end
    return current
end

-- Private utility: Generates a visual tree of the game hierarchy
function Modules.CallumAI:_getHierarchyMap(parent: Instance, depth: number): string
    local map: string = ""
    local indent: string = string.rep("  ", depth)
    local children: {Instance} = parent:GetChildren()
    
    for i: number, child: Instance in ipairs(children) do
        -- Performance safety: avoid flooding context with too many objects
        if i > 25 then 
            map ..= indent .. "... (" .. (#children - 25) .. " more items)\n"
            break 
        end
        map ..= string.format("%s%s [%s]\n", indent, child.Name, child.ClassName)
        if depth < 2 and (child:IsA("Folder") or child:IsA("Model")) then
            map ..= self:_getHierarchyMap(child, depth + 1)
        end
    end
    return map
end

-- Private utility: Scans high-value containers for forensic analysis
function Modules.CallumAI:_scanGameContainers(): string
    local report: string = "--- FORENSIC HIERARCHY ANALYSIS ---\n"
    local targets: {Instance} = {ReplicatedStorage, Workspace, ReplicatedFirst}
    
    for _, container: Instance in ipairs(targets) do
        report ..= "[" .. container.Name .. "]\n"
        report ..= self:_getHierarchyMap(container, 1)
    end
    
    return report
end

function Modules.CallumAI:FetchResponse(prompt: string, options: {Scan: boolean, Decompile: string?, Poison: string?, Silent: boolean}): string
    local requestFunc: any = (typeof(request) == "function" and request) or (typeof(syn) == "table" and syn.request) or (typeof(http) == "table" and http.request)
    
    if not requestFunc then return "Error: No HTTP capability." end
    
    local gameContext: string = options.Scan and self:_scanGameContainers() or ""
    local scriptContext: string = ""
    
    if options.Decompile then
        local target = self:_getInstanceFromPath(options.Decompile)
        if target then scriptContext = "\n[SOURCE]: " .. self:_decompileScript(target) end
    end

    local systemInstruction: string = [[
        Identity: Callum, elite Luau Architect.
        Task: Generate functional, optimized Luau code based on game hierarchy.
        STRICT RULES:
        1. NO COMMENTS in the code.
        2. NO explanations, introductions, or summaries.
        3. Output ONLY the code block.
        4. Use 'game:GetService()' for all services.
        5. Use local variables for everything.
        6. Ensure the code is 'ready-to-run'.
        7. If you cannot fulfill a request, return '-- ERROR: [Reason]'.
    ]------
    
    local userPayload: string = string.format("[CONTEXT]\n%s\n%s\n\n[REQUEST]\n%s", 
        gameContext, scriptContext, prompt)
    
    local success, result = pcall(function()
        local response = requestFunc({
            Url = "https://openrouter.ai/api/v1/chat/completions",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. self.Config.API_KEY,
                ["HTTP-Referer"] = "https://roblox.com",
                ["X-Title"] = "Callum AI"
            },
            Body = HttpService:JSONEncode({
                model = "deepseek/deepseek-chat", -- Highly recommended for no-comment logic
                messages = {
                    {role = "system", content = systemInstruction},
                    {role = "user", content = userPayload}
                },
                temperature = 0.2 -- Lower temperature = more stable, less "creative" (better for code)
            })
        })
        
        if response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            local content = data.choices[1].message.content
            
            -- If we only want the code, strip everything else immediately
            if options.Silent then
                return self:_extractCode(content) or content
            end
            return content
        end
        return "Uplink Failure."
    end)
    
    return success and result or "Critical Error."
end

function Modules.CallumAI:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "callum",
        Aliases = {"c"},
        Description = "Clean-code AI interface."
    }, function(args: {string})
        local sub = args[1] and args[1]:lower() or ""
        local isRun = (sub == "run" or sub == "execute")
        
        -- If it's a 'run' command, we set 'Silent' to true to force code-only output
        module.State.IsProcessing = true
        
        task.spawn(function()
            local reply = module:FetchResponse(table.concat(args, " "), {
                Scan = true,
                Decompile = (sub == "dec" and args[2] or nil),
                Silent = isRun -- This triggers the code-only filter
            })
            
            module.State.IsProcessing = false
            
            if isRun then
                local cleanCode = module:_extractCode(reply) or reply
                -- Clean up any residual markdown symbols just in case
                cleanCode = cleanCode:gsub("```lua", ""):gsub("```", "")
                
                local func, err = loadstring(cleanCode)
                if func then
                    task.spawn(func)
                    DoNotif("Script Executed Successfully.", 2)
                else
                    warn("[CallumAI] Execution Error: " .. tostring(err))
                    print("Attempted Code:\n" .. cleanCode)
                end
            else
                -- Standard output for 'scan' or 'dec'
                if Modules.CommandBar then
                    Modules.CommandBar:AddOutput(reply, module.Config.ACCENT_COLOR)
                else
                    print(reply)
                end
            end
        end)
    end)
end--]]

Modules.SourceBhop = {
    State = {
        IsEnabled = false,
        Velocity = Vector3.zero,
        SpaceHeld = false,
        UI = nil,
        Connections = {},
        OriginalWalkSpeed = 16,
        OriginalJumpPower = 50,
        HasStoredOriginals = false,
        LastCharacter = nil
    },
    Config = {
        GroundAccel = 45,
        AirAccel = 3500,
        MaxAirSpeed = 15,
        RunSpeed = 24,
        JumpPower = 28,
        Gravity = 100,
        Friction = 7,
        StopSpeed = 5
    },
    Theme = {
        Main = Color3.fromRGB(15, 15, 18),
        Accent = Color3.fromRGB(0, 255, 180),
        Text = Color3.fromRGB(230, 230, 235),
        Button = Color3.fromRGB(25, 25, 30)
    }
}

function Modules.SourceBhop:_createUI(): ()
    if self.State.UI then self.State.UI.Enabled = true return end
    
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "Zuka_Bhop_v2"
    sg.ResetOnSpawn = false
    self.State.UI = sg
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.fromOffset(180, 80)
    main.Position = UDim2.new(0, 40, 0.5, -40)
    main.BackgroundColor3 = self.Theme.Main
    main.BorderSizePixel = 0
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 4)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = self.Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Text = "BHOP"
    title.TextColor3 = self.Theme.Accent
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.BackgroundTransparency = 1
    
    local toggle = Instance.new("TextButton", main)
    toggle.Size = UDim2.new(0.9, 0, 0, 35)
    toggle.Position = UDim2.new(0.05, 0, 0.4, 0)
    toggle.BackgroundColor3 = self.Theme.Button
    toggle.Text = "SYSTEM: OFF"
    toggle.TextColor3 = self.State.IsEnabled and self.Theme.Accent or self.Theme.Text
    toggle.Font = Enum.Font.Code
    toggle.TextSize = 13
    local bCorner = Instance.new("UICorner", toggle)
    bCorner.CornerRadius = UDim.new(0, 4)
    
    toggle.MouseButton1Click:Connect(function()
        local character = Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        self.State.IsEnabled = not self.State.IsEnabled
        toggle.Text = self.State.IsEnabled and "SYSTEM: ON" or "SYSTEM: OFF"
        toggle.TextColor3 = self.State.IsEnabled and self.Theme.Accent or self.State.Text
        
        if self.State.IsEnabled then
            if humanoid and not self.State.HasStoredOriginals then
                self.State.OriginalWalkSpeed = humanoid.WalkSpeed
                self.State.OriginalJumpPower = humanoid.JumpPower
                self.State.HasStoredOriginals = true
            end
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        else
            if humanoid then
                humanoid.WalkSpeed = self.State.HasStoredOriginals and self.State.OriginalWalkSpeed or 16
                humanoid.JumpPower = self.State.HasStoredOriginals and self.State.OriginalJumpPower or 50
            end
            self.State.Velocity = Vector3.zero
        end
    end)
    
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Modules.SourceBhop:Process(dt: number): ()
    if not self.State.IsEnabled then return end
    
    local character = Players.LocalPlayer.Character
    if character ~= self.State.LastCharacter then
        self.State.LastCharacter = character
        self.State.HasStoredOriginals = false
        self.State.Velocity = Vector3.zero
    end
    
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not (humanoid and hrp and humanoid.Health > 0) then return end
    
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local groundCheck = Workspace:Raycast(hrp.Position, Vector3.new(0, -3.8, 0), rayParams)
    local isGrounded = groundCheck and groundCheck.Instance and groundCheck.Instance.CanCollide
    
    local cam = Workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local moveInput = Vector3.zero
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveInput += Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveInput -= Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveInput -= Vector3.new(right.X, 0, right.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveInput += Vector3.new(right.X, 0, right.Z).Unit end
    
    if moveInput.Magnitude > 0 then moveInput = moveInput.Unit end
    
    if isGrounded then
        local speed = self.State.Velocity.Magnitude
        if speed > 0.1 then
            local drop = math.max(speed, self.Config.StopSpeed) * self.Config.Friction * dt
            self.State.Velocity *= math.max(speed - drop, 0) / speed
        else
            self.State.Velocity = Vector3.zero
        end
        
        local wishDir = moveInput
        local curSpeed = self.State.Velocity:Dot(wishDir)
        local addSpeed = self.Config.RunSpeed - curSpeed
        if addSpeed > 0 then
            local acc = math.min(self.Config.GroundAccel * dt * self.Config.RunSpeed, addSpeed)
            self.State.Velocity += wishDir * acc
        end
        
        if self.State.SpaceHeld then
            self.State.Velocity = Vector3.new(self.State.Velocity.X, self.Config.JumpPower, self.State.Velocity.Z)
        else
            self.State.Velocity = Vector3.new(self.State.Velocity.X, 0, self.State.Velocity.Z)
        end
    else
        local wishDir = moveInput
        local wishSpeed = self.Config.MaxAirSpeed
        local curSpeed = self.State.Velocity:Dot(wishDir)
        local addSpeed = wishSpeed - curSpeed
        if addSpeed > 0 then
            local acc = math.min(self.Config.AirAccel * dt * wishSpeed, addSpeed)
            self.State.Velocity += wishDir * acc
        end
        self.State.Velocity += Vector3.new(0, -self.Config.Gravity * dt, 0)
    end
    
    hrp.AssemblyLinearVelocity = self.State.Velocity
end

function Modules.SourceBhop:Initialize(): ()
    local module = self
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Space then
            module.State.SpaceHeld = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            module.State.SpaceHeld = false
        end
    end)
    
    RunService.Heartbeat:Connect(function(dt)
        module:Process(dt)
    end)
    
    RegisterCommand({
        Name = "bhop",
        Aliases = {"sourcemove", "bhopengine"},
        Description = "Enables Source Engine momentum and BunnyHopping."
    }, function()
        module:_createUI()
    end)
end

Modules.VoidFling = {
    State = {
        IsFlinging = false
    }
}

function Modules.VoidFling:Execute(target: Player): ()
    if self.State.IsFlinging then return end
    local character: Model? = LocalPlayer.Character
    local hrp: BasePart? = character and character:FindFirstChild("HumanoidRootPart")
    local targetHrp: BasePart? = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    
    if not (hrp and targetHrp) then return end
    
    self.State.IsFlinging = true
    local originalCFrame: CFrame = hrp.CFrame
    local originalHeight: number = Workspace.FallenPartsDestroyHeight
    
    task.spawn(function()
        pcall(function()
            Workspace.FallenPartsDestroyHeight = 0/0
            local connection: RBXScriptConnection
            connection = RunService.Stepped:Connect(function()
                if not self.State.IsFlinging then 
                    connection:Disconnect()
                    return 
                end
                hrp.CanCollide = false
                hrp.Velocity = Vector3.new(0, 1e7, 0)
                hrp.CFrame = targetHrp.CFrame
            end)
            
            task.wait(0.5)
            self.State.IsFlinging = false
            Workspace.FallenPartsDestroyHeight = originalHeight
            hrp.Velocity = Vector3.zero
            hrp.CFrame = originalCFrame
        end)
    end)
end

RegisterCommand({
    Name = "vfling",
    Aliases = {"voidfling", "killfling"},
    Description = "Sends a target to the void using NaN height manipulation."
}, function(args: {string})
    local target: Player? = Utilities.findPlayer(args[1] or "")
    if target and target ~= LocalPlayer then
        Modules.VoidFling:Execute(target)
    else
        DoNotif("Invalid target for VoidFling.", 3)
    end
end)

Modules.NetworkSaturator = {
    State = {
        Active = false
    }
}

function Modules.NetworkSaturator:Start(): ()
    self.State.Active = true
    task.spawn(function()
        while self.State.Active do
            for _: number, obj: Instance in ipairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    pcall(obj.FireServer, obj, math.huge, "Zuka_Saturate", string.rep("0", 100))
                end
            end
            task.wait(0.1)
        end
    end)
    DoNotif("Network Saturation: ACTIVE", 2)
end

RegisterCommand({
    Name = "netsat",
    Aliases = {"lagserver", "remotenuke"},
    Description = "Saturates discoverable remotes with high-density data payloads."
}, function()
    if Modules.NetworkSaturator.State.Active then
        Modules.NetworkSaturator.State.Active = false
        DoNotif("Network Saturation: DISABLED", 2)
    else
        Modules.NetworkSaturator:Start()
    end
end)

Modules.UltimateGod = {
    State = {
        IsEnabled = false,
        Connection = nil
    }
}

function Modules.UltimateGod:Toggle(): ()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self.State.Connection = RunService.Heartbeat:Connect(function()
            local char: Model? = LocalPlayer.Character
            local hum: Humanoid? = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                if hum.Health <= 0 then
                    hum.Health = hum.MaxHealth
                end
            end
        end)
        DoNotif("Ultimate Godmode: ENABLED", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        local hum: Humanoid? = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
        DoNotif("Ultimate Godmode: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "god",
    Aliases = {"godmode", "integrityv3"},
    Description = "Aggressively locks humanoid state and health to prevent death."
}, function()
    Modules.UltimateGod:Toggle()
end)

Modules.NetworkNormalizer = {
    State = {
        IsNormalized = false,
        OriginalNames = {} 
    },
    Config = {
        TARGET_CONTAINERS = {ReplicatedStorage},
        PREFIX = "" 
    }
}

function Modules.NetworkNormalizer:Normalize()
    local count = 0
    table.clear(self.State.OriginalNames)
    
    print("--- [Network Normalization Started] ---")
    
    for _, container in ipairs(self.Config.TARGET_CONTAINERS) do
        local descendants = container:GetDescendants()
        
        for _, obj in ipairs(descendants) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                count += 1
                local oldPath = obj:GetFullName()
                local newName = self.Config.PREFIX .. tostring(count)
                
                self.State.OriginalNames[obj] = {
                    Name = obj.Name,
                    Path = oldPath
                }
                
                local success, err = pcall(function()
                    obj.Name = newName
                end)
                
                if success then
                    print(string.format("[ID: %d] Normalized: %s", count, oldPath))
                else
                    warn(string.format("[ID: %d] Failed to rename: %s | Error: %s", count, oldPath, err))
                end
            end
        end
    end
    
    self.State.IsNormalized = true
    DoNotif(string.format("Normalized %d network objects. Check F9 for the map.", count), 4)
    print("--- [Normalization Complete] ---")
end

function Modules.NetworkNormalizer:Restore()
    if not self.State.IsNormalized then
        return DoNotif("Network is not currently normalized.", 3)
    end
    
    local count = 0
    for obj, data in pairs(self.State.OriginalNames) do
        if obj and obj.Parent then
            pcall(function()
                obj.Name = data.Name
                count += 1
            end)
        end
    end
    
    self.State.IsNormalized = false
    table.clear(self.State.OriginalNames)
    DoNotif(string.format("Restored %d network objects to original states.", count), 3)
end

function Modules.NetworkNormalizer:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "normalize",
        Aliases = {"renameremotes", "simplifynet"},
        Description = "Renames all Remotes in ReplicatedStorage to a numerical sequence (1-100+)."
    }, function()
        module:Normalize()
    end)
    
    RegisterCommand({
        Name = "unnormalize",
        Aliases = {"restoreremotes"},
        Description = "Restores all renamed remotes to their original obfuscated names."
    }, function()
        module:Restore()
    end)
end

Modules.UpvalueSurgeon = {
    State = {
        IsScanning = false
    },
    Config = {
        MAX_RESULTS = 50,
        BLACKLIST = {"Chat", "PlayerScripts", "CharacterSounds", "BubbleChat"}
    }
}

function Modules.UpvalueSurgeon:_convert(val: string): any
    if val:lower() == "true" then return true end
    if val:lower() == "false" then return false end
    if tonumber(val) then return tonumber(val) end
    return val
end

function Modules.UpvalueSurgeon:ScanGC(targetName: string)
    local matches = {}
    local getUpvalue = (debug and debug.getupvalue) or getupvalue
    local getInfo = (debug and debug.getinfo) or getinfo
    local isL = (islclosure or function(f) return true end) 

    if not (getgc and getUpvalue and getInfo) then
        return matches
    end

    for _, obj in ipairs(getgc()) do
        if type(obj) == "function" and isL(obj) then
            local success, info = pcall(getInfo, obj)
            if success and info.source then
                local blacklisted = false
                for _, word in ipairs(self.Config.BLACKLIST) do
                    if info.source:find(word) then
                        blacklisted = true
                        break
                    end
                end

                if not blacklisted then
                    local idx = 1
                    while true do
                        local name, val = nil, nil
                        local ok, err = pcall(function()
                            name, val = getUpvalue(obj, idx)
                        end)
                        
                        if not ok or not name then break end
                        
                        if tostring(name) == targetName or (type(name) == "string" and name:lower() == targetName:lower()) then
                            table.insert(matches, {
                                Function = obj,
                                Index = idx,
                                Value = val,
                                Source = info.source,
                                FuncName = info.name or "Anonymous"
                            })
                        end
                        idx += 1
                        if idx > 100 then break end
                    end
                end
            end
        end
        if #matches >= self.Config.MAX_RESULTS then break end
    end
    return matches
end

function Modules.UpvalueSurgeon:Operate(targetName: string, rawValue: string)
    local newValue = self:_convert(rawValue)
    local setUpvalue = (debug and debug.setupvalue) or setupvalue
    local matches = self:ScanGC(targetName)
    local count = 0

    if not setUpvalue then return DoNotif("Executor lacks 'setupvalue'.", 3) end

    for _, m in ipairs(matches) do
        local ok = pcall(setUpvalue, m.Function, m.Index, newValue)
        if ok then
            count += 1
            print(string.format("[SURGEON] Modified upvalue '%s' in %s", targetName, m.Source))
        end
    end

    DoNotif(string.format("Surgery successful. Patched %d functions.", count), 3)
end

function Modules.UpvalueSurgeon:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "upvalue",
        Aliases = {"surgeon", "ups"},
        Description = "Globally overwrites a local variable (upvalue) by name."
    }, function(args)
        local target, val = args[1], args[2]
        if not target or not val then return DoNotif("Usage: ;upvalue <name> <value>", 3) end
        module:Operate(target, val)
    end)

    RegisterCommand({
        Name = "scanup",
        Aliases = {"fup"},
        Description = "Scans game memory for functions containing a specific variable name."
    }, function(args)
        local target = args[1]
        if not target then return DoNotif("Variable name required.", 3) end
        
        DoNotif("Performing memory scan for: " .. target, 2)
        task.spawn(function()
            local matches = module:ScanGC(target)
            if #matches == 0 then
                DoNotif("No instances found in memory.", 3)
            else
                print("--- [Surgeon Scan Report] ---")
                for i, m in ipairs(matches) do
                    print(string.format("[%d] %s | Value: %s | Source: %s", i, m.FuncName, tostring(m.Value), m.Source))
                end
                DoNotif("Scan Complete. Found " .. #matches .. " matches. Check F9.", 4)
            end
        end)
    end)
end

Modules.FolderBringer = {
    State = {
        IsEnabled = true
    },
    Dependencies = {"Workspace", "Players"},
    Services = {}
}

--[[
    Internal execution logic.
    Tries to find a folder by name and teleport its contents to the player.
    Supports: ;bfldr {folderName} OR ;bfldr {folderName} {partName}
--]]
function Modules.FolderBringer:Execute(args)
    if #args == 0 then
        return DoNotif("Usage: ;bringfolder {folderName} [partName]", 3)
    end

    local folder, partFilter
    local workspace = self.Services.Workspace
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    
    if not char then 
        return DoNotif("Character not found.", 3) 
    end

    for i = #args, 1, -1 do
        local potentialName = table.concat(args, " ", 1, i):lower()
        local potentialFilter = table.concat(args, " ", i + 1):lower()

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Folder") and obj.Name:lower() == potentialName then
                folder = obj
                partFilter = potentialFilter
                break
            end
        end
        if folder then break end
    end

    if not folder then
        return DoNotif("Folder sequence not found in Workspace.", 3)
    end

    local pivot = char:GetPivot()
    local bringCount = 0

    -- Securely pivot the parts
    for _, desc in ipairs(folder:GetDescendants()) do
        if desc:IsA("BasePart") then
            local shouldBring = true
            
            if partFilter and partFilter ~= "" then
                local n = desc.Name:lower()
                shouldBring = (n == partFilter) or (n:find(partFilter, 1, true) ~= nil)
            end

            if shouldBring then
                desc:PivotTo(pivot)
                bringCount = bringCount + 1
            end
        end
    end

    if bringCount > 0 then
        DoNotif(string.format("Brought %d parts from '%s'.", bringCount, folder.Name), 2)
    else
        DoNotif("No matching parts found in the folder.", 2)
    end
end

--// Initialize the module and register the command
function Modules.FolderBringer:Initialize()
    local module = self
    
    -- Load required services using the Zuka pattern
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "bringfolder",
        Aliases = {"bfldr", "folderbring"},
        Description = "Teleports all parts (or a specific part) from a Workspace folder to you."
    }, function(args)
        module:Execute(args)
    end)
end

Modules.QuickExecutor = {
    State = {
        IsEnabled = true
    }
}

--[[
    Internal execution logic.
    Compiles the string arguments and spawns them as a new thread.
    Usage: ;execute print("Hello World")
--]]
function Modules.QuickExecutor:RunCode(args)
    local code = table.concat(args, " ")

    if not code or code == "" then
        return DoNotif("Quick Executor: No code provided.", 2)
    end

    -- Attempt to compile the string
    local func, compileError = loadstring(code)

    if not func then
        warn("--> [QuickExecutor] Syntax Error:", compileError)
        return DoNotif("Syntax Error: Check F9 for details.", 3)
    end

    -- Use pcall during the spawn to catch runtime errors without halting the module
    local success, runError = pcall(function()
        task.spawn(func)
    end)

    if not success then
        warn("--> [QuickExecutor] Runtime Error:", runError)
        DoNotif("Runtime Error occurred. Check F9 console.", 3)
    else
        DoNotif("Code executed.", 1)
    end
end

--// Initialize the module and register the command
function Modules.QuickExecutor:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "loadstring",
        Aliases = {"ls", "lstring", "loads", "execute", "run"},
        Description = "Compiles and executes Lua code directly from the command bar."
    }, function(args)
        module:RunCode(args)
    end)
end

Modules.CommandHistory = {
    State = {
        LastCommand = nil,  -- Stores the raw command string
        PrevCommand = nil   -- Stores the one before that (for when you spam ;re)
    }
}

--[[
    Internal recorder.
    This logic filters out history commands to prevent an infinite loop.
--]]
function Modules.CommandHistory:Record(message)
    -- Ignore the prefix and get the command name
    local cmdName = message:sub(#Prefix + 1):match("%S+")
    if not cmdName then return end
    cmdName = cmdName:lower()

    -- We don't record the history commands themselves
    local blacklist = {["lastcommand"] = true, ["lastcmd"] = true, ["re"] = true}
    
    if not blacklist[cmdName] then
        self.State.PrevCommand = self.State.LastCommand
        self.State.LastCommand = message
    end
end

--[[
    Internal execution logic.
    Replays the last recorded message through the panel processor.
--]]
function Modules.CommandHistory:ExecuteLast()
    local toRun = self.State.LastCommand
    
    if not toRun then
        return DoNotif("No previous command recorded.", 2)
    end

    -- Visual feedback in the command bar if available
    if Modules.CommandBar and Modules.CommandBar.AddOutput then
        Modules.CommandBar:AddOutput("Replaying: " .. toRun, Modules.CommandBar.Theme.Accent)
    end

    processCommand(toRun)
end

--// Initialize the module and register the command
function Modules.CommandHistory:Initialize()
    local module = self


    local oldProcess = processCommand
    getgenv().processCommand = function(message)
        module:Record(message)
        return oldProcess(message)
    end

    RegisterCommand({
        Name = "lastcommand",
        Aliases = {"lastcmd", "re", "redo"},
        Description = "Re-runs the last command you successfully executed."
    }, function()
        module:ExecuteLast()
    end)
end

Modules.CommandLooper = {
    State = {
        IsRunning = false,
        LoopThread = nil,
        CurrentCommand = nil
    },
    Config = {
        Interval = 1 -- Seconds between executions
    }
}

--[[
    Internal loop logic.
    Uses task.spawn to ensure the main script never yields.
--]]
function Modules.CommandLooper:Start(commandName, args)
    local cmdFunc = Commands[commandName:lower()]
    
    if not cmdFunc then
        return DoNotif(string.format("Loop Error: Command ';%s' not found.", commandName), 3)
    end

    -- Safety: Prevent the user from looping the loop command
    if commandName:lower() == "cmdloop" or commandName:lower() == "commandloop" then
        return DoNotif("Architect Error: Infinite recursion prevented.", 3)
    end

    -- Stop any existing loop first
    self:Stop()

    self.State.IsRunning = true
    self.State.CurrentCommand = commandName
    
    DoNotif(string.format("Looping command ';%s' every %ds.", commandName, self.Config.Interval), 2)

    self.State.LoopThread = task.spawn(function()
        while self.State.IsRunning do
            -- Wrap in pcall so an error in the looped command doesn't kill the whole panel
            local success, err = pcall(cmdFunc, args)
            if not success then
                warn("--> [CommandLooper] Error in loop:", err)
            end
            task.wait(self.Config.Interval)
        end
    end)
end

--[[
    Stops the currently active loop and cleans up the thread.
--]]
function Modules.CommandLooper:Stop()
    if not self.State.IsRunning then return end

    self.State.IsRunning = false
    if self.State.LoopThread then
        task.cancel(self.State.LoopThread)
        self.State.LoopThread = nil
    end

    DoNotif(string.format("Stopped loop for ';%s'.", self.State.CurrentCommand or "unknown"), 2)
    self.State.CurrentCommand = nil
end

--// Initialize the module and register the commands
function Modules.CommandLooper:Initialize()
    local module = self
    
    RegisterCommand({
        Name = "commandloop",
        Aliases = {"cmdloop", "cloop"},
        Description = "Runs a command repeatedly."
    }, function(args)
        if #args == 0 then
            return DoNotif("Usage: ;cmdloop <command> [args]", 3)
        end

        local cmdTarget = table.remove(args, 1)
        module:Start(cmdTarget, args)
    end)

    RegisterCommand({
        Name = "stoploop",
        Aliases = {"uncmdloop", "sloop", "stopl", "unloop"},
        Description = "Stops the currently running command loop."
    }, function()
        if not module.State.IsRunning then
            return DoNotif("No command is currently looping.", 2)
        end
        module:Stop()
    end)
end

Modules.ChatFilterReseter = {
    State = {
        IsEnabled = true
    },
    Dependencies = {"Players"},
    Services = {}
}

--[[
    Internal execution logic.
    Sends /e hi to the chat 3 times to clear the local filter buffer.
--]]
function Modules.ChatFilterReseter:Reset()
    local lp = self.Services.Players.LocalPlayer
    if not lp then return end

    DoNotif("Resetting chat filter...", 2)

    for i = 1, 3 do
        pcall(function()
            lp:Chat("/e hi")
        end)
        
        -- A micro-wait ensures the server registers three distinct events
        task.wait(0.1)
    end

    DoNotif("Filter Reset: Complete.", 2)
end

--// Initialize the module and register the command
function Modules.ChatFilterReseter:Initialize()
    local module = self

    -- Load required services
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "resetfilter",
        Aliases = {"ref", "resetchat", "unfilter"},
        Description = "Sends emote commands to try and stop Roblox from tagging your messages."
    }, function()
        module:Reset()
    end)
end

Modules.ToolMasher = {
    State = {
        IsExecuting = false
    },
    Dependencies = {"Players"},
    Services = {}
}

--[[
    Internal execution logic.
    Moves all tools to the character, fires Activate(), and resets them.
--]]
function Modules.ToolMasher:Mash()
    if self.State.IsExecuting then return end
    
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local backpack = lp:FindFirstChildOfClass("Backpack")

    if not char or not backpack then
        return DoNotif("Tool Masher: Character or Backpack missing.", 3)
    end

    self.State.IsExecuting = true
    local toolBuffer = {}

    -- 1. Collect and Equip all tools from backpack
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(toolBuffer, tool)
            tool.Parent = char
        end
    end

    -- 2. Include tools already equipped
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and not table.find(toolBuffer, tool) then
            table.insert(toolBuffer, tool)
        end
    end

    if #toolBuffer == 0 then
        self.State.IsExecuting = false
        return DoNotif("No tools found to mash.", 2)
    end

    -- A micro-wait allows the engine to register the tools as 'Equipped'
    task.wait(0.1)

    -- 3. Activate all tools
    local successCount = 0
    for _, tool in ipairs(toolBuffer) do
        pcall(function()
            tool:Activate()
            successCount = successCount + 1
        end)
    end

    -- 4. Clean up: Move tools back to backpack to prevent clutter
    task.wait(0.1)
    for _, tool in ipairs(toolBuffer) do
        pcall(function()
            tool.Parent = backpack
        end)
    end

    DoNotif(string.format("Mashed %d tools successfully.", successCount), 2)
    self.State.IsExecuting = false
end

--// Initialize the module and register the command
function Modules.ToolMasher:Initialize()
    local module = self
    
    -- Load services
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "usetools",
        Aliases = {"uset", "mash", "useall"},
        Description = "Equips every tool you own, uses them once, and puts them back."
    }, function()
        module:Mash()
    end)
end

Modules.InvisDeleter = {
    State = {
        IsScanning = false
    },
    Dependencies = {"Workspace"},
    Services = {}
}

--[[
    Internal execution logic.
    Filters: BasePart, Transparency >= 1, CanCollide == true.
--]]
function Modules.InvisDeleter:Purge()
    if self.State.IsScanning then 
        return DoNotif("Purge already in progress...", 2) 
    end

    local workspace = self.Services.Workspace
    local count = 0
    
    self.State.IsScanning = true
    DoNotif("Scanning for invisible walls...", 2)

    -- Run in a separate thread to prevent UI hang
    task.spawn(function()
        local descendants = workspace:GetDescendants()
        
        for i, part in ipairs(descendants) do
            -- Performance check: Yield every 500 objects to prevent frame drops
            if i % 500 == 0 then task.wait() end

            if part:IsA("BasePart") then

                if part.Transparency >= 1 and part.CanCollide then
                    
                    -- Safety: Never delete parts belonging to your own character
                    local char = game:GetService("Players").LocalPlayer.Character
                    if not (char and part:IsDescendantOf(char)) then
                        pcall(function()
                            part:Destroy()
                            count = count + 1
                        end)
                    end
                end
            end
        end

        self.State.IsScanning = false
        DoNotif(string.format("Purge complete. Destroyed %d parts.", count), 3)
    end)
end

--// Initialize the module and register the command
function Modules.InvisDeleter:Initialize()
    local module = self
    
    -- Load Workspace service
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "deleteinvisparts",
        Aliases = {"deleteinvisibleparts", "dip", "delinvis", "unblock"},
        Description = "Removes all invisible parts that have collisions enabled (Invisible Walls)."
    }, function()
        module:Purge()
    end)
end

Modules.KickShield = {
    State = {
        IsEnabled = false,
        Mode = "FakeSuccess", -- Options: "FakeSuccess" or "Error"
        OriginalNamecall = nil
    },
    Dependencies = {"Players"},
    Services = {}
}

--[[
    Internal Hooking Logic.
    Uses a metatable hook to intercept the :Kick() method.
--]]
function Modules.KickShield:ApplyHook()
    local success, mt = pcall(getrawmetatable, game)
    if not success or not mt then
        return DoNotif("KickShield: Metatable access denied.", 3)
    end

    if self.State.OriginalNamecall then return end -- Already hooked

    self.State.OriginalNamecall = mt.__namecall
    local original = self.State.OriginalNamecall
    local lp = self.Services.Players.LocalPlayer

    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(selfArg, ...)
        local method = getnamecallmethod()
        
        if selfArg == lp and (method == "Kick" or method == "kick") then
            local currentMode = Modules.KickShield.State.Mode
            
            warn("--> [KickShield] Intercepted Kick Attempt. Mode: " .. currentMode)
            
            if currentMode == "Error" then
                -- This kills the calling script entirely by throwing a Lua error.
                error("Critical Engine Failure: Memory Address 0x000F is Read-Only.")
                return nil
            else
                -- FakeSuccess: The script thinks it kicked you, but nothing happens.
                return nil
            end
        end
        
        return original(selfArg, ...)
    end)
    setreadonly(mt, true)
    
    self.State.IsEnabled = true
    DoNotif("KickShield: Active [Mode: " .. self.State.Mode .. "]", 2)
end

--[[
    Internal execution logic for command processing.
--]]
function Modules.KickShield:Toggle(modeArg)
    local m = tostring(modeArg):lower()

    if m == "error" or m == "fail" or m == "crash" then
        self.State.Mode = "Error"
    elseif m == "success" or m == "ok" or m == "fake" or m == "nil" then
        self.State.Mode = "FakeSuccess"
    end

    if not self.State.IsEnabled then
        self:ApplyHook()
    else
        DoNotif("KickShield: Updated Mode to " .. self.State.Mode, 2)
    end
end

--// Initialize the module and register the command
function Modules.KickShield:Initialize()
    local module = self
    
    -- Load Players service
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end

    RegisterCommand({
        Name = "kickshield",
        Aliases = {"ks", "shield", "bypasskickv2"},
        Description = "Prevents kicks. Modes: ;shield error (crashes script) or ;shield fake (spoofs success)."
    }, function(args)
        module:Toggle(args[1] or "fake")
    end)
end

Modules.RaycastVisualBypass = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        BlacklistedNames = {}
    }
}

function Modules.RaycastVisualBypass:Toggle(): ()
    if not (getrawmetatable and getnamecallmethod and newcclosure) then
        return DoNotif("Environment does not support namecall hooks.", 3)
    end

    local mt = getrawmetatable(game)
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(selfArg, ...)
            local method = getnamecallmethod()
            local args = {...}

            if selfArg == Workspace and method == "Raycast" then
                local result = self.State.OriginalNamecall(selfArg, unpack(args))
                if result and result.Instance and self.State.BlacklistedNames[result.Instance.Name] then
                    return nil
                end
            end

            return self.State.OriginalNamecall(selfArg, unpack(args))
        end)

        setreadonly(mt, true)
        DoNotif("Raycast Bypass: ENABLED (Hiding specific parts from scripts)", 2)
    else
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
        DoNotif("Raycast Bypass: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "rayblock",
    Aliases = {"rayignore", "rbloc"},
    Description = "Makes scripts ignore specific parts during raycasting. Usage: ;rb [PartName]"
}, function(args)
    local name = args[1]
    if not name then
        Modules.RaycastVisualBypass:Toggle()
    else
        Modules.RaycastVisualBypass.State.BlacklistedNames[name] = true
        DoNotif("Added '" .. name .. "' to raycast blacklist.", 2)
        if not Modules.RaycastVisualBypass.State.IsEnabled then
            Modules.RaycastVisualBypass:Toggle()
        end
    end
end)

Modules.SpatialQueryBypass = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil
    }
}

function Modules.SpatialQueryBypass:Toggle(): ()
    local mt = getrawmetatable(game)
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(selfArg, ...)
            local method = getnamecallmethod()
            if selfArg == Workspace and (method == "GetPartBoundsInBox" or method == "GetPartBoundsInRadius" or method == "GetPartsInPart") then
                local results = self.State.OriginalNamecall(selfArg, ...)
                if typeof(results) == "table" then
                    for i = #results, 1, -1 do
                        if results[i]:IsDescendantOf(LocalPlayer.Character) then
                            table.remove(results, i)
                        end
                    end
                    return results
                end
            end
            return self.State.OriginalNamecall(selfArg, ...)
        end)

        setreadonly(mt, true)
        DoNotif("Spatial Query Bypass: ENABLED (Invisible to area-detection scripts)", 3)
    else
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
        DoNotif("Spatial Query Bypass: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "ghostmode",
    Aliases = {"invisdetect", "gm"},
    Description = "Prevents anti-cheats from detecting your character inside parts or zones."
}, function()
    Modules.SpatialQueryBypass:Toggle()
end)

Modules.AutoInteract = {
    State = {
        IsEnabled = false,
        Radius = 15,
        Connection = nil
    }
}

function Modules.AutoInteract:Enable(radius: number)
    if self.State.IsEnabled then self:Disable() end
    self.State.Radius = tonumber(radius) or 15
    self.State.IsEnabled = true
    
    self.State.Connection = RunService.Heartbeat:Connect(function()
        local character = Players.LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local part = prompt.Parent
                if part and part:IsA("BasePart") then
                    local distance = (hrp.Position - part.Position).Magnitude
                    if distance <= self.State.Radius then
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end
    end)
    DoNotif("Auto-Interact: ENABLED (Radius: " .. self.State.Radius .. ")", 2)
end

function Modules.AutoInteract:Disable()
    if not self.State.IsEnabled then return end
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    self.State.IsEnabled = false
    DoNotif("Auto-Interact: DISABLED", 2)
end

RegisterCommand({
    Name = "autoprompt",
    Aliases = {"autointeract", "ap"},
    Description = "Automatically triggers proximity prompts within a radius."
}, function(args)
    if args[1] == "off" then
        Modules.AutoInteract:Disable()
    else
        Modules.AutoInteract:Enable(args[1])
    end
end)

Modules.Backtrack = {
    State = {
        IsEnabled = false,
        History = {},
        Ghosts = {},
        Connection = nil
    },
    Config = {
        MaxHistory = 10,
        RecordInterval = 0.1
    }
}

function Modules.Backtrack:Enable()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    local lastRecord = 0
    
    self.State.Connection = RunService.Heartbeat:Connect(function()
        if os.clock() - lastRecord < self.Config.RecordInterval then return end
        lastRecord = os.clock()
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not self.State.History[player] then self.State.History[player] = {} end
                    table.insert(self.State.History[player], 1, hrp.CFrame)
                    
                    if #self.State.History[player] > self.Config.MaxHistory then
                        table.remove(self.State.History[player])
                    end
                    
                    if not self.State.Ghosts[player] then
                        local ghost = Instance.new("Part")
                        ghost.Size = hrp.Size
                        ghost.Color = Color3.fromRGB(255, 0, 255)
                        ghost.Transparency = 0.6
                        ghost.Anchored = true
                        ghost.CanCollide = false
                        ghost.Material = Enum.Material.Neon
                        ghost.Parent = Workspace
                        self.State.Ghosts[player] = ghost
                    end
                    
                    local oldestPos = self.State.History[player][#self.State.History[player]]
                    self.State.Ghosts[player].CFrame = oldestPos
                end
            end
        end
    end)
    DoNotif("Backtrack Visualizer: ENABLED", 2)
end

function Modules.Backtrack:Disable()
    if not self.State.IsEnabled then return end
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    for _, ghost in pairs(self.State.Ghosts) do
        ghost:Destroy()
    end
    table.clear(self.State.Ghosts)
    table.clear(self.State.History)
    self.State.IsEnabled = false
    DoNotif("Backtrack Visualizer: DISABLED", 2)
end

RegisterCommand({
    Name = "backtrack",
    Aliases = {"ghosts", "bt"},
    Description = "Visualizes player positions from 1 second ago."
}, function()
    if Modules.Backtrack.State.IsEnabled then
        Modules.Backtrack:Disable()
    else
        Modules.Backtrack:Enable()
    end
end)

Modules.PhysicsGun = {
    State = {
        IsEnabled = false,
        SelectedPart = nil,
        Connection = nil,
        AlignPos = nil,
        AlignOri = nil,
        Attachment0 = nil,
        Attachment1 = nil
    }
}

function Modules.PhysicsGun:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        local mouse = Players.LocalPlayer:GetMouse()
        self.State.Connection = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if not self.State.SelectedPart then
                    local target = mouse.Target
                    if target and not target.Anchored and not target:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                        self.State.SelectedPart = target
                        
                        self.State.Attachment1 = Instance.new("Attachment", Workspace.Terrain)
                        self.State.Attachment0 = Instance.new("Attachment", target)
                        
                        local ap = Instance.new("AlignPosition")
                        ap.Attachment0 = self.State.Attachment0
                        ap.Attachment1 = self.State.Attachment1
                        ap.MaxForce = 1e9
                        ap.Responsiveness = 200
                        ap.Parent = target
                        self.State.AlignPos = ap
                        
                        local ao = Instance.new("AlignOrientation")
                        ao.Attachment0 = self.State.Attachment0
                        ao.Attachment1 = self.State.Attachment1
                        ao.MaxTorque = 1e9
                        ao.Responsiveness = 200
                        ao.Parent = target
                        self.State.AlignOri = ao
                    end
                end
                
                if self.State.SelectedPart and self.State.Attachment1 then
                    self.State.Attachment1.WorldCFrame = mouse.Hit
                end
            else
                if self.State.AlignPos then self.State.AlignPos:Destroy() end
                if self.State.AlignOri then self.State.AlignOri:Destroy() end
                if self.State.Attachment0 then self.State.Attachment0:Destroy() end
                if self.State.Attachment1 then self.State.Attachment1:Destroy() end
                self.State.SelectedPart = nil
            end
        end)
        DoNotif("Physics Gun: ENABLED (Hold LMB)", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        self.State.IsEnabled = false
        DoNotif("Physics Gun: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "physicsgun",
    Aliases = {"pgun", "grab"},
    Description = "Allows you to grab and move unanchored parts with your mouse."
}, function()
    Modules.PhysicsGun:Toggle()
end)

Modules.VisualClear = {
    State = {
        IsEnabled = false,
        OriginalStates = {}
    }
}

function Modules.VisualClear:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostProcessEffect") then
                self.State.OriginalStates[effect] = effect.Enabled
                effect.Enabled = false
            end
        end
        for _, effect in ipairs(Workspace.CurrentCamera:GetChildren()) do
            if effect:IsA("PostProcessEffect") then
                self.State.OriginalStates[effect] = effect.Enabled
                effect.Enabled = false
            end
        end
        DoNotif("Visual Clear: ENABLED (Blur/Bloom Removed)", 2)
    else
        for effect, state in pairs(self.State.OriginalStates) do
            if effect and effect.Parent then
                effect.Enabled = state
            end
        end
        table.clear(self.State.OriginalStates)
        DoNotif("Visual Clear: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "clearvisuals",
    Aliases = {"noblur", "clean"},
    Description = "Removes all post-processing effects like Blur, Bloom, and ColorCorrection."
}, function()
    Modules.VisualClear:Toggle()
end)

Modules.NetworkOwner = {
    State = {
        IsEnabled = false,
        Connection = nil
    }
}

function Modules.NetworkOwner:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self.State.Connection = RunService.Stepped:Connect(function()
            local char = Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Velocity = Vector3.new(0, 30, 0)
                    end
                end
            end
        end)
        DoNotif("Netless: ENABLED (Bypasses distance-based network ownership)", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        self.State.IsEnabled = false
        DoNotif("Netless: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "netless",
    Aliases = {"networkowner", "net"},
    Description = "Maintains network ownership of your character parts at all times."
}, function()
    Modules.NetworkOwner:Toggle()
end)

Modules.AttributeSpoofer = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil,
        SpoofTable = {}
    }
}

function Modules.AttributeSpoofer:Toggle(): ()
    local mt = getrawmetatable(game)
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(selfArg, ...)
            local method = getnamecallmethod()
            local args = {...}
            if method == "GetAttribute" and self.State.SpoofTable[args[1]] ~= nil then
                return self.State.SpoofTable[args[1]]
            end
            return self.State.OriginalNamecall(selfArg, ...)
        end)

        setreadonly(mt, true)
        DoNotif("Attribute Spoofer: ENABLED", 2)
    else
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
        DoNotif("Attribute Spoofer: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "spoofattribute",
    Aliases = {"sa", "setattr"},
    Description = "Spoofs return values of GetAttribute."
}, function(args)
    local attrName = args[1]
    local attrValue = args[2]

    if not attrName then return DoNotif("Usage: ;sa <attribute> <value>", 3) end

    if attrValue == "true" then attrValue = true
    elseif attrValue == "false" then attrValue = false
    elseif tonumber(attrValue) then attrValue = tonumber(attrValue) end

    Modules.AttributeSpoofer.State.SpoofTable[attrName] = attrValue
    DoNotif("Spoofing attribute '" .. attrName .. "' as: " .. tostring(attrValue), 3)

    if not Modules.AttributeSpoofer.State.IsEnabled then
        Modules.AttributeSpoofer:Toggle()
    end
end)

Modules.MeleeFreezer = {
    State = {
        IsEnabled = false,
        FrozenTracks = {},
        Connection = nil
    },
    Config = {
        ToggleKey = Enum.KeyCode.G
    }
}

function Modules.MeleeFreezer:Enable(): ()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true
    
    self.State.Connection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.IsPlaying and track.Speed ~= 0 then
                    track:AdjustSpeed(0)
                end
            end
        end
    end)
    
    DoNotif("Melee Freeze: ENABLED (Animations Locked)", 2)
end

function Modules.MeleeFreezer:Disable(): ()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(1)
        end
    end
    
    DoNotif("Melee Freeze: DISABLED (Animations Restored)", 2)
end

function Modules.MeleeFreezer:Toggle(): ()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

function Modules.MeleeFreezer:Initialize(): ()
    local module = self
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == module.Config.ToggleKey then
            module:Toggle()
        end
    end)
    
    RegisterCommand({
        Name = "freezemelee",
        Aliases = {"animfreeze", "lagswing"},
        Description = "Toggles an animation freeze (Key: G) to keep weapon hitboxes active during a swing."
    }, function()
        module:Toggle()
    end)
end

Modules.WhisperSpy = {
    State = {
        IsEnabled = false,
        Connections = {}
    }
}

function Modules.WhisperSpy:Enable(): ()
    if self.State.IsEnabled then return end
    self.State.IsEnabled = true

    local function handleLegacyMessage(data: table)
        if not self.State.IsEnabled then return end
        
        local message = data.Message
        local sender = data.FromPlayer
        local recipient = data.ToPlayer
        local isWhisper = data.IsWhisper or (data.MessageType == "Whisper")

        if isWhisper and sender and recipient then
            if sender ~= LocalPlayer.Name and recipient ~= LocalPlayer.Name then
                local log = string.format("[WhisperSpy] %s -> %s: %s", sender, recipient, message)
                print(log)
                DoNotif(log, 4)
            end
        end
    end

    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMsg = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMsg and onMsg:IsA("RemoteEvent") then
            self.State.Connections.Legacy = onMsg.OnClientEvent:Connect(handleLegacyMessage)
        end
    end

    self.State.Connections.Modern = TextChatService.MessageReceived:Connect(function(textChatMessage: TextChatMessage)
        local metadata = textChatMessage.Metadata
        local textSource = textChatMessage.TextSource
        
        if textSource and metadata and metadata:find("whisper") then
            local senderId = textSource.UserId
            local sender = Players:GetPlayerByUserId(senderId)
            
            if sender and sender ~= LocalPlayer then
                local log = string.format("[WhisperSpy Modern] %s: %s", sender.Name, textChatMessage.Text)
                print(log)
                DoNotif(log, 4)
            end
        end
    end)

    DoNotif("Whisper Spy: ENABLED. Monitoring private channels.", 3)
end

function Modules.WhisperSpy:Disable(): ()
    if not self.State.IsEnabled then return end
    self.State.IsEnabled = false
    
    for _, conn in pairs(self.State.Connections) do
        if conn then conn:Disconnect() end
    end
    table.clear(self.State.Connections)
    
    DoNotif("Whisper Spy: DISABLED", 2)
end

function Modules.WhisperSpy:Toggle(): ()
    if self.State.IsEnabled then
        self:Disable()
    else
        self:Enable()
    end
end

RegisterCommand({
    Name = "whisperspy",
    Aliases = {"chatspy", "viewwhispers"},
    Description = "Attempts to intercept and display private whisper messages between other players."
}, function()
    Modules.WhisperSpy:Toggle()
end)

Modules.ToolAttributeLister = {
    State = {}
}

function Modules.ToolAttributeLister:Scan(): ()
    local character = LocalPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        return DoNotif("You must have a tool equipped to scan it.", 3)
    end

    local attributes = tool:GetAttributes()
    local attributeCount = 0

    print("--- [Attribute Scan: " .. tool.Name .. "] ---")
    
    for name, value in pairs(attributes) do
        attributeCount = attributeCount + 1
        local valueType = typeof(value)
        local formattedValue = tostring(value)

        if valueType == "Color3" then
            formattedValue = string.format("RGB(%d, %d, %d)", value.R * 255, value.G * 255, value.B * 255)
        elseif valueType == "Vector3" then
            formattedValue = string.format("(%.2f, %.2f, %.2f)", value.X, value.Y, value.Z)
        end

        print(string.format("  [!] %s [%s]: %s", name, valueType, formattedValue))
    end

    if attributeCount == 0 then
        print("  (No attributes found on this tool)")
        DoNotif("No attributes found on " .. tool.Name, 3)
    else
        print("--- Total Attributes: " .. attributeCount .. " ---")
        DoNotif("Listed " .. attributeCount .. " attributes for " .. tool.Name .. " in F9 console.", 4)
    end
end

RegisterCommand({
    Name = "listattributes",
    Aliases = {"toolattrs", "getattr", "scantool"},
    Description = "Dumps every attribute and value of the equipped tool to the developer console (F9)."
}, function()
    Modules.ToolAttributeLister:Scan()
end)


Modules.NeuralOverride = {
    State = {
        IsScanning = false
    }
}

function Modules.NeuralOverride:OverwriteData(targetVar: string, newValue: any): ()
    if not (getgc and debug.getupvalue and debug.setupvalue) then
        return DoNotif("NeuralOverride: Executor lacks debug library support.", 3)
    end

    local count: number = 0
    local convertedValue: any = newValue
    if newValue == "true" then convertedValue = true
    elseif newValue == "false" then convertedValue = false
    elseif tonumber(newValue) then convertedValue = tonumber(newValue) end

    for _: number, obj: any in ipairs(getgc()) do
        if type(obj) == "function" and islclosure(obj) then
            local idx: number = 1
            while true do
                local name: string?, val: any = debug.getupvalue(obj, idx)
                if not name then break end
                if name == targetVar then
                    pcall(debug.setupvalue, obj, idx, convertedValue)
                    count = count + 1
                end
                idx = idx + 1
            end
        end
    end
    DoNotif(string.format("NeuralOverride: Patched %d instances of '%s'", count, targetVar), 3)
end

RegisterCommand({
    Name = "neural",
    Aliases = {"patch"},
    Description = "Scans game memory and overwrites internal script variables. ;neural isAdmin true"
}, function(args: {string})
    if #args < 2 then return DoNotif("Usage: ;neural [varName] [value]", 3) end
    Modules.NeuralOverride:OverwriteData(args[1], args[2])
end)

Modules.VanguardShield = {
    State = {
        IsEnabled = false,
        OriginalIndex = nil,
        SpoofTable = {
            WalkSpeed = 16,
            JumpPower = 50,
            JumpHeight = 7.2,
            Health = 100
        }
    }
}

function Modules.VanguardShield:Toggle(): ()
    local success, mt = pcall(getrawmetatable, game)
    if not success or not mt then return end

    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalIndex = mt.__index
        local originalIndex = self.State.OriginalIndex
        local lp = LocalPlayer

        setreadonly(mt, false)
        mt.__index = newcclosure(function(selfArg, key)
            if Modules.VanguardShield.State.IsEnabled and selfArg:IsA("Humanoid") and selfArg:IsDescendantOf(lp.Character) then
                if Modules.VanguardShield.State.SpoofTable[key] ~= nil then
                    return Modules.VanguardShield.State.SpoofTable[key]
                end
            end
            return originalIndex(selfArg, key)
        end)
        setreadonly(mt, true)
        DoNotif("Vanguard Shield: ENABLED (Property Spoofing Active)", 2)
    else
        setreadonly(mt, false)
        mt.__index = self.State.OriginalIndex
        setreadonly(mt, true)
        DoNotif("Vanguard Shield: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "vanguard",
    Aliases = {"antiscan", "propertyspoof"},
    Description = "Prevents local scripts from reading your real WalkSpeed/JumpPower/Health."
}, function()
    Modules.VanguardShield:Toggle()
end)

Modules.InterstellarInteraction = {
    State = {
        Active = false,
        Connection = nil
    }
}

function Modules.InterstellarInteraction:Toggle(): ()
    self.State.Active = not self.State.Active
    if self.State.Active then
        self.State.Connection = RunService.Heartbeat:Connect(function()
            for _: number, obj: Instance in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.RequiresLineOfSight = false
                    obj.MaxActivationDistance = 1e7
                    if fireproximityprompt then
                        fireproximityprompt(obj)
                    end
                end
                if obj:IsA("ClickDetector") then
                    obj.MaxActivationDistance = 1e7
                    if fireclickdetector then
                        fireclickdetector(obj)
                    end
                end
            end
        end)
        DoNotif("Interstellar: Global Interaction ACTIVE", 2)
    else
        if self.State.Connection then self.State.Connection:Disconnect() end
        DoNotif("Interstellar: Global Interaction DISABLED", 2)
    end
end

RegisterCommand({
    Name = "fireallclickprompt",
    Aliases = {"massfire", "autofireall"},
    Description = "Automatically triggers every Prompt and ClickDetector in the game regardless of distance."
}, function()
    Modules.InterstellarInteraction:Toggle()
end)

Modules.IdentityPhantom = {
    State = {
        IsEnabled = false,
        OriginalIndex = nil
    }
}

function Modules.IdentityPhantom:Toggle(targetUser: string?): ()
    local success, mt = pcall(getrawmetatable, game)
    if not success or not mt then return end

    self.State.IsEnabled = not self.State.IsEnabled
    if self.State.IsEnabled then
        self.State.OriginalIndex = mt.__index
        local originalIndex = self.State.OriginalIndex
        local fakeId: number = 1 
        local fakeName: string = targetUser or "Roblox"

        pcall(function()
            if targetUser then
                fakeId = Players:GetUserIdFromNameAsync(targetUser)
            end
        end)

        setreadonly(mt, false)
        mt.__index = newcclosure(function(selfArg, key)
            if Modules.IdentityPhantom.State.IsEnabled and selfArg == LocalPlayer then
                if key == "UserId" or key == "userId" then return fakeId end
                if key == "Name" or key == "name" then return fakeName end
            end
            return originalIndex(selfArg, key)
        end)
        setreadonly(mt, true)
        DoNotif("Identity Phantom: Masked as " .. fakeName, 3)
    else
        setreadonly(mt, false)
        mt.__index = self.State.OriginalIndex
        setreadonly(mt, true)
        DoNotif("Identity Phantom: Mask REMOVED", 2)
    end
end

RegisterCommand({
    Name = "phantom",
    Aliases = {"mask"},
    Description = "Locally spoofs your Name and UserId to fool group-based admin scripts. ;phantom [username]"
}, function(args: {string})
    Modules.IdentityPhantom:Toggle(args[1])
end)



Modules.ClassicSwordAnim = {
    State = {
        IsEnabled = false,
        OriginalNamecall = nil
    },
    Config = {
        SLASH = "rbxassetid://1259011",
        LUNGE = "rbxassetid://129967390",
        IDLE = "rbxassetid://180435571",
        WALK = "rbxassetid://180426354"
    }
}

function Modules.ClassicSwordAnim:Toggle(): ()
    local success, mt = pcall(getrawmetatable, game)
    if not success or not mt then
        return DoNotif("Classic Sword: Metatable access denied.", 3)
    end

    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        self.State.OriginalNamecall = mt.__namecall
        local originalNamecall = self.State.OriginalNamecall

        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(selfArg, ...)
            local method = getnamecallmethod()
            local args = {...}

            if Modules.ClassicSwordAnim.State.IsEnabled and (method == "LoadAnimation" or method == "loadAnimation") then
                local animObj = args[1]
                if animObj and animObj:IsA("Animation") then
                    local name = animObj.Name:lower()
                    local id = animObj.AnimationId:lower()

                    if name:find("lunge") or name:find("power") or name:find("heavy") then
                        animObj.AnimationId = Modules.ClassicSwordAnim.Config.LUNGE
                    elseif name:find("slash") or name:find("attack") or name:find("swing") then
                        animObj.AnimationId = Modules.ClassicSwordAnim.Config.SLASH
                    elseif name:find("idle") then
                        animObj.AnimationId = Modules.ClassicSwordAnim.Config.IDLE
                    elseif name:find("walk") or name:find("run") then
                        animObj.AnimationId = Modules.ClassicSwordAnim.Config.WALK
                    end
                end
            end

            return originalNamecall(selfArg, unpack(args))
        end)
        setreadonly(mt, true)

        task.spawn(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
            end
        end)

        DoNotif("Classic Sword: ENABLED (Slash & Lunge Mapped)", 3)
    else
        setreadonly(mt, false)
        mt.__namecall = self.State.OriginalNamecall
        setreadonly(mt, true)
        DoNotif("Classic Sword: DISABLED", 2)
    end
end

RegisterCommand({
    Name = "classicsword",
    Aliases = {"swordanim", "oldschool"},
    Description = "Forces all melee animations to use Classic Slash and Lunge IDs."
}, function()
    Modules.ClassicSwordAnim:Toggle()
end)


local function loadstringCmd(url, notif)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    DoNotif(notif, 3)
end


RegisterCommand({Name = "teleporter", Aliases = {"tpui"}, Description = "Loads the Game Universe."}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/GameFinder.lua", "stolen from nameless-admin")
end)


RegisterCommand({Name = "wallwalk", Aliases = {"ww"}, Description = "Walk On Walls"}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/wallwalk.lua", "Loaded!")
end)


RegisterCommand({Name = "dex", Aliases = {}, Description = "Loads Dex"}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/luaprojectse3/refs/heads/main/CustomDex.lua", "we lit")
end)

RegisterCommand({Name = "antibang", Aliases = {}, Description = "i'd rather fuck you"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/anthonysrepository/refs/heads/main/scripts/Anti%20Bang.lua", "Anti Gay Shield Activated.") end)

RegisterCommand({Name = "plag", Aliases = {}, Description = "Makes the pumpkin launcher lag players"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/GameLaggerPlauncher.lua", "Loading Modification") end)

RegisterCommand({Name = "pumpkin", Aliases = {}, Description = "Makes the pumpkin launcher into a rapid fire beast."}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/RAPIDFIREPumpkinlauncher.lua", "Loading Modification") end)

RegisterCommand({Name = "zukahub", Aliases = {"zuka"}, Description = "Loads the Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/ZukaHub.lua", "Loading Zuka's Hub...") end)

RegisterCommand({Name = "noacid", Aliases = {"unfuck"}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/AntiAcidRainLag.lua", "Loading...") end)

RegisterCommand({Name = "stats", Aliases = {}, Description = "Edit and lock your properties."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/statlock.lua", "Loading Stats..") end)

RegisterCommand({Name = "zgui", Aliases = {"upd3", "zui"}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/ZfuckerUpgraded.lua", "Loaded GUI") end)

RegisterCommand({Name = "creepyanim", Aliases = {"canim"}, Description = "Uncanny Animation GUI"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/uncannyanim.lua", "Loaded GUI") end)

RegisterCommand({Name = "swordbot", Aliases = {"sf", "sfbot"}, Description = "Auto Sword Fighter, use E and R"}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/swordnpc", "Bot loaded.") end)

RegisterCommand({Name = "touchfling", Aliases = {}, Description = "Loads the touchfling GUI"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/SimpleTouchFlingGui.lua", "Loaded") end)

--RegisterCommand({Name = "zoneui", Aliases = {}, Description = "For https://www.roblox.com/games/99381597249674/Zombie-Zone" }, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/Nice.lua", "Loaded") end)

RegisterCommand({Name = "inbypass", Aliases = {}, Description = "Instance Bypasser" }, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/instancebypass.lua", "Loaded") end)

RegisterCommand({Name = "ibtools", Aliases = {"btools"}, Description = "Upgraded Gui For Btools"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/fixedbtools.lua", "Loading Revamped Btools Gui") end)

RegisterCommand({Name = "ketamine", Aliases = {}, Description = "Updated remote spy"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/remotes.lua", "Loading rSpy...") end)

RegisterCommand({Name = "simplespy", Aliases = {"bestspy"}, Description = "Best remote spy"}, function() loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/simplee%20spyyy%20mobilee", "Loading rSpy...") end)

RegisterCommand({Name = "csgo", Aliases = {"phoon"}, Description = "Bhop movement fallback"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/phoon.lua", "Loading") end)

RegisterCommand({Name = "lineofsight", Aliases = {}, Description = "Logger for players looking at you"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/LineOfSightLogger.lua", "Loading...") end)

RegisterCommand({Name = "nova", Aliases = {"delua"}, Description = "Novas Deobfuscator, Bytecode Grabber"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/NovasDeobfuscator.lua", "Deobfuscator Loaded") end)

RegisterCommand({Name = "nocooldown", Aliases = {"ncd"}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/NocooldownsZombieUpd3.txt", "Loading Cooldownremover...") end)

RegisterCommand({Name = "extendroot", Aliases = {}, Description = "Bypasses Raycasting"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/HitboxExtender.lua", "Loading Extender.") end)

RegisterCommand({Name = "npc", Aliases = {"npcmode"}, Description = "Avoid being kicked for being idle."}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/AutoPilotMode.lua", "Anti Afk loaded.") end)

RegisterCommand({Name = "overseer", Aliases = {"patcher"}, Description = "Loads the Module Poisoner."}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Overseerv27.txt", "Loading GUI..") end)

RegisterCommand({Name = "flinger", Aliases = {"flingui"}, Description = "Loads a Fling GUI."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/SkidFling.lua", "Loading GUI..") end)

RegisterCommand({Name = "rem", Aliases = {}, Description = "In game exploit creation kit.."}, function() loadstringCmd("https://e-vil.com/anbu/rem.lua", "Loading Rem.") end)

RegisterCommand({Name = "copyconsole", Aliases = {"copy"}, Description = "Allows you to copy errors from the console.."}, function() loadstringCmd("https://raw.githubusercontent.com/scriptlisenbe-stack/luaprojectse3/refs/heads/main/consolecopy.lua", "Copy Console Activated.") end)

RegisterCommand({Name = "tptohp", Aliases = {}, Description = "For https://www.roblox.com/games/14419907512/Zombie-game"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/zgamemedkit.lua", "Loading HP Teleport") end)

RegisterCommand({Name = "reachfix", Aliases = {"fix"}, Description = "Makes your equipped tool invisible when using reach"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/Scripts/refs/heads/main/InvisibleEquippedTool.lua", "Fixed") end)

RegisterCommand({Name = "worldofstands", Aliases = {"wos"}, Description = "For https://www.roblox.com/games/6728870912/World-of-Stands - Removes dash cooldown"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/WOS.lua", "Loading, Wait a sec.") end)

RegisterCommand({Name = "zfucker", Aliases = {}, Description = "zfucker for the zl series."}, function() loadstringCmd("https://raw.githubusercontent.com/osukfcdays/zlfucker/refs/heads/main/main.luau", "Loading, Wait a sec.") end)

RegisterCommand({Name = "unlock", Aliases = {}, Description = "Gives you the number to any code door free model if the game has it."}, function() loadstringCmd("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/codeunlocker.lua", "Loading, Wait a sec.") end)


function processCommand(message)
    if not (message:sub(1, #Prefix) == Prefix) then
        return false
    end
    local args = {}
    for word in message:sub(#Prefix + 1):gmatch("%S+") do
        table.insert(args, word)
    end
    if #args == 0 then
        return true
    end
    local cmdName = table.remove(args, 1):lower()
    local cmdFunc = Commands[cmdName]
    if cmdFunc then
        local success, err = pcall(cmdFunc, args)
        if not success then
            warn("Command Error:", err)
            DoNotif("Error: " .. tostring(err), 5)
        end
    else
        local lowestDistance = math.huge
        local closestMatch = nil
        local SUGGESTION_THRESHOLD = 2

        for command, _ in pairs(Commands) do
            local distance = Utilities.calculateLevenshteinDistance(cmdName, command)
            if distance < lowestDistance then
                lowestDistance = distance
                closestMatch = command
            end
        end

        if closestMatch and lowestDistance <= SUGGESTION_THRESHOLD then
            DoNotif(string.format("Unknown command: %s. Did you mean ;%s?", cmdName, closestMatch), 4)
        else
            DoNotif("Unknown command: " .. cmdName, 3)
        end
    end
    return true
end

for moduleName, module in pairs(Modules) do
    if type(module) == "table" and type(module.Initialize) == "function" then
        pcall(function()
        module:Initialize()
        print("Initialized module:", moduleName)
    end)
end
end



local function CreateMobileCommandButton()

    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    if not UserInputService.TouchEnabled then
        return
    end

    if CoreGui:FindFirstChild("MobileCommandButton_Zuka") then
        return
    end

    local buttonGui = Instance.new("ScreenGui")
    buttonGui.Name = "MobileCommandButton_Zuka"
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    buttonGui.ResetOnSpawn = false
    buttonGui.Parent = CoreGui

    local cmdButton = Instance.new("ImageButton")
    cmdButton.Name = "DraggableCommandButton"
    cmdButton.Size = UDim2.fromOffset(60, 60) -- A comfortable tap size for mobile
    cmdButton.Position = UDim2.new(0, 20, 0.5, -30) -- Initial position: left side of the screen
    cmdButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    cmdButton.BackgroundTransparency = 0.2
    cmdButton.Image = "rbxassetid://7243158473" -- Using the gear icon from your splash screen
    cmdButton.ImageColor3 = Color3.fromRGB(0, 255, 255) -- Matching accent color
    cmdButton.Parent = buttonGui

    Instance.new("UICorner", cmdButton).CornerRadius = UDim.new(1, 0) -- Makes it circular
    Instance.new("UIStroke", cmdButton).Color = Color3.fromRGB(80, 80, 100)

    -- 4. Drag and Tap Logic
    local isDragging = false
    local dragStartPos = nil
    local startGuiPosition = nil
    local DRAG_THRESHOLD = 8 -- Minimum pixel distance to be considered a drag, preventing accidental drags on tap

    cmdButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = input.Position
            startGuiPosition = cmdButton.Position
            isDragging = false -- Reset state on new touch
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragStartPos then
            local delta = input.Position - dragStartPos
            
            -- If the finger moves past the threshold, it's officially a drag
            if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
                isDragging = true
            end

            if isDragging then
                cmdButton.Position = UDim2.new(startGuiPosition.X.Scale, startGuiPosition.X.Offset + delta.X, startGuiPosition.Y.Scale, startGuiPosition.Y.Offset + delta.Y)
            end
        end
    end)

    cmdButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = nil
            startGuiPosition = nil
        end
    end)

    cmdButton.Activated:Connect(function()
        -- The 'Activated' event fires on release. We only toggle the bar if it wasn't a drag.
        if not isDragging then
            if Modules.CommandBar and Modules.CommandBar.Toggle then
                Modules.CommandBar:Toggle()
            end
        end
        -- Reset dragging state after the action is complete
        isDragging = false
    end)
end

-- Execute the creation function
CreateMobileCommandButton()
Modules.CommandList:Initialize()
local TextChatService = game:GetService("TextChatService")
if TextChatService then
    TextChatService.SendingMessage:Connect(function(messageObject)
    local wasCommand = processCommand(messageObject.Text)
    if wasCommand then
        messageObject.ShouldSend = false
    end
end)
else
LocalPlayer.Chatted:Connect(processCommand)
end
DoNotif("We're So back. The Best Underground Panel.", 3)
