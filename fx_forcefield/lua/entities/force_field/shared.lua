ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Category = "Other"
ENT.Spawnable = false
ENT.PrintName = "force_field"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "Color");
end

function ENT:InitPhysics()
	if self.min and self.max then
		self:PhysicsInitBox(self.min, self.max)
		
		self:EnableCustomCollisions(true)
		self:SetCustomCollisionCheck(true)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local Phys = self:GetPhysicsObject()
		Phys:SetMaterial("player_control_clip")
		Phys:EnableMotion(false)
		Phys:Sleep()

		self:DrawShadow(false)
	else
		print("[FX FORCEFIELDS] No min/max points found for entity: ")
		timer.Simple(1,function() self:InitPhysics() end)
	end
end

if CLIENT then
	net.Receive("force_field_shareminmax", function()
		local ent = net.ReadEntity()

		if not ent or not IsValid(ent) then 
			net.Start("force_field_shareminmax")
			net.SendToServer()
			MsgC(Color(255,128,128),"HATA: 'force_field_shareminmax' ent bulunamadi (ISTEK GONDERILDI)\n")
			return 
		end

		ent._min = net.ReadVector()
		ent._max = net.ReadVector()

		ent.min = WorldToLocal(ent._min,ent:GetAngles(),ent:GetPos(),ent:GetAngles())
		ent.max = WorldToLocal(ent._max,ent:GetAngles(),ent:GetPos(),ent:GetAngles())

		if ent.InitPhysics then
			ent:InitPhysics()
		else
			net.Start("force_field_shareminmax")
			net.SendToServer()
			MsgC(Color(255,128,128),"HATA: 'force_field_shareminmax' InitPhysics bulunamadi (ISTEK GONDERILDI)\n")
		end
	end)
end

local function canPass(field, ply)
	if field.allowed_teams then
		return field.allowed_teams[ply:Team()] or false
	end
	return false
end

hook.Add("ShouldCollide","shouldcollide_fx_forcefield", function(ent1, ent2)
	if ent1 and ent2 then
		local field = nil
		local ply = nil
		if ent1:GetClass()=="force_field" then field = ent1 ply = ent2 end
		if ent2:GetClass()=="force_field" then field = ent2  ply = ent1 end

		if field then
			if ply:IsPlayer() then
				return !canPass(field, ply)
			end
			return true
		end
	end
end)

hook.Add("PhysgunPickup","physgunpickup_fx_forcefield", function(ply, ent)
	if ent:GetClass()=="force_field" then return false end
end)