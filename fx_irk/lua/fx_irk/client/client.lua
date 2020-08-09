local draw_what = nil
local draw_what_name = nil
local draw_rec = nil

surface.CreateFont("fx_irk", {
	font = "Open Sans",
	extended = true,
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

surface.CreateFont("fx_irk_big", {
	font = "Open Sans",
	extended = true,
	size = 45,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

hook.Add("DrawOverlay","fx_irk",function()
	if draw_what!=nil and draw_rec!=nil and draw_what_name!=nil then
		if (draw_rec>=CurTime()) then
			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,ScrW(),ScrH())

			surface.SetFont("fx_irk_big")
			local w1, t1 = surface.GetTextSize(draw_what_name)

			surface.SetFont("fx_irk")
			local w2, t2 = surface.GetTextSize("- "..draw_what_name.." olarak seçildin!\n\nÖZELLİKLER\n"..draw_what.ozellik)

			local y = ScrH()/2-(t1+t2-110)/2

			draw.DrawText(draw_what_name,"fx_irk_big",ScrW()/2,y-50,draw_what.renk,TEXT_ALIGN_CENTER)
			draw.DrawText("- "..draw_what_name.." olarak seçildin!\n\nÖZELLİKLER\n"..draw_what.ozellik,"fx_irk",ScrW()/2,y,color_white,TEXT_ALIGN_CENTER)
		end
	end
end)

net.Receive("fx_irk-secim", function()
	local irk = net.ReadString()

	for name, data in pairs(fx_irk.irklar) do
		if (data.realkey==irk) then
			draw_what = data
			draw_what_name = name
			draw_rec = CurTime()+fx_irk.gostermesuresi
		end
	end
end)

local isopen = false
local f

local function fill()
	if isopen==true then return end

	isopen = true

	f = vgui.Create("DFrame")
	local w,h = 300,300
	f:SetSize(w,h)
	f:Center()
	f:SetTitle("Irk Değişim Menüsü")
	f:MakePopup()
	f:SetDraggable(false)
	f.OnClose = function()
		isopen = false
		f:Remove()
	end

	local steamid = vgui.Create("DComboBox",f)
	steamid:Dock(TOP)
	steamid:SetValue("Irk değiştirmek istediğiniz oyuncuyu seçin.")
	steamid:DockMargin(4,4,4,4)

	for _,ply in pairs(player.GetHumans()) do
		steamid:AddChoice(ply:Nick(),ply:SteamID())
	end

	local irk = vgui.Create("DComboBox",f)
	irk:Dock(TOP)
	irk:SetValue("Yeni ırkı seçin.")
	irk:DockMargin(4,4,4,4)

	for name, data in pairs(fx_irk.irklar) do
		irk:AddChoice(name,data.realkey)
	end

	local bilgi = vgui.Create("DCheckBoxLabel",f)
	bilgi:Dock(TOP)
	bilgi:SetText("Hedefe seçilme ekranı yeniden gösterilsin.")
	bilgi:SetValue(1)
	bilgi:SizeToContents()
	bilgi:DockMargin(4,4,4,4)

	local okaybutton = vgui.Create("DButton",f)
	okaybutton:SetText("TAMAM")
	okaybutton:Dock(TOP)
	okaybutton:DockMargin(4,4,4,4)
	okaybutton.DoClick = function()
		local id = steamid:GetOptionData(steamid:GetSelectedID()) or "nil"
		local selectedirk = irk:GetOptionData(irk:GetSelectedID()) or "nil"

		print("irkdegis \""..id.."\" \""..selectedirk.."\" "..(bilgi:GetChecked() and "1" or "0"))
		LocalPlayer():ConCommand("irkdegis \""..id.."\" \""..selectedirk.."\" "..(bilgi:GetChecked() and "1" or "0"))
	end
end

net.Receive("fx_irk-irkdegis",function()
	fill()
end)