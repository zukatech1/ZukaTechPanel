local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// CONFIGURATION //--
local config = {
    -- The chat command prefix. Must be unique.
    COMMAND_PREFIX = "/forensic ",
    -- Heuristic keywords that suggest a remote might be interesting to analyze.
    -- These are often verbs that imply state changes.
    HEURISTIC_KEYWORDS = {
        "Give", "Set", "Equip", "Tool", "Event", "Admin", "Request",
        "Buy", "Sell", "Trade", "Remote", "Update", "Unsecure", "Handle"
    },
    -- Root instances to begin scanning from.
    SEARCH_PATHS = {
        ReplicatedStorage,
        Workspace,
        Players -- Sometimes remotes are parented to player objects
    }
}

--// CONSTANTS //--
local localPlayer = Players.LocalPlayer

--// CORE: UTILITY FUNCTIONS //--

--[[
    Parses a string path (e.g., "game.ReplicatedStorage.Events.RequestGearEvent")
    and returns the actual object if it exists. This is safer than loadstring
    and more flexible than hardcoding paths.
]]
local function findObjectFromPath(pathString)
    local currentObject = game
    -- Split the path by dots and iterate through the hierarchy
    for part in string.gmatch(pathString, "[^.]+") do
        if currentObject then
            currentObject = currentObject:FindFirstChild(part)
        else
            return nil -- Path is broken
        end
    end
    return currentObject
end

--[[
    Parses a string of arguments into a table of correct types.
    - "Sword" -> string
    - 123 -> number
    - true -> boolean
    - nil -> nil
]]
local function parseArguments(argString)
    local args = {}
    -- Use gmatch to find words, numbers, or quoted strings
    for match in string.gmatch(argString, '"([^"]*)"|%S+') do
        if tonumber(match) then
            table.insert(args, tonumber(match))
        elseif match == "true" then
            table.insert(args, true)
        elseif match == "false" then
            table.insert(args, false)
        elseif match == "nil" then
            table.insert(args, nil)
        else
            -- If it's not a number/bool/nil, treat it as a string,
            -- removing quotes if they were added.
            table.insert(args, match:gsub('^"|"$', ''))
        end
    end
    return args
end


--// CORE: COMMAND FUNCTIONS //--

--[[
    Scans configured paths for remotes matching heuristic keywords.
    This is the primary information gathering function.
]]
local function commandScanRemotes()
    print("Zuka's Forensic Log: Beginning heuristic scan for interesting remotes...")
    local findings = 0
    for _, root in ipairs(config.SEARCH_PATHS) do
        for _, descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                local remoteName = string.lower(descendant.Name)
                for _, keyword in ipairs(config.HEURISTIC_KEYWORDS) do
                    if string.find(remoteName, string.lower(keyword)) then
                        print("  [!] Potential Target Found: "..descendant:GetFullName())
                        findings = findings + 1
                        break -- Avoid printing the same remote multiple times
                    end
                end
            end
        end
    end
    print("Zuka's Forensic Log: Scan complete. Found "..findings.." potential targets.")
end

--[[
    Fires a remote at a given path with provided arguments.
    This is the active probing function.
]]
local function commandProbeRemote(pathString, argString)
    print("Zuka's Forensic Log: Preparing to probe remote at path: '"..pathString.."'")
    local remote = findObjectFromPath(pathString)

    if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        warn("Zuka's Security Warning: Probe failed. Object at path is nil or not a remote.")
        return
    end

    local args = parseArguments(argString or "")
    print("Zuka's Forensic Log: Target acquired. Firing '"..remote.Name.."' with "..#args.." arguments.")

    -- Use a protected call (pcall) to fire the remote. This prevents the
    -- local script from crashing if the server errors or the arguments are bad.
    local success, result = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
            return "Event Fired (No Return)"
        else -- It's a RemoteFunction
            return remote:InvokeServer(unpack(args))
        end
    end)

    if success then
        print("Zuka's Forensic Log: Probe successful. Server responded with:", result)
    else
        warn("Zuka's Security Warning: Probe failed. The remote call errored on the client. Details:", result)
    end
end


--// MAIN: INPUT HANDLER //--
local function onPlayerChatted(message)
    local lowerMessage = string.lower(message)
    local lowerPrefix = string.lower(config.COMMAND_PREFIX)

    if string.sub(lowerMessage, 1, string.len(lowerPrefix)) == lowerPrefix then
        local commandString = string.sub(message, string.len(lowerPrefix) + 1)
        local command = commandString:match("%S+") or "help"
        local payload = commandString:sub(#command + 2)

        if command == "scan" then
            commandScanRemotes()
        elseif command == "probe" then
            local pathString = payload:match("%S+")
            local argString = payload:sub(#pathString + 2)
            if not pathString then
                warn("Zuka's Warning: Probe command requires a path. Usage: /forensic probe [FullPathToObject] [args...]")
                return
            end
            commandProbeRemote(pathString, argString)
        else
            print("--- Zuka's Forensic Analyzer Help ---")
            print("Usage: /forensic [command] [payload]")
            print("Commands:")
            print("  scan - Scans the game for remotes based on keywords.")
            print("  probe [path] [args] - Fires a remote with arguments.")
            print("    -> Example: /forensic probe game.ReplicatedStorage.Events.EquipTool \"ClassicSword\" 1")
            print("    -> Arguments: Use quotes for strings. Numbers/bools/nil are auto-detected.")
            print("---------------------------------------")
        end
    end
end

--// CONNECTIONS //--
localPlayer.Chatted:Connect(onPlayerChatted)
print("Zuka's Log: Forensic Remote Analyzer is online. Type '/forensic help' for commands.")
