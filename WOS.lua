-- [[ Dash Cooldown ]]


local runService = game:GetService("RunService")

local function getCombatTable()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "lastDash") and rawget(v, "comboCount") then
            return v
        end
    end
end

local combatTable = getCombatTable()

if combatTable then
    print("[SUCCESS] Combat State Table found. Hooking...")
    
    runService.Heartbeat:Connect(function()
        combatTable.lastDash = 0
        combatTable.dashing = false
        
        local char = game.Players.LocalPlayer.Character
        if char and char:GetAttribute("Dashing") then
            char:SetAttribute("Dashing", false)
        end
    end)
else
    warn("[ERROR] Could not locate Combat State Table. Framework might not be loaded.")
end
