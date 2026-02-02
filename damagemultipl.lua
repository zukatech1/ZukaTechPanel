local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Config = {
    Weapon = {
        SpoofName = "DoomsBanHammer",
        AmplifyFactor = 250,
        SpamDelay = 0
    },
    Movement = {
        LeapKey = Enum.KeyCode.Q,
        LeapPower = 150
    },
    AOE = {
        Range = 100,
        HitsPerCycle = 15,
        TargetName = "Hitbox",
        UpdateRate = 0.03
    }
}
local FireWeapon = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("FireWeapon")
if not FireWeapon then
    warn("[ERROR] FireWeapon remote not found!")
    return
end
local function initializeTool()
    if not LocalPlayer.Character then
        warn("[!] No character found. Equip a weapon first.")
        return false
    end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        print("[RESEARCH] Current Tool: " .. tool.Name)
        tool.Name = Config.Weapon.SpoofName
        print("[SUCCESS] Tool identity masked as " .. Config.Weapon.SpoofName)
        return true
    else
        print("[!] Equip a weapon first.")
        return false
    end
end
local function setupMetahook()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == FireWeapon and method == "FireServer" and not checkcaller() then
            local weapon = args[1]
            if weapon and weapon:IsA("Instance") then
                weapon.Name = Config.Weapon.SpoofName
            end
            oldNamecall(self, unpack(args))
            for i = 1, Config.Weapon.AmplifyFactor - 1 do
                task.spawn(function()
                    task.wait(Config.Weapon.SpamDelay)
                    oldNamecall(self, unpack(args))
                end)
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    print("[SUCCESS] FireWeapon amplification active (" .. Config.Weapon.AmplifyFactor .. "x damage).")
end
UserInputService.InputBegan:Connect(function(input, proc)
    if proc then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if input.KeyCode == Config.Movement.LeapKey then
        print("[RESEARCH] Executing Grand Leap")
        hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.Movement.LeapPower, hrp.Velocity.Z)
        local damageIndicator = ReplicatedStorage:FindFirstChild("Remotes") and
                                 ReplicatedStorage.Remotes:FindFirstChild("Unreliables") and
                                 ReplicatedStorage.Remotes.Unreliables:FindFirstChild("DamageIndicator")
        if damageIndicator then
            firesignal(damageIndicator.OnClientEvent, {Position = hrp.Position, Damage = "GRAND LEAP"})
        end
    end
end)
task.spawn(function()
    print("[SUCCESS] AOE Instakill Always Active - Targeting all enemies in range.")
    while task.wait(Config.AOE.UpdateRate) do
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local weapon = char and char:FindFirstChildOfClass("Tool")
        if not (root and weapon) then continue end
        local enemies = workspace:FindFirstChild("Enemies") or workspace
        for _, enemy in pairs(enemies:GetChildren()) do
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local targetPart = enemy:FindFirstChild(Config.AOE.TargetName) or enemy:FindFirstChild("HumanoidRootPart")
            if targetPart and humanoid and humanoid.Health > 0 then
                local dist = (targetPart.Position - root.Position).Magnitude
                if dist <= Config.AOE.Range then
                    for i = 1, Config.AOE.HitsPerCycle do
                        FireWeapon:FireServer(weapon, {
                            Target = targetPart,
                            Position = targetPart.Position,
                            Damage = math.huge
                        })
                    end
                end
            end
        end
    end
end)
setupMetahook()
initializeTool()