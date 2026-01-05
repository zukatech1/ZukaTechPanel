
if getgenv().ZukaLuaHub then
    pcall(function() getgenv().ZukaLuaHub:Destroy() end)
    getgenv().ZukaLuaHub = nil
end

--==============================================================================
-- Services & Architectural Setup
--==============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Connections = {}

--==============================================================================
-- Aesthetic Configuration
--==============================================================================
local THEME = {
    Background = Color3.fromRGB(20, 20, 24),
    Window = Color3.fromRGB(28, 28, 30),
    Panel = Color3.fromRGB(30, 30, 34),
    Accent = Color3.fromRGB(75, 145, 255),
    AccentMuted = Color3.fromRGB(70, 110, 210),
    Button = Color3.fromRGB(36, 36, 40),
    ButtonHover = Color3.fromRGB(56, 56, 60),
    Text = Color3.fromRGB(235, 240, 255),
    MutedText = Color3.fromRGB(150, 160, 180),
    Corner = 8,
}

--==============================================================================
-- Framework UI Helpers
--==============================================================================
local screen = Instance.new("ScreenGui")
screen.Name = "ZukaLuaHub"
screen.ResetOnSpawn = false
getgenv().ZukaLuaHub = screen

local function notify(title, text, duration)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 3 }) end)
end

local function makeUICorner(parent, radius)
    local c = Instance.new("UICorner", parent); c.CornerRadius = UDim.new(0, radius or 6); return c
end

local function makeButton(parent, text, size, pos, callback, isAccent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size; btn.Position = pos; btn.AutoButtonColor = false
    btn.BackgroundColor3 = isAccent and THEME.Accent or THEME.Button
    btn.TextColor3 = THEME.Text; btn.Font = Enum.Font.Code; btn.TextSize = 14; btn.Text = text
    makeUICorner(btn, math.max(4, THEME.Corner - 2))

    table.insert(Connections, btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.ButtonHover}):Play() 
    end))
    table.insert(Connections, btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = isAccent and THEME.Accent or THEME.Button}):Play() 
    end))
    table.insert(Connections, btn.MouseButton1Click:Connect(function() pcall(callback, btn) end))
    return btn
end

--==============================================================================
-- Structural Components (Main Frame)
--==============================================================================
local MainFrame = Instance.new("Frame", screen)
MainFrame.Size = UDim2.new(0, 760, 0, 440)
MainFrame.Position = UDim2.new(0.5, -380, 0.5, -220)
MainFrame.BackgroundColor3 = THEME.Window
MainFrame.BorderSizePixel = 0
makeUICorner(MainFrame, THEME.Corner)
local mainStroke = Instance.new("UIStroke", MainFrame); mainStroke.Color = Color3.fromRGB(10,10,12); mainStroke.Transparency = 0.6

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.BackgroundColor3 = THEME.Panel; makeUICorner(TitleBar, THEME.Corner)
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -180, 1, 0); TitleLabel.Position = UDim2.new(0, 44, 0, 0); TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ZukaTech Executor // Architect Edition"; TitleLabel.Font = Enum.Font.Code; TitleLabel.TextSize = 16; TitleLabel.TextColor3 = THEME.Text; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
local TitleIcon = Instance.new("ImageLabel", TitleBar)
TitleIcon.Size = UDim2.new(0,28,0,28); TitleIcon.Position = UDim2.new(0, 8, 0, 6); TitleIcon.BackgroundTransparency = 1; TitleIcon.Image = "rbxassetid://7072711062"

-- Optimized Dragging Logic
do
    local dragging, dragStart, startPos
    table.insert(Connections, TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, MainFrame.Position
            local conn; conn = input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false; conn:Disconnect() end end)
        end
    end))
    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

--==============================================================================
-- Navigation System
--==============================================================================
local TabsColumn = Instance.new("Frame", MainFrame)
TabsColumn.Size = UDim2.new(0, 140, 1, -48); TabsColumn.Position = UDim2.new(0, 8, 0, 44); TabsColumn.BackgroundColor3 = THEME.Panel; makeUICorner(TabsColumn, THEME.Corner)
local tabsLayout = Instance.new("UIListLayout", TabsColumn); tabsLayout.Padding = UDim.new(0, 8); tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local PagesArea = Instance.new("Frame", MainFrame)
PagesArea.Size = UDim2.new(1, -164, 1, -48); PagesArea.Position = UDim2.new(0, 156, 0, 44); PagesArea.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local p = Instance.new("Frame", PagesArea); p.Name = name; p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1; p.Visible = false
    pages[name] = p; return p
end

local function switchPage(name)
    for k,v in pairs(pages) do v.Visible = (k == name) end
    for _, child in pairs(TabsColumn:GetChildren()) do
        if child:IsA("TextButton") then
            local isTarget = child.Name == (name .. "_Tab")
            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = isTarget and THEME.AccentMuted or THEME.Button}):Play()
        end
    end
end

local function makeTab(name)
    local btn = makeButton(TabsColumn, name, UDim2.new(1, -16, 0, 40), UDim2.new(), function() switchPage(name) end)
    btn.Name = name .. "_Tab"; btn.LayoutOrder = #TabsColumn:GetChildren()
    return btn
end

-- Initialize the solitary Editor Tab
local EditorPage = createPage("Editor")
makeTab("Editor")

--==============================================================================
-- Editor Logic (Execution Hub)
--==============================================================================
do
    local editorBack = Instance.new("Frame", EditorPage); editorBack.Size = UDim2.new(1, 0, 1, 0); editorBack.BackgroundColor3 = THEME.Background; makeUICorner(editorBack, THEME.Corner)
    local gutter = Instance.new("TextLabel", editorBack); gutter.Size = UDim2.new(0,44,1,-50); gutter.BackgroundColor3 = THEME.Panel; gutter.TextColor3 = THEME.MutedText; gutter.Font = Enum.Font.Code; gutter.TextSize = 14; gutter.TextXAlignment = Enum.TextXAlignment.Right; gutter.TextYAlignment = Enum.TextYAlignment.Top; gutter.Text = "1"; gutter.ClipsDescendants = true
    
    local scroller = Instance.new("ScrollingFrame", editorBack); scroller.Size = UDim2.new(1, -44, 1, -50); scroller.Position = UDim2.new(0, 44, 0, 0); scroller.CanvasSize = UDim2.new(0,0,0,0); scroller.ScrollBarThickness = 6; scroller.BackgroundColor3 = THEME.Background; scroller.BorderSizePixel = 0; scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local textBox = Instance.new("TextBox", scroller); textBox.Size = UDim2.new(1, 0, 1, 0); textBox.MultiLine = true; textBox.ClearTextOnFocus = false; textBox.TextXAlignment = Enum.TextXAlignment.Left; textBox.TextYAlignment = Enum.TextYAlignment.Top; textBox.Font = Enum.Font.Code; textBox.TextSize = 15; textBox.TextColor3 = THEME.Text; textBox.Text = "-- ZukaTech Architect Editor --\n-- Ready for injection.\n"; textBox.BackgroundTransparency = 1
    
    table.insert(Connections, scroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function() gutter.Position = UDim2.new(0,0,0,-scroller.CanvasPosition.Y) end))
    table.insert(Connections, textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local lines = select(2, textBox.Text:gsub("\n","")) + 1
        local lineNumbers = {}; for i = 1, lines do table.insert(lineNumbers, tostring(i)) end
        gutter.Text = table.concat(lineNumbers, "\n")
    end))
    
    local bar = Instance.new("Frame", editorBack); bar.Size = UDim2.new(1,0,0,50); bar.Position = UDim2.new(0,0,1,-50); bar.BackgroundColor3 = THEME.Panel
    
    makeButton(bar, "Execute", UDim2.new(0,120,0,34), UDim2.new(0,10,0,8), function()
        local func, err = loadstring(textBox.Text)
        if func then 
            task.spawn(function()
                local success, execErr = pcall(func)
                if not success then notify("Runtime Error", tostring(execErr), 5) end
            end)
        else 
            notify("Compile Error", tostring(err), 5) 
        end
    end, true)
    
    makeButton(bar, "Clear", UDim2.new(0,120,0,34), UDim2.new(0,140,0,8), function() textBox.Text = "" end)
    
    makeButton(bar, "Save", UDim2.new(0,120,0,34), UDim2.new(0,270,0,8), function()
        if writefile then 
            pcall(writefile, "ZukaHubScript.lua", textBox.Text)
            notify("Architect", "Buffer saved to disk.", 2) 
        else 
            notify("Architect", "FS: writefile unsupported.", 3) 
        end
    end)
    
    makeButton(bar, "Load", UDim2.new(0,120,0,34), UDim2.new(0,400,0,8), function()
        if readfile and isfile and isfile("ZukaHubScript.lua") then 
            local ok, c = pcall(readfile, "ZukaHubScript.lua")
            if ok then textBox.Text = c; notify("Architect", "Buffer loaded.", 2) end 
        else 
            notify("Architect", "FS: File not found.", 3) 
        end
    end)
end

--==============================================================================
-- Cleanup & Lifecycle Management
--==============================================================================
local function cleanupAll()
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    table.clear(Connections)
end

local CloseBtn = makeButton(TitleBar, "X", UDim2.new(0,40,1,-12), UDim2.new(1,-50,0,6), function()
    cleanupAll()
    if getgenv().ZukaLuaHub then 
        pcall(function() getgenv().ZukaLuaHub:Destroy() end)
        getgenv().ZukaLuaHub = nil 
    end
end)

local minimized = false; local originalSize
local MinBtn = makeButton(TitleBar, "-", UDim2.new(0,40,1,-12), UDim2.new(1,-95,0,6), function()
    minimized = not minimized
    if minimized then
        originalSize = MainFrame.Size
        PagesArea.Visible = false; TabsColumn.Visible = false; MinBtn.Text = "+"
        TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 320, 0, 40)}):Play()
    else
        PagesArea.Visible = true; TabsColumn.Visible = true; MinBtn.Text = "-"
        TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Size = originalSize}):Play()
    end
end)

--==============================================================================
-- Injection Point
--==============================================================================
screen.Parent = CoreGui
switchPage("Editor")
notify("ZukaTech", "Executor Core Initialized.", 3)
