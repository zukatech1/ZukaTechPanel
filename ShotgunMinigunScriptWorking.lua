local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
local ShotgunModule = require(ReplicatedStorage.Modules.Items.Shotgun)
local ToolsDetails = require(ReplicatedStorage.Modules.Gui.Tools_Details)
local GunRemotes = ReplicatedStorage.Remotes.Guns
ShotgunModule.MaxAmmo = 999
ShotgunModule.ShotCooldown = 0
ShotgunModule.Range = 1000
ToolsDetails.ShowDurability = function() end
ToolsDetails.UpdateDurability = function() end
if ToolsDetails.HideDurability then ToolsDetails.HideDurability() end
local prototype = nil
for _, v in pairs(debug.getupvalues(ShotgunModule.new)) do
    if type(v) == "table" and v.FireGun then
        prototype = v
        break
    end
end
if not prototype then return end
prototype.Reload = function(self)
    if self.Reloading then return end
    self.Reloading = true
    task.spawn(function()
        for i = 1, 50 do
            GunRemotes.Reload:FireServer()
            self.Ammo = math.min(self.Ammo + 1, ShotgunModule.MaxAmmo)
            local GunUi = debug.getupvalues(ShotgunModule.new)[4]
            if GunUi and GunUi.SetAmmoLabel then
                GunUi:SetAmmoLabel(self.Ammo .. "/" .. ShotgunModule.MaxAmmo)
            end
        end
        self.Reloading = false
    end)
end
local oldFire = prototype.FireGun
prototype.FireGun = function(self, x, y)
    self.LastUsedTime = 0
    self.Loaded = true
    self.Reloading = false
    GunRemotes.Reload:FireServer()
    GunRemotes.ShotgunLoad:FireServer()
    self.Ammo = 999
    return oldFire(self, x, y)
end
local isFiring = false
mouse.Button1Down:Connect(function()
    local char = lplr.Character
    if not char or not char:FindFirstChild("Shotgun") then return end
    isFiring = true
    local activeShotgun = nil
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" and obj.Tool and obj.Tool.Name == "Shotgun" and obj.Tool.Parent == char then
            activeShotgun = obj
            break
        end
    end
    if activeShotgun then
        while isFiring and activeShotgun.Tool.Parent == char do
            activeShotgun:FireGun(mouse.X, mouse.Y)
            task.wait(0.08)
        end
    end
end)
mouse.Button1Up:Connect(function()
    isFiring = false
end)
print("Nice")
