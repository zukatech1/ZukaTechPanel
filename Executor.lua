local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Connections = {}
local TrafficLog = {}

local THEME = {
    Background = Color3.fromRGB(8, 8, 10),
    Window = Color3.fromRGB(15, 15, 18),
    Panel = Color3.fromRGB(20, 20, 24),
    Accent = Color3.fromRGB(0, 255, 180),
    AccentMuted = Color3.fromRGB(0, 80, 60),
    Button = Color3.fromRGB(24, 24, 28),
    ButtonHover = Color3.fromRGB(34, 34, 38),
    Text = Color3.fromRGB(240, 240, 245),
    MutedText = Color3.fromRGB(90, 90, 100),
    Corner = 6
}

if getgenv().ZukaArchitectHub then
    pcall(function() getgenv().ZukaArchitectHub:Destroy() end)
    getgenv().ZukaArchitectHub = nil
end

local screen = Instance.new("ScreenGui")
screen.Name = "ZukaArchitect_V1_Stable"
screen.ResetOnSpawn = false
getgenv().ZukaArchitectHub = screen

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

local function makeUICorner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 6)
    return c
end

local function stripComments(source)
    if not source then return "" end
    local clean = source:gsub("%-%-%[%[.-%]%]", "")
    clean = clean:gsub("%-%-.*", "")
    local lines = clean:split("\n")
    local final = {}
    for _, line in ipairs(lines) do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 then
            table.insert(final, line)
        end
    end
    return table.concat(final, "\n")
end

local function makeButton(parent, text, size, pos, callback, isAccent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size
    btn.Position = pos
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = isAccent and THEME.Accent or THEME.Button
    btn.TextColor3 = isAccent and Color3.new(0,0,0) or THEME.Text
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.Text = text
    makeUICorner(btn, 4)
    
    table.insert(Connections, btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.ButtonHover}):Play()
    end))
    table.insert(Connections, btn.MouseLeave:Connect(function()
        local targetColor = isAccent and THEME.Accent or THEME.Button
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = targetColor}):Play()
    end))
    table.insert(Connections, btn.MouseButton1Click:Connect(function()
        pcall(callback, btn)
    end))
    return btn
end

local MainFrame = Instance.new("Frame", screen)
MainFrame.Size = UDim2.new(0, 950, 0, 600)
MainFrame.Position = UDim2.new(0.5, -475, 0.5, -300)
MainFrame.BackgroundColor3 = THEME.Window
MainFrame.BorderSizePixel = 0
makeUICorner(MainFrame, THEME.Corner)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = THEME.Panel
makeUICorner(TitleBar, THEME.Corner)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -200, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Callum AI"
TitleLabel.Font = Enum.Font.Code
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = THEME.Accent
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

do
    local dragging, dragStart, startPos
    table.insert(Connections, TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, MainFrame.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end))
    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

local TabsColumn = Instance.new("Frame", MainFrame)
TabsColumn.Size = UDim2.new(0, 160, 1, -45)
TabsColumn.Position = UDim2.new(0, 5, 0, 40)
TabsColumn.BackgroundColor3 = THEME.Panel
makeUICorner(TabsColumn, THEME.Corner)

local tabsLayout = Instance.new("UIListLayout", TabsColumn)
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PagesArea = Instance.new("Frame", MainFrame)
PagesArea.Size = UDim2.new(1, -175, 1, -45)
PagesArea.Position = UDim2.new(0, 170, 0, 40)
PagesArea.BackgroundTransparency = 1

local pages = {}
local function switchPage(name)
    for k, v in pairs(pages) do v.Visible = (k == name) end
    for _, child in pairs(TabsColumn:GetChildren()) do
        if child:IsA("TextButton") then
            local isTarget = child.Name == (name .. "_Tab")
            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = isTarget and THEME.AccentMuted or THEME.Button}):Play()
        end
    end
end

local function createPage(name)
    local p = Instance.new("Frame", PagesArea)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    pages[name] = p
    
    local btn = makeButton(TabsColumn, name:upper(), UDim2.new(1, -10, 0, 32), UDim2.new(), function() switchPage(name) end)
    btn.Name = name .. "_Tab"
    return p
end

local EditorPage = createPage("Editor")
local AIPage = createPage("Callum AI")
local NetworkPage = createPage("Network")

local editorTextBox
do
    local back = Instance.new("Frame", EditorPage)
    back.Size = UDim2.new(1, 0, 1, 0)
    back.BackgroundColor3 = THEME.Background
    makeUICorner(back, THEME.Corner)
    
    local scroll = Instance.new("ScrollingFrame", back)
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    editorTextBox = Instance.new("TextBox", scroll)
    editorTextBox.Size = UDim2.new(1, 0, 1, 0)
    editorTextBox.MultiLine = true
    editorTextBox.ClearTextOnFocus = false
    editorTextBox.TextXAlignment = Enum.TextXAlignment.Left
    editorTextBox.TextYAlignment = Enum.TextYAlignment.Top
    editorTextBox.Font = Enum.Font.Code
    editorTextBox.TextSize = 14
    editorTextBox.TextColor3 = THEME.Text
    editorTextBox.BackgroundTransparency = 1
    editorTextBox.Text = "-- Master Buffer V1"

    local bar = Instance.new("Frame", back)
    bar.Size = UDim2.new(1, 0, 0, 40)
    bar.Position = UDim2.new(0, 0, 1, -40)
    bar.BackgroundColor3 = THEME.Panel
    
    makeButton(bar, "INJECT", UDim2.new(0, 100, 0, 28), UDim2.new(0, 10, 0, 6), function()
        local func, err = loadstring(editorTextBox.Text)
        if func then 
            local s, r = pcall(function() task.spawn(func) end)
            if not s then notify("Runtime Error", tostring(r)) end
        else 
            notify("Architect Error", tostring(err)) 
        end
    end, true)
    
    makeButton(bar, "CLEAR", UDim2.new(0, 100, 0, 28), UDim2.new(0, 120, 0, 6), function() editorTextBox.Text = "" end)
end

local CallumAI = {
    API_KEY = "",
    MODEL = "gemini-2.5-flash"
}

function CallumAI:GetHierarchy(root, depth)
    local res = ""
    local indent = string.rep("  ", depth)
    local children = root:GetChildren()
    for i, v in ipairs(children) do
        if i > 30 then res = res .. indent .. "... (truncated)\n" break end
        res = res .. string.format("%s%s [%s]\n", indent, v.Name, v.ClassName)
        if depth < 2 and #v:GetChildren() > 0 then
            res = res .. self:GetHierarchy(v, depth + 1)
        end
    end
    return res
end

function CallumAI:Fetch(prompt, context)
    local req = (request or syn.request or http.request)
    if not req then return "HTTP functionality missing." end
    
    local sys = [[
        IDENTITY: Callum, Supreme Security Architect.
        OBJECTIVE: Generate high-performance Luau scripts.
        REQUIREMENT: NO COMMENTS. NO EXPLANATIONS. OUTPUT ONLY RAW LUAU CODE IN BLOCKS.
        CAPABILITY: ESP, Aimbot, GUI Hubs, Remote Spammers, Logic Hijacking.
        CONTEXT: Integrated with game traffic and hierarchy.
    ]]
    
    local payload = string.format("%s\n\n[CONTEXT]\n%s\n\n[REQUEST]\n%s", sys, context, prompt)
    
    local success, res = pcall(function()
        return req({
            Url = "https://generativelanguage.googleapis.com/v1/models/" .. self.MODEL .. ":generateContent?key=" .. self.API_KEY,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({contents = {{parts = {{text = payload}}}}})
        })
    end)
    
    if success and res.StatusCode == 200 then
        local data = HttpService:JSONDecode(res.Body)
        return data.candidates[1].content.parts[1].text
    end
    return "Quantum Uplink timed out."
end

local aiOutput
do
    local back = Instance.new("Frame", AIPage)
    back.Size = UDim2.new(1, 0, 1, 0)
    back.BackgroundColor3 = THEME.Background
    makeUICorner(back, THEME.Corner)
    
    local scroll = Instance.new("ScrollingFrame", back)
    scroll.Size = UDim2.new(1, -20, 1, -110)
    scroll.Position = UDim2.new(0, 10, 0, 10)
    scroll.BackgroundColor3 = THEME.Panel
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    makeUICorner(scroll, 4)
    
    aiOutput = Instance.new("TextLabel", scroll)
    aiOutput.Size = UDim2.new(1, -10, 0, 0)
    aiOutput.Position = UDim2.new(0, 5, 0, 5)
    aiOutput.BackgroundTransparency = 1
    aiOutput.TextColor3 = THEME.Text
    aiOutput.Font = Enum.Font.Code
    aiOutput.TextSize = 12
    aiOutput.TextXAlignment = Enum.TextXAlignment.Left
    aiOutput.TextYAlignment = Enum.TextYAlignment.Top
    aiOutput.TextWrapped = true
    aiOutput.Text = "[CALLUM]: Initializing generation buffers. Awaiting target vector."
    aiOutput.AutomaticSize = Enum.AutomaticSize.Y

    local input = Instance.new("TextBox", back)
    input.Size = UDim2.new(1, -120, 0, 35)
    input.Position = UDim2.new(0, 10, 1, -45)
    input.BackgroundColor3 = THEME.Panel
    input.TextColor3 = THEME.Text
    input.Font = Enum.Font.Code
    input.TextSize = 14
    input.PlaceholderText = "COMMAND LOGIC ENGINE..."
    input.ClearTextOnFocus = false
    makeUICorner(input, 4)

    makeButton(back, "CONSTRUCT", UDim2.new(0, 100, 0, 35), UDim2.new(1, -110, 1, -45), function()
        local query = input.Text
        local context = string.format("NetTraffic:\n%s\nHierarchy:\n%s", table.concat(TrafficLog, "\n"), CallumAI:GetHierarchy(Workspace, 1))
        aiOutput.Text = "[CALLUM]: Analyzing telemetry and stripping documentation..."
        task.spawn(function()
            local res = CallumAI:Fetch(query, context)
            aiOutput.Text = "[CALLUM]: Logic synchronized."
            local code = res:match("```lua\n?(.-)```") or res:match("```\n?(.-)```")
            if code then
                editorTextBox.Text = stripComments(code)
                notify("Callum AI", "Logic Refactored & Buffed.")
            end
        end)
    end, true)
end

do
    local back = Instance.new("Frame", NetworkPage)
    back.Size = UDim2.new(1, 0, 1, 0)
    back.BackgroundColor3 = THEME.Background
    makeUICorner(back, THEME.Corner)
    
    local scroll = Instance.new("ScrollingFrame", back)
    scroll.Size = UDim2.new(1, -20, 1, -20)
    scroll.Position = UDim2.new(0, 10, 0, 10)
    scroll.BackgroundColor3 = THEME.Panel
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    makeUICorner(scroll, 4)
    
    local logList = Instance.new("UIListLayout", scroll)
    logList.Padding = UDim.new(0, 2)
    
    local function logTraffic(remote, args)
        local entry = string.format("[%s] %s (%d args)", os.date("%X"), remote.Name, #args)
        if #TrafficLog > 50 then table.remove(TrafficLog, 1) end
        table.insert(TrafficLog, entry)
        local l = Instance.new("TextLabel", scroll)
        l.Size = UDim2.new(1, 0, 0, 22)
        l.BackgroundColor3 = THEME.Button
        l.TextColor3 = THEME.Accent
        l.Text = "  " .. entry
        l.Font = Enum.Font.Code
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        makeUICorner(l, 2)
    end
    
    local success, mt = pcall(getrawmetatable, game)
    if success and mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                task.spawn(logTraffic, self, {...})
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end
end

local function cleanupAll()
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    table.clear(Connections)
end

makeButton(TitleBar, "X", UDim2.new(0, 35, 1, -10), UDim2.new(1, -45, 0, 5), function()
    cleanupAll()
    if getgenv().ZukaArchitectHub then 
        pcall(function() getgenv().ZukaArchitectHub:Destroy() end)
        getgenv().ZukaArchitectHub = nil 
    end
end)

makeButton(TitleBar, "-", UDim2.new(0, 35, 1, -10), UDim2.new(1, -85, 0, 5), function(btn)
    local isMin = MainFrame.Size.Y.Offset < 100
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = isMin and UDim2.new(0, 950, 0, 600) or UDim2.new(0, 450, 0, 35)}):Play()
    PagesArea.Visible = isMin
    TabsColumn.Visible = isMin
    btn.Text = isMin and "-" or "+"
end)

screen.Parent = CoreGui
switchPage("Editor")
notify("Architect V1", "Neural Link established. Network Hook active.")
