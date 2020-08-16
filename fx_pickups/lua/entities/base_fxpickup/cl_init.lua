include("shared.lua")

function ENT:Initialize()
	self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:Draw()
	local visible = util.PixelVisible(self:GetPos(), 4, self.PixVis)

	if (!visible || visible<.1) then return end
	
	render.SetMaterial(Material("sprites/light_ignorez"))
	render.DrawSprite(self:GetPos() + self:OBBCenter(), 96, 96, Color(255, 0, 255))
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
	local sway = self:GetUp() * math.sin(CurTime() * 8) * .5
	pos = self:GetPos() + sway
	self:SetPos(pos)
end