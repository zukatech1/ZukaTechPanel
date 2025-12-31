local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    COMMAND_PREFIX = "/scan ",
    HEURISTIC_KEYWORDS = {
        "Give", "Set", "Equip", "Tool", "Event", "Admin", "Request",
        "Buy", "Sell", "Trade", "Remote", "Update", "Unsecure", "Handle"
    },
    SEARCH_PATHS = {
        ReplicatedStorage,
        Workspace,
        Players
    }
}

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local UI = {}
UI.ScreenGui = Instance.new("ScreenGui", PlayerGui)
UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

UI.MainFrame = Instance.new("Frame", UI.ScreenGui)
UI.MainFrame.BorderSizePixel = 0
UI.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI.MainFrame.Size = UDim2.new(0, 750, 0, 420)
UI.MainFrame.Position = UDim2.new(0.5, -375, 0.5, -210)
UI.MainFrame.BackgroundTransparency = 0.4

Instance.new("UICorner", UI.MainFrame)
Instance.new("UIDragDetector", UI.MainFrame)

UI.LogContainer = Instance.new("ScrollingFrame", UI.MainFrame)
UI.LogContainer.BorderSizePixel = 0
UI.LogContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.LogContainer.Size = UDim2.new(0, 726, 0, 340)
UI.LogContainer.Position = UDim2.new(0, 12, 0, 14)
UI.LogContainer.BackgroundTransparency = 1
UI.LogContainer.ScrollBarThickness = 4
UI.LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

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
UI.InputBox.PlaceholderText = "Enter command here (e.g. scan, probe [path] [args])..."
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
UI.ExitButton.BorderSizePixel = 0
UI.ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.ExitButton.BackgroundColor3 = Color3.fromRGB(201, 0, 0)
UI.ExitButton.Size = UDim2.new(0, 62, 0, 24)
UI.ExitButton.Text = "EXIT"
UI.ExitButton.Position = UDim2.new(1, -62, 0, -30)

Instance.new("UICorner", UI.ExitButton)

local function AddToLog(text: string, color: Color3?)
    local logLabel = Instance.new("TextLabel")
    logLabel.Name = "LogEntry"
    logLabel.Parent = UI.LogContainer
    logLabel.BackgroundTransparency = 1
    logLabel.Size = UDim2.new(1, -10, 0, 20)
    logLabel.Font = Enum.Font.Code
    logLabel.Text = "> " .. text
    logLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    logLabel.TextSize = 14
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.RichText = true

    UI.LogContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    UI.LogContainer.CanvasPosition = Vector2.new(0, UI.LogContainer.CanvasSize.Y.Offset)
end

local function FindObjectFromPath(pathString: string): Instance?
    local currentObject = game
    for part in string.gmatch(pathString, "[^.]+") do
        if currentObject then
            currentObject = currentObject:FindFirstChild(part)
        else
            return nil
        end
    end
    return currentObject
end

local function ParseArguments(argString: string): {any}
    local args = {}
    for match in string.gmatch(argString, '"([^"]*)"|%S+') do
        if tonumber(match) then
            table.insert(args, tonumber(match))
        elseif match == "true" then
            table.insert(args, true)
        elseif match == "false" then
            table.insert(args, false)
        elseif match == "nil" then
            table.insert(args, nil)
        else
            table.insert(args, match:gsub('^"|"$', ''))
        end
    end
    return args
end

local function CommandScanRemotes()
    AddToLog("Beginning heuristic scan for interesting remotes...", Color3.fromRGB(255, 200, 0))
    local findings = 0
    for _, root in ipairs(Config.SEARCH_PATHS) do
        for _, descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                local remoteName = string.lower(descendant.Name)
                for _, keyword in ipairs(Config.HEURISTIC_KEYWORDS) do
                    if string.find(remoteName, string.lower(keyword)) then
                        AddToLog("[!] Target Found: " .. descendant:GetFullName(), Color3.fromRGB(0, 255, 150))
                        findings = findings + 1
                        break
                    end
                end
            end
        end
    end
    AddToLog("Scan complete. Found " .. findings .. " potential targets.", Color3.fromRGB(255, 200, 0))
end

local function CommandProbeRemote(pathString: string, argString: string)
    AddToLog("Preparing probe: " .. pathString, Color3.fromRGB(100, 100, 255))
    local remote = FindObjectFromPath(pathString)
    
    if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        AddToLog("Probe failed: Object at path is invalid.", Color3.fromRGB(255, 50, 50))
        return
    end

    local args = ParseArguments(argString or "")
    AddToLog("Firing '" .. remote.Name .. "' with " .. #args .. " arguments.", Color3.fromRGB(100, 100, 255))

    local success, result = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
            return "Event Fired"
        else
            return remote:InvokeServer(unpack(args))
        end
    end)

    if success then
        AddToLog("Probe success. Server Response: " .. tostring(result), Color3.fromRGB(0, 255, 0))
    else
        AddToLog("Probe failed. Client Error: " .. tostring(result), Color3.fromRGB(255, 50, 50))
    end
end

local function ProcessInput(input: string)
    local message = input:gsub("^" .. Config.COMMAND_PREFIX, "")
    local command = message:match("%S+") or "help"
    local payload = message:sub(#command + 2)

    if command == "scan" then
        CommandScanRemotes()
    elseif command == "probe" then
        local pathString = payload:match("%S+")
        local argString = payload:sub(#pathString + 2)
        if not pathString then
            AddToLog("Usage: probe [Path] [Args]", Color3.fromRGB(255, 50, 50))
            return
        end
        CommandProbeRemote(pathString, argString)
    else
        AddToLog("--- Forensic Analyzer Help ---", Color3.fromRGB(255, 255, 255))
        AddToLog("scan - Search for remotes", Color3.fromRGB(200, 200, 200))
        AddToLog("probe [path] [args] - Fire/Invoke remote", Color3.fromRGB(200, 200, 200))
    end
end

UI.InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = UI.InputBox.Text
        if input ~= "" then
            AddToLog("Input: " .. input, Color3.fromRGB(180, 180, 180))
            ProcessInput(input)
            UI.InputBox.Text = ""
        end
    end
end)

UI.ExitButton.MouseButton1Click:Connect(function()
    UI.ScreenGui:Destroy()
end)

LocalPlayer.Chatted:Connect(function(msg)
    if string.sub(msg:lower(), 1, #Config.COMMAND_PREFIX) == Config.COMMAND_PREFIX:lower() then
        ProcessInput(msg)
    end
end)

AddToLog("Forensic Remote Analyzer UI Online.", Color3.fromRGB(0, 255, 255))
AddToLog("Type commands in the input box below.", Color3.fromRGB(0, 255, 255))