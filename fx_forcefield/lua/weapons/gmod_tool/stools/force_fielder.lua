TOOL.Category = "fx"
TOOL.Name = "Force Fields"

TOOL.ClientConVar["r"] = "255"
TOOL.ClientConVar["g"] = "255"
TOOL.ClientConVar["b"] = "255"

if DarkRP then
	for i=1, #RPExtraTeams do 
		TOOL.ClientConVar["teams_"..i] = "false"
	end
end

if CLIENT then
	surface.CreateFont("fx_field", {
		font = "Open Sans",
		extended = true,
		size = 30,
		shadow = true,
		blursize = 0,
		antialias = true
	})
	surface.CreateFont("fx_field_s", {
		font = "Open Sans",
		extended = true,
		size = 20,
		shadow = true,
		blursize = 0,
		antialias = true
	})
end

function TOOL:LeftClick(trace)
	if trace.HitNonWorld then return end

	if self:GetOwner().min then
		self:GetOwner().max = trace.HitPos
		local max, min = self:GetOwner().max, self:GetOwner().min
		local size = (max-min)
		local x, y, z = size.x, size.y, size.z 
		if SERVER then
			/*local corners = {
				--ön yüz
				{pos = size},
				{pos = size - Vector(0,0,z)},
				{pos = Vector(0,y,0)},
				{pos = size},
				{pos = size - Vector(x,0,0)},
				{pos = Vector(0,y,0)},

				--arka yüz
				{pos = size - Vector(0,y,0)},
				{pos = Vector(x,0,0)},
				{pos = Vector(0,0,0)},
				{pos = size - Vector(0,y,0)},
				{pos = Vector(0,0,z)},
				{pos = Vector(0,0,0)},				
			}*/

	/*		if self:GetOwner().prop and IsValid(self:GetOwner().prop) then
				self:GetOwner().prop:Remove()
			end*/
			local field = ents.Create("force_field")
			field._max = max
			field._min = min	

			field.allowed_teams = {}
			for i=1,#RPExtraTeams do
				if self:GetClientNumber("teams_"..i)==1 then
					field.allowed_teams[i] = true
				end
			end		

			local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
			local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
			local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )

			field:SetColor(Color(r, g, b))
			field:SetPos(min+size/2)
			field:Spawn()
		end

		self:GetOwner().min = nil
		self:GetOwner().max = nil
		return true
	end
	self:GetOwner().min = trace.HitPos
	
	return true
end

function TOOL:Reload()
	self:GetOwner().min = nil
	self:GetOwner().max = nil
/*	if self:GetOwner().prop and IsValid(self:GetOwner().prop) then
		self:GetOwner().prop:Remove()
	end*/
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Text = "Force Fields", Description = "Fizişik bloklar yaratmanı sağlar." })
 
--[[	panel:AddControl("CheckBox", {
	    Label = "A Boolean Value",
	    Command = "example_bool"
	})]]
 
	panel:AddControl( "Color", { Label = "Renk", Red = "force_fielder_r", Green = "force_fielder_g", Blue = "force_fielder_b" } )


	panel:AddControl("Label", { Text = "Hangi meslekler içinden geçebilir?"})
	if DarkRP then
		for i=1, #RPExtraTeams do 
			panel:AddControl("CheckBox", {Label = RPExtraTeams[i].name, Command = "force_fielder_teams_"..i})
		end
	end
end

function TOOL:DrawHUD()
	if IsValid(self:GetOwner():GetEyeTrace().Entity) and (self:GetOwner():GetEyeTrace().Entity:GetClass()=="force_field") then
		local ent = self:GetOwner():GetEyeTrace().Entity
		local y = (ScrH()/768)*200
		draw.SimpleText(ent:GetClass(),"fx_field",ScrW()/2,y,color_white, TEXT_ALIGN_CENTER)
		local str = ""
		if ent.allowed_teams and DarkRP and str=="" then
			for key, value in pairs(ent.allowed_teams) do
				str = str.."\n"..RPExtraTeams[key].name
			end
		end
		draw.DrawText(str,"fx_field_s",ScrW()/2,y+7, Color(128,255,128), TEXT_ALIGN_CENTER)
	end
end

hook.Add("PostDrawOpaqueRenderables", "ff_opaquerenderables", function()
/*	local max, min = LocalPlayer().max, LocalPlayer().min
	if max and min then
		local size = max - min 
		local x, y, z = size.x, size.y, size.z 
		local corners = {
			max, 
			max - Vector(0,0,z),
			max - Vector(0,y,0),
			max - Vector(x,0,0),
			min + Vector(0,0,z),
			min + Vector(0,y,0),
			min + Vector(x,0,0),
			min
		}
		local r = math.Clamp( GetConVar("force_fielder_r"):GetInt(), 0, 255 )
		local g = math.Clamp( GetConVar("force_fielder_g"):GetInt(), 0, 255 )
		local b = math.Clamp( GetConVar("force_fielder_b"):GetInt(), 0, 255 )

		cam.Start3D2D( max, Angle(0,0,90), 1 )
			surface.SetDrawColor(  Color(r, g, b, 255) )

			local x = ( b_tonumber(max.x < corners[4].x) * max:Distance(corners[4]) )
			local y = ( b_tonumber(max.z > corners[2].z) * max:Distance(corners[2]) )

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
	end*/
/*
	local min = LocalPlayer().min
	local max = LocalPlayer().max

	local r = math.Clamp(GetConVar("force_fielder_r"):GetInt(), 0, 255 )
	local g = math.Clamp(GetConVar("force_fielder_g"):GetInt(), 0, 255 )
	local b = math.Clamp(GetConVar("force_fielder_b"):GetInt(), 0, 255 )

	if min and not max then
		render.DrawWireframeBox(min,Angle(0,0,0),Vector(0,0,0),LocalPlayer():GetEyeTrace().HitPos-min,Color(r,g,b),true)			
	end*/
end)

hook.Add("HUDPaint","asdasdas",function()
/*
		local max, min = LocalPlayer().max, LocalPlayer().min
		local size = max - min 
		local x, y, z = size.x, size.y, size.z 
		local corners = {
			max, 
			max - Vector(0,0,z),
			max - Vector(0,y,0),
			max - Vector(x,0,0),
			min + Vector(0,0,z),
			min + Vector(0,y,0),
			min + Vector(x,0,0),
			min
		}

		for i=1,#corners do
			draw.SimpleText(i,"chatfont",corners[i]:ToScreen().x,corners[i]:ToScreen().y,color_white)
		end
*/
end)