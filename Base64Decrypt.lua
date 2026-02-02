local Players: Players = game:GetService("Players")
local LogService: LogService = game:GetService("LogService")

type DecodedPacket = {
	Type: string,
	Raw: string,
	Decoded: string,
	Remote: string
}

local BASE64_ALPHABET: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function DecodeBase64(data: string): string?
	local success, result = pcall(function()
		data = string.gsub(data, "[^" .. BASE64_ALPHABET .. "=]", "")
		local decoded = ""
		local buffer = 0
		local bitCount = 0

		for i = 1, #data do
			local char = string.sub(data, i, i)
			if char == "=" then break end

			local value = string.find(BASE64_ALPHABET, char, 1, true) - 1
			buffer = bit32.lshift(buffer, 6) + value
			bitCount = bitCount + 6

			if bitCount >= 8 then
				bitCount = bitCount - 8
				local byte = bit32.extract(buffer, bitCount, 8)
				decoded = decoded .. string.char(byte)
			end
		end
		return decoded
	end)
	return success and result or nil
end

local function DecodeHex(data: string): string?
	local success, result = pcall(function()
		local decoded = ""
		for i = 1, #data, 2 do
			local hexPair = string.sub(data, i, i + 1)
			local byte = tonumber(hexPair, 16)
			if not byte then return nil end
			decoded = decoded .. string.char(byte)
		end
		return decoded
	end)
	return success and result or nil
end

local function IsLikelyHex(data: string): boolean
	return #data % 2 == 0 and string.match(data, "^[0-9a-fA-F]+$") ~= nil
end

local function IsLikelyBase64(data: string): boolean
	return #data % 4 == 0 and string.match(data, "^[A-Za-z0-9+/]+=?=?$") ~= nil
end

local function ProcessNetworkArg(remoteName: string, arg: any): ()
	if type(arg) ~= "string" or #arg < 4 then return end

	local packet: DecodedPacket = {
		Type = "Unknown",
		Raw = arg,
		Decoded = "",
		Remote = remoteName
	}

	if IsLikelyHex(arg) then
		local decoded = DecodeHex(arg)
		if decoded and string.match(decoded, "[%w%s%p]+") then
			packet.Type = "Hexadecimal"
			packet.Decoded = decoded
		end
	elseif IsLikelyBase64(arg) then
		local decoded = DecodeBase64(arg)
		if decoded and string.match(decoded, "[%w%s%p]+") then
			packet.Type = "Base64"
			packet.Decoded = decoded
		end
	end

	if packet.Type ~= "Unknown" then
		print(string.format("[FORENSIC] %s DETECTED", packet.Type:upper()))
		print(string.format("Remote: %s", packet.Remote))
		print(string.format("Raw: %s", packet.Raw))
		print(string.format("Decoded: %s", packet.Decoded))
		print("-----------------------------------")
	end
end

local function InitiateForensicHook(): ()
	local rawMetatable: any = getrawmetatable(game)
	local originalNamecall: (any, ...any) -> ...any = rawMetatable.__namecall
	
	setreadonly(rawMetatable, false)

	rawMetatable.__namecall = newcclosure(function(self: any, ...: any): ...any
		local method: string = getnamecallmethod()
		local args: {any} = {...}

		if method == "FireServer" or method == "InvokeServer" then
			for _: number, arg: any in pairs(args) do
				task.spawn(ProcessNetworkArg, self.Name, arg)
			end
		end

		return originalNamecall(self, unpack(args))
	end)

	setreadonly(rawMetatable, true)
end

task.spawn(InitiateForensicHook)