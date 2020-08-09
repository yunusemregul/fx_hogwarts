include("shared.lua")
include("config.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

surface.CreateFont("sec_tit", {
	font = "Harry P",
	extended = true,
	size = 60,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

surface.CreateFont("sec_tit_bigga", {
	font = "Open Sans",
	extended = true,
	size = 36,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()+Vector(0,0,30)
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Right(),-90)
	ang:RotateAroundAxis(ang:Up(),90)


	cam.Start3D2D(pos, Angle(0,LocalPlayer():EyeAngles().y-90,90), 0.11)
		draw.SimpleText("Secmen Sapka","sec_tit",-115,0,Color(233,233,233), 3)
--[[		draw.RoundedBox(0,0,0,200,200,color_white)
		draw.SimpleText("up","chatfont",100,5,Color(0,0,0),TEXT_ALIGN_CENTER)
		draw.SimpleText("down","chatfont",100,180,Color(0,0,0),TEXT_ALIGN_CENTER)
		draw.SimpleText("left","chatfont",5,100,Color(0,0,0),TEXT_ALIGN_LEFT)]]
	cam.End3D2D()
end

local isopen = false

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

local mats_info = {
	["gryffindor"] = "* Godric Gryffindor tarafından kurulmuştur.\n* Cesur ve özgüvenlidirler.\n* Her türlü ırka sahip birey bu binaya girebilir.",
	["hufflepuff"] = "* Helga Hufflepuff tarafından kurulmuştur.\n* Masum, sakin ve adaletlilerdir.\n* Her türlü ırka sahip birey bu binaya girebilir.",
	["ravenclaw"] = "* Rowena Ravenclaw tarafından kurulmuştur.\n* Zeki,çevik ve bilgedirler.\n* Bu binaya yeni şeyler öğrenmeyi ve bilgi peşinde koşma-\nyı en çok seven öğrenciler de kabul edilir.",
	["slytherin"] = "* Salazar Slytherin tarafından kurulmuştur.\n* Salazar Slytherin bir çatalağızdır.\n* Sinsi ve kurnazdırlar.\n* Diğer binalara göre Slytherin, güce ulaşabilmek adına daha hırslılardır."
}

ev_chosen_pop_up = ev_chosen_pop_up or 0
local f

local function _menu()
	if isopen then return end
	if (LocalPlayer():GetNWString("hogwarts_ev","yok")!="yok") then ev_chosen_pop_up = CurTime()+10 return end
	isopen = true

	local w,h = ScrW(), ScrH()
	f = vgui.Create("DFrame")
	f:SetSize(w,h)
	f:Center()
	f:MakePopup()
	f:SetTitle("")
	f:SetDraggable(false)
	f.OnClose = function()
		isopen = false
		f:Remove()
	end
	f.Paint = function(s,w,h)
--[[		draw.RoundedBox(0,0,0,w,h,Color(20,20,20,250))
		draw.RoundedBox(0,5,27,w-10,h-32,Color(20,20,20,240))]]
	end

	local w,h = 1200, 295
	local p = vgui.Create("DPanel",f)
	p:SetSize(w,h)
	p:Center()
	p.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
		local out = 4
		draw.RoundedBox(0,out,out,w-out*2,h-out*2,Color(30,30,30))
		draw.RoundedBox(0,out,out+30,w-out*2,155,Color(40,40,40))
		
		for k,v in pairs(mats) do
			local slid = 209
			draw.RoundedBox(0,slid*k,33,156,156,Color(35,35,35))
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(Material(v))
			surface.DrawTexturedRect(slid*k,33,156,156)
		end
--[[		surface.SetDrawColor(255,255,255)
			surface.DrawLine(w/2,0,w/2,h)	]]	
	end

	local w,h = 200, 50
	local set_ev = vgui.Create("DButton",p)
	set_ev:SetText("Evimi Belirle")
	set_ev:SetSize(w,h)
	set_ev:SetPos(1200/2-w/2,215)
	set_ev:SetColor(Color(240,240,240))
	set_ev:SetFont("sec_tit")
	set_ev.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(240,50,20))
	end
	set_ev.DoClick = function()
		net.Start("ev_net_belirle")
		net.SendToServer()
	end
end

net.Receive("ev_net_menu", function()
	_menu()
end)

net.Receive("ev_net_belirle", function()
	if f and IsValid(f) then
		f:Close()
		f = nil
	end

	local chosen = net.ReadString()
	ev_chosen_pop_up = CurTime()+18 
	surface.PlaySound("ev_sistemi/before_secim.wav")
	timer.Simple(8,function() surface.PlaySound("ev_sistemi/"..chosen..".wav") end)
end)

hook.Add("DrawOverlay", "ev_hudpaint", function()
	if ev_chosen_pop_up>=CurTime() then
		draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(10,10,10,255))
		--draw.SimpleText(ev_chosen_pop_up-CurTime(),"sec_tit",5,5,color_white)
		if ((ev_chosen_pop_up-CurTime()))>=10 then
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(Material("ev_sistemi/background.png"))
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())			
		elseif ((ev_chosen_pop_up-CurTime()))>=6 and ((ev_chosen_pop_up-CurTime()))<10 and (LocalPlayer():GetNWString("hogwarts_ev","yok")!="yok") then
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(Material(mats[mats_string_id[LocalPlayer():GetNWString("hogwarts_ev")]]))
			surface.DrawTexturedRect(ScrW()/2-256/2,ScrH()/2-256/2-20,256,256)
			draw.SimpleText(LocalPlayer():GetNWString("hogwarts_ev"):upper().." binasına seçildin!","sec_tit_bigga",ScrW()/2,ScrH()/2+256/2-10,color_white,TEXT_ALIGN_CENTER)
		else
			if (LocalPlayer():GetNWString("hogwarts_ev","yok")!="yok") then
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material(mats[mats_string_id[LocalPlayer():GetNWString("hogwarts_ev")]]))
				surface.DrawTexturedRect(ScrW()/8-256/2,ScrH()/2-256/2-20,256,256)

				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material(mats[mats_string_id[LocalPlayer():GetNWString("hogwarts_ev")]]))
				surface.DrawTexturedRect(ScrW()-(256+(ScrW()/8-256/2)),ScrH()/2-256/2-20,256,256)

				surface.SetFont("sec_tit_bigga")
				local text = LocalPlayer():GetNWString("hogwarts_ev"):upper().." binasının özellikleri;"
				local wd, tl = surface.GetTextSize(text)
				surface.SetFont("sec_tit_bigga")
				local text2 = mats_info[LocalPlayer():GetNWString("hogwarts_ev")]
				local wd2, tl2 = surface.GetTextSize(text)
				local y = ScrH()/2-(tl+tl2)
				draw.SimpleText(text,"sec_tit_bigga",ScrW()/2,y,color_white,TEXT_ALIGN_CENTER)
				draw.DrawText(text2,"sec_tit_bigga",ScrW()/2,y+40,color_white,TEXT_ALIGN_CENTER)
			end
		end
	end
end)