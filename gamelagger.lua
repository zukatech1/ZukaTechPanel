local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")

local localPlayer: Player = Players.LocalPlayer
local capturedRemote: RemoteEvent? = nil
local capturedArgs: table? = nil
local isFlooding: boolean = false

-- 1. THE SNIFFER: Intercepting the game's own 'FireServer' call
local gmt: table = getrawmetatable(game)
local oldNamecall = gmt.__namecall
setreadonly(gmt, false)

gmt.__namecall = newcclosure(function(self, ...)
	local method: string = getnamecallmethod()
	local args: table = { ... }

	-- Detect when the weapon script tries to communicate with the server
	if method == "FireServer" and not isFlooding then
		capturedRemote = self
		capturedArgs = args
		print("Target Acquired: " .. self:GetFullName())
		isFlooding = true -- Start the flood as soon as you shoot once
	end

	return oldNamecall(self, ...)
end)

setreadonly(gmt, true)

-- 2. THE REPEATER: Flooding the captured packet
RunService.Heartbeat:Connect(function()
	if isFlooding and capturedRemote and capturedArgs then
		-- Execute 100 shots per heartbeat for maximum saturation
		for i = 1, 100 do
			task.spawn(function()
				capturedRemote:FireServer(unpack(capturedArgs))
			end)
		end
	end
end)