local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local function DoNotif(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Melee On Crack",
            Text = msg,
            Duration = 2
        })
    end)
end

local function PatchCooldowns()
    local count = 0
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then

            if rawget(v, "IsOnCooldown") and rawget(v, "SetCooldown") then
                v.IsOnCooldown = function() return false end
                v.SetCooldown = function() return end
                v.RemoveCooldown = function() return end
                count = count + 1
            end

            if rawget(v, "Cooldown") or rawget(v, "AttackDelay") then
                pcall(function()
                    v.Cooldown = 0
                    v.AttackDelay = 0
                    if rawget(v, "AttackSpeed") then v.AttackSpeed = 0 end
                end)
                count = count + 1
            end
        end
    end
    return count > 0
end

local function BypassTeams()

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:lower():find("team") or v.Name:lower():find("check")) then
            local success, t_mod = pcall(require, v)
            if success and type(t_mod) == "table" and rawget(t_mod, "CanAttack") then
                t_mod.CanAttack = function() return true end
                return true
            end
        end
    end
    return false
end

local function SetupStableBlender()
    local remote = ReplicatedStorage:FindFirstChild("MeleeDamage", true)
    if not remote or not remote:IsA("RemoteEvent") then
        warn("--> [Crack]: Melee Remote not found.")
        return
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if self == remote and (method == "FireServer" or method == "fireServer") and not checkcaller() then

            oldNamecall(self, unpack(args))
            oldNamecall(self, unpack(args))
            oldNamecall(self, unpack(args))

        end
        
        return oldNamecall(self, ...)
    end))
    DoNotif("Success")
end

local function StartDebounceFlush()
    local cachedHitTable = nil

    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "ClearTagged") then
            cachedHitTable = v
            break
        end
    end

    if cachedHitTable then
        RunService.Heartbeat:Connect(function()

            pcall(cachedHitTable.ClearTagged)
        end)
        DoNotif("Crack Smoked, x2 Success")
    else
        warn("--> [OVERDRIVE]: Hit-table not found. Multi-hit limited.")
    end
end

task.spawn(function()
    DoNotif("Injecting fent v2...")
    
    local cooldownPatched = PatchCooldowns()
    local teamPatched = BypassTeams()
    
    SetupStableBlender()
    StartDebounceFlush()

    if cooldownPatched or teamPatched then
        DoNotif("✓ Melee on Crack: FULLY OPERATIONAL")
    else
        DoNotif("check f9 for debug")
    end
end)
