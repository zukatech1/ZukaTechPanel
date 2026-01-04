local CoreGui: CoreGui = game:GetService("CoreGui")
local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TweenService: TweenService = game:GetService("TweenService")
local Players: Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

type PatchData = {
    Value: any,
    Locked: boolean,
    IsFunction: boolean,
    Original: any?
}

local Registry = {
    ActivePatches = {} :: { [table]: { [any]: PatchData } },
    Hooks = {} :: { [any]: any }
}

local State = {
    SelectedModule = nil,
    CurrentTable = nil,
    PathStack = {},
    Minimized = false,
    ViewingCode = false,
    SearchFilter = ""
}

local SidebarButtons = {}

local decompiler = (decompile or decompile_script or function() return "-- [ERROR] Decompiler unsupported." end)

local ArchitectSuite = {
    GetBestTarget = function(dist: number): Instance?
        local target, closest = nil, dist
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < closest then
                    target = p.Character.HumanoidRootPart
                    closest = d
                end
            end
        end
        return target
    end,

    ProxyRaycast = function(originalFunc: any)
        return hookfunction(originalFunc, function(...)
            local result = originalFunc(...)
            local target = ArchitectSuite.GetBestTarget(20)

            if target then
                if typeof(result) == "Instance" then
                    return target
                elseif type(result) == "table" or typeof(result) == "RaycastResult" then
                    local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
                    
                    if typeof(result) == "RaycastResult" then
                        return result
                    end

                    pcall(function()
                        setRO(result, false)
                        result.Instance = target
                        result.Position = target.Position
                        result.Hit = target
                        setRO(result, true)
                    end)
                end
            end
            return result
        end)
    end
}

local function SafeRawSet(tbl: table, key: any, val: any)
    local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
    local success, err = pcall(function()
        setRO(tbl, false)
        rawset(tbl, key, val)
        setRO(tbl, true)
    end)
    return success
end

local function ApplyDeepPatch(tbl: table, key: any, val: any, isFunc: boolean)
    if not Registry.ActivePatches[tbl] then
        Registry.ActivePatches[tbl] = {}
    end

    if isFunc then
        local spoofValue = val
        local originalFunc = tbl[key]
        
        if hookfunction then
            local newClosure = function(...)
                if spoofValue == "TRUE" then return true end
                if spoofValue == "FALSE" then return false end
                return nil
            end
            Registry.Hooks[originalFunc] = hookfunction(originalFunc, newClosure)
        end
    else
        Registry.ActivePatches[tbl][key] = {
            Value = val,
            Locked = true,
            IsFunction = false
        }
        SafeRawSet(tbl, key, val)
    end
end

RunService.Heartbeat:Connect(function()
    for tbl, keys in pairs(Registry.ActivePatches) do
        for key, data in pairs(keys) do
            if data.Locked and not data.IsFunction then
                if tbl[key] ~= data.Value then
                    SafeRawSet(tbl, key, data.Value)
                end
            end
        end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OVERSEER_ARCHITECT_V26_PAYLOADS"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(850, 550)
main.Position = UDim2.new(0.5, -425, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local function applyStyle(obj: Instance, r: number?)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

local function createStroke(obj: Instance, color: Color3)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1
    s.Transparency = 0.8
    s.Parent = obj
end

applyStyle(main, 6)
createStroke(main, Color3.fromRGB(0, 255, 170))

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -220, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.Text = "OVERSEER // ARCHITECT EDITION V26"
title.TextColor3 = Color3.fromRGB(0, 255, 170)
title.Font = Enum.Font.Code
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = header

local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.new(0, 60, 0, 22)
backBtn.Position = UDim2.new(1, -195, 0.5, -11)
backBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
backBtn.Text = "< BACK"
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.Code
backBtn.TextSize = 10
applyStyle(backBtn, 3)
backBtn.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 0)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BackgroundTransparency = 1
minBtn.Font = Enum.Font.Code
minBtn.Parent = header

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.fromOffset(0, 35)
content.BackgroundTransparency = 1
content.Parent = main

local searchInput = Instance.new("TextBox")
searchInput.Size = UDim2.new(0, 230, 0, 30)
searchInput.Position = UDim2.fromOffset(10, 10)
searchInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
searchInput.PlaceholderText = "SEARCH REGISTRY..."
searchInput.Text = ""
searchInput.TextColor3 = Color3.fromRGB(0, 255, 170)
searchInput.Font = Enum.Font.Code
searchInput.TextSize = 10
applyStyle(searchInput, 4)
createStroke(searchInput, Color3.fromRGB(40, 40, 45))
searchInput.Parent = content

local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 230, 1, -60)
sidebar.Position = UDim2.fromOffset(10, 50)
sidebar.BackgroundTransparency = 1
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 1
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.Parent = content

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 4)
sidebarList.Parent = sidebar

local grid = Instance.new("ScrollingFrame")
grid.Size = UDim2.new(1, -270, 1, -20)
grid.Position = UDim2.fromOffset(260, 10)
grid.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
grid.ScrollBarThickness = 1
grid.CanvasSize = UDim2.new(0, 0, 0, 0)
applyStyle(grid, 4)
createStroke(grid, Color3.fromRGB(30, 30, 35))
grid.Parent = content

local gridList = Instance.new("UIListLayout")
gridList.SortOrder = Enum.SortOrder.LayoutOrder
gridList.Parent = grid

local codeFrame = Instance.new("Frame")
codeFrame.Size = grid.Size
codeFrame.Position = grid.Position
codeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
codeFrame.Visible = false
applyStyle(codeFrame, 4)
codeFrame.Parent = content

local codeScroller = Instance.new("ScrollingFrame")
codeScroller.Size = UDim2.new(1, -20, 1, -60)
codeScroller.Position = UDim2.fromOffset(10, 10)
codeScroller.BackgroundTransparency = 1
codeScroller.ScrollBarThickness = 1
codeScroller.AutomaticCanvasSize = Enum.AutomaticSize.XY
codeScroller.Parent = codeFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, 0, 1, 0)
codeBox.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
codeBox.TextColor3 = Color3.fromRGB(180, 180, 180)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 10
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.TextEditable = false
codeBox.MultiLine = true
codeBox.Text = ""
codeBox.AutomaticSize = Enum.AutomaticSize.XY
applyStyle(codeBox, 4)
codeBox.Parent = codeScroller

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 100, 0, 30)
copyBtn.Position = UDim2.new(1, -110, 1, -40)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
copyBtn.Text = "COPY"
copyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
copyBtn.Font = Enum.Font.Code
copyBtn.TextSize = 10
applyStyle(copyBtn, 4)
copyBtn.Parent = codeFrame

local closeCode = Instance.new("TextButton")
closeCode.Size = UDim2.new(0, 100, 0, 30)
closeCode.Position = UDim2.new(0, 10, 1, -40)
closeCode.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
closeCode.Text = "EXIT"
closeCode.TextColor3 = Color3.new(1, 1, 1)
closeCode.Font = Enum.Font.Code
closeCode.TextSize = 10
applyStyle(closeCode, 4)
closeCode.Parent = codeFrame

local function ShowSource(target: any)
    State.ViewingCode = true
    grid.Visible = false
    codeFrame.Visible = true
    title.Text = "DECOMPILING OBJECT..."
    codeBox.Text = "-- Architect Decompiler at work..."
    task.spawn(function()
        local src = decompiler(target)
        codeBox.Text = src
    end)
end

local function PopulateGrid(targetTable: table, name: string)
    State.CurrentTable = targetTable
    title.Text = "POISONING PATH: " .. (name or "Unknown")
    
    for _, v in ipairs(grid:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local function CreateRow(k: any, v: any, parent: table)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -10, 0, 35)
        row.BackgroundTransparency = 1
        row.Parent = grid

        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0.4, 0, 1, 0)
        keyLabel.Position = UDim2.fromOffset(5, 0)
        keyLabel.Text = "[" .. type(v):upper() .. "] " .. tostring(k)
        keyLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
        keyLabel.Font = Enum.Font.Code
        keyLabel.TextSize = 9
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.BackgroundTransparency = 1
        keyLabel.Parent = row

        if type(v) == "table" then
            local dive = Instance.new("TextButton")
            dive.Size = UDim2.new(0, 70, 0, 22)
            dive.Position = UDim2.fromScale(0.45, 0.2)
            dive.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            dive.Text = "DIVE"
            dive.TextColor3 = Color3.fromRGB(0, 255, 170)
            dive.Font = Enum.Font.Code
            dive.TextSize = 8
            applyStyle(dive, 2)
            dive.Parent = row
            dive.MouseButton1Click:Connect(function()
                table.insert(State.PathStack, parent)
                PopulateGrid(v, tostring(k))
            end)
        elseif type(v) == "function" then
            local hook = Instance.new("TextButton")
            hook.Size = UDim2.new(0, 70, 0, 22)
            hook.Position = UDim2.fromScale(0.45, 0.2)
            hook.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
            hook.Text = "HOOK"
            hook.TextColor3 = Color3.new(1, 1, 1)
            hook.Font = Enum.Font.Code
            hook.TextSize = 8
            applyStyle(hook, 2)
            hook.Parent = row

            local view = Instance.new("TextButton")
            view.Size = UDim2.new(0, 70, 0, 22)
            view.Position = UDim2.fromScale(0.55, 0.2)
            view.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
            view.Text = "SOURCE"
            view.TextColor3 = Color3.fromRGB(0, 255, 170)
            view.Font = Enum.Font.Code
            view.TextSize = 8
            applyStyle(view, 2)
            view.Parent = row

            view.MouseButton1Click:Connect(function() ShowSource(v) end)

            local modes = {"NORMAL", "TRUE", "FALSE"}
            local cur = 1
            hook.MouseButton1Click:Connect(function()
                cur = (cur % 3) + 1
                local m = modes[cur]
                hook.Text = "FORCE " .. m
                ApplyDeepPatch(parent, k, m, true)
            end)
            
            if debug and debug.getupvalues then
                local upvBtn = Instance.new("TextButton")
                upvBtn.Size = UDim2.new(0, 70, 0, 22)
                upvBtn.Position = UDim2.fromScale(0.65, 0.2)
                upvBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 40)
                upvBtn.Text = "UPVALUES"
                upvBtn.TextColor3 = Color3.new(1, 0.8, 0)
                upvBtn.Font = Enum.Font.Code
                upvBtn.TextSize = 8
                applyStyle(upvBtn, 2)
                upvBtn.Parent = row
                upvBtn.MouseButton1Click:Connect(function()
                    table.insert(State.PathStack, parent)
                    PopulateGrid(debug.getupvalues(v), "UPVALUES: " .. tostring(k))
                end)
            end
        else
            local valInput = Instance.new("TextBox")
            valInput.Size = UDim2.new(0, 120, 0, 22)
            valInput.Position = UDim2.fromScale(0.45, 0.2)
            valInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            valInput.Text = tostring(v)
            valInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            valInput.Font = Enum.Font.Code
            valInput.TextSize = 9
            applyStyle(valInput, 2)
            valInput.Parent = row
            valInput.FocusLost:Connect(function(enter)
                if enter then
                    local newVal = tonumber(valInput.Text) or valInput.Text
                    if valInput.Text == "true" then newVal = true elseif valInput.Text == "false" then newVal = false end
                    ApplyDeepPatch(parent, k, newVal, false)
                end
            end)
        end
    end

    pcall(function()
        for k, v in pairs(targetTable) do
            CreateRow(k, v, targetTable)
        end
    end)
end

local function AddSidebarItem(obj: any, name: string)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -5, 0, 28)
    container.BackgroundTransparency = 1
    container.Parent = sidebar

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    btn.Text = " " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    applyStyle(btn, 3)
    btn.Parent = container

    local payload = Instance.new("TextButton")
    payload.Size = UDim2.new(0, 35, 1, 0)
    payload.Position = UDim2.new(1, -75, 0, 0)
    payload.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
    payload.Text = "PL"
    payload.TextColor3 = Color3.fromRGB(255, 50, 50)
    payload.Font = Enum.Font.Code
    payload.TextSize = 9
    payload.Visible = (name:lower():find("melee") or name:lower():find("combat") or name:lower():find("ray")) ~= nil
    applyStyle(payload, 3)
    payload.Parent = container

    local src = Instance.new("TextButton")
    src.Size = UDim2.new(0, 35, 1, 0)
    src.Position = UDim2.new(1, -35, 0, 0)
    src.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    src.Text = "{}"
    src.TextColor3 = Color3.fromRGB(0, 255, 170)
    src.Font = Enum.Font.Code
    src.TextSize = 10
    applyStyle(src, 3)
    src.Parent = container

    SidebarButtons[container] = name

    btn.MouseButton1Click:Connect(function()
        State.SelectedModule = obj
        State.PathStack = {}
        local success, result = pcall(require, obj)
        if success then PopulateGrid(result, name) else PopulateGrid(obj, name) end
    end)

    payload.MouseButton1Click:Connect(function()
        local success, result = pcall(require, obj)
        if success then
            for k, v in pairs(result) do
                if type(v) == "function" then
                    if k:lower():find("cooldown") then
                        hookfunction(v, function() return false end)
                    elseif k:lower():find("cast") or k:lower():find("ray") or k:lower():find("hit") then
                        ArchitectSuite.ProxyRaycast(v)
                    end
                end
            end
            payload.Text = "OK"
            payload.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
            payload.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)

    src.MouseButton1Click:Connect(function() ShowSource(obj) end)
end

task.spawn(function()
    local processed = {}
    local function scan(root)
        for _, m in ipairs(root:GetDescendants()) do
            if m:IsA("ModuleScript") and not processed[m] then
                processed[m] = true
                AddSidebarItem(m, m.Name)
            end
        end
    end

    scan(game:GetService("ReplicatedStorage"))
    scan(Players.LocalPlayer)

    if getloadedmodules then
        for _, m in ipairs(getloadedmodules()) do
            if not processed[m] then
                processed[m] = true
                AddSidebarItem(m, "[LOADED] " .. tostring(m))
            end
        end
    end
end)

backBtn.MouseButton1Click:Connect(function()
    if #State.PathStack > 0 then
        local prev = table.remove(State.PathStack)
        PopulateGrid(prev, "Parent Scope")
    end
end)

closeCode.MouseButton1Click:Connect(function()
    State.ViewingCode = false
    codeFrame.Visible = false
    grid.Visible = true
end)

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = searchInput.Text:lower()
    for btn, name in pairs(SidebarButtons) do
        btn.Visible = name:lower():find(filter) ~= nil
    end
end)

minBtn.MouseButton1Click:Connect(function()
    State.Minimized = not State.Minimized
    content.Visible = not State.Minimized
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = State.Minimized and UDim2.fromOffset(850, 35) or UDim2.fromOffset(850, 550)
    }):Play()
end)

local dragging, dragInput, dragStart, startPos
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
