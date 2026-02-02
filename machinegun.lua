--[[
    ARCHITECT: Callum
    PROJECT: Performance Calibration Research
    VECTOR: Frame-Timing Instability & GPU Overdraw
    OBJECTIVE: Induce ~30-40 FPS "Sluggishness" without crashing.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponPath = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeaponSettings"):WaitForChild("Gun"):WaitForChild("MachineGun"):WaitForChild("Setting"):WaitForChild("1")

local function PatchModule()
    local success, weaponTable = pcall(require, WeaponPath)
    
    if success and type(weaponTable) == "table" then
        -- MODIFIED VALUES FOR "PERFORMANCE TAX"
        weaponTable.FireRate = 0.033 -- ~30 shots/sec (Matches tick rate)
        weaponTable.BulletPerShot = 323 -- Geometric limit that stresses without crashing
        weaponTable.ShotgunEnabled = true
        weaponTable.LightShadows = true -- Force Shadow Atlas updates
        weaponTable.LightRange = 40
        weaponTable.LaserTrailTransparency = 0.85 -- Heavy blending cost
        weaponTable.ExplosionRadius = 15 -- Localized physics debris
        weaponTable.ExplosionSoundVolume = 2
        weaponTable.AmmoPerMag = 99999
        weaponTable.ReloadTime = 0.1
    end
end

task.spawn(PatchModule)

local v1 = {
    ["ModuleName"] = "1",
    ["BaseDamage"] = 100,
    ["FireRate"] = 0.00,
    ["BulletPerShot"] = 302,
    ["ShotgunEnabled"] = true,
    
    -- LIGHTING: The "Micro-Stutter" Vector
    ["MuzzleLightEnabled"] = true,
    ["LightShadows"] = true,
    ["LightBrightness"] = 50,
    ["LightRange"] = 40,
    ["LightColor"] = Color3.new(1, 0, 0),
    
    -- RENDERING: Transparency Overdraw
    ["LaserTrailEnabled"] = true,
    ["LaserTrailTransparency"] = 0.85,
    ["LaserTrailMaterial"] = Enum.Material.Neon,
    ["LaserTrailScaleMultiplier"] = 2,
    ["LaserTrailVisibleTime"] = 2, -- Keeps the geometry in memory longer
    
    -- PHYSICS: Buffer Noise
    ["ExplosiveEnabled"] = true,
    ["ExplosionRadius"] = 15,
    ["ExplosionCraterEnabled"] = true,
    ["ExplosionCraterSize"] = 50,
    ["ExplosionSoundVolume"] = 2,
    
    -- AUDIO: Thread Saturation
    ["HitSoundVolume"] = 0,
    ["HitSoundIDs"] = { 151130059 },
    
    -- UTILITY
    ["Auto"] = true,
    ["AmmoPerMag"] = 99999,
    ["Ammo"] = 99999,
    ["MaxAmmo"] = 99999,
    ["ReloadTime"] = 0.1,
    ["Accuracy"] = 0,
    ["Spread"] = 0,
    ["Recoil"] = 0,
    ["BulletSpeed"] = 5000,
    ["Range"] = 10000,
    ["Lifetime"] = 10,
    ["ProjectileType"] = "Bullet",
    ["BulletType"] = "Normal"
}

return v1