local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage.Modules
local RaycastHitboxV4 = require(Modules.RaycastHitboxV4)
local MeleeFunctions = require(Modules.MeleeFunctions)
local Global_Items_Stats = require(ReplicatedStorage.Global_Items_Stats)

local IDS = {
    IDLE = "rbxassetid://15646201947",
    ATTACK_1 = "rbxassetid://15646194255",
    ATTACK_2 = "rbxassetid://15646197427"
}

local Anim_Idle = Instance.new("Animation")
Anim_Idle.AnimationId = IDS.IDLE

local Anim_Atk1 = Instance.new("Animation")
Anim_Atk1.AnimationId = IDS.ATTACK_1

local Anim_Atk2 = Instance.new("Animation")
Anim_Atk2.AnimationId = IDS.ATTACK_2

local TargetMelees = {
    "Frying Pan",
    "Wooden Bat",
    "Stun Baton",
    "Machete",
    "Katana",
    "Golf Club",
    "Frozen Katana",
    "Frozen Bat",
    "Flaming Bat",
    "Fire Axe",
    "Classic Sword",
    "Charged Bat",
    "Chainsaw",
    "Bone Sword",
    "Shovel"
}

local function PoisonModule(moduleName)
    local success, module = pcall(function()
        return require(ReplicatedStorage.Modules.Items:FindFirstChild(moduleName))
    end)

    if not success or type(module) ~= "table" then
        warn("Callum | Failed to intercept module: " .. moduleName)
        return
    end

    module.new = function(toolInstance)
        local self = setmetatable({}, module)

        self.LastUsedTime = time() + 0.2
        self.Events = {}
        self.AnimationTracks = {}
        self.Tasks = {}
        self.Tool = toolInstance
        self.Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        
        local humanoid = self.Character:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")

        local hitboxPart = toolInstance:WaitForChild("Model"):WaitForChild("Hitbox")
        self.HitboxObject = RaycastHitboxV4.new(hitboxPart)
        MeleeFunctions.ConfigureRaycastHitbox(self.HitboxObject)
        MeleeFunctions.MeleeEquip(self)

        self.AnimationTracks.Idle = animator:LoadAnimation(Anim_Idle)
        self.AnimationTracks.Attack1 = animator:LoadAnimation(Anim_Atk1)
        self.AnimationTracks.Attack2 = animator:LoadAnimation(Anim_Atk2)

        self.AnimationTracks.Idle:Play()

        local function bindMarkers(track)
            self.Events[track.Animation.AnimationId .. "_Start"] = track:GetMarkerReachedSignal("HitStart"):Connect(function()
                self.HitboxObject:HitStart()
            end)
            self.Events[track.Animation.AnimationId .. "_End"] = track:GetMarkerReachedSignal("HitStop"):Connect(function()
                self.HitboxObject:HitStop()
            end)
        end
        
        bindMarkers(self.AnimationTracks.Attack1)
        bindMarkers(self.AnimationTracks.Attack2)

        local sequence = 1
        self.Events.OnActivated = toolInstance.Activated:Connect(function()
            if self.LastUsedTime < time() and not MeleeFunctions.CheckForCooldown() then

                local stats = Global_Items_Stats[moduleName]
                if stats then
                    MeleeFunctions.AddCooldown(stats.Cooldown)
                end
                
                MeleeFunctions.ResetTagged(self)

                if sequence == 1 then
                    self.AnimationTracks.Attack1:Play()
                    sequence = 2
                else
                    self.AnimationTracks.Attack2:Play()
                    sequence = 1
                end

                if moduleName == "Shovel" then
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
                            task.delay(30, function() grave.Parent = interaction end)
                        end
                    end
                end
            end
        end)
        
        self.HitboxObject.OnHit:Connect(MeleeFunctions.OnHit)
        return self
    end
end

for _, meleeName in ipairs(TargetMelees) do
    task.spawn(PoisonModule, meleeName)
end

print("by zuka")
