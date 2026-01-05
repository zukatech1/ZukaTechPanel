-- Source Engine Movement for Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local scriptEnabled = true
local spaceHeld = false

local velocity = Vector3.new()
local isGrounded = false
local wasGrounded = false
local moveDir = Vector3.new()

local footstepTimer = 0
local footstepInterval = 0.35
local lastFootstepIndex = 0

-- config
local cfg = {
    groundAccel = 50,
    airAccel = 3200,
    maxAirSpeed = 20,
    runSpeed = 23,
    jumpPower = 26,
    gravity = 80,
    friction = 6,
    stopSpeed = 5,
}

local rocketBlastRadius = 25

local footstepSounds = {
    "rbxassetid://81623756670923",
    "rbxassetid://78754179999047",
    "rbxassetid://79418255155423",
    "rbxassetid://112240321395589",
}

local jumpSound = Instance.new("Sound", root)
jumpSound.SoundId = "rbxassetid://78754179999047"
jumpSound.Volume = 0.5
jumpSound.PlaybackSpeed = 1

local landSound = Instance.new("Sound", root)
landSound.SoundId = "rbxassetid://78754179999047"
landSound.Volume = 0.6
landSound.PlaybackSpeed = 1

local function playFootstep()
    local sound = Instance.new("Sound", workspace)
    
    lastFootstepIndex = lastFootstepIndex + 1
    if lastFootstepIndex > #footstepSounds then
        lastFootstepIndex = 1
    end
    
    sound.SoundId = footstepSounds[lastFootstepIndex]
    sound.Volume = 0.6
    sound.PlaybackSpeed = 1.0 + math.random(-10, 10) / 100
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 2)
end

local function playJump()
    if jumpSound then
        jumpSound:Stop()
        jumpSound:Play()
    end
end

local function playLand()
    if landSound then
        landSound:Stop()
        landSound:Play()
    end
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local gameModes = {}

if isMobile then
    gameModes = {
        "default (mobile)",
        "no grenades (mobile)",
        "hard (mobile)"
    }
else
    gameModes = {
        "default (PC)",
        "no grenades (PC)",
        "hard (PC)"
    }
end

local currentModeIndex = 1

-- GUI
local function createGui()
    local g = Instance.new("ScreenGui", gui)
    g.ResetOnSpawn = false
    g.Name = "SourceDBG"

    local destroy = Instance.new("TextButton", g)
    destroy.Size = UDim2.new(0, 70, 0, 30)
    destroy.Position = UDim2.new(0, 10, 1, -130)
    destroy.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    destroy.Text = "DESTROY"

    destroy.MouseButton1Click:Connect(function()
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50

        for _, c in pairs(getconnections(RunService.Heartbeat)) do
            if c.Function then c:Disconnect() end
        end

        g:Destroy()
        scriptEnabled = false
        script:Destroy()
    end)

    local toggle = Instance.new("TextButton", g)
    toggle.Size = UDim2.new(0, 70, 0, 30)
    toggle.Position = UDim2.new(0, 10, 1, -90)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 255, 130)
    toggle.Text = "ON"

    toggle.MouseButton1Click:Connect(function()
        scriptEnabled = not scriptEnabled
        if scriptEnabled then
            toggle.BackgroundColor3 = Color3.fromRGB(80, 255, 130)
            toggle.Text = "ON"
            if isMobile then
                local jumpBtn = g:FindFirstChild("JumpButton")
                if jumpBtn then jumpBtn.Visible = true end
            end
        else
            toggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            toggle.Text = "OFF"
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            velocity = Vector3.new()
            
            if isMobile then
                local jumpBtn = g:FindFirstChild("JumpButton")
                if jumpBtn then jumpBtn.Visible = false end
            end
            
            for _, sound in pairs(root:GetChildren()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0.5
                end
            end
            for _, sound in pairs(humanoid:GetChildren()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0.5
                end
            end
        end
    end)

    local modeButton = Instance.new("TextButton", g)
    modeButton.Size = UDim2.new(0, 150, 0, 30)
    modeButton.Position = UDim2.new(0, 10, 1, -50)
    modeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    modeButton.Text = "Mode: " .. gameModes[currentModeIndex]
    modeButton.TextScaled = true

    modeButton.MouseButton1Click:Connect(function()
        currentModeIndex = currentModeIndex + 1
        if currentModeIndex > #gameModes then
            currentModeIndex = 1
        end
        modeButton.Text = "Mode: " .. gameModes[currentModeIndex]
    end)

    if isMobile then
        local grenadeButton = Instance.new("TextButton", g)
        grenadeButton.Size = UDim2.new(0, 80, 0, 80)
        grenadeButton.Position = UDim2.new(1, -90, 0.5, -40)
        grenadeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        grenadeButton.Text = "GRENADE"
        grenadeButton.TextScaled = true
        grenadeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        grenadeButton.Font = Enum.Font.SourceSansBold
        grenadeButton.Name = "GrenadeButton"
        
        local corner = Instance.new("UICorner", grenadeButton)
        corner.CornerRadius = UDim.new(0.5, 0)

        grenadeButton.MouseButton1Click:Connect(function()
            local currentMode = gameModes[currentModeIndex]
            if currentMode == "no grenades (mobile)" or currentMode == "hard (mobile)" then
                return
            end
            
            if not scriptEnabled then return end
            
            local cam = workspace.CurrentCamera
            local direction = cam.CFrame.LookVector
            local startPos = root.Position + direction * 3
            
            local rocket = Instance.new("Part")
            rocket.Name = "Rocket"
            rocket.Size = Vector3.new(0.5, 0.5, 2)
            rocket.BrickColor = BrickColor.new("Really red")
            rocket.Material = Enum.Material.Neon
            rocket.Anchored = false
            rocket.CanCollide = false
            rocket.CFrame = CFrame.lookAt(startPos, startPos + direction)
            rocket.Parent = workspace
            
            local attachment0 = Instance.new("Attachment", rocket)
            attachment0.Position = Vector3.new(0, 0, -1)
            local attachment1 = Instance.new("Attachment", rocket)
            local trail = Instance.new("Trail", rocket)
            trail.Attachment0 = attachment0
            trail.Attachment1 = attachment1
            trail.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
            trail.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            }
            trail.Lifetime = 0.3
            trail.MinLength = 0
            
            rocket.AssemblyLinearVelocity = direction * 150
            
            local explodeSound = Instance.new("Sound")
            explodeSound.SoundId = "rbxassetid://90586353104830"
            explodeSound.Volume = 1.0
            explodeSound.PlaybackSpeed = 1
            
            local shootSound = Instance.new("Sound", root)
            shootSound.SoundId = "rbxassetid://2156366946"
            shootSound.Volume = 1.0
            shootSound.PlaybackSpeed = 1.0
            shootSound:Play()
            game.Debris:AddItem(shootSound, 2)
            
            local connection
            connection = rocket.Touched:Connect(function(hit)
                if hit and not hit:IsDescendantOf(character) then
                    local explosionPos = rocket.Position
                    
                    local dist = (root.Position - explosionPos).Magnitude
                    local shouldPush = dist <= rocketBlastRadius
                    
                    explodeSound.Parent = workspace
                    explodeSound:Play()
                    game.Debris:AddItem(explodeSound, 2)
                    
                    local explosion = Instance.new("Explosion")
                    explosion.Position = explosionPos
                    explosion.BlastPressure = 0
                    explosion.BlastRadius = rocketBlastRadius
                    explosion.Parent = workspace
                    
                    if shouldPush then
                        local dir = (root.Position - explosionPos).Unit
                        local forceMagnitude = 80
                        velocity = velocity + dir * forceMagnitude
                    end
                    
                    rocket:Destroy()
                    connection:Disconnect()
                end
            end)
            
            game.Debris:AddItem(rocket, 5)
        end)
        
        local jumpButton = Instance.new("TextButton", g)
        jumpButton.Size = UDim2.new(0, 80, 0, 80)
        jumpButton.Position = UDim2.new(1, -90, 1, -90)
        jumpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        jumpButton.Text = "JUMP"
        jumpButton.TextScaled = true
        jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpButton.Font = Enum.Font.SourceSansBold
        jumpButton.Name = "JumpButton"
        
        local jumpCorner = Instance.new("UICorner", jumpButton)
        jumpCorner.CornerRadius = UDim.new(0.5, 0)
        
        jumpButton.MouseButton1Down:Connect(function()
            spaceHeld = true
        end)
        
        jumpButton.MouseButton1Up:Connect(function()
            spaceHeld = false
        end)
    end
end

createGui()

task.spawn(function()
    while true do
        task.wait()
        if scriptEnabled then
            for _, sound in pairs(root:GetChildren()) do
                if sound:IsA("Sound") and sound ~= jumpSound and sound ~= landSound then
                    sound.Volume = 0
                end
            end
            
            for _, sound in pairs(humanoid:GetChildren()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0
                end
            end
        end
    end
end)

if isMobile then
end

local function grounded()
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(root.Position, Vector3.new(0, -3.8, 0), rayParams)
    
    if result and result.Instance then
        return result.Instance.CanCollide
    end
    
    return false
end

local function applyFriction(dt)
    local speed = velocity.Magnitude
    if speed < 0.1 then
        velocity = Vector3.new()
        return
    end

    local drop = 0
    if isGrounded then
        local control = math.max(speed, cfg.stopSpeed)
        drop = control * cfg.friction * dt
    end

    local newSpeed = math.max(speed - drop, 0)
    if newSpeed ~= speed then
        velocity = velocity * (newSpeed / speed)
    end
end

local function accel(wishDir, wishSpeed, accel, dt)
    local cur = velocity:Dot(wishDir)
    local add = wishSpeed - cur
    if add <= 0 then return end

    local accelSpeed = math.min(accel * dt * wishSpeed, add)
    velocity = velocity + wishDir * accelSpeed
end

local function process(dt)
    if not scriptEnabled then return end

    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0

    wasGrounded = isGrounded
    isGrounded = grounded()

    if isGrounded and not wasGrounded and velocity.Y < -5 then
        playLand()
        footstepTimer = 0
    end

    local camLook = workspace.CurrentCamera.CFrame.LookVector
    local flat = Vector3.new(camLook.X, 0, camLook.Z)

    if flat.Magnitude > 0.01 then
        root.CFrame = CFrame.new(root.Position, root.Position + flat)
    end

    local cam = workspace.CurrentCamera
    local fwd = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector

    fwd = Vector3.new(fwd.X, 0, fwd.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit

    local input = Vector3.new()

    if isMobile then
        local moveVector = humanoid.MoveDirection
        if moveVector.Magnitude > 0 then
            input = moveVector
        end
    else
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then input += fwd end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then input -= fwd end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then input -= right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then input += right end
    end

    if input.Magnitude > 0 then
        input = input.Unit
    end

    moveDir = input

    local currentMaxAirSpeed = cfg.maxAirSpeed
    if gameModes[currentModeIndex] == "hard (PC)" or gameModes[currentModeIndex] == "hard (mobile)" then
        currentMaxAirSpeed = cfg.maxAirSpeed * 0.3
    end

    if isGrounded then
        applyFriction(dt)
        accel(moveDir, cfg.runSpeed, cfg.groundAccel, dt)

        if moveDir.Magnitude > 0.1 then
            footstepTimer = footstepTimer + dt
            if footstepTimer >= footstepInterval then
                playFootstep()
                footstepTimer = 0
            end
        else
            footstepTimer = 0
        end

        if spaceHeld then
            velocity = Vector3.new(velocity.X, cfg.jumpPower, velocity.Z)
            playJump()
        else
            velocity = Vector3.new(velocity.X, 0, velocity.Z)
        end
    else
        accel(moveDir, currentMaxAirSpeed, cfg.airAccel, dt)
        velocity += Vector3.new(0, -cfg.gravity * dt, 0)
    end

    root.AssemblyLinearVelocity = velocity
end

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space then
        spaceHeld = true
    elseif i.KeyCode == Enum.KeyCode.X and scriptEnabled and not isMobile then
        local currentMode = gameModes[currentModeIndex]
        if currentMode == "no grenades (PC)" or currentMode == "no grenades (mobile)" or 
           currentMode == "hard (PC)" or currentMode == "hard (mobile)" then
            return
        end
        
        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector
        local startPos = root.Position + direction * 3
        
        local rocket = Instance.new("Part")
        rocket.Name = "Rocket"
        rocket.Size = Vector3.new(0.5, 0.5, 2)
        rocket.BrickColor = BrickColor.new("Really red")
        rocket.Material = Enum.Material.Neon
        rocket.Anchored = false
        rocket.CanCollide = false
        rocket.CFrame = CFrame.lookAt(startPos, startPos + direction)
        rocket.Parent = workspace
        
        local attachment0 = Instance.new("Attachment", rocket)
        attachment0.Position = Vector3.new(0, 0, -1)
        local attachment1 = Instance.new("Attachment", rocket)
        local trail = Instance.new("Trail", rocket)
        trail.Attachment0 = attachment0
        trail.Attachment1 = attachment1
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
        trail.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }
        trail.Lifetime = 0.3
        trail.MinLength = 0
        
        rocket.AssemblyLinearVelocity = direction * 150
        
        local explodeSound = Instance.new("Sound")
        explodeSound.SoundId = "rbxassetid://90586353104830"
        explodeSound.Volume = 1.0
        explodeSound.PlaybackSpeed = 1
        
        local shootSound = Instance.new("Sound", root)
        shootSound.SoundId = "rbxassetid://2156366946"
        shootSound.Volume = 1.0
        shootSound.PlaybackSpeed = 1.0
        shootSound:Play()
        game.Debris:AddItem(shootSound, 2)
        
        local connection
        connection = rocket.Touched:Connect(function(hit)
            if hit and not hit:IsDescendantOf(character) then
                local explosionPos = rocket.Position
                
                local dist = (root.Position - explosionPos).Magnitude
                local shouldPush = dist <= rocketBlastRadius
                
                explodeSound.Parent = workspace
                explodeSound:Play()
                game.Debris:AddItem(explodeSound, 2)
                
                local explosion = Instance.new("Explosion")
                explosion.Position = explosionPos
                explosion.BlastPressure = 0
                explosion.BlastRadius = rocketBlastRadius
                explosion.Parent = workspace
                
                if shouldPush then
                    local dir = (root.Position - explosionPos).Unit
                    local forceMagnitude = 80
                    velocity = velocity + dir * forceMagnitude
                end
                
                rocket:Destroy()
                connection:Disconnect()
            end
        end)
        
        game.Debris:AddItem(rocket, 5)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space then
        spaceHeld = false
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if humanoid and humanoid.Health > 0 then
        process(dt)
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    velocity = Vector3.new()
    
    jumpSound = Instance.new("Sound", root)
    jumpSound.SoundId = "rbxassetid://78754179999047"
    jumpSound.Volume = 0.5
    jumpSound.PlaybackSpeed = 1.2
    
    landSound = Instance.new("Sound", root)
    landSound.SoundId = "rbxassetid://78754179999047"
    landSound.Volume = 0.6
    landSound.PlaybackSpeed = 0.8
end)

print("Source Movement successfully Loaded")
