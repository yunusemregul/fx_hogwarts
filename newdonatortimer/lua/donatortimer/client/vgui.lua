local isopen = isopen or false
local selectedbutton = nil

local fwid, ftall = 1000, 600
local slpawid = 175
local butall = 40

local c_back 	= Color(34,37,46)
local c_topl 	= Color(52,172,189)
local c_topf 	= Color(61,193,214)
local c_buho 	= Color(28,29,34)
local c_bute 	= Color(51,53,65)
local c_bute_ho = Color(63,65,67)

local c_white = Color(237,239,238)
local c_red = Color(214,60,60)
local c_orange = Color(214,124,60)
local c_yellow = Color(214,201,60)
local c_green = Color(88,214,60)

local f
local sapa

local donators = donators or {}
local logs = logs or {}
local servertime = servertime or 0

local cthemetall = 24

local function preparekalaninfo(time)
	local kalan = "Bitti"
	local color = color_white
	local brut = time-servertime
	local days 
	local hours

	if brut>86400 then
		days = math.floor(brut/86400)
		brut = brut-(days*86400)
		hours = math.floor((brut%86400)/3600,1)
		kalan = days.." gün "..(hours==0 and "" or hours.." saat")
	else 
		if brut<86400 and brut>0 then
			days = 0
			hours = math.floor(brut/3600)
			local mins = math.floor((brut%3600)/60)
			kalan = hours==0 and (mins==0 and "" or mins.." dakika") or hours..(" saat "..(mins==0 and "" or mins.." dakika"))
		else
			days = 0
			hours = 0
		end
	end

	if days<=5 then color = c_red end
	if days<=10 and days>5 then color = c_orange end
	if days<=15 and days>10 then color = c_yellow end
	if days>15 then color = c_green end

	return kalan, color
end

local function filladminmenudonators()
	sapa:Clear()
	local new = vgui.Create("DButton",sapa)
	new:SetText("")
	new:DockMargin(5,5,5,0)
	new:SetTall(cthemetall)
	new:Dock(TOP)
	new.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,c_orange)
		draw.SimpleText("YENI DONATOR","verdana13",w/2,h/2,c_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	new.open = new.open or false
	new.DoClick = function()
		if new.open then return end
		new.open = true 

		new.gui = vgui.Create("DFrame")
		new.gui:SetSize(500,114)
		new.gui:SetTitle("")
		new.gui:Center()
		new.gui:MakePopup()
		new.gui.OnClose = function()
			new.open = false
			new.gui:Remove()
		end
		new.gui.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_back)
		end

		new.gui.steamid = vgui.Create("DComboBox",new.gui)
		new.gui.steamid:SetTall(cthemetall)
		new.gui.steamid:Dock(TOP)
		new.gui.steamid.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_orange)
		end
		new.gui.steamid.DropButton.ComboBox.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_buho)
		end
		new.gui.steamid:SetTextColor(c_white)

		for k,v in pairs(player.GetAll()) do
			new.gui.steamid:AddChoice(v:Name(),v:SteamID64())	
		end

		new.gui.steamid:SetText("Oyuncu")

		new.gui.panl = vgui.Create("DPanel",new.gui)
		new.gui.panl:DockMargin(0,4,0,0)
		new.gui.panl:Dock(TOP)
		new.gui.panl.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_buho)
			draw.SimpleText("Örn: 1 ay/1 yıl/1 hafta","verdana13",347,h/2,c_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
		new.gui.panl.text = vgui.Create("DTextEntry",new.gui.panl)
		new.gui.panl.text:Dock(FILL)
		new.gui.panl.text:DockMargin(1,1,150,1)
		new.gui.panl.text:SetText("SÜRE")
		new.gui.panl.text:SetTextColor(c_white)
		new.gui.panl.text.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_bute_ho)
			s:DrawTextEntryText(s:GetTextColor() or c_white, Color(30, 130, 255), Color(255, 255, 255))
		end
		new.gui.panl.text.OnTextChanged = function()
			local text = new.gui.panl.text:GetText()
			local tabl = string.Explode(" ",text)
			local amount = tabl[1]
			if tabl[3] then
				new.gui.panl.text:SetTextColor(Color(255,0,0))
			end
			if tabl[2]=="ay" and not tabl[3] and tonumber(tabl[1]) then
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*2592000
			elseif tabl[2]=="yıl" and not tabl[3] and tonumber(tabl[1]) then
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*31104000
			elseif tabl[2]=="hafta" and not tabl[3] and tonumber(tabl[1]) then
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*604800
			elseif tabl[2]=="sene" and not tabl[3] and tonumber(tabl[1]) then 
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*31104000
			elseif tabl[2]=="gün" and not tabl[3] and tonumber(tabl[1]) then 
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*86400
			elseif tabl[2]=="saat" and not tabl[3] and tonumber(tabl[1]) then 
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*3600
			elseif tabl[2]=="dakika" and not tabl[3] and tonumber(tabl[1]) then 
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = amount*60
			elseif tabl[1]=="süresiz" then
				new.gui.panl.text:SetTextColor(Color(0,255,0))
				new.gui.panl.data = 999999999999999
			else
				new.gui.panl.text:SetTextColor(Color(255,0,0))
			end
		end
		new.gui.ekle = vgui.Create("DButton",new.gui)
		new.gui.ekle:SetText("")
		new.gui.ekle:DockMargin(0,4,0,0)
		new.gui.ekle:Dock(TOP)
		new.gui.ekle.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_orange)
			draw.SimpleText("EKLE","verdana13",w/2,h/2,c_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		new.gui.ekle.DoClick = function()
			local text,data = new.gui.steamid:GetSelected()
			if not new.gui.panl.data then return end
			print(text,data,new.gui.panl.data)
			RunConsoleCommand("givedonator",data,servertime+new.gui.panl.data)
		end		
	end

	for k,v in pairs(donators) do 
		local dn = vgui.Create("DButton",sapa)
		dn:SetText("")
		dn:SetTall(cthemetall)
		dn:DockMargin(5,5,5,0)
		dn:Dock(TOP)
		local kalantext, color = preparekalaninfo(v.bitecegitarih)
		if v.bitecegitarih-servertime<0 then color = c_red end
		dn.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_back)
			draw.RoundedBox(0,6,6,11,11,color)
			draw.SimpleText(v.name,"verdana13",cthemetall,5,c_white)
			if dn.open then
				draw.RoundedBox(0,0,cthemetall,w,h,c_buho)
				draw.SimpleText("EKLEYEN 					:","verdana13",5,cthemetall+5,color)
				draw.SimpleText(v.ekleyenadi,"verdana13",124,cthemetall+5,c_white)
				draw.SimpleText("BİTECEĞİ TARİH	:","verdana13",5,cthemetall+20,color)
				draw.SimpleText(os.date("%H:%M:%S - %d.%m.%Y", v.bitecegitarih),"verdana13",124,cthemetall+20,c_white)
				draw.SimpleText("KALAN						 :","verdana13",5,cthemetall+35,color)
				draw.SimpleText(kalantext,"verdana13",124,cthemetall+35,c_white)
			end
		end
		dn.open = false
		dn.DoClick = function()
			if dn.open then
				dn:SizeTo(dn:GetWide(), 24, 0.1, 0)
			else
				dn:SizeTo(dn:GetWide(), 80, 0.3, 0)
			end
			dn.open = !dn.open
		end
		dn.sil = vgui.Create("DButton", dn)
		dn.sil:SetWide(30)
		dn.sil:SetText("")
		dn.sil:DockMargin(0,0,0,56)
		dn.sil:Dock(RIGHT)
		dn.sil.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_red)
			draw.SimpleText("Sil","verdana13",w/2,h/2,c_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		dn.sil.open = false
		dn.sil.DoClick = function()
			if dn.sil.open then if IsValid(dn.sil.gui) then dn.sil.gui:MakePopup() end return false end
			dn.sil.open = true

			dn.sil.gui = vgui.Create("DFrame")
			dn.sil.gui:SetSize(300,110)
			dn.sil.gui:MakePopup()
			dn.sil.gui:Center()
			dn.sil.gui:SetTitle("")
			dn.sil.gui.OnClose = function()
				if IsValid(dn.sil) then
					dn.sil.open = false
				end
				dn.sil.gui:Remove()
			end
			dn.sil.gui.Paint = function(s,w,h)
				draw.RoundedBox(0,0,0,w,h,c_back)
				draw.DrawText(v.name.." isimli oyuncunun\ndonatorluğunu silecek misin?","verdana13",w/2,24,c_white,TEXT_ALIGN_CENTER)
			end
			dn.sil.gui.hayir = vgui.Create("DButton",dn.sil.gui)
			dn.sil.gui.hayir:DockMargin(4,0,4,2)
			dn.sil.gui.hayir:Dock(BOTTOM)
			dn.sil.gui.hayir:SetText("")		
			dn.sil.gui.hayir.Paint = function(s,w,h)
				draw.RoundedBox(0,0,0,w,h,c_red)
				draw.SimpleText("HAYIR","verdana13",w/2,h/2,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			dn.sil.gui.hayir.DoClick = function()
				dn.sil.gui:Close()
			end
			dn.sil.gui.evet = vgui.Create("DButton",dn.sil.gui)
			dn.sil.gui.evet:DockMargin(4,0,4,4)
			dn.sil.gui.evet:Dock(BOTTOM)
			dn.sil.gui.evet:SetText("")
			dn.sil.gui.evet.Paint = function(s,w,h)
				draw.RoundedBox(0,0,0,w,h,c_green)
				draw.SimpleText("EVET","verdana13",w/2,h/2,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			dn.sil.gui.evet.DoClick = function()
				RunConsoleCommand("removedonator",v.steamid64)
				dn.sil.gui:Close()
			end
		end
	end
end

local function fillLogs()
	sapa:Clear()
	for k,v in pairs(logs) do 
		local dn = vgui.Create("DButton",sapa)
		dn:SetText("")
		dn:SetTall(cthemetall)
		dn:DockMargin(5,5,5,0)
		dn:Dock(TOP)
		dn.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,c_back)
			local first = string.sub(v.log,0,22)
			surface.SetFont("verdana13")
			local flen = surface.GetTextSize(first)
			local rest = string.sub(v.log,23)
			draw.RoundedBox(0,0,0,flen+8,h,c_buho)
			draw.SimpleText(first,"verdana13",5,5,c_red)
			draw.SimpleText(rest,"verdana13",flen+10,5,c_white)
		end
	end
end

local function showadmin()
	if isopen then return end
	isopen = true

	f = vgui.Create("DFrame")
	f:SetSize(fwid, ftall)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	f:SetDraggable(false)
	f.OnClose = function()
		f:Remove()
		isopen = false
	end
	f.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,c_white)
		draw.RoundedBox(0,0,0,slpawid,24,c_topl)
		draw.RoundedBox(0,slpawid,0,w,24,c_topf)
		--draw.SimpleText("PANEL","verdana13",5,5,c_white)
	end

	local slpa = vgui.Create("DPanel", f)
	slpa:SetWide(slpawid)
	slpa:DockMargin(-5,-5,-5,-5)
	slpa:Dock(LEFT)
	slpa.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,c_back)
	end

	sapa = vgui.Create("DScrollPanel", f)
	sapa:SetWide(slpawid)
	sapa:DockMargin(5,-5,-5,-5)
	sapa:Dock(FILL)
	sapa.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,c_white)
	end

	local dnsb = vgui.Create("DButton", slpa)
	dnsb:SetTall(butall)
	dnsb:Dock(TOP)
	dnsb:SetTextColor(c_white)
	dnsb:SetText("DONATORLAR")
	dnsb:SetFont("verdana20")
	dnsb.Paint = function(s,w,h)
		local color = c_back
		if s:IsHovered() or selectedbutton==s then
			color = c_buho
		else
			color = c_back
		end
		draw.RoundedBox(0,0,0,w,h,color)

		if selectedbutton==s then
			draw.RoundedBox(0,0,0,4,h,c_topf)
		end
	end
	dnsb.DoClick = function()
		selectedbutton = dnsb
		filladminmenudonators()
	end

	local logs = vgui.Create("DButton", slpa)
	logs:SetTall(butall)
	logs:Dock(TOP)
	logs:SetTextColor(c_white)
	logs:SetText("LOGLAR")
	logs:SetFont("verdana20")
	logs.Paint = function(s,w,h)
		local color = c_back
		if s:IsHovered() or selectedbutton==s then
			color = c_buho
		else
			color = c_back
		end
		draw.RoundedBox(0,0,0,w,h,color)

		if selectedbutton==s then
			draw.RoundedBox(0,0,0,4,h,c_topf)
		end
	end
	logs.DoClick = function()
		selectedbutton = logs
		fillLogs()
	end
end

local mydata = mydata or {}
local function showdonator()
	if isopen then return end
	isopen = true

	local f = vgui.Create("DFrame")
	f:SetTitle("")
	f:SetSize(500,100)
	f:Center()
	f:MakePopup()
	f.OnClose = function()
		isopen = false
		f:Remove()
	end

	local kalan, color = preparekalaninfo(mydata[1].bitecegitarih)

	f.Paint = function(s,w,h)
		draw.RoundedBox(0,5,30,w-10,cthemetall,c_buho)
		draw.RoundedBox(0,15,30+cthemetall,w-30,40,Color(c_buho.r+10,c_buho.g+10,c_buho.b+10))
		draw.SimpleText(LocalPlayer():Name(),"verdana20",w/2,31.5,c_white,TEXT_ALIGN_CENTER)
		
		draw.SimpleText("Donatorluğu veren:","verdana13",20,30+cthemetall+5,Color(121,121,121))
		draw.SimpleText("Kalan süre:","verdana13",20,30+cthemetall+20,Color(121,121,121))

		draw.SimpleText(mydata[1].ekleyenadi,"verdana13",w/2,30+cthemetall+5,c_orange,TEXT_ALIGN_CENTER)
		draw.SimpleText(kalan,"verdana13",w/2,30+cthemetall+20,color,TEXT_ALIGN_CENTER)
	end
end

local function showcustomer()
	gui.OpenURL("http://steamcommunity.com/id/acnyrt/")
end

--[[
	0 = admin
	1 = donator
	2 = customer
]]

local menutypes = {
	[0] = showadmin,
	[1] = showdonator,
	[2] = showcustomer
}

net.Receive("donatortimer-menu", function()
	local menutype = net.ReadInt(4)
	servertime = net.ReadInt(32)
	
	if (menutype == 0) then 
		donators = net.ReadTable() 
		logs = net.ReadTable() 
		table.sort(donators, function(a, b) return a.bitecegitarih<b.bitecegitarih end) 
		table.sort(logs, function(a, b) return a.date>b.date end) 
	end
	
	if (menutype == 1) then 
		mydata = net.ReadTable()
	end

	menutypes[menutype]()
end)