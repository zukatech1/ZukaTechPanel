local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local meleeFunctions = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MeleeFunctions"))
local ragdollRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild("RagdollStartLocal")
local knockbackRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild("KnockbackReplication")

local CONFIG = {
	KNOCKBACK_STRENGTH = 65,
	UPWARD_FORCE = 30,
	TARGET_ITEM = "Frying Pan"
}

local function applyMeleeAugmentation()
	local success, err = pcall(function()
		local oldOnHit = meleeFunctions.OnHit
		local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)

		if setRO then setRO(meleeFunctions, false) end

		meleeFunctions.OnHit = function(hitPart, humanoid, ...)
			local targetHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
			local localChar = Players.LocalPlayer.Character
			
			if targetHumanoid and targetHumanoid.Parent ~= localChar then
				task.spawn(function()
					pcall(function()
						firesignal(ragdollRemote.OnClientEvent, targetHumanoid)
						
						local rootPart = targetHumanoid.Parent:FindFirstChild("Torso") or targetHumanoid.Parent:FindFirstChild("HumanoidRootPart")
						if rootPart and localChar.PrimaryPart then
							local direction = (rootPart.Position - localChar.PrimaryPart.Position).Unit
							local velocity = (direction * CONFIG.KNOCKBACK_STRENGTH) + Vector3.new(0, CONFIG.UPWARD_FORCE, 0)
							
							firesignal(knockbackRemote.OnClientEvent, rootPart, velocity)
						end
					end)
				end)
			end
			
			return oldOnHit(hitPart, humanoid, ...)
		end

		if setRO then setRO(meleeFunctions, true) end
	end)
	
	return success
end

applyMeleeAugmentation()