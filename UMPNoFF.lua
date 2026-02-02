
--[[ 
	POISONED PATCH: 1
	ENGINE: Standard Weapon '1' Architecture
	ARCHITECT: Callum (ZukaTech v10)
	TARGET: game:GetService("Players").OverZuka.Backpack["BounceUMP-45"].Setting["1"]
--]]

local targetModule = require(game:GetService("Players").OverZuka.Backpack["BounceUMP-45"].Setting["1"])
if setreadonly then setreadonly(targetModule, false) end

targetModule.AngleX_Min = 0 -- [PATCHED]
targetModule.MeleeCriticalDamageEnabled = 999999 -- [PATCHED]
targetModule.Spread = 0 -- [PATCHED]
targetModule.Auto = true
targetModule.BaseDamage = 999999 -- [PATCHED]
targetModule.MeleeDamage = 999999 -- [PATCHED]
targetModule.BulletSpeed = 5000 -- [PATCHED]
targetModule.HeadshotEnabled = 100 -- [PATCHED]
targetModule.AngleZ_Max = 0 -- [PATCHED]
targetModule.DelayBeforeFiring = 0 -- [PATCHED]
targetModule.EquipTime = 0 -- [PATCHED]
targetModule.BurstRate = 0 -- [PATCHED]
targetModule.Recoil = 0 -- [PATCHED]
targetModule.MeleeHeadshotEnabled = 100 -- [PATCHED]
targetModule.AngleX_Max = 0 -- [PATCHED]
targetModule.CriticalDamageEnabled = 999999 -- [PATCHED]
targetModule.SwitchTime = 0 -- [PATCHED]
targetModule.AmmoPerMag = 999999 -- [PATCHED]
targetModule.FireRate = 0.2 -- [PATCHED]
targetModule.SuperRicochet = false -- [PATCHED]
targetModule.MeleeCriticalDamageMultiplier = 999999 -- [PATCHED]
targetModule.RicochetAmount = 0
targetModule.Ricochet = false -- [PATCHED]
targetModule.ZeroDamageDistance = 999999 -- [PATCHED]
targetModule.AngleY_Max = 0 -- [PATCHED]
targetModule.MeleeHeadshotDamageMultiplier = 999999 -- [PATCHED]
targetModule.CriticalDamageMultiplier = 999999 -- [PATCHED]
targetModule.TacticalReloadTime = 0 -- [PATCHED]
targetModule.DelayAfterFiring = 0 -- [PATCHED]
targetModule.ReduceSelfDamageOnAirOnly = 999999 -- [PATCHED]
targetModule.SelfDamage = 999999 -- [PATCHED]
targetModule.DamageBasedOnDistance = 999999 -- [PATCHED]
targetModule.ExplosionRadius = 9999 -- [PATCHED]
targetModule.DamageDropOffEnabled = 999999 -- [PATCHED]
targetModule.ReloadTime = 0 -- [PATCHED]
targetModule.BulletPerShot = 15 -- [PATCHED]
targetModule.FriendlyFire = false -- [PATCHED]
targetModule.AngleY_Min = 0 -- [PATCHED]
targetModule.Accuracy = 0 -- [PATCHED]
targetModule.LimitedAmmoEnabled = false -- [PATCHED]
targetModule.FullDamageDistance = 999999 -- [PATCHED]
targetModule.HeadshotDamageMultiplier = 999999 -- [PATCHED]
targetModule.AngleZ_Min = 0 -- [PATCHED]
targetModule.SelfDamageRedution = 999999
targetModule.HoldAndReleaseEnabled = false 
targetModule.ChargedShotEnabled = false -- [PATCHED]

if setreadonly then setreadonly(targetModule, true) end
print('--> [Poison]: 1 has been neutralized.')