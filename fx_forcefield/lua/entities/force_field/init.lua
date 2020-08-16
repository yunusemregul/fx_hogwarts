AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("force_field_shareminmax")
util.AddNetworkString("force_field_shareteams")

last_broadcasted_field = last_broadcasted_field or nil

function ENT:Initialize()
	self:SetModel("models/effects/teleporttrail.mdl")
	if self._max and self._min then
		self.min = WorldToLocal(self._min,self:GetAngles(),self:GetPos(),self:GetAngles())
		self.max = WorldToLocal(self._max,self:GetAngles(),self:GetPos(),self:GetAngles())
		timer.Simple(0, function()
			net.Start("force_field_shareminmax")
				net.WriteEntity(self)
				net.WriteVector(self._min)
				net.WriteVector(self._max)
			net.Broadcast()
			last_broadcasted_field = self
		end)
		self:InitPhysics()
	end
	if self.allowed_teams and (table.Count(self.allowed_teams)>0) then
		timer.Simple(0, function()
			net.Start("force_field_shareteams")
				net.WriteEntity(self)
				net.WriteInt(table.Count(self.allowed_teams),8)
				for key, value in pairs(self.allowed_teams) do
					net.WriteString(key..";"..tostring(value))
				end
			net.Broadcast()
			last_broadcasted_field = self
		end)
	end
end

--util.PrecacheSound("player/bhit_helmet-1.wav")
--local snd = Sound("player/bhit_helmet-1.wav")

function ENT:OnTakeDamage( Dmg )
	local Pos = Dmg:GetDamagePosition()

	local Eff = EffectData()
	Eff:SetOrigin(Pos)
	Eff:SetNormal(-Dmg:GetDamageForce())


	util.Effect( "cball_bounce", Eff )

--	EmitSound(snd, Pos, 1, CHAN_AUTO, 1, 75, 0, 100)
end

net.Receive("force_field_shareminmax", function(len, ply)
	if ply.last_minmax_field and (ply.last_minmax_field==last_broadcasted_field) then return end	
	
	timer.Simple(0, function()
		net.Start("force_field_shareminmax")
			net.WriteEntity(last_broadcasted_field)
			net.WriteVector(last_broadcasted_field._min)
			net.WriteVector(last_broadcasted_field._max)
		net.Send(ply)
	end)
	--MsgC(Color(255,128,128),"HATA: ("..ply:Nick()..") 'force_field_shareminmax' ent bulunamadi (ISTEK ALINDI)\n")
	ply.last_minmax_field = last_broadcasted_field
end)

net.Receive("force_field_shareteams", function(len, ply)
	if ply.last_shareteams_field and (ply.last_shareteams_field==last_broadcasted_field) then return end

	timer.Simple(0, function()
		net.Start("force_field_shareteams")
			net.WriteEntity(last_broadcasted_field)
			net.WriteInt(table.Count(last_broadcasted_field.allowed_teams),8)
			for key, value in pairs(last_broadcasted_field.allowed_teams) do
				net.WriteString(key..";"..tostring(value))
			end
		net.Send(ply)
	end)
	--MsgC(Color(255,128,128),"HATA: ("..ply:Nick()..") 'force_field_shareteams' ent bulunamadi (ISTEK ALINDI)\n")
	ply.last_shareteams_field = last_broadcasted_field
end)