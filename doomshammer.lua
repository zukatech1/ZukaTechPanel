local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local FireWeapon = ReplicatedStorage.Remotes.FireWeapon
local PhantomConfig = {
    AmplifyFactor = 150,
    SpoofIdentity = true,
    Active = true
}
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if self == FireWeapon and method == "FireServer" and not checkcaller() then
        local weapon = args[1]
        if PhantomConfig.SpoofIdentity and weapon:IsA("Instance") then
            weapon.Name = "DoomsBanHammer"
        end
        for i = 1, PhantomConfig.AmplifyFactor - 1 do
            task.spawn(function()
                task.wait(i * 0.03)
                oldNamecall(self, unpack(args))
            end)
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
game:GetService("UserInputService").InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.Q then
        print("[get fucked] Executing Grand Leap (Simulated)")
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 150, hrp.Velocity.Z)
        local DamageIndicator = ReplicatedStorage.Remotes.Unreliables.DamageIndicator
        firesignal(DamageIndicator.OnClientEvent, {Position = hrp.Position, Damage = "GRAND LEAP"})
    end
    if input.KeyCode == Enum.KeyCode.E then
        print("[get fucked] Executing Spontaneous Combustion (AOE Spam)")
        local weapon = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not weapon then return end
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            local enemyPart = enemy:FindFirstChild("Hitbox") or enemy:FindFirstChild("HumanoidRootPart")
            if enemyPart and (enemyPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 50 then
                for i = 1, 5 do
                    FireWeapon:FireServer(weapon, {Target = enemyPart, Position = enemyPart.Position})
                end
            end
        end
    end
end)
print("[get fucked] spam e for x10 damage near an enemy.")