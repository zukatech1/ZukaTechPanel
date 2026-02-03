--[ hi this is a hub, didnt take long to put together. xeno wont load every option so i removed those. feel free to skid this, if you want to use this as a template simply rename zukahub to whatever and put loadstrings in the safebuttons --]

print("[ZukaHub -> Mercury] Starting migration...")


local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local MainWindow = Mercury:create({
    Name = "Zuka Hub",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/zukatech1" -- Example link
})

print("[ZukaHub -> Mercury] Main window created.")

-- Step 2: Create the Tabs
local CommandsTab = MainWindow:tab({ Name = "Commands", Icon = "rbxassetid://4483362458" })
local UtilityTab = MainWindow:tab({ Name = "Utilities", Icon = "rbxassetid://4483362458" })
local SettingsTab = MainWindow:tab({ Name = "Hub Settings", Icon = "rbxassetid://4483362458" })

print("[ZukaHub -> Mercury] Tabs created.")

-- ============================================================================
-- === COMMANDS TAB ===
-- ============================================================================

local CommandsSection = CommandsTab:section({ Name = "Main Addons" })

-- Re-implement the 'safeButton' helper function for Mercury
local function normalizeUrl(url)
    if not url or type(url) ~= "string" then return url end
    if url:find("raw.githubusercontent.com") then return url end
    if url:find("github.com") then
        url = url:gsub("https://github.com/", "https://raw.githubusercontent.com/")
        url = url:gsub("/blob/", "/")
        url = url:gsub("/tree/", "/")
        url = url:gsub("/refs/heads/", "/")
        return url
    end
    if url:find("pastebin.com/") and not url:find("pastebin.com/raw/") then
        return url:gsub("pastebin.com/", "pastebin.com/raw/")
    end
    return url
end

local function safeButton(name, url, successMsg)
    CommandsSection:button({
        Name = name,
        Callback = function()
            local finalUrl = normalizeUrl(url)
            MainWindow:set_status("Fetching " .. name .. "...")
            local fetchOk, src = pcall(function() return game:HttpGet(finalUrl) end)
            
            if not fetchOk or not src then
                MainWindow:set_status("Error fetching addon.")
                warn("Failed to fetch " .. tostring(name) .. " from " .. tostring(finalUrl))
                return
            end
            
            local func, loadErr = loadstring(src)
            if not func then
                MainWindow:set_status("Error loading addon.")
                warn("Failed to load string for " .. tostring(name) .. ": " .. tostring(loadErr))
                return
            end
            
            local ranOk, runErr = pcall(func)
            if ranOk then
                MainWindow:set_status(successMsg or (name .. " Loaded"))
                print(successMsg or (name .. " Loaded"))
            else
                MainWindow:set_status("Error running addon.")
                warn("Error running " .. tostring(name) .. ": " .. tostring(runErr))
            end
        end
    })
end

-- Create all the addon buttons using the migrated helper function
print("[ZukaHub -> Mercury] Populating Commands tab...")
safeButton("Zuka Tech Panel +", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Source.lua", "Welcome, use with care.")
safeButton("Build Tools", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/buildtools.lua", "Builder tools.")
safeButton("Dex + Module Poison Support", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Custom.lua", "Zex Started")
safeButton("Attach Hub", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/AttachHub.lua", "By Anthony")
safeButton("FE Control Tool", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/Control%20Tool.lua", "By Anthony")
safeButton("Fly GUI", "https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua", "Fly GUI Started")
safeButton("Universe Explorer", "https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/Universe%20Viewer", "Explorer Loaded")
safeButton("Fling V1", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/FlingerGUI.lua", "Fling GUI Loaded")
safeButton("BHOP Movement", "https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/phoon.lua", "Hell yeah.")
safeButton("Zombie Game Upd3", "https://raw.githubusercontent.com/osukfcdays/zlfucker/refs/heads/main/.luau", "Zombie GUI Started")


-- ============================================================================
-- === UTILITIES TAB ===
-- ============================================================================

local UtilitySection = UtilityTab:section({ Name = "Utilities" })

print("[ZukaHub -> Mercury] Populating Utilities tab...")
UtilitySection:button({
    Name = "Rejoin Game",
    Callback = function()
        MainWindow:set_status("Rejoining server...")
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

UtilitySection:button({
    Name = "Code Door Unlocker",
    Callback = function()
        MainWindow:set_status("One sec")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zukatech1/ZukaTechPanel/refs/heads/main/codeunlocker.lua"))()
    end    
})

UtilitySection:button({
    Name = "Local Player Settings",
    Callback = function()
        MainWindow:set_status("Loading Properties...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/editstats.txt"))()
    end
})

-- ============================================================================
-- === HUB SETTINGS TAB ===
-- ============================================================================

local SettingsSection = SettingsTab:section({ Name = "Hub Settings" })

print("[ZukaHub -> Mercury] Populating Hub Settings tab...")
SettingsSection:button({
    Name = "Exit Zuka Hub",
    Callback = function()
        -- Mercury's destroy function is accessed via the returned window object.
        MainWindow.core.AbsoluteObject:Destroy()
        getgenv().ZukaLuaHub = nil
        print("Zuka Hub (Mercury) unloaded and cleaned up.")
    end
})


print("We're so back.")