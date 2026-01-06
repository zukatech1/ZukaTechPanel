local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local VELOCITY_POISON: Vector3 = Vector3.new(0, 50, 0)  -- Controlled random velocity
local TARGET_RADIUS: number = 1000  -- More reasonable simulation radius
local localPlayer: Player = Players.LocalPlayer

local Attacher = {
    State = {
        chaosIntensity = 1.2,
        selectedPlayerName = "Nearest Player",
        isAttaching = false,
        originalDestroyHeight = Workspace.FallenPartsDestroyHeight,
        connections = {}
    }
}

local function setSimulationRadius(): nil
    xpcall(function()
        if localPlayer then
            localPlayer.MaximumSimulationRadius = TARGET_RADIUS
            sethiddenproperty(localPlayer, "SimulationRadius", TARGET_RADIUS)
        end
    end, function() end)
    return nil
end

local function toggleNoClip(character: Model, state: boolean): nil
    if not character then return nil end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
    return nil
end

local function getRandomTarget(): Player?
    local availableTargets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(availableTargets, player)
        end
    end
    if #availableTargets > 0 then
        return availableTargets[math.random(1, #availableTargets)]
    end
    return nil
end

function Attacher:Deactivate(): nil
    self.State.isAttaching = false
    
    if self.State.connections.PhysicsLoop then
        self.State.connections.PhysicsLoop:Disconnect()
        self.State.connections.PhysicsLoop = nil
    end

    xpcall(function()
        local character: Model? = localPlayer.Character
        if character then
            toggleNoClip(character, false)
            local humanoid: Humanoid? = character:FindFirstChildOfClass("Humanoid")
            local root: BasePart? = character:FindFirstChild("HumanoidRootPart") :: BasePart
            
            if humanoid then
                humanoid.AutoRotate = true
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            if root then
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
            end
        end
        Workspace.FallenPartsDestroyHeight = self.State.originalDestroyHeight
    end, function() end)
    return nil
end

function Attacher:Activate(): nil
    if self.State.connections.PhysicsLoop then return nil end

    self.State.originalDestroyHeight = Workspace.FallenPartsDestroyHeight
    Workspace.FallenPartsDestroyHeight = 0/0

    local oscillationStep: number = 0

    self.State.connections.PhysicsLoop = RunService.Stepped:Connect(function()
        if not self.State.isAttaching then 
            local character: Model? = localPlayer.Character
            local root: BasePart? = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
            if root then
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
            end
            return 
        end

        local character: Model? = localPlayer.Character
        local root: BasePart? = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
        local humanoid: Humanoid? = character and character:FindFirstChildOfClass("Humanoid")

        local target: Player? = (self.State.selectedPlayerName == "Nearest Player" and getRandomTarget()) or Players:FindFirstChild(self.State.selectedPlayerName)
        local targetCharacter: Model? = target and target.Character
        local targetRoot: BasePart? = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") :: BasePart

        if character and root and humanoid and targetRoot then
            setSimulationRadius()
            toggleNoClip(character, true)
            humanoid.AutoRotate = false
            
            oscillationStep += 1
            local intensity: number = self.State.chaosIntensity

            -- Offset to position the player near the target's right shoulder, making the aimbot aim upwards
            local hoverOffset = Vector3.new(math.random(0, 2), math.random(5, 8), math.random(-3, 3))  -- Right shoulder area

            -- We apply a CFrame offset to keep the player slightly behind and above the target's shoulder
            local currentOffset: CFrame = CFrame.new(hoverOffset)
            local angles: CFrame = CFrame.Angles(
                math.rad(math.random(0, 360)),
                math.rad(math.random(0, 360)),
                math.rad(math.random(0, 360))
            )

            -- Apply random, controlled velocity (not too extreme)
            root.Velocity = Vector3.new(math.random(-50, 50), math.random(-25, 25), math.random(-50, 50))

            -- Position the player close enough to the target's right shoulder, avoiding direct aim
            root.CFrame = targetRoot.CFrame * currentOffset * angles
        else
            if root then
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
            end
        end
    end)

    return nil
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local window = library:CreateWindow("Hellspawn Core")
local folder = window:CreateFolder("Attachment")

folder:Toggle("Attach to Target", function(state: boolean)
    Attacher.State.isAttaching = state
    if state then
        Attacher:Activate()
    else
        Attacher:Deactivate()
    end
end)

folder:Slider("Intensity", {min = 0.5, max = 5, precise = true}, function(v: number)
    Attacher.State.chaosIntensity = v
end)

folder:Box("Target Name", "string", function(v: string)
    local found: Player? = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then
            found = p
            break
        end
    end
    Attacher.State.selectedPlayerName = found and found.Name or "Nearest Player"
end)

folder:Button("Force Reset Physics", function()
    Attacher:Deactivate()
end)
