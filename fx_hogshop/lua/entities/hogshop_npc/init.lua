include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/Male_04.mdl");
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT);
	self:SetSolid(SOLID_BBOX);
	self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD);
	self:SetUseType(SIMPLE_USE);
	self:DropToFloor();
end

util.AddNetworkString("hogshop_menu")

function ENT:AcceptInput(key, cal)
	if key == "Use" and cal:IsPlayer() then
		net.Start("hogshop_menu")
		net.Send(cal)
	end
end