TOOL.Category = "Debugging"
TOOL.Name = "Sınıf Oluşturucu"

if SERVER then
	return
end

language.Add("tool.fx_d_siniftool.name", "Sınıf Oluşturucu")
language.Add("tool.fx_d_siniftool.0", "Sol Klik: Birinci ya da ikinci konumu belirler. Sağ Klik: Konsolunuza yazar.")
language.Add("tool.fx_d_siniftool.desc", "Sınıflar için konum yardımcısı.")

fx_d_siniftool = fx_d_siniftool or {}
fx_d_siniftool.selecting = fx_d_siniftool.selecting or 1
fx_d_siniftool.selected = {}

local r_delay = 0

function TOOL:RightClick(tr)
	if not LocalPlayer():IsAdmin() then 
		notification.AddLegacy("Yetkili olmanız gerek!",1,5)
		return false 
	end
	if (CurTime()<r_delay) then return false end
	if not fx_d_siniftool.selected.min or not fx_d_siniftool.selected.max then return false end
	r_delay = CurTime()+0.1

	MsgC(Color(255,0,0),"[FX-DERS-SINIFTOOL] Konum Bilgileri;\n")
	print("\tkonum = {min = Vector("..(math.Round(fx_d_siniftool.selected.min.x,2))..", "..(math.Round(fx_d_siniftool.selected.min.y,2))..", "..(math.Round(fx_d_siniftool.selected.min.z,2)).."), max = Vector("..(math.Round(fx_d_siniftool.selected.max.x,2))..", "..(math.Round(fx_d_siniftool.selected.max.y,2))..", "..(math.Round(fx_d_siniftool.selected.max.z,2))..")}\n")
	fx_d_siniftool.selecting = 1
	fx_d_siniftool.selected = {}
	notification.AddLegacy("Bilgiler konsolunuza yazdırıldı! \" tuşuna basarak açabilirsiniz.",0,5)
	return true
end

local l_delay = 0

function TOOL:LeftClick(tr)
	if not LocalPlayer():IsAdmin() then 
		notification.AddLegacy("Yetkili olmanız gerek!",1,5)
		return false 
	end
	if (CurTime()<l_delay) then return false end

	l_delay = CurTime()+0.1

	if (fx_d_siniftool.selecting==1) then
		fx_d_siniftool.selected.min = tr.HitPos
		fx_d_siniftool.selecting = 2
		return true
	end
	if (fx_d_siniftool.selecting==2) then
		fx_d_siniftool.selected.max = tr.HitPos
		fx_d_siniftool.selecting = 1
		return true
	end

	return false
end


function TOOL.BuildCPanel(cp)
	cp:AddControl("Header",{"Sınıf Bilgileri"})
end


local function drawShadowyText(text, font, x, y, color, alignX, alignY)
	return draw.TextShadow({
		text = text,
		font = font,
		pos = {x, y},
		color = color,
		xalign = alignX or 0,
		yalign = alignY or 0
	}, 1, alpha or (color.a * 0.575))
end

hook.Add("HUDPaint","fx_d_siniftool",function()
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():Alive() and LocalPlayer():IsAdmin() and LocalPlayer():GetActiveWeapon():GetClass()=="gmod_tool" and (GetConVarString("gmod_toolmode")=="fx_d_siniftool") then
			for sinif, data in pairs(fx_d.siniflar) do
				if not data.konum or not data.konum.min or not data.konum.max then continue end
				if not isvector(data.konum.min) or not isvector(data.konum.max) then continue end

				local vec = data.konum.min+(data.konum.max-data.konum.min)/2
				local vecdat = vec:ToScreen()
			
				drawShadowyText(sinif, "siniftitle", vecdat.x, vecdat.y, (data.renk or Color(255,0,128)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				local min, max = data.konum.min, data.konum.max

				OrderVectors(min,max)
				if (LocalPlayer():GetPos()+LocalPlayer():OBBCenter()):WithinAABox(min,max) then
					drawShadowyText(sinif, "siniftitle_big", ScrW()/2, ScrH()/6, (data.renk or Color(255,0,128)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
				end
			end
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables","fx_d_siniftool",function()
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():Alive() and LocalPlayer():IsAdmin() and LocalPlayer():GetActiveWeapon():GetClass()=="gmod_tool" and (GetConVarString("gmod_toolmode")=="fx_d_siniftool") then
			for sinif, data in pairs(fx_d.siniflar) do
				if not data.konum or not data.konum.min or not data.konum.max then continue end
				if not isvector(data.konum.min) or not isvector(data.konum.max) then continue end

				render.DrawWireframeBox(data.konum.min,Angle(0,0,0),Vector(0,0,0),data.konum.max-data.konum.min,(data.renk or Color(255,0,128)),true)
			end

			if fx_d_siniftool.selected.min and not fx_d_siniftool.selected.max then
				render.DrawWireframeBox(fx_d_siniftool.selected.min,Angle(0,0,0),Vector(0,0,0),LocalPlayer():GetEyeTrace().HitPos-fx_d_siniftool.selected.min,Color(255,0,0),true)	
			elseif fx_d_siniftool.selected.min and fx_d_siniftool.selected.max then
				render.DrawWireframeBox(fx_d_siniftool.selected.min,Angle(0,0,0),Vector(0,0,0),fx_d_siniftool.selected.max-fx_d_siniftool.selected.min,Color(255,0,0),true)				
			end
		end
	end
end)