AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player/items/humans/graduation_cap.mdl")
	self:PhysicsInitSphere(16,"plastic")
		self:SetMoveType(MOVETYPE_NONE)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	timer.Simple(0,function() 
		self:SetPos(self:GetPos()+self:GetUp()*40) 
		local pos = self:GetPos()
		local data = EffectData()
		data:SetOrigin(pos)
		util.Effect("balloon_pop",data)
	end)
end

function ENT:StartTouch(ent)
	self:EmitSound("buttons/button14.wav")
	self:Remove()

	fx_pickups_award(ent);
end