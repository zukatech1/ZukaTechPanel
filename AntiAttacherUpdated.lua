local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")

local LocalPlayer: Player = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart: BasePart = Character:WaitForChild("HumanoidRootPart")

local SETTINGS = {
    ENABLED = true,
    VELOCITY_MODIFIER = Vector3.new(0, 9e9, 0),
    ANGULAR_MODIFIER = Vector3.new(0, 9e9, 0),
    JITTER_STRENGTH = 20,
    NETWORK_TICK_RATE = 0.03
}

local function GetRawMeta(): any
    local Success, Meta = pcall(getrawmetatable, game)
    return Success and Meta or nil
end

local function ProtectEnvironment(): ()
    local Meta = GetRawMeta()
    if not Meta then return end

    local OldIndex = Meta.__index
    local OldNewIndex = Meta.__newindex

    sethook(Meta.__index, function(Self, Key)
        if not checkcaller() and Self == RootPart then
            if Key == "Velocity" or Key == "AssemblyLinearVelocity" or Key == "AssemblyAngularVelocity" then
                return Vector3.new(0, 0, 0)
            end
        end
        return OldIndex(Self, Key)
    end)
end

local function ConstructAntiAttach(): ()
    local LastUpdate: number = 0
    
    local function OnHeartbeat(): ()
        if not SETTINGS.ENABLED or not RootPart then return end
        
        pcall(function()
            local CurrentTime: number = tick()
            local StoredCFrame: CFrame = RootPart.CFrame
            local StoredVelocity: Vector3 = RootPart.AssemblyLinearVelocity
            
            if CurrentTime - LastUpdate > SETTINGS.NETWORK_TICK_RATE then
                RootPart.AssemblyLinearVelocity = SETTINGS.VELOCITY_MODIFIER
                RootPart.AssemblyAngularVelocity = SETTINGS.ANGULAR_MODIFIER
                
                RootPart.CFrame = StoredCFrame * CFrame.Angles(
                    math.rad(math.random(-SETTINGS.JITTER_STRENGTH, SETTINGS.JITTER_STRENGTH)),
                    math.rad(math.random(-SETTINGS.JITTER_STRENGTH, SETTINGS.JITTER_STRENGTH)),
                    math.rad(math.random(-SETTINGS.JITTER_STRENGTH, SETTINGS.JITTER_STRENGTH))
                )
                
                RunService.PostSimulation:Wait()
                
                RootPart.AssemblyLinearVelocity = StoredVelocity
                RootPart.CFrame = StoredCFrame
                LastUpdate = CurrentTime
            end
        end)
    end

    RunService.Heartbeat:Connect(OnHeartbeat)
end

local function HandleCharacter(NewCharacter: Model): ()
    Character = NewCharacter
    RootPart = NewCharacter:WaitForChild("HumanoidRootPart")
    
    local Humanoid = NewCharacter:WaitForChild("Humanoid")
    Humanoid.StateChanged:Connect(function(_, NewState)
        if NewState == Enum.HumanoidStateType.FallingDown or NewState == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

pcall(function()
    LocalPlayer.CharacterAdded:Connect(HandleCharacter)
    ProtectEnvironment()
    ConstructAntiAttach()
end)