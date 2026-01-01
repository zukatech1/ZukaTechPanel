--[[
    ARCHITECT // OVERSEER V25 (THE FINISHER) + DECOMPILER EXTENSION
    - Integration: Native Decompiler Hook (decompile/decompile_script).
    - UI: Code View Overlay with Copy-to-Clipboard.
    - Logic: Functional closure decompilation within tables.
--]]

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LogService = game:GetService("LogService")

local Registry = { ActivePatches = {} }
local State = { SelectedModule = nil, CurrentTable = nil, PathStack = {}, Minimized = false, ViewingCode = false }
local SidebarButtons = {}

-- [ UTILITY: DECOMPILER HOOK ] --
local decompiler = (decompile or decompile_script or function() return "-- [ERROR] Decompiler not supported by your executor." end)

local function SetClipboard(txt)
    if setclipboard then setclipboard(txt) end
end

-- [ ENGINE: THE OMNI-FORCER ] --
RunService.Heartbeat:Connect(function()
    for tbl, keys in pairs(Registry.ActivePatches) do
        for key, data in pairs(keys) do
            if data.Locked then
                local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
                pcall(function()
                    setRO(tbl, false)
                    if data.IsFunction then
                        if data.Value == "TRUE" then rawset(tbl, key, function() return true end)
                        elseif data.Value == "FALSE" then rawset(tbl, key, function() return false end) end
                    else
                        rawset(tbl, key, data.Value)
                    end
                    setRO(tbl, true)
                end)
            end
        end
    end
end)

local function ApplyPatch(tbl, key, val, isFunc)
    if not Registry.ActivePatches[tbl] then Registry.ActivePatches[tbl] = {} end
    Registry.ActivePatches[tbl][key] = {Value = val, Locked = true, IsFunction = isFunc}
    local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)
    pcall(function() 
        setRO(tbl, false)
        if isFunc then
            if val == "TRUE" then rawset(tbl, key, function() return true end)
            elseif val == "FALSE" then rawset(tbl, key, function() return false end) end
        else rawset(tbl, key, val) end
        setRO(tbl, true) 
    end)
end

-- [ UI CONSTRUCTION ] --
local screenGui = Instance.new("ScreenGui", CoreGui); screenGui.Name = "Overseer_Final_V25_Decomp"
local main = Instance.new("Frame", screenGui); main.Size = UDim2.fromOffset(850, 550); main.Position = UDim2.new(0.5, -425, 0.5, -275); main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); main.BorderSizePixel = 0; main.ClipsDescendants = true
local function applyStyle(obj, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 4); c.Parent = obj end
applyStyle(main, 6)

-- Header
local header = Instance.new("Frame", main); header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1, -220, 1, 0); title.Position = UDim2.fromOffset(10, 0); title.Text = "OVERSEER V25 // READY FOR SCAN"; title.TextColor3 = Color3.fromRGB(0, 255, 170); title.Font = Enum.Font.Code; title.TextSize = 12; title.TextXAlignment = "Left"; title.BackgroundTransparency = 1

local backBtn = Instance.new("TextButton", header); backBtn.Size = UDim2.new(0, 60, 0, 24); backBtn.Position = UDim2.new(1, -195, 0.5, -12); backBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45); backBtn.Text = "< BACK"; backBtn.TextColor3 = Color3.new(1,1,1); backBtn.Font = Enum.Font.Code; backBtn.TextSize = 10; applyStyle(backBtn, 2)
local minBtn = Instance.new("TextButton", header); minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -35, 0, 0); minBtn.Text = "_"; minBtn.TextColor3 = Color3.new(1, 1, 1); minBtn.BackgroundTransparency = 1; minBtn.Font = Enum.Font.Code

-- Content
local content = Instance.new("Frame", main); content.Size = UDim2.new(1, 0, 1, -35); content.Position = UDim2.fromOffset(0, 35); content.BackgroundTransparency = 1
local searchInput = Instance.new("TextBox", content); searchInput.Size = UDim2.new(0, 230, 0, 30); searchInput.Position = UDim2.fromOffset(10, 10); searchInput.BackgroundColor3 = Color3.fromRGB(18, 18, 22); searchInput.PlaceholderText = "SEARCH MODULES..."; searchInput.Text = ""; searchInput.TextColor3 = Color3.fromRGB(0, 255, 170); searchInput.Font = Enum.Font.Code; searchInput.TextSize = 10; applyStyle(searchInput, 4)

local sidebar = Instance.new("ScrollingFrame", content); sidebar.Size = UDim2.new(0, 230, 1, -60); sidebar.Position = UDim2.fromOffset(10, 50); sidebar.BackgroundTransparency = 1; sidebar.AutomaticCanvasSize = "Y"; sidebar.ScrollBarThickness = 1; Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 4)
local grid = Instance.new("ScrollingFrame", content); grid.Size = UDim2.new(1, -270, 1, -20); grid.Position = UDim2.fromOffset(260, 10); grid.BackgroundColor3 = Color3.fromRGB(18, 18, 22); grid.AutomaticCanvasSize = "Y"; applyStyle(grid, 4); Instance.new("UIListLayout", grid)

-- [ DECOMPILER VIEW OVERLAY ] --
local codeFrame = Instance.new("Frame", content); codeFrame.Size = grid.Size; codeFrame.Position = grid.Position; codeFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15); codeFrame.Visible = false; applyStyle(codeFrame, 4)
local codeBox = Instance.new("TextBox", codeFrame); codeBox.Size = UDim2.new(1, -20, 1, -50); codeBox.Position = UDim2.fromOffset(10, 10); codeBox.BackgroundColor3 = Color3.fromRGB(5, 5, 7); codeBox.TextColor3 = Color3.fromRGB(200, 200, 200); codeBox.Font = Enum.Font.Code; codeBox.TextSize = 10; codeBox.TextXAlignment = "Left"; codeBox.TextYAlignment = "Top"; codeBox.ClearTextOnFocus = false; codeBox.TextEditable = false; codeBox.MultiLine = true; codeBox.Text = ""; applyStyle(codeBox, 4)
local copyBtn = Instance.new("TextButton", codeFrame); copyBtn.Size = UDim2.new(0, 100, 0, 30); copyBtn.Position = UDim2.new(1, -110, 1, -35); copyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170); copyBtn.Text = "COPY CODE"; copyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); copyBtn.Font = Enum.Font.Code; copyBtn.TextSize = 10; applyStyle(copyBtn, 4)
local closeCode = Instance.new("TextButton", codeFrame); closeCode.Size = UDim2.new(0, 100, 0, 30); closeCode.Position = UDim2.new(0, 10, 1, -35); closeCode.BackgroundColor3 = Color3.fromRGB(40, 40, 45); closeCode.Text = "EXIT SOURCE"; closeCode.TextColor3 = Color3.new(1, 1, 1); closeCode.Font = Enum.Font.Code; closeCode.TextSize = 10; applyStyle(closeCode, 4)

local function ShowSource(target)
    State.ViewingCode = true
    grid.Visible = false
    codeFrame.Visible = true
    title.Text = "DECOMPILING: " .. (target.Name or "Closure")
    codeBox.Text = "-- Generating Source, please wait..."
    task.spawn(function()
        local src = decompiler(target)
        codeBox.Text = src
    end)
end

closeCode.MouseButton1Click:Connect(function()
    State.ViewingCode = false
    codeFrame.Visible = false
    grid.Visible = true
    title.Text = "PATH: " .. (State.SelectedModule and State.SelectedModule.Name or "Main")
end)

copyBtn.MouseButton1Click:Connect(function()
    SetClipboard(codeBox.Text)
    copyBtn.Text = "COPIED!"
    task.wait(1)
    copyBtn.Text = "COPY CODE"
end)

-- [ THE RECURSIVE ABYSS GRID ] --
local function PopulateGrid(targetTable, name)
    State.CurrentTable = targetTable
    title.Text = "PATH: " .. (name or "Main")
    for _, v in ipairs(grid:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    
    local function CreateRow(k, v, src)
        local row = Instance.new("Frame", grid); row.Size = UDim2.new(1, -10, 0, 35); row.BackgroundTransparency = 1
        local kL = Instance.new("TextLabel", row); kL.Size = UDim2.new(0.4, 0, 1, 0); kL.Text = " "..tostring(k); kL.TextColor3 = Color3.fromRGB(150, 150, 150); kL.Font = Enum.Font.Code; kL.TextSize = 9; kL.TextXAlignment = "Left"; kL.BackgroundTransparency = 1
        
        if type(v) == "table" then
            local diveBtn = Instance.new("TextButton", row); diveBtn.Size = UDim2.new(0, 100, 0, 24); diveBtn.Position = UDim2.fromScale(0.42, 0.15); diveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60); diveBtn.Text = "DIVE >"; diveBtn.TextColor3 = Color3.fromRGB(0, 255, 170); diveBtn.Font = Enum.Font.Code; diveBtn.TextSize = 8; applyStyle(diveBtn, 2)
            diveBtn.MouseButton1Click:Connect(function() table.insert(State.PathStack, src); PopulateGrid(v, tostring(k)) end)
        elseif type(v) == "function" then
            local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 60, 0, 24); btn.Position = UDim2.fromScale(0.42, 0.15); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70); btn.Text = "SPOOF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Code; btn.TextSize = 8; applyStyle(btn, 2)
            
            local viewBtn = Instance.new("TextButton", row); viewBtn.Size = UDim2.new(0, 60, 0, 24); viewBtn.Position = UDim2.fromScale(0.55, 0.15); viewBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 60); viewBtn.Text = "VIEW"; viewBtn.TextColor3 = Color3.fromRGB(255, 100, 255); viewBtn.Font = Enum.Font.Code; viewBtn.TextSize = 8; applyStyle(viewBtn, 2)
            viewBtn.MouseButton1Click:Connect(function() ShowSource(v) end)

            local modes = {"NORMAL", "TRUE", "FALSE"}; local cur = 1
            btn.MouseButton1Click:Connect(function()
                cur = (cur % 3) + 1; local m = modes[cur]; btn.Text = "FORCE " .. m; btn.BackgroundColor3 = (m == "TRUE" and Color3.fromRGB(0, 200, 100)) or (m == "FALSE" and Color3.fromRGB(200, 50, 50)) or Color3.fromRGB(50, 50, 70)
                if m == "NORMAL" then Registry.ActivePatches[src][k] = nil else ApplyPatch(src, k, m, true) end
            end)
        else
            local box = Instance.new("TextBox", row); box.Size = UDim2.new(0, 100, 0, 24); box.Position = UDim2.fromScale(0.42, 0.15); box.BackgroundColor3 = Color3.fromRGB(10, 10, 12); box.Text = tostring(v); box.TextColor3 = Color3.fromRGB(0, 255, 170); box.Font = Enum.Font.Code; box.TextSize = 9; applyStyle(box, 2)
            box.FocusLost:Connect(function(e) if e then ApplyPatch(src, k, tonumber(box.Text) or box.Text, false) end end)
        end
    end

    for k, v in pairs(targetTable) do CreateRow(k, v, targetTable) end
    local mt = getrawmetatable and getrawmetatable(targetTable)
    if mt and mt.__index and type(mt.__index) == "table" then
        local l = Instance.new("TextLabel", grid); l.Size = UDim2.new(1,0,0,20); l.Text = " -- GHOST INDEX -- "; l.TextColor3 = Color3.fromRGB(255, 0, 255); l.BackgroundTransparency = 1; l.Font = Enum.Font.Code; l.TextSize = 9
        for k, v in pairs(mt.__index) do CreateRow(k, v, mt.__index) end
    end
end

-- Navigation
backBtn.MouseButton1Click:Connect(function() if #State.PathStack > 0 then local prev = table.remove(State.PathStack); PopulateGrid(prev, "Parent") end end)

-- [ MODULE DISCOVERY ] --
local function AddModule(mod)
    local n = mod.Name:lower()
    if n:find("chat") or n:find("roblox") then return end
    
    local container = Instance.new("Frame", sidebar); container.Size = UDim2.new(1, -5, 0, 25); container.BackgroundTransparency = 1
    
    local b = Instance.new("TextButton", container); b.Size = UDim2.new(0.7, 0, 1, 0); b.Text = " " .. mod.Name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"; applyStyle(b, 2)
    
    local srcB = Instance.new("TextButton", container); srcB.Size = UDim2.new(0.28, 0, 1, 0); srcB.Position = UDim2.fromScale(0.72, 0); srcB.BackgroundColor3 = Color3.fromRGB(30, 30, 35); srcB.Text = "SRC"; srcB.TextColor3 = Color3.fromRGB(0, 255, 170); srcB.Font = Enum.Font.Code; srcB.TextSize = 8; applyStyle(srcB, 2)
    
    SidebarButtons[container] = mod.Name
    b.MouseButton1Click:Connect(function() State.SelectedModule = mod; State.PathStack = {}; local s, r = pcall(require, mod); if s then PopulateGrid(r, mod.Name) end end)
    srcB.MouseButton1Click:Connect(function() ShowSource(mod) end)
end

task.spawn(function()
    local paths = {game:GetService("ReplicatedStorage"), game:GetService("Players").LocalPlayer, workspace}
    for _, p in ipairs(paths) do for _, m in ipairs(p:GetDescendants()) do if m:IsA("ModuleScript") then AddModule(m) end end task.wait() end
end)

-- Search & Window Logic
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local f = searchInput.Text:lower()
    for b, n in pairs(SidebarButtons) do b.Visible = n:lower():find(f) ~= nil end
end)

minBtn.MouseButton1Click:Connect(function()
    State.Minimized = not State.Minimized; content.Visible = not State.Minimized
    TweenService:Create(main, TweenInfo.new(0.3), {Size = State.Minimized and UDim2.fromOffset(850, 35) or UDim2.fromOffset(850, 550)}):Play()
end)

local d, ds, sp
header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds; main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
