-- Optimized sword collection with better detection and feedback
local SwordStands = {
	"VenomshankStand",
	"WindforceStand",
	"IlluminaStand",
	"IceDaggerStand",
	"GhostwalkerStand",
	"FirebrandStand",
	"DarkheartStand",
}

local LocalPlayer = game:GetService("Players").LocalPlayer
local character = LocalPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")

if not (humanoidRootPart and humanoid) then
	warn("[ERROR] Character or Humanoid not found!")
	return
end

local Interactives = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Interactives")
if not Interactives then
	warn("[ERROR] Interactives folder not found!")
	return
end

local collected = 0
local total = #SwordStands
print("[INFO] Starting sword collection... (" .. total .. " swords)")

for i, standName in ipairs(SwordStands) do
	task.spawn(function()
		local stand = Interactives:FindFirstChild(standName)
		
		if not stand then
			print("[SKIP] Stand not found: " .. standName)
			return
		end
		
		local sword = stand:FindFirstChild("Sword")
		if not sword then
			print("[SKIP] Already collected: " .. standName)
			return
		end
		
		-- Collect the sword
		local originalPos = humanoidRootPart.CFrame
		local swordPos = sword.CFrame + Vector3.new(0, 3, 0)
		
		humanoidRootPart.CFrame = swordPos
		task.wait(0.1)
		humanoidRootPart.CFrame = originalPos
		
		collected = collected + 1
		print("[SUCCESS] Collected: " .. standName .. " (" .. collected .. "/" .. total .. ")")
	end)
	
	task.wait(0.05)  -- Small stagger to prevent server lag
end

print("[INFO] Collection complete! Check inventory for new swords.")