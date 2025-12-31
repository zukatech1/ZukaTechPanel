local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shovelModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Items"):WaitForChild("Shovel"))
local meleeFunctions = require(ReplicatedStorage.Modules.MeleeFunctions)
local itemStats = require(ReplicatedStorage.Global_Items_Stats)

local ANIM_1 = "rbxassetid://15646194255"
local ANIM_2 = "rbxassetid://15646197427"

local function patchShovel()
	local oldNew = shovelModule.new
	local setRO = setreadonly or (make_writeable and function(t, b) if b then make_writeable(t) else make_readonly(t) end end)

	if setRO then setRO(shovelModule, false) end

	shovelModule.new = function(toolInstance)
		local obj = oldNew(toolInstance)
		local animator = obj.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")

		if animator then
			for _, track in ipairs(obj.AnimationTracks) do track:Stop() track:Destroy() end
			obj.Events.AnimHitStart:Disconnect()
			obj.Events.AnimHitEnd:Disconnect()
			obj.Events.OnActivated:Disconnect()

			local a1 = Instance.new("Animation")
			a1.AnimationId = ANIM_1
			local a2 = Instance.new("Animation")
			a2.AnimationId = ANIM_2

			obj.AnimationTracks.Attack1 = animator:LoadAnimation(a1)
			obj.AnimationTracks.Attack2 = animator:LoadAnimation(a2)
			obj.AnimationTracks.Idle = animator:LoadAnimation(toolInstance.Parent:FindFirstChild("Idle") or ReplicatedStorage.Modules.Items.Shovel.Idle)
			obj.AnimationTracks.Idle:Play()

			local useAttack2 = false

			local function bindMarkers(track)
				obj.Events.AnimHitStart = track:GetMarkerReachedSignal("HitStart"):Connect(function()
					obj.HitboxObject:HitStart()
				end)
				obj.Events.AnimHitEnd = track:GetMarkerReachedSignal("HitStop"):Connect(function()
					obj.HitboxObject:HitStop()
				end)
			end

			obj.Events.OnActivated = toolInstance.Activated:Connect(function()
				if obj.LastUsedTime < time() and not meleeFunctions.CheckForCooldown() then
					meleeFunctions.AddCooldown(itemStats["Shovel"].Cooldown)
					meleeFunctions.ResetTagged(obj)

					if obj.Events.AnimHitStart then obj.Events.AnimHitStart:Disconnect() end
					if obj.Events.AnimHitEnd then obj.Events.AnimHitEnd:Disconnect() end

					local selectedTrack = useAttack2 and obj.AnimationTracks.Attack2 or obj.AnimationTracks.Attack1
					bindMarkers(selectedTrack)
					selectedTrack:Play()

					useAttack2 = not useAttack2

					local interaction = workspace:FindFirstChild("Interaction")
					if interaction and interaction:FindFirstChild("GraveHitbox") then
						local mag = (obj.Character.PrimaryPart.Position - interaction.GraveHitbox.Position).Magnitude
						if mag < 8 and interaction:FindFirstChild("Grave") then
							local grave = interaction.Grave
							grave.Parent = ReplicatedStorage
							if interaction:FindFirstChild("GraveSmoke") then
								interaction.GraveSmoke.Smoke:Emit(50)
								interaction.GraveSmoke.Dig:Play()
							end
							task.delay(30, function()
								grave.Parent = interaction
							end)
						end
					end
				end
			end)
		end
		return obj
	end

	if setRO then setRO(shovelModule, true) end
end

patchShovel()