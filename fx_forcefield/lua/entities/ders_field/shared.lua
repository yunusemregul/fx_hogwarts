ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Category = "Other"
ENT.Spawnable = false
ENT.PrintName = "ders_field"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "Color")
	self:NetworkVar("Vector", 1, "Min")
	self:NetworkVar("Vector", 2, "Max")
	self:NetworkVar("String", 0, "Name")
	self:NetworkVar("Bool", 0, "Block")
end

function ENT:InitPhysics()
	if self:GetMin() and self:GetMax() then
		print(self:GetMin(),self:GetMax())
		self:PhysicsInitBox(self:GetMin(), self:GetMax())
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

		timer.Simple(1, function()
			self:InitPhysics()
		end)
	end
end

local function canPass(field, ply)
	if field:GetBlock()==true and not ply:isProfessor() then
		return false
	end

	return true
end

hook.Add("ShouldCollide", "shouldcollide_fx_dersfield", function(ent1, ent2)
	if ent1 and ent2 then
		local field = nil
		local ply = nil

		if ent1:GetClass() == "ders_field" then
			field = ent1
			ply = ent2
		end

		if ent2:GetClass() == "ders_field" then
			field = ent2
			ply = ent1
		end

		if field then
			if ply:IsPlayer() then return not canPass(field, ply) end

			return true
		end
	end
end)

hook.Add("PhysgunPickup", "physgunpickup_fx_dersfield", function(ply, ent)
	if ent:GetClass() == "ders_field" then return false end
end)