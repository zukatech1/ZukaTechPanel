local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace: Workspace = game:GetService("Workspace")

local c_check = clonefunction(checkcaller)
local c_namecall = clonefunction(getnamecallmethod)

--// Configuration
local TARGET_NAME: string = "AcidSpit"
local PART_KEYWORDS: {string} = {"Acid", "Spit", "Pool"}

--// 1. Inbound & Outbound Remote Suppression
local acidRemote: RemoteEvent? = nil
local function hookRemote()
    pcall(function()
        acidRemote = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("ZombieRelated", 5):WaitForChild("AcidSpit", 5)
        
        if acidRemote and hookfunction then
            -- Disable the client's ability to even process the spit signal
            local old; old = hookfunction(acidRemote.FireServer, newcclosure(function(...)
                if not c_check() then return nil end
                return old(...)
            end))
        end
    end)
end
hookRemote()

--// 2. Global Metamethod Protection (High-Performance)
local success, mt = pcall(getrawmetatable, game)
if success and mt then
    local originalNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(selfArg, ...)
        if not c_check() and selfArg == acidRemote then
            return nil 
        end
        return originalNamecall(selfArg, ...)
    end)
    setreadonly(mt, true)
end

--// 3. Physical Sanitizer (Removes Visuals & Damage Zones)
local function sanitize(obj: Instance)
    if not obj:IsA("BasePart") then return end
    
    local name = obj.Name
    for _, keyword in ipairs(PART_KEYWORDS) do
        if name:find(keyword) then
            obj:Destroy()
            break
        end
    end
end

-- Efficiently monitor the workspace
Workspace.DescendantAdded:Connect(function(descendant)
    -- Small delay to let the engine initialize the part properties
    task.wait() 
    sanitize(descendant)
end)

-- Initial Sweep
for _, v in ipairs(Workspace:GetDescendants()) do
    sanitize(v)
end

warn("--> [Acid-Blocker] Protocols Initialized.")
