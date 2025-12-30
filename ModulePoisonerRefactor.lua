local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local SCAN_TARGETS = {ReplicatedStorage, game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"), game:GetService("StarterPack")}
local BLACKLISTED_MODULE_NAMES = {["Settings"] = true, ["CoreScript"] = true, ["Chat"] = true, ["Camera"] = true, ["ControlModule"] = true}
local TOGGLE_KEY = Enum.KeyCode.RightAlt
local ACCENT_COLOR = Color3.fromRGB(0, 255, 150)
local BACK_COLOR = Color3.fromRGB(20, 20, 25)
local ITEM_COLOR = Color3.fromRGB(30, 30, 35)

local POISON_TYPES = {"Log Call", "Return Nil", "Return True", "Return False", "No-Op", "Upvalue Dump", "Custom Constant"}
local foundModules = {}
local selectedModule = nil
local selectedModuleTable = nil
local selectedFunctionName = nil
local selectedPoisonType = POISON_TYPES[1]
local originalFunctions = {}
local autoPoisonList = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZukaModulePoisoner_v6"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 450)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
mainFrame.BackgroundColor3 = BACK_COLOR
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 8)
local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Color = ACCENT_COLOR
uiStroke.Thickness = 2
uiStroke.Transparency = 0.5

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner", topBar)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.fromOffset(15, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ARCHITECT MODULE POISONER [V6]"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = ACCENT_COLOR
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 200, 0, 25)
searchBox.Position = UDim2.new(1, -215, 0.5, -12)
searchBox.BackgroundColor3 = ITEM_COLOR
searchBox.PlaceholderText = "Search Modules..."
searchBox.Text = ""
searchBox.Font = Enum.Font.Code
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.TextSize = 12
searchBox.Parent = topBar
Instance.new("UICorner", searchBox)

local moduleList = Instance.new("ScrollingFrame")
moduleList.Size = UDim2.new(0.4, -10, 1, -100)
moduleList.Position = UDim2.fromOffset(10, 50)
moduleList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
moduleList.BorderSizePixel = 0
moduleList.ScrollBarThickness = 4
moduleList.Parent = mainFrame
local moduleLayout = Instance.new("UIListLayout", moduleList)
moduleLayout.Padding = UDim.new(0, 2)

local functionList = Instance.new("ScrollingFrame")
functionList.Size = UDim2.new(0.6, -20, 1, -100)
functionList.Position = UDim2.new(0.4, 5, 0, 50)
functionList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
functionList.BorderSizePixel = 0
functionList.ScrollBarThickness = 4
functionList.Parent = mainFrame
local functionLayout = Instance.new("UIListLayout", functionList)
functionLayout.Padding = UDim.new(0, 2)

local controls = Instance.new("Frame")
controls.Size = UDim2.new(1, -20, 0, 40)
controls.Position = UDim2.new(0, 10, 1, -50)
controls.BackgroundTransparency = 1
controls.Parent = mainFrame

local function createButton(name, pos, size, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 14
    btn.Parent = controls
    Instance.new("UICorner", btn)
    return btn
end

local scanBtn = createButton("SCAN", UDim2.fromScale(0, 0), UDim2.fromScale(0.2, 1), ACCENT_COLOR)
local poisonBtn = createButton("POISON", UDim2.fromScale(0.22, 0), UDim2.fromScale(0.2, 1), Color3.fromRGB(200, 50, 80))
local restoreBtn = createButton("RESTORE", UDim2.fromScale(0.44, 0), UDim2.fromScale(0.2, 1), Color3.fromRGB(50, 100, 200))
local typeBtn = createButton(selectedPoisonType, UDim2.fromScale(0.66, 0), UDim2.fromScale(0.34, 1), ITEM_COLOR)

local typeMenu = Instance.new("Frame")
typeMenu.Size = UDim2.new(0, 200, 0, #POISON_TYPES * 30)
typeMenu.Position = UDim2.new(0.66, 0, 0, -typeMenu.Size.Y.Offset)
typeMenu.BackgroundColor3 = ITEM_COLOR
typeMenu.Visible = false
typeMenu.ZIndex = 10
typeMenu.Parent = controls
Instance.new("UIListLayout", typeMenu)

for _, pType in ipairs(POISON_TYPES) do
    local opt = Instance.new("TextButton")
    opt.Size = UDim2.new(1, 0, 0, 30)
    opt.BackgroundTransparency = 1
    opt.Text = pType
    opt.TextColor3 = Color3.new(1,1,1)
    opt.Font = Enum.Font.Code
    opt.Parent = typeMenu
    opt.MouseButton1Click:Connect(function()
        selectedPoisonType = pType
        typeBtn.Text = pType
        typeMenu.Visible = false
    end)
end

typeBtn.MouseButton1Click:Connect(function()
    typeMenu.Visible = not typeMenu.Visible
end)

local function notify(txt)
    StarterGui:SetCore("SendNotification", {Title = "SYSTEM", Text = txt, Duration = 2})
end

local function deepSearchFunctions(tbl, nameList, depth)
    if depth > 3 then return end
    for k, v in pairs(tbl) do
        if type(v) == "function" then
            nameList[tostring(k)] = v
        elseif type(v) == "table" and k ~= "_G" and k ~= "shared" then
            deepSearchFunctions(v, nameList, depth + 1)
        end
    end
    local mt = getmetatable(tbl)
    if mt and type(mt.__index) == "table" then
        deepSearchFunctions(mt.__index, nameList, depth + 1)
    end
end

local function getTablePath(root, targetFunc)
    local foundTbl = nil
    local function scan(t)
        if foundTbl then return end
        for k, v in pairs(t) do
            if v == targetFunc then
                foundTbl = t
                return
            end
            if type(v) == "table" and k ~= "_G" then scan(v) end
        end
    end
    scan(root)
    return foundTbl
end

local function populateFunctions(module)
    for _, v in ipairs(functionList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local success, returned = pcall(require, module)
    if not success then return notify("Module Require Failed") end
    
    selectedModuleTable = returned
    local funcs = {}
    if type(returned) == "table" then
        deepSearchFunctions(returned, funcs, 1)
    end

    for name, func in pairs(funcs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.BackgroundColor3 = ITEM_COLOR
        btn.Text = "  " .. name
        btn.Font = Enum.Font.Code
        btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = functionList
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            selectedFunctionName = name
            for _, b in ipairs(functionList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.8,0.8,0.8) end end
            btn.TextColor3 = ACCENT_COLOR
        end)
    end
end

local function scan()
    for _, v in ipairs(moduleList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    foundModules = {}
    for _, target in ipairs(SCAN_TARGETS) do
        if not target then continue end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("ModuleScript") and not BLACKLISTED_MODULE_NAMES[desc.Name] then
                table.insert(foundModules, desc)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 25)
                btn.BackgroundColor3 = ITEM_COLOR
                btn.Text = "  " .. desc.Name
                btn.Font = Enum.Font.Code
                btn.TextColor3 = Color3.new(0.8,0.8,0.8)
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = moduleList
                Instance.new("UICorner", btn)
                
                btn.MouseButton1Click:Connect(function()
                    selectedModule = desc
                    for _, b in ipairs(moduleList:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.8,0.8,0.8) end end
                    btn.TextColor3 = ACCENT_COLOR
                    populateFunctions(desc)
                end)
            end
        end
    end
end

scanBtn.MouseButton1Click:Connect(scan)

poisonBtn.MouseButton1Click:Connect(function()
    if not selectedModule or not selectedFunctionName then return notify("Select target first") end
    
    local path = selectedModule:GetFullName()
    local funcs = {}
    deepSearchFunctions(selectedModuleTable, funcs, 1)
    local targetFunc = funcs[selectedFunctionName]
    local targetTbl = getTablePath(selectedModuleTable, targetFunc)
    
    if not targetTbl then return notify("Table Path Lost") end
    
    if not originalFunctions[path] then originalFunctions[path] = {} end
    if not originalFunctions[path][selectedFunctionName] then
        originalFunctions[path][selectedFunctionName] = targetFunc
    end
    
    local original = originalFunctions[path][selectedFunctionName]
    local poison
    
    if selectedPoisonType == "Log Call" then
        poison = function(...)
            print("--> [POISON] " .. path .. " -> " .. selectedFunctionName .. " CALLED")
            return original(...)
        end
    elseif selectedPoisonType == "Return Nil" then
        poison = function() return nil end
    elseif selectedPoisonType == "Return True" then
        poison = function() return true end
    elseif selectedPoisonType == "Return False" then
        poison = function() return false end
    elseif selectedPoisonType == "No-Op" then
        poison = function() end
    elseif selectedPoisonType == "Upvalue Dump" then
        poison = function(...)
            if debug and debug.getupvalues then
                print("--- [UPVALUES] " .. selectedFunctionName .. " ---")
                for i, v in pairs(debug.getupvalues(original)) do
                    print("  [" .. i .. "]:", v)
                end
            end
            return original(...)
        end
    end
    
    if hookfunction then
        hookfunction(original, newcclosure(poison))
    else
        targetTbl[selectedFunctionName] = poison
    end
    
    notify("Poisoned: " .. selectedFunctionName)
end)

restoreBtn.MouseButton1Click:Connect(function()
    if not selectedModule or not selectedFunctionName then return end
    local path = selectedModule:GetFullName()
    local original = originalFunctions[path] and originalFunctions[path][selectedFunctionName]
    if original then
        local funcs = {}
        deepSearchFunctions(selectedModuleTable, funcs, 1)
        local targetTbl = getTablePath(selectedModuleTable, funcs[selectedFunctionName])
        if targetTbl then
            targetTbl[selectedFunctionName] = original
            notify("Restored: " .. selectedFunctionName)
        end
    end
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchBox.Text:lower()
    for _, btn in ipairs(moduleList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Visible = btn.Text:lower():find(query) ~= nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == TOGGLE_KEY then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

scan()
