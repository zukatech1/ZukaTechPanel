local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
if not player then
  error("[BuildTools] LocalPlayer not found!")
end
local THEME = {
  Background = Color3.fromRGB(34, 32, 38),
  Accent = Color3.fromRGB(255, 105, 180),
  Title = Color3.fromRGB(255, 182, 193),
  Text = Color3.fromRGB(240, 240, 240),
  Interactive = Color3.fromRGB(20, 20, 25),
  InteractiveHover = Color3.fromRGB(45, 42, 50),
  InteractiveActive = Color3.fromRGB(80, 120, 255),
  Destructive = Color3.fromRGB(200, 70, 90)
}
local builderState = {
  selectedParts = {},
  isDragging = false,
  dragStart = nil,
  dragParts = {},
  currentMode = "move",
  isActive = false,
  ui = nil,
  highlight = nil,
  connections = {},
  history = {},
  saveHistory = {},
  currentPart = nil
}
local function DoNotif(title, text, duration)
  pcall(function()
    StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 3 })
  end)
end
local modeHandlers = {
  move = function(part)
    if not part then return end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
      local found = false
      for i, p in pairs(builderState.selectedParts) do
        if p == part then
          table.remove(builderState.selectedParts, i)
          found = true
          break
        end
      end
      if not found then
        table.insert(builderState.selectedParts, part)
      end
    else
      if #builderState.selectedParts == 0 then
        table.insert(builderState.selectedParts, part)
      end
    end
  end,
  delete = function(part)
    if part:IsDescendantOf(Players.LocalPlayer.Character) then
      return DoNotif("BuildTools", "Cannot delete character parts.", 2)
    end
    table.insert(builderState.history, { part = part, parent = part.Parent, cframe = part.CFrame })
    table.insert(builderState.saveHistory, { name = part.Name, position = part.Position })
    part.Parent = nil
    builderState.selectedParts = {}
    DoNotif("BuildTools", "Deleted '" .. part.Name .. "'", 2)
  end,
  anchor = function(part)
    part.Anchored = not part.Anchored
    DoNotif("BuildTools", string.format("'%s' anchor set to %s", part.Name, tostring(part.Anchored)), 2)
  end,
  collide = function(part)
    part.CanCollide = not part.CanCollide
    DoNotif("BuildTools", string.format("'%s' CanCollide set to %s", part.Name, tostring(part.CanCollide)), 2)
  end,
  group_model = function(part)
    if #builderState.selectedParts > 0 then
      local model = Instance.new("Model")
      model.Name = "BuildGroup"
      model.Parent = workspace
      for _, p in pairs(builderState.selectedParts) do
        p.Parent = model
      end
      DoNotif("BuildTools", "Parts grouped as model", 2)
      builderState.selectedParts = {}
    end
  end,
  group_folder = function(part)
    if #builderState.selectedParts > 0 then
      local folder = Instance.new("Folder")
      folder.Name = "BuildGroup"
      folder.Parent = workspace
      for _, p in pairs(builderState.selectedParts) do
        p.Parent = folder
      end
      DoNotif("BuildTools", "Parts grouped as folder", 2)
      builderState.selectedParts = {}
    end
  end
}
local function updateStatus(part)
  if not builderState.ui then return end
  local statusLabel = builderState.ui.StatusLabel
  if not statusLabel then return end
  local targetText = "none"
  if part then
    targetText = part.Name
  end
  statusLabel.Text = string.format("Mode: %s | Target: %s | Selected: %d",
    builderState.currentMode:upper(), targetText, #builderState.selectedParts)
end
local function setTarget(part)
  if part and not part:IsA("BasePart") then
    part = nil
  end
  builderState.currentPart = part
  if builderState.highlight then
    builderState.highlight.Adornee = part
  end
  updateStatus(part)
end
local function createMainPanel()
  local ui = {}
  builderState.ui = ui
  ui.ScreenGui = Instance.new("ScreenGui")
  ui.ScreenGui.Name = "BuildToolsUI"
  ui.ScreenGui.ResetOnSpawn = false
  ui.ScreenGui.Parent = CoreGui
  local panel = Instance.new("Frame", ui.ScreenGui)
  panel.Name = "Panel"
  panel.Size = UDim2.fromOffset(280, 380)
  panel.Position = UDim2.new(0.05, 0, 0.4, 0)
  panel.BackgroundColor3 = THEME.Background
  panel.BackgroundTransparency = 0.1
  Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
  local uiStroke = Instance.new("UIStroke", panel)
  uiStroke.Color = THEME.Accent
  uiStroke.Thickness = 2
  table.insert(builderState.connections, RunService.RenderStepped:Connect(function()
    if not uiStroke.Parent then return end
    uiStroke.Thickness = 2 + (math.sin(os.clock() * 4) * 0.5)
    uiStroke.Transparency = 0.3 + (math.sin(os.clock() * 4) * 0.2)
  end))
  local header = Instance.new("Frame", panel)
  header.Name = "Header"
  header.Size = UDim2.new(1, 0, 0, 40)
  header.BackgroundTransparency = 1
  header.Active = true
  local title = Instance.new("TextLabel", header)
  title.BackgroundTransparency = 1
  title.Font = Enum.Font.GothamSemibold
  title.Text = "BuildTools"
  title.Size = UDim2.new(1, 0, 1, 0)
  title.TextColor3 = THEME.Title
  title.TextSize = 20
  ui.StatusLabel = Instance.new("TextLabel", panel)
  ui.StatusLabel.Name = "Status"
  ui.StatusLabel.BackgroundTransparency = 1
  ui.StatusLabel.Size = UDim2.new(1, -24, 0, 30)
  ui.StatusLabel.Position = UDim2.new(0, 12, 0, 45)
  ui.StatusLabel.Font = Enum.Font.Gotham
  ui.StatusLabel.TextColor3 = THEME.Text
  ui.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
  ui.StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
  ui.StatusLabel.TextWrapped = true
  ui.StatusLabel.TextSize = 10
  ui.StatusLabel.Text = "Mode: MOVE | Target: none | Selected: 0"
  local buttonHolder = Instance.new("Frame", panel)
  buttonHolder.BackgroundTransparency = 1
  buttonHolder.Size = UDim2.new(1, -24, 1, -90)
  buttonHolder.Position = UDim2.new(0, 12, 0, 80)
  local layout = Instance.new("UIListLayout", buttonHolder)
  layout.Padding = UDim.new(0, 6)
  local modeButtons = {}
  local function createButton(text, mode)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Parent = buttonHolder
    button.Size = UDim2.new(1, 0, 0, 32)
    button.Font = Enum.Font.GothamSemibold
    button.Text = text
    button.TextColor3 = THEME.Text
    button.TextSize = 13
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    return button
  end
  local function refreshModeButtons()
    for mode, button in pairs(modeButtons) do
      local isActive = builderState.currentMode == mode
      button.BackgroundColor3 = isActive and THEME.Accent or THEME.Interactive
      button.TextColor3 = isActive and THEME.Background or THEME.Text
    end
  end
  local modes = {
    move = "Move",
    delete = "Delete",
    anchor = "Toggle Anchor",
    collide = "Toggle CanCollide",
    group_model = "Group as Model",
    group_folder = "Group as Folder"
  }
  for mode, label in pairs(modes) do
    local button = createButton(label, mode)
    modeButtons[mode] = button
    button.MouseButton1Click:Connect(function()
      builderState.currentMode = mode
      refreshModeButtons()
      DoNotif("BuildTools", "Mode: " .. label, 1)
    end)
  end
  local undoButton = createButton("Undo Last Action")
  undoButton.BackgroundColor3 = THEME.Interactive
  undoButton.MouseButton1Click:Connect(function()
    local lastAction = table.remove(builderState.history)
    if lastAction then
      lastAction.part.Parent = lastAction.parent
      pcall(function() lastAction.part.CFrame = lastAction.cframe end)
      setTarget(lastAction.part)
      DoNotif("BuildTools", "Restored '" .. lastAction.part.Name .. "'", 2)
    else
      DoNotif("BuildTools", "Nothing to undo.", 2)
    end
  end)
  local copyButton = createButton("Copy Delete Script")
  copyButton.BackgroundColor3 = THEME.Interactive
  copyButton.MouseButton1Click:Connect(function()
    if #builderState.saveHistory == 0 then
      return DoNotif("BuildTools", "No deleted parts to export.", 3)
    end
    local lines = {}
    for _, data in ipairs(builderState.saveHistory) do
      local line = string.format(
        "for _,v in ipairs(workspace:FindPartsInRegion3(Region3.new(%s, %s), nil, math.huge)) do if v.Name == %q then v:Destroy() end end",
        string.format("Vector3.new(%.3f, %.3f, %.3f)", data.position.X - 0.1, data.position.Y - 0.1, data.position.Z - 0.1),
        string.format("Vector3.new(%.3f, %.3f, %.3f)", data.position.X + 0.1, data.position.Y + 0.1, data.position.Z + 0.1),
        data.name
      )
      table.insert(lines, line)
    end
    if setclipboard then
      setclipboard(table.concat(lines, "\n"))
      DoNotif("BuildTools", "Copied delete script to clipboard.", 3)
    else
      DoNotif("BuildTools", "setclipboard not available.", 3)
    end
  end)
  local function makeDraggable(frame, dragPart)
    local dragging, dragStart, frameStart
    dragPart.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, frameStart = true, input.Position, frame.Position
      end
    end)
    table.insert(builderState.connections, UserInputService.InputEnded:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
      end
    end))
    table.insert(builderState.connections, UserInputService.InputChanged:Connect(function(input)
      if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
      end
    end))
  end
  makeDraggable(panel, header)
  refreshModeButtons()
  return ui
end
local function disable()
  if not builderState.isActive then return end
  if builderState.ui and builderState.ui.ScreenGui then
    builderState.ui.ScreenGui:Destroy()
  end
  if builderState.highlight then
    builderState.highlight:Destroy()
  end
  for _, conn in ipairs(builderState.connections) do
    conn:Disconnect()
  end
  builderState.isActive = false
  builderState.ui = nil
  builderState.highlight = nil
  builderState.selectedParts = {}
  table.clear(builderState.connections)
  DoNotif("BuildTools", "Deactivated.", 3)
end
local function enable()
  if builderState.isActive then return end
  builderState.isActive = true
  createMainPanel()
  builderState.highlight = Instance.new("SelectionBox")
  builderState.highlight.Name = "BuildToolsSelection"
  builderState.highlight.LineThickness = 0.04
  builderState.highlight.Color3 = THEME.Accent
  builderState.highlight.Parent = CoreGui
  table.insert(builderState.connections, RunService.RenderStepped:Connect(function()
    setTarget(player:GetMouse().Target)
  end))
  table.insert(builderState.connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      if builderState.currentPart then
        local handler = modeHandlers[builderState.currentMode]
        if handler then handler(builderState.currentPart) end
      end
    elseif input.KeyCode == Enum.KeyCode.Delete then
      for _, part in pairs(builderState.selectedParts) do
        part:Destroy()
      end
      builderState.selectedParts = {}
      DoNotif("BuildTools", "Deleted selected parts", 2)
    end
  end))
  table.insert(builderState.connections, RunService.RenderStepped:Connect(function()
    if builderState.currentMode == "move" and player:GetMouse().Button1Down and #builderState.selectedParts > 0 then
      if not builderState.isDragging then
        builderState.isDragging = true
        builderState.dragStart = player:GetMouse().Hit.Position
        builderState.dragParts = {}
        for _, part in pairs(builderState.selectedParts) do
          if part then
            table.insert(builderState.dragParts, {part = part, offset = part.Position - player:GetMouse().Hit.Position})
          end
        end
      else
        local delta = player:GetMouse().Hit.Position - builderState.dragStart
        for _, data in pairs(builderState.dragParts) do
          data.part.Position = data.part.Position + delta
        end
        builderState.dragStart = player:GetMouse().Hit.Position
      end
    else
      builderState.isDragging = false
    end
  end))
  DoNotif("BuildTools", "Activated.", 3)
end
local function toggle()
  if builderState.isActive then
    disable()
  else
    enable()
  end
end
local function initializeToggleButton()
  local toggleGui = CoreGui:FindFirstChild("BuildToolsToggle")
  if toggleGui then toggleGui:Destroy() end
  local toggleButtonGui = Instance.new("ScreenGui")
  toggleButtonGui.Name = "BuildToolsToggle"
  toggleButtonGui.ResetOnSpawn = false
  toggleButtonGui.Parent = CoreGui
  local textButton = Instance.new("TextButton", toggleButtonGui)
  textButton.Size = UDim2.fromOffset(60, 60)
  textButton.Position = UDim2.new(0, 20, 0.5, -30)
  textButton.Text = "B"
  textButton.Font = Enum.Font.GothamBold
  textButton.TextSize = 28
  textButton.TextColor3 = THEME.Title
  textButton.BackgroundColor3 = THEME.Background
  Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
  local stroke = Instance.new("UIStroke", textButton)
  stroke.Thickness = 2
  stroke.Color = THEME.Accent
  stroke.Transparency = 0.3
  local isDragging = false
  local dragStart, startPosition
  local DRAG_THRESHOLD = 10
  textButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragStart, startPosition, isDragging = input.Position, textButton.Position, false
    end
  end)
  textButton.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
      local delta = input.Position - dragStart
      if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
        isDragging = true
      end
      if isDragging then
        textButton.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
      end
    end
  end)
  textButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragStart, startPosition = nil, nil
    end
  end)
  textButton.Activated:Connect(function()
    if not isDragging then toggle() end
    isDragging = false
  end)
end
local function main()
  print("[BuildTools] Initializing revamped building tools...")
  initializeToggleButton()
  enable()
  print("[BuildTools] Loaded successfully!")
  print("[BuildTools] Click the 'B' button to toggle, or press Shift+B")
  table.insert(builderState.connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
      toggle()
    end
  end))
  while true do
    task.wait(10)
  end
end
pcall(main)
