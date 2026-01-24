local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")

local LocalPlayer: Player = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart: BasePart = Character:WaitForChild("HumanoidRootPart")

local DesyncSettings = {
    Enabled = true,
    Velocity = Vector3.new(0, -9e9, 0),
    Jitter = 15,
    NetworkRate = 0.01
}

local function GetMetatable(): any
    local Success, Meta = pcall(getrawmetatable, game)
    return Success and Meta or nil
end

local function ApplyVisualFix(): ()
    local LastRealCFrame: CFrame = RootPart.CFrame
    
    RunService.PreSimulation:Connect(function()
        if not DesyncSettings.Enabled or not RootPart then return end
        LastRealCFrame = RootPart.CFrame
    end)

    RunService.PostSimulation:Connect(function()
        if not DesyncSettings.Enabled or not RootPart then return end
        
        local DesyncCFrame: CFrame = LastRealCFrame * CFrame.new(
            math.random(-DesyncSettings.Jitter, DesyncSettings.Jitter),
            0,
            math.random(-DesyncSettings.Jitter, DesyncSettings.Jitter)
        )
        
        RootPart.AssemblyLinearVelocity = DesyncSettings.Velocity
        RootPart.CFrame = DesyncCFrame
    end)

    RunService.PreRender:Connect(function()
        if not RootPart then return end
        RootPart.CFrame = LastRealCFrame
    end)
end

local function InternalProtection(): ()
    local Meta = GetMetatable()
    if not Meta then return end

    local OldIndex = Meta.__index
    sethook(Meta.__index, function(Self, Key)
        if not checkcaller() and Self == RootPart then
            if Key == "Velocity" or Key == "AssemblyLinearVelocity" then
                return Vector3.new(0, 0, 0)
            end
        end
        return OldIndex(Self, Key)
    end)
end

local function MonitorCharacter(NewCharacter: Model): ()
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
    LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
    InternalProtection()
    ApplyVisualFix()
end)