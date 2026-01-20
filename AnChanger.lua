local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shovelModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Items"):WaitForChild("Shovel"))
local meleeFunctions = require(ReplicatedStorage.Modules.MeleeFunctions)
local itemStats = require(ReplicatedStorage.Global_Items_Stats)

local ANIM_1 = "rbxassetid://15646194255" -- Slash
local ANIM_2 = "rbxassetid://15646197427" -- Lunge
local ANIM_3 = "rbxassetid://14422819392"

local function patchShovel()
	local oldNew = shovelModule.new
	local setRO = setreadonly or (make_writeable and function(t, b)
		if b then make_writeable(t) else make_readonly(t) end
	end)

	if setRO then setRO(shovelModule, false) end

	shovelModule.new = function(toolInstance)
		local obj = oldNew(toolInstance)

		local humanoid = obj.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return obj end

		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		-- clear old animations
		for _, track in pairs(obj.AnimationTracks) do
			if typeof(track) == "Instance" then
				track:Stop()
				track:Destroy()
			end
		end

		-- disconnect old events
		for _, conn in pairs(obj.Events) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			end
		end

		obj.AnimationTracks = {}

		-- load animations
		local slashAnim = Instance.new("Animation")
		slashAnim.AnimationId = ANIM_1

		local lungeAnim = Instance.new("Animation")
		lungeAnim.AnimationId = ANIM_2

		obj.AnimationTracks.Attack1 = animator:LoadAnimation(slashAnim)
		obj.AnimationTracks.Attack2 = animator:LoadAnimation(lungeAnim)

		obj.AnimationTracks.Attack1.Priority = Enum.AnimationPriority.Action
		obj.AnimationTracks.Attack2.Priority = Enum.AnimationPriority.Action

		-- idle
		obj.AnimationTracks.Idle = animator:LoadAnimation(
			toolInstance.Parent:FindFirstChild("Idle")
			or ReplicatedStorage.Modules.Items.Shovel.Idle
		)
		obj.AnimationTracks.Idle.Priority = Enum.AnimationPriority.Idle
		obj.AnimationTracks.Idle:Play()

		local useAttack2 = true

		-- manual hit timing (Linked Sword–style)
		local function playAttack(track)
			if track.IsPlaying then
				track:Stop()
			end

			track:Play()

			task.delay(0.15, function()
				obj.HitboxObject:HitStart()
			end)

			task.delay(0., function()
				obj.HitboxObject:HitStop()
			end)
		end

		obj.Events.OnActivated = toolInstance.Activated:Connect(function()
			if obj.LastUsedTime < time() and not meleeFunctions.CheckForCooldown() then
				meleeFunctions.AddCooldown(itemStats["Shovel"].Cooldown)
				meleeFunctions.ResetTagged(obj)

				local selectedTrack = useAttack2
					and obj.AnimationTracks.Attack2
					or obj.AnimationTracks.Attack1

				playAttack(selectedTrack)
				useAttack2 = not useAttack2

				-- grave interaction logic (unchanged)
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

		return obj
	end

	if setRO then setRO(shovelModule, true) end
end

patchShovel()
