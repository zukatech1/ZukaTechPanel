local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
local firing = false
local function initializeRapidFire()
    local char = lplr.Character
    if not char then return end
    local sniper = char:FindFirstChild("Sniper") or lplr.Backpack:FindFirstChild("Sniper")
    if not sniper or not sniper:FindFirstChild("LocalScript") then
        warn("Sniper tool or LocalScript not found.")
        return
    end
    local success, scr = pcall(function() return getsenv(sniper.LocalScript) end)
    if not success or not scr then
        warn("Failed to access script environment.")
        return
    end
    local shoot = debug.getupvalue(scr.FireGun, 5)
    local calc = debug.getupvalue(scr.FireGun, 6)
    local handle = sniper:FindFirstChild("Handle")
    local flash = sniper:FindFirstChild("Flash2", true)
    if not shoot or not calc then
        warn("Failed to hook upvalues. The game may have updated.")
        return
    end
    scr.FireGun = function(...)
        if handle and handle:FindFirstChild("Sniper fire sound") then
            local sound = handle["Sniper fire sound"]:Clone()
            sound.Parent = handle
            sound:Play()
            task.delay(sound.TimeLength, function() sound:Destroy() end)
        end
        shoot(flash and flash.Position or Vector3.new(), calc(...))
    end
    local connectionDown
    local connectionUp
    connectionDown = mouse.Button1Down:Connect(function()
        if sniper.Parent == char then
            firing = true
            while firing and sniper.Parent == char do
                task.spawn(function()
                    scr.FireGun(mouse.X, mouse.Y)
                end)
                task.wait(0.05)
            end
        end
    end)
    connectionUp = mouse.Button1Up:Connect(function()
        firing = false
    end)
    sniper.AncestryChanged:Connect(function()
        if not sniper:IsDescendantOf(game) then
            firing = false
            connectionDown:Disconnect()
            connectionUp:Disconnect()
        end
    end)
end
initializeRapidFire()
