include("shared.lua");

surface.CreateFont("muratyalanimisumutsahayal", {
	font = "Open Sans", 
	extended = true,
	size = 24,
	weight = 500,
	blursize = 0,
})

function ENT:Draw()
	self:DrawModel();

	local pos, ang = self:GetPos(), self:GetAngles();
	local rmin, rmax = self:GetRenderBounds();

	ang:RotateAroundAxis(self:GetUp(),90);
	ang:RotateAroundAxis(self:GetRight(),-90);
	ang:RotateAroundAxis(self:GetUp(),0)

	local w,h = 200,40;
	zero = -w*.56;
	cam.Start3D2D(pos+self:GetUp()*(rmax-rmin)+self:GetUp()*3,ang,0.1)
		draw.RoundedBox(0,zero,0,w,h,Color(30,30,30))
		surface.SetDrawColor(242,108,79)
		surface.DrawOutlinedRect(zero,0,w,h)
		draw.SimpleText("Kütüphane Görevlisi","muratyalanimisumutsahayal",zero+w/2,h/2,Color(242,108,79),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	cam.End3D2D()
end