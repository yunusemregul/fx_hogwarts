include("shared.lua")

function ENT:CalculateCorners()
	local size = self._max - self._min 
	local x, y, z = size.x, size.y, size.z 
		self._corners = {
		self._max, 
		self._max - Vector(0,0,z),
		self._max - Vector(0,y,0),
		self._max - Vector(x,0,0),
		self._min + Vector(0,0,z),
		self._min + Vector(0,y,0),
		self._min + Vector(x,0,0),
		self._min
	}
end 

function ENT:Initialize()
	self.bounds_been_set = false
end

local function b_tonumber( bool )
	return (bool == true) and 1 or -1
end 

function ENT:Draw()
	local pos, ang = self:GetPos(), self:GetAngles()

	if self._min and self._max then
		if not self.bounds_been_set then
			self:SetRenderBounds(self.min,self.max)
			self:CalculateCorners()
			self.bounds_been_set = true
		end

		--render.SetColorMaterial()
		--render.DrawBox(pos,ang,self.min,self.max,self:GetColor(),true)
		--render.DrawWireframeBox(self:GetPos(),self:GetAngles(),self.min,self.max,self:GetColor(),true)

		local corners = self._corners 
		local min = self._min 
		local max = self._max 
		local clr = self:GetColor() 
		local r, g, b = clr.r, clr.g, clr.b

		cam.Start3D2D( max, Angle(0,0,0), 1 ) 
			surface.SetDrawColor( Color(r, g, b, 255) )

			local x = ( b_tonumber(max.x < corners[4].x) * max:Distance(corners[4]) )
			local y = ( b_tonumber(max.y > corners[3].y) * max:Distance(corners[3]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()

		cam.Start3D2D( max, Angle(0,0,90), 1 )
			surface.SetDrawColor(  Color(r, g, b, 255) )

			local x = ( b_tonumber(max.x < corners[4].x) * max:Distance(corners[4]) )
			local y = ( b_tonumber(max.z > corners[2].z) * max:Distance(corners[2]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()

		cam.Start3D2D( max, Angle(90,0,0), 1 )
			surface.SetDrawColor( Color(r, g, b, 255) )

			local x = ( b_tonumber(max.z > corners[2].z) * max:Distance(corners[2]) )
			local y = ( b_tonumber(max.y > corners[3].y) * max:Distance(corners[3]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()

		cam.Start3D2D( min, Angle(0,0,0), 1 ) 
			surface.SetDrawColor( Color(r, g, b, 255) )

			local x = ( b_tonumber(min.x < corners[7].x) * min:Distance(corners[7]) )
			local y = ( b_tonumber(min.y > corners[6].y) * min:Distance(corners[6]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()

		cam.Start3D2D( min, Angle(0,0,90), 1 ) 
			surface.SetDrawColor( Color(r, g, b, 255) )

			local x = ( b_tonumber(min.x < corners[7].x) * min:Distance(corners[7]) )
			local y = ( b_tonumber(min.z > corners[5].z) * min:Distance(corners[5]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()

		cam.Start3D2D( min, Angle(90,0,0), 1 ) 
			surface.SetDrawColor( Color(r, g, b, 255) )

			local x = ( b_tonumber(min.z > corners[5].z) * min:Distance(corners[5]) )
			local y = ( b_tonumber(min.y > corners[6].y) * min:Distance(corners[6]) )

			surface.DrawOutlinedRect( 0, 0, x, y )
			surface.SetDrawColor( Color(r, g, b, 10) )
		    surface.DrawRect(0, 0, x, y)
		cam.End3D2D()
	end
end

net.Receive("force_field_shareteams", function()
	local ent = net.ReadEntity()

	if not ent or not IsValid(ent) then 
		net.Start("force_field_shareteams")
		net.SendToServer()
		MsgC(Color(255,128,128),"HATA: 'force_field_shareteams' ent bulunamadi (ISTEK GONDERILDI)\n")
		return 
	end

	ent.allowed_teams = {}
	local size = net.ReadInt(8)

	for i=1,size do 
		local str = net.ReadString()
		local ex = string.Explode(";",str)
		ent.allowed_teams[tonumber(ex[1])] = tobool(ex[2])
	end
end)