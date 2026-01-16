local LocalPlayer = game:GetService("Players").LocalPlayer
if not LocalPlayer then
    LocalPlayer = game:WaitForChild("Players").LocalPlayer
end
local function Initialize()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if self == LocalPlayer and getnamecallmethod() == "Kick" then
            return
        end
        return oldNamecall(self, ...)
    end)
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if self == LocalPlayer and key == "Kick" then
            return function() end
        end
        return oldIndex(self, key)
    end)
end
if hookmetamethod then
    Initialize()
else
    warn("Anti-Kick: Executor does not support hookmetamethod")
end
