AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/effects/teleporttrail.mdl")
	if self._max and self._min then
		self.min = WorldToLocal(self._min,self:GetAngles(),self:GetPos(),self:GetAngles())
		self.max = WorldToLocal(self._max,self:GetAngles(),self:GetPos(),self:GetAngles())
		//print(self.min, self.max)
		self:SetMin(self.min)
		self:SetMax(self.max)
		self:InitPhysics()
	end
	self:SetBlock(false)
end

--util.PrecacheSound("player/bhit_helmet-1.wav")
--local snd = Sound("player/bhit_helmet-1.wav")

function ENT:OnTakeDamage( Dmg )
	if self:GetBlock() then
		local Pos = Dmg:GetDamagePosition()

		local Eff = EffectData()
		Eff:SetOrigin(Pos)
		Eff:SetNormal(-Dmg:GetDamageForce())


		util.Effect( "cball_bounce", Eff )

	--	EmitSound(snd, Pos, 1, CHAN_AUTO, 1, 75, 0, 100)
	end
end