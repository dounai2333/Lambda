AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_postprocess.lua")
AddCSLuaFile("cl_ragdoll_ext.lua")
AddCSLuaFile("cl_skin_lambda.lua")
AddCSLuaFile("huds/hud_numeric.lua")
AddCSLuaFile("huds/hud_suit.lua")
AddCSLuaFile("huds/hud_health.lua")
AddCSLuaFile("huds/hud_armor.lua")
AddCSLuaFile("huds/hud_primary_ammo.lua")
AddCSLuaFile("huds/hud_secondary_ammo.lua")
AddCSLuaFile("huds/hud_ammo.lua")
AddCSLuaFile("huds/hud_aux.lua")
AddCSLuaFile("huds/hud_pickup.lua")
AddCSLuaFile("huds/hud_roundinfo.lua")
AddCSLuaFile("huds/hud_settings.lua")
AddCSLuaFile("huds/hud_hint.lua")
AddCSLuaFile("huds/hud_crosshair.lua")
AddCSLuaFile("huds/hud_vote.lua")
AddCSLuaFile("huds/hud_deathnotice.lua")
AddCSLuaFile("huds/hud_scoreboard.lua")

DEFINE_BASECLASS( "gamemode_base" )

include("shared.lua")
include("sv_inputoutput.lua")
include("sv_changelevel.lua")
include("sv_transition.lua")
include("sv_generic_fixes.lua")
include("sv_resource.lua")
include("sv_taunts.lua")
include("sv_playerspeech.lua")
include("sv_commands.lua")
include("sv_checkpoints.lua")
include("sv_weapontracking.lua")
include("sv_player_pickup.lua")
include("sv_votefuncs.lua")

util.AddNetworkString("LambdaDeathEvent")

local DbgPrint = GetLogging("Server")
local DbgPrintDmg = GetLogging("Damage")

function GM:GetNextUniqueEntityId()
	self.UniqueEntityId = self.UniqueEntityId or 0
	self.UniqueEntityId = self.UniqueEntityId + 1
	return self.UniqueEntityId
end

function GM:InsertLevelDesignerPlacedObject(obj)
	local objects = self.LevelRelevantObjects or {}
	objects[obj] = { pos = obj:GetPos(), ang = obj:GetAngles() }
	self.LevelRelevantObjects = objects
end

function GM:IsLevelDesignerPlacedObject(obj)
	local objects = self.LevelRelevantObjects or {}
	if objects == nil then
		return false
	end
	return objects[obj] ~= nil
end

function GM:GetLevelDesignerPlacedData(obj)
	local objects = self.LevelRelevantObjects or {}
	return objects[obj]
end

function GM:RemoveLevelDesignerPlacedObject(obj)
	local objects = self.LevelRelevantObjects or {}
	if objects == nil then
		return
	end
	objects[obj] = nil
end

function GM:ClearLevelDesignerPlacedObjects()
	self.LevelRelevantObjects = {}
end

function GM:ApplyCorrectedDamage(dmginfo)

	local DbgPrint = DbgPrintDmg
	
	DbgPrint("ApplyCorrectedDamage")

	local attacker = dmginfo:GetAttacker()

	if IsValid(attacker) and (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_CLUB)) then

		local weaponTable = nil
		local wep = nil

		if attacker:IsPlayer() then
			weaponTable = self.PLAYER_WEAPON_DAMAGE
			wep = attacker:GetActiveWeapon()
		elseif attacker:IsNPC() then
			weaponTable = self.NPC_WEAPON_DAMAGE
			wep = attacker:GetActiveWeapon()
		end

		if weaponTable ~= nil and IsValid(wep) then
			local class = wep:GetClass()
			local dmgCVar = weaponTable[class]
			if dmgCVar ~= nil then
				local dmgAmount = dmgCVar:GetInt()
				DbgPrint("Setting modified weapon damage " .. tostring(dmgAmount) .. " on " .. class)
				dmginfo:SetDamage(dmgAmount)
			end
		end

	end

	return dmginfo

end

if DMG_SNIPER == nil then 
	DMG_SNIPER = 1073741824
end 

if DMG_MISSILEDEFENSE == nil then 
	DMG_MISSILEDEFENSE = 2147483648
end 

local DMG_TYPES =
{
	[DMG_GENERIC] = "Generic",
	[DMG_CRUSH] = "Crush",
	[DMG_BULLET] = "Bullet",
	[DMG_SLASH] = "Slash",
	[DMG_BURN] = "Burn",
	[DMG_VEHICLE] = "Vehicle",
	[DMG_FALL] = "Fall",
	[DMG_BLAST] = "Blast",
	[DMG_CLUB] = "Club",
	[DMG_SHOCK] = "Shock",
	[DMG_SONIC] = "Sonic",
	[DMG_ENERGYBEAM] = "Energybeam",
	[DMG_PREVENT_PHYSICS_FORCE] = "PhysForce",
	[DMG_NEVERGIB] = "NeverGib",
	[DMG_ALWAYSGIB] = "AlwaysGib",
	[DMG_DROWN] = "Drown",
	[DMG_PARALYZE] = "Paralyze",
	[DMG_NERVEGAS] = "NerveGas",
	[DMG_POISON] = "Poison",
	[DMG_RADIATION] = "Radiation",
	[DMG_DROWNRECOVER] = "DrownRecover",
	[DMG_ACID] = "Acid",
	[DMG_SLOWBURN] = "SlowBurn",
	[DMG_REMOVENORAGDOLL] = "RemoveNoRagdoll",
	[DMG_PHYSGUN] = "Physgun",
	[DMG_PLASMA] = "Plasma",
	[DMG_AIRBOAT] = "Airboat",
	[DMG_DISSOLVE] = "Dissolve",
	[DMG_BLAST_SURFACE] = "BlastSurface",
	[DMG_DIRECT] = "Direct",
	[DMG_BUCKSHOT] = "Buckshot",
	[DMG_SNIPER] = "Sniper",
	[DMG_MISSILEDEFENSE] = "MissileDefense",
}

local function GetDamageTypeText(dmginfo)
	local text = ""
	local append = function(t) 
		if text ~= "" then
			text = text .. ", " .. t
		else 
			text = t 
		end 
	end
	for k,v in pairs(DMG_TYPES) do 
		if dmginfo:IsDamageType(k) == true then
			append(v)
		end 
	end
	return text .. " : " .. dmginfo:GetDamageType()
end 

function GM:EntityTakeDamage(target, dmginfo)

	local DbgPrint = DbgPrintDmg

	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local targetClass = target:GetClass()
	local dmgText = GetDamageTypeText(dmginfo)

	DbgPrint("EntityTakeDamage -> Target: " .. tostring(target) .. ", Attacker: " .. tostring(attacker) .. ", Inflictor: " .. tostring(inflictor) .. ", Type: " .. dmgText)

	local gameType = self:GetGameType()

	local dmgType = dmginfo:GetDamageType()
	target:SetLastDamageType(dmgType)

	target.IsPhysgunDamage = dmginfo:IsDamageType(DMG_PHYSGUN)
	DbgPrint(target, "PhysgunDamage: " .. tostring(target.IsPhysgunDamage))

	if target:IsNPC() then

		local restrictedNPCNames = self:GetGameTypeData("ImportantPlayerNPCNames") or {}
		local restrictedNPCClasses = self:GetGameTypeData("ImportantPlayerNPCClasses") or {}
		local npcName = target:GetName()
		local isRestricted = restrictedNPCNames[npcName] == true or restrictedNPCClasses[targetClass] == true
		local attackerIsPlayer = ((IsValid(attacker) and attacker:IsPlayer()) or (IsValid(inflictor) and inflictor:IsPlayer()))
		-- Check if player is attacking friendlies.
		if attackerIsPlayer == true and isRestricted == true and lambda_allow_npcdmg:GetBool() == false then
			DbgPrint("Filtering damage on restricted NPC")
			dmginfo:ScaleDamage(0)
			return true
		end

	elseif target:IsPlayer() then

		if target:IsPositionLocked() or target:IsInactive() == true then
			return true
		end

		local gameType = self:GetGameType()
		if target ~= attacker and target ~= inflictor then
			if self:CallGameTypeFunc("PlayerShouldTakeDamage", target, attacker, inflictor) == false then
				return true
			end
		end

		local dmg = dmginfo:GetDamage()
		if dmg > 0 then
			local hitGroup = HITGROUP_GENERIC
			if dmginfo:IsDamageType(DMG_FALL) and dmg > 40 and math.random(1, 2) == 1 then
				hitGroup = HITGROUP_LEFTLEG
			end
			self:EmitPlayerHurt(dmginfo:GetDamage(), target, hitGroup)
		end

		if target:InVehicle() then
			dmginfo:ScaleDamage(0.6)
		end

		-- NOTE: Blocking too early would not register any damage.
		if lambda_player_god:GetBool() == true then
			return true
		end

	elseif target:IsWeapon() == true or target:IsItem() == true then
		if lambda_prevent_item_move:GetBool() == true then
			if (IsValid(attacker) and attacker:IsPlayer()) or (IsValid(inflictor) and inflictor:IsPlayer()) then
				dmginfo:SetDamageForce(Vector(0, 0, 0))
			end
		end
	end

	if target.FilterDamage == true then
		DbgPrint("Filtering Damage!")
		dmginfo:ScaleDamage(0)
		return true
	end

end

function GM:CreateEntityRagdoll( owner, ragdoll )

	DbgPrint("Create Ragdoll:", tostring(owner), tostring(ragdoll))
	ragdoll.IsPhysgunDamage = owner.IsPhysgunDamage

end

function GM:LambdaPreChangelevel(data)

end

function GM:SendDeathNotice(victim, attacker, inflictor, dmgType)

	local function GetEntityData(e)
		local data = {}
		data.entIndex = e:EntIndex()
		data.class = e:GetClass()
		data.name = e:GetName()
		data.isNPC = e:IsNPC()
		data.isPlayer = e:IsPlayer()
		if e.Team ~= nil then 
			data.team = e:Team()
		end
		return data
	end 

	local bulletDamage = bit.band(dmgType, DMG_BULLET) ~= 0 or bit.band(dmgType, DMG_BUCKSHOT) ~= 0

	if attacker == nil then 
		attacker = inflictor 
	end 
	
	local data = {}
	if IsValid(victim) then 
		data.victim = GetEntityData(victim)
	end 
	if IsValid(attacker) then 
		data.attacker = GetEntityData(attacker)
	end 

	if bit.band(dmgType, DMG_BULLET) ~= 0 or 
		bit.band(dmgType, DMG_CLUB) ~= 0 or 
		bit.band(dmgType, DMG_BUCKSHOT) ~= 0 
	then 
		-- Player used his weapon in this case.
		if IsValid(inflictor) and inflictor == attacker and attacker.GetActiveWeapon ~= nil then 
			local wep = attacker:GetActiveWeapon()
			if IsValid(wep) then 
				inflictor = wep
			end
		end 
	end

	if IsValid(inflictor) then 
		data.inflictor = GetEntityData(inflictor)
	end

	data.dmgType = dmgType

	net.Start("LambdaDeathEvent")
		net.WriteTable(data)
	net.Broadcast()

end 