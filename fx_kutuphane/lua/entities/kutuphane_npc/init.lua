include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	// models/models/mage/mage_npc.mdl
	self:SetModel("models/models/mage/mage_npc.mdl");
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT);
	self:SetSolid(SOLID_BBOX);
	self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD);
	self:SetUseType(SIMPLE_USE);
	self:DropToFloor();
end

function ENT:AcceptInput(key, cal)
	if key == "Use" and cal:IsPlayer() then
		local tab = cal:FX_GetBuyus();
		net.Start("kutuphane_menu")
			net.WriteTable(tab)
			net.WriteString("")
			net.WriteEntity(self)
		net.Send(cal)
		cal.kutuphanenpc = self;
	end
end