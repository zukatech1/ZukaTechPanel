local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ShotgunModule = require(ReplicatedStorage.Modules.Items.Shotgun)
local ToolsDetails = require(ReplicatedStorage.Modules.Gui.Tools_Details)
local GunRemotes = ReplicatedStorage.Remotes.Guns
ToolsDetails.ShowDurability = function() end
ToolsDetails.UpdateDurability = function() end
if ToolsDetails.HideDurability then
    ToolsDetails.HideDurability()
end
local prototype = nil
for _, v in pairs(debug.getupvalues(ShotgunModule.new)) do
    if type(v) == "table" and v.FireGun then
        prototype = v
        break
    end
end
if not prototype then return end
local oldFireGun = prototype.FireGun
prototype.FireGun = function(self, x, y)
    self.LastUsedTime = 0
    self.Loaded = true
    self.Reloading = false
    GunRemotes.Reload:FireServer()
    GunRemotes.ShotgunLoad:FireServer()
    self.Ammo = 6
    return oldFireGun(self, x, y)
end
local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
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
            task.wait(0.12)
        end
    end
end)
mouse.Button1Up:Connect(function()
    isFiring = false
end)
print("we lit")