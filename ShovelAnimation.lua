-- // Callum's Shovel Module Poisoning Protocol
-- // Target: game:GetService("ReplicatedStorage").Modules.Items.Shovel
-- // Features: Custom Idle, Custom Attack 1, Integrated Attack 2 Sequence

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- // Fetch original module and dependencies
local ShovelModule = require(ReplicatedStorage.Modules.Items.Shovel)
local Modules = ReplicatedStorage.Modules
local RaycastHitboxV4 = require(Modules.RaycastHitboxV4)
local MeleeFunctions = require(Modules.MeleeFunctions)
local Global_Items_Stats = require(ReplicatedStorage.Global_Items_Stats)

-- // Create custom animation objects
local CustomIdle = Instance.new("Animation")
CustomIdle.AnimationId = "rbxassetid://15646201947"

local CustomAttack1 = Instance.new("Animation")
CustomAttack1.AnimationId = "rbxassetid://15646194255"

local CustomAttack2 = Instance.new("Animation")
CustomAttack2.AnimationId = "rbxassetid://15646197427"

-- // Poisoning the .new constructor
ShovelModule.new = function(toolInstance)
    local self = setmetatable({}, ShovelModule)
    
    -- // State management
    self.LastUsedTime = time() + 0.2
    self.Events = {}
    self.AnimationTracks = {}
    self.Tasks = {}
    self.Tool = toolInstance
    self.Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    
    local humanoid = self.Character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    
    -- // Hitbox Initialization
    self.HitboxObject = RaycastHitboxV4.new(toolInstance.Model.Hitbox)
    MeleeFunctions.ConfigureRaycastHitbox(self.HitboxObject)
    MeleeFunctions.MeleeEquip(self)
    
    -- // Load Poisoned Animations
    self.AnimationTracks.Idle = animator:LoadAnimation(CustomIdle)
    self.AnimationTracks.Attack1 = animator:LoadAnimation(CustomAttack1)
    self.AnimationTracks.Attack2 = animator:LoadAnimation(CustomAttack2)
    
    -- // Persistence: Play Idle
    self.AnimationTracks.Idle:Play()
    
    -- // Setup Hitbox Event Interceptors for BOTH attacks
    local function setupHitboxSignals(track)
        self.Events[track.Animation.AnimationId .. "_Start"] = track:GetMarkerReachedSignal("HitStart"):Connect(function()
            self.HitboxObject:HitStart()
        end)
        self.Events[track.Animation.AnimationId .. "_End"] = track:GetMarkerReachedSignal("HitStop"):Connect(function()
            self.HitboxObject:HitStop()
        end)
    end
    
    setupHitboxSignals(self.AnimationTracks.Attack1)
    setupHitboxSignals(self.AnimationTracks.Attack2)
    
    -- // Attack Logic with Sequence Toggle
    local attackSequence = 1
    self.Events.OnActivated = toolInstance.Activated:Connect(function()
        if self.LastUsedTime < time() and not MeleeFunctions.CheckForCooldown() then
            -- // Apply cooldown from global stats
            local shovelStats = Global_Items_Stats["Shovel"] -- script.Name replacement
            MeleeFunctions.AddCooldown(shovelStats.Cooldown)
            MeleeFunctions.ResetTagged(self)
            
            -- // Alternate between Attack 1 and Attack 2
            if attackSequence == 1 then
                self.AnimationTracks.Attack1:Play()
                attackSequence = 2
            else
                self.AnimationTracks.Attack2:Play()
                attackSequence = 1
            end
            
            -- // Preserve original Grave digging logic
            local interaction = workspace:FindFirstChild("Interaction")
            if interaction and interaction:FindFirstChild("GraveHitbox") then
                local magnitude = (self.Character.PrimaryPart.Position - interaction.GraveHitbox.Position).Magnitude
                if magnitude < 8 and interaction:FindFirstChild("Grave") then
                    local grave = interaction.Grave
                    grave.Parent = ReplicatedStorage
                    
                    if interaction:FindFirstChild("GraveSmoke") then
                        interaction.GraveSmoke.Smoke:Emit(50)
                        interaction.GraveSmoke.Dig:Play()
                    end
                    
                    task.delay(30, function()
                        grave.Parent = interaction
                    end)
                end
            end
        end
    end)
    
    self.HitboxObject.OnHit:Connect(MeleeFunctions.OnHit)
    
    return self
end

print("Shovel Module successfully poisoned. Animations re-routed.")
