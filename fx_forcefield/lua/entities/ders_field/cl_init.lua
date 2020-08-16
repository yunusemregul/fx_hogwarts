include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(self:GetMin(),self:GetMax())
	self:InitPhysics()
end

function ENT:Draw()
	local pos, ang = self:GetPos(), self:GetAngles()

	if self:GetBlock() then
		render.SetColorMaterial()
		render.DrawBox(pos,ang,self:GetMin(),self:GetMax(),Color(33,33,39,200))
	end
end	

surface.CreateFont( "fdtitle", {
	font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "fdtext", {
	font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

hook.Add("PostDrawTranslucentRenderables","dersfield",function()
	local ply = LocalPlayer()

	local ent = ply:GetEyeTrace().Entity


	if IsValid(ent) then
		if ent:GetClass()=="ders_field" and LocalPlayer():GetPos():Distance(ent:GetPos())<250 then
			if ent:GetBlock() then
				local pos = ply:GetEyeTrace().HitPos
				local ang = ply:GetEyeTrace().HitNormal
				ang = ang:Angle()

				ang:RotateAroundAxis(ang:Up(),90)
				ang:RotateAroundAxis(ang:Forward(),90)

				local w, h = 400, 155
				local x, y = -w/2, -h/2
				cam.Start3D2D(pos,ang,0.11)
					draw.RoundedBox(0,x,y,w,h,Color(33,33,39))
					draw.RoundedBox(0,x,y,w,35,Color(242,108,79))
					draw.SimpleText("Ders Başladı","fdtitle",x+w/2,y,color_white,TEXT_ALIGN_CENTER)
					draw.DrawText("Profesör dersi çoktan başlattı, lütfen dersin\nhuzurunu bozacak şeyler yapmayın.\n\nUzaklaştırma cezası alabilirsiniz.","fdtext",x+10,y+40,color_white)
				cam.End3D2D()
			end
		end
	end
end)