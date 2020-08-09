local isopen = false
local f

local checks = {}

local homes = {
	"gryffindor",
	"hufflepuff",
	"ravenclaw",
	"slytherin",
	"evsiz"
}

surface.CreateFont("sec_tit", {
	font = "Open Sans",
	extended = true,
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

local MAT_GRYFFINDOR = 1
local MAT_HUFFLEPUFF = 2
local MAT_RAVENCLAW = 3
local MAT_SLYTHERIN = 4

local mats = {
	[MAT_GRYFFINDOR] = "ev_sistemi/gryffindor.png",
	[MAT_HUFFLEPUFF] = "ev_sistemi/hufflepuff.png",
	[MAT_RAVENCLAW] = "ev_sistemi/ravenclaw.png",
	[MAT_SLYTHERIN] = "ev_sistemi/slytherin.png"
}

local mats_string_id = {
	["gryffindor"] = MAT_GRYFFINDOR,
	["hufflepuff"] = MAT_HUFFLEPUFF,
	["ravenclaw"] = MAT_RAVENCLAW,
	["slytherin"] = MAT_SLYTHERIN
}

local function addcheck(key, panel, type)
	if type=="combobox" then
		checks[key] = panel:GetValue()
		panel.OnSelect = function()
			checks[key] = panel:GetValue()
		end
		return
	end

	if type=="textentry" then
		checks[key] = panel:GetValue()
		panel.OnTextChanged = function()
			checks[key] = panel:GetValue()
		end 
		return
	end

	if type=="checkbox" then
		checks[key] = panel:GetChecked()
		panel.OnChange = function()
			checks[key] = panel:GetChecked()
		end 
		return		
	end
	if isnumber(panel:GetValue()) then
		checks[key] = math.Round(panel:GetValue())
		panel.OnValueChanged = function()
			checks[key] = math.Round(panel:GetValue())
		end 
	else
		checks[key] = panel:GetValue()
		panel.OnValueChanged = function()
			checks[key] = panel:GetValue()
		end 
	end
end

local function _menu()
	if isopen then return end
	isopen = true

	checks = {}

	local w,t = 300, 120
	f = vgui.Create("DFrame")
	f:SetSize(w,t)
	f:SetTitle("")
	f:Center()
	f:MakePopup()
	f.OnClose = function()
		isopen = false
		f:Remove()
	end
	f.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
	end

	local dcombo = vgui.Create("DComboBox",f)
	dcombo:Dock(TOP)
	dcombo:DockMargin(3,3,3,3)
	dcombo:SetValue("Evi değiştirilecek oyuncuyu seçin..")
	for i=1,#player.GetAll() do
		dcombo:AddChoice(player.GetAll()[i]:Nick())
	end
	addcheck("nick", dcombo, "combobox")

	local new_home = vgui.Create("DComboBox",f)
	new_home:Dock(TOP)
	new_home:SetValue("Yeni evi seçin")
	new_home:DockMargin(3,3,3,3)
	for i=1,#homes do 
		new_home:AddChoice(homes[i])
	end
	addcheck("home", new_home, "combobox")

	local onayla = vgui.Create("DButton",f)
	onayla:Dock(TOP)
	onayla:DockMargin(3,3,3,3)
	onayla:SetText("ONAYLA")
	onayla:SetColor(color_white)
	onayla.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
	end
	onayla.DoClick = function()
		if checks.nick and checks.home then
			local target = nil

			for i=1,#player.GetAll() do
				if player.GetAll()[i]:Nick()==checks.nick then
					target = player.GetAll()[i]
				end
			end

			if target==nil then
				chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'Hedef bulunamadi!')
				return
			end	

			if not table.HasValue(homes, checks.home) then
				chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'Girdiginiz ev bulunamadi!')
				return
			end			

			net.Start("ev_degistir")
				net.WriteEntity(target)
				net.WriteString(checks.home)
			net.SendToServer()
		end
	end
end

net.Receive("ev_degisim_menu", function()
	_menu()
end)
/*
hook.Add("HUDPaint","ev_hudpaint_ev",function()
	if (LocalPlayer():GetNWString("hogwarts_ev","yok")!="yok") then
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(Material(mats[mats_string_id[LocalPlayer():GetNWString("hogwarts_ev")]]))
		surface.DrawTexturedRect(5,5,176*(ScrW()/1366),176*(ScrH()/768))
	else
		draw.WordBox(2,5,5,"Evin yok, Büyük Salon'da Seçmen Şapkaya gitmelisin!","sec_tit",Color(20,20,20,100),color_white)
	end
end)*/
hook.Remove("HUDPaint","ev_hudpaint_ev")