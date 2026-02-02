--[=[
    Callum's Animation Neutralizer
    Research Lead: Game Security Analyst
    Focus: API Hooking & Environment Manipulation
--]=]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Use hookfunction if your executor supports it; it's cleaner than raw metatable manipulation.
-- However, since you started with metatable logic, we'll finish that for educational transparency.

local function neutralizeAnimations(character)
    if not character then return end
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    local animator = humanoid and humanoid:WaitForChild("Animator", 5)
    
    if not animator then return end

    -- 1. Disable the standard Roblox Animate script
    local animateScript = character:FindFirstChild("Animate")
    if animateScript then
        animateScript.Enabled = false
    end

    -- 2. Freeze and stop all currently active tracks
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:Stop(0) -- Stop immediately
        track:AdjustSpeed(0) -- Redundancy for 'frozen' state
    end

    -- 3. Metatable Hooking (The Logic Reversal)
    -- We target the __index metamethod to intercept calls to LoadAnimation.
    local animatorMT = getrawmetatable(animator)
    local oldIndex = animatorMT.__index
    setreadonly(animatorMT, false)

    animatorMT.__index = newcclosure(function(self, key)
        -- If the script tries to call LoadAnimation, we return a dummy function
        -- that returns a proxy object or nil to prevent errors.
        if key == "LoadAnimation" then
            return function()
                return {
                    Play = function() end,
                    Stop = function() end,
                    AdjustSpeed = function() end,
                    IsPlaying = false
                }
            end
        end
        return oldIndex(self, key)
    end)

    setreadonly(animatorMT, true)
    
    print("[RESEACH] Animator methods neutralized for: " .. character.Name)
end

-- Persistence Layer: Ensure it runs every time the character loads
LocalPlayer.CharacterAdded:Connect(neutralizeAnimations)

-- Initial run
if LocalPlayer.Character then
    task.spawn(neutralizeAnimations, LocalPlayer.Character)
end