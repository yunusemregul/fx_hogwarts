local main_f -- main frame
local queue_f -- queue frame
local derscombo
local sureslid
local sinifcombo
local buyuver
local konuentry
local gryf
local huffle
local raven
local slyt
local dersno = 1
local d_menu

local ders_draw = 0
local ders_lined = false

local isopen = false

local checks = {}

fx_ders_hp_time = fx_ders_hp_time or 0
fx_ders_hp_table = fx_ders_hp_table or {{},{}};
fx_ders_hp_queue = fx_ders_hp_queue or {{},{}};

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

local function addcheck(key, panel, type)
	if type=="combobox" then
		checks[key] = panel:GetValue()
		panel.OnSelect = function()
			checks[key] = panel:GetValue()
			if key=="dersno" then
				dersno = tonumber(panel:GetValue())
				main_f:Close() -- yeniliyoruz :)
				d_menu()
			end
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

d_menu = function()
	if isopen then return end
	isopen = true
	checks = {}

	main_f = vgui.Create("DFrame")
	local w, h = 500, 600--405
	main_f:SetSize(w,h)
	main_f:SetTitle("")
	main_f:MakePopup()
	main_f:Center()
	main_f.OnClose = function()
		isopen = false
		main_f:Remove()
		queue_f:Remove()
		fx_d_print("Ders menüsü kapatıldı!")
	end
	main_f.Paint = function(s,w,h)
		draw.RoundedBox(6,0,0,w,h,Color(0,0,0,220))
	end

	queue_f = vgui.Create("DFrame")
	queue_f:SetSize(w,h)
	queue_f:SetTitle("")
	queue_f:ShowCloseButton(false)
	queue_f.Paint = function() end
	local x,y = main_f:GetPos()
	queue_f:SetPos(x+w+6,y)

	local tp = vgui.Create("fx_d_titlepanel",queue_f)
	tp:SetText("1. Ders İçin Sıra","fx_d_normal")
	tp:DockMargin(0,5,5,0)
	tp:Dock(TOP)
	tp:SetTall(h/2-12)

	local q1 = vgui.Create("DListView",tp)
	q1:Dock(FILL)
	q1:AddColumn("Sıra")
	q1:AddColumn("Başlatacak Prof.")
	q1:AddColumn("Ders")
	q1:AddColumn("Konu")
	q1:AddColumn("Sınıf")
	q1:AddColumn("Süre")

	local tp = vgui.Create("fx_d_titlepanel",queue_f)
	tp:SetText("2. Ders İçin Sıra","fx_d_normal")
	tp:DockMargin(0,5,5,0)
	tp:Dock(FILL)
	
	local q2 = vgui.Create("DListView",tp)
	q2:Dock(FILL)
	q2:AddColumn("Sıra")
	q2:AddColumn("Başlatacak Prof.")
	q2:AddColumn("Ders")
	q2:AddColumn("Konu")
	q2:AddColumn("Sınıf")
	q2:AddColumn("Süre")

	for i=1,2 do
		for _, tab in ipairs(fx_ders_hp_queue[i]) do
			local toadd;
			if i==1 then
				toadd = q1;
			end
			if i==2 then
				toadd = q2;
			end

			toadd:AddLine(_,tab.prof,tab.ders,tab.konu,tab.sinif,(string.len(math.floor((tab.time/60)))==1 and "0"..(math.floor((tab.time/60))) or (math.floor((tab.time/60))))..":"..(string.len(tab.time%60)==1 and "0"..(tab.time%60) or (tab.time%60)));
		end
	end

	local scroll = vgui.Create("DScrollPanel",main_f)
	scroll:Dock(FILL)
	local sbar = scroll:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 31, 31, 31 ) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 26, 26, 26 ) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 26, 26, 26 ) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 41, 41 ) )
	end

	local dl = vgui.Create("fx_d_labelpanel",scroll)
	dl:SetText("Hoşgeldin "..LocalPlayer():Nick().."!\nBaşlamadan önce hangi dersi ne kadar süreyle ve hangi sınıfta baş-\nlatacağını seçmelisin.","fx_d_normal")
	dl:Dock(TOP)
	dl:DockMargin(0,5,5,0)

	local tp = vgui.Create("fx_d_titlepanel",scroll)
	tp:SetText("Ders Numarası","fx_d_normal")
	tp:DockMargin(0,5,5,0)
	tp:Dock(TOP)

	dersnocombo = vgui.Create("DComboBox",tp)
	dersnocombo:Dock(TOP)
	dersnocombo:SetText("Bir ders seçin...")
	dersnocombo:AddChoice("1")
	dersnocombo:AddChoice("2")
	dersnocombo:ChooseOption(tostring(dersno),dersno)
	tp:SizeToContentsY(12)
	addcheck("dersno", dersnocombo, "combobox")

	if fx_ders_hp_table[dersno].time and fx_ders_hp_table[dersno].time>=CurTime() then
		local dersbitir = vgui.Create("DButton",scroll)
		dersbitir:Dock(TOP)
		dersbitir:DockMargin(0,5,5,0)
		dersbitir:SetText("Aktif dersi bitir")
		dersbitir:SetTextColor(color_white)
		dersbitir.Paint = function(s,w,h)
			local col = Color(231,31,31)
			draw.RoundedBox(0,0,0,w,h,col)
		end
		dersbitir.DoClick = function()
			net.Start("fx_ders_end_ders")
				net.WriteInt(dersno,4)
			net.SendToServer()
		end
	end

	/* derste verilecek büyü */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Ders Sonunda Verilecek Büyü","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)

		local dmenu;

		buyuver = vgui.Create("DTextEntry",tp)
		buyuver:SetText("Verilecek büyünün ismi..")
		buyuver:Dock(TOP)
		buyuver.OnValueChange = function(val)
			val = val:GetValue()
			if IsValid(dmenu) then
				dmenu:Remove()
			end
			dmenu = DermaMenu()
			local posx, posy = select(1,main_f:GetPos())-200, select(2,main_f:GetPos())
			dmenu:SetPos(posx,posy)
			for spellname, _ in pairs(HpwRewrite:GetSpells()) do
				if spellname:lower():find(val) and fx_d_cangivespell(spellname) then
					dmenu:AddOption(spellname,function() 
						buyuver:SetValue(spellname)
					end)
				end
			end
			dmenu:Open(posx, posy)
			if fx_d_cangivespell(val) then
				buyuver:SetTextColor(Color(0,0,0))
				checks["buyu"] = val
			else
				buyuver:SetTextColor(Color(255,0,0))
			end
		end
		buyuver:SetUpdateOnType(true)
		addcheck("buyu", buyuver, "textentry")

		tp:SizeToContentsY(16)
	/**/

	/* ders seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Ders Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)

		derscombo = vgui.Create("DComboBox",tp)
		derscombo:Dock(TOP)
		derscombo:SetText("Bir ders seçin...")
		for ders, tab in pairs(fx_d.dersler) do
			derscombo:AddChoice(ders)
		end
		tp:SizeToContentsY(12)
		addcheck("ders", derscombo, "combobox")
	/**/

	/* sure seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Süre Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)

		sureslid = vgui.Create("DNumSlider",tp)
		sureslid:Dock(TOP)
		sureslid:SetText("Süre (Dk.)")
		sureslid:SetMin(5)
		sureslid:SetMax(30)
		sureslid:SetValue(5)
		sureslid:SetDecimals(0)
		sureslid.Label:SetTextColor(color_white)
		sureslid.TextArea:SetTextColor(color_white)
		tp:SizeToContentsY(12)
		addcheck("sure", sureslid, "numslider")
	/**/

	/* sınıf seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Sınıf Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)

		sinifcombo = vgui.Create("DComboBox",tp)
		sinifcombo:Dock(TOP)
		sinifcombo:SetText("Bir sınıf seçin...")
		for sinif, data in pairs(fx_d.siniflar) do
			sinifcombo:AddChoice(sinif)
		end
		tp:SizeToContentsY(12)
		addcheck("sinif", sinifcombo, "combobox")
	/**/

	/* konu seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Konu Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)

		konuentry = vgui.Create("DTextEntry",tp)
		konuentry:SetText("Konuyu girin...")
		konuentry:Dock(TOP)
		tp:SizeToContentsY(12)
		addcheck("konu", konuentry, "textentry")
	/**/

	/* bölüm seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Bölüm Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)
		tp:SetTall(145)

		gryf = vgui.Create("fx_d_checkbox",tp)
		gryf:SetText("Gryffindor","fx_d_normal")
		gryf:Dock(TOP)
		addcheck("gryffindor", gryf.checkbox, "checkbox")

		huffle = vgui.Create("fx_d_checkbox",tp)
		huffle:SetText("Hufflepuff","fx_d_normal")
		huffle:Dock(TOP)
		huffle:DockMargin(0,5,0,0)
		addcheck("hufflepuff", huffle.checkbox, "checkbox")

		raven = vgui.Create("fx_d_checkbox",tp)
		raven:SetText("Ravenclaw","fx_d_normal")
		raven:Dock(TOP)
		raven:DockMargin(0,5,0,0)
		addcheck("ravenclaw", raven.checkbox, "checkbox")

		slyt = vgui.Create("fx_d_checkbox",tp)
		slyt:SetText("Slytherin","fx_d_normal")
		slyt:Dock(TOP)
		slyt:DockMargin(0,5,0,0)
		addcheck("slytherin", slyt.checkbox, "checkbox")
	/**/

	/* seviye seçimi */
		local tp = vgui.Create("fx_d_titlepanel",scroll)
		tp:SetText("Seviye Seçimi","fx_d_normal")
		tp:DockMargin(0,5,5,0)
		tp:Dock(TOP)
		tp:SetTall(70)

		for i=1, 8 do 
			local checkbox = vgui.Create("fx_d_checkbox",tp)
			checkbox:SetText(fx_numbertoroman(i),"fx_d_normal")
			checkbox:Dock(LEFT)
			checkbox:DockMargin(6,0,0,8)
			checkbox:SetWidth(51)

			addcheck("seviye_"..i, checkbox.checkbox, "checkbox")
		end
	/**/

	local onaylabut = vgui.Create("DButton",scroll)
	onaylabut:Dock(TOP)
	onaylabut:DockMargin(0,5,5,0)
	onaylabut:SetText(((fx_ders_hp_table[dersno].time and fx_ders_hp_table[dersno].time>=CurTime()) or areThereAnyDersOnQueue(dersno)) && "Sıraya Gir" || "Onayla")
	onaylabut:SetTextColor(color_white)
	onaylabut.Paint = function(s,w,h)
		local col = Color(31,31,31)
		draw.RoundedBox(0,0,0,w,h,col)
	end
	onaylabut.DoClick = function()
		/*if not table.HasValue(fx_d.dersler,checks.ders) then
			fx_d_print("Ders belirlenmedi!")
			return
		end

		if not table.HasValue(fx_d.siniflar,checks.sinif) then
			fx_d_print("Sınıf belirlenmedi!")
			return
		end*/

		if (fx_ders_hp_table[dersno].time and fx_ders_hp_table[dersno].time>=CurTime()) or areThereAnyDersOnQueue(dersno) then
			net.Start("fx_ders_queue_ders")
				net.WriteInt(dersno,4)
				net.WriteInt(table.Count(checks),8)
				for key,value in pairs(checks) do
					net.WriteString(key..";"..tostring(value))
				end
			net.SendToServer()			
		else
			net.Start("fx_ders_start_ders")
				net.WriteInt(dersno,4)
				net.WriteInt(table.Count(checks),8)
				for key,value in pairs(checks) do
					net.WriteString(key..";"..tostring(value))
				end
			net.SendToServer()
		end

		fx_d_print("Ders NO: "..checks.dersno.." | Ders: "..checks.ders.." | Süre: "..checks.sure.."dk | Sınıf: "..checks.sinif)
	end
	fx_d_print("Ders menüsü açıldı!")
end

net.Receive("fx_ders_menu", function()
	d_menu()
end)

net.Receive("fx_ders_start_ders", function()
	local dersno = net.ReadInt(4)
	local starter = net.ReadString()
	local table_count = net.ReadInt(8) -- table size

	fx_ders_hp_table[dersno] = {}
	for i=1,table_count do
		local str = net.ReadString()
		fx_ders_hp_table[dersno][string.Explode(";",str)[1]] = string.Explode(";",str)[2]
	end	
	fx_ders_hp_table[dersno].time = CurTime()+(fx_ders_hp_table[dersno].sure*60)
	fx_ders_hp_table[dersno].classtext = ""
	for key,value in pairs(fx_ders_hp_table[dersno]) do 
		if value=="true" and not (key:sub(0,7)=="seviye_") then
			key = string.ToTable(key)
			key[1] = key[1]:upper()
			keystr = ""
			for i=1, #key do
				keystr = keystr..key[i] 
			end
			fx_ders_hp_table[dersno].classtext = fx_ders_hp_table[dersno].classtext..keystr.." "
		end
	end
	fx_ders_hp_table[dersno].seviyetext = ""

	local cache = {}
	for key, value in pairs(fx_ders_hp_table[dersno]) do
		if key:sub(0,7)=="seviye_" and value=="true" then
			cache[tonumber(key:sub(8,8))] = fx_numbertoroman(key:sub(8,8))
			--fx_ders_hp_table.seviyetext = fx_ders_hp_table.seviyetext..fx_numbertoroman(key:sub(8,8)).."-"
		end
	end

	for i=1,8 do
		if cache[i] then
			fx_ders_hp_table[dersno].seviyetext = fx_ders_hp_table[dersno].seviyetext..cache[i].."-"
		end
	end

	fx_ders_hp_table[dersno].seviyetext = fx_ders_hp_table[dersno].seviyetext:sub(0,fx_ders_hp_table[dersno].seviyetext:len()-1)

	chat.AddText(Color(7,229,142),"["..dersno..". DERS] "..starter,color_white," isimli profesör ",Color(7,229,142),fx_ders_hp_table[dersno].ders,color_white," dersini başlattı.")
	surface.PlaySound("ui/achievement_earned.wav")

--PrintTable(fx_ders_hp_table[dersno])	
end)

net.Receive("fx_ders_queue_ders", function()
	local dersno = net.ReadInt(4)
	local starter = net.ReadString()
	local table_count = net.ReadInt(8) -- table size

	local tab = {}
	for i=1,table_count do
		local str = net.ReadString()
		tab[string.Explode(";",str)[1]] = string.Explode(";",str)[2]
	end	
	tab.prof = starter
	tab.starter = starter
	tab.time = (tab.sure*60)
	tab.classtext = ""
	for key,value in pairs(tab) do 
		if value=="true" and not (key:sub(0,7)=="seviye_") then
			key = string.ToTable(key)
			key[1] = key[1]:upper()
			keystr = ""
			for i=1, #key do
				keystr = keystr..key[i] 
			end
			tab.classtext = tab.classtext..keystr.." "
		end
	end
	tab.seviyetext = ""

	local cache = {}
	for key, value in pairs(tab) do
		if key:sub(0,7)=="seviye_" and value=="true" then
			cache[tonumber(key:sub(8,8))] = fx_numbertoroman(key:sub(8,8))
		end
	end

	for i=1,8 do
		if cache[i] then
			tab.seviyetext = tab.seviyetext..cache[i].."-"
		end
	end

	tab.seviyetext = tab.seviyetext:sub(0,tab.seviyetext:len()-1)
	table.insert(fx_ders_hp_queue[dersno],tab)
	chat.AddText(Color(7,229,142),"["..dersno..". DERS] "..starter,color_white," isimli profesör sıraya ",Color(7,229,142),fx_ders_hp_queue[dersno].ders,color_white," dersini ekledi.\n")
end)

net.Receive("fx_ders_queue_end",function()
	local dersno = net.ReadInt(4); // ders numarası.
	local queue_number = net.ReadUInt(5); // queue deki yeri
	chat.AddText(Color(7,229,142),"["..dersno..". DERS] "..fx_ders_hp_queue[dersno][queue_number].starter,color_white," isimli profesörün sıraya eklediği ",Color(7,229,142),fx_ders_hp_queue[dersno].ders,color_white," dersi sıradan çıkartıldı.\n")
	//fx_ders_hp_queue[dersno][queue_number] = nil; // siliyoruz
	table.remove(fx_ders_hp_queue[dersno],queue_number);
end)

net.Receive("fx_ders_end_ders", function()
	local ender = net.ReadString()
	local dersno = net.ReadInt(4)
	fx_ders_hp_table[dersno].time = 0
	chat.AddText(Color(7,229,142),"["..dersno..". DERS] "..ender,color_white," isimli profesör dersi bitirdi.")
	surface.PlaySound("ui/achievement_earned.wav")
end)

local y = ScrH()/3
local x = 15

local bos_w, bos_h = 72, 80
local dolu_w, dolu_h = 320, 105
local gap = 5

local c_cerc = Color(0,0,0,220)
local c_ic = Color(0,0,0,200)

local function DrawOutlinedRect(x, y, w, h, outcol, incol)
	surface.SetDrawColor(outcol)
	surface.DrawOutlinedRect(x,y,w,h)

	surface.SetDrawColor(incol)
	surface.DrawRect(x,y,w,h)
end

local function DrawDersStuff(dersno, x, y)
	--draw.SimpleText("Ders: "..(#fx_ders_hp_table[dersno].ders>=27 and string.Left(fx_ders_hp_table[dersno].ders,23).."..." or fx_ders_hp_table[dersno].ders),"fx_d_magic_s",x+10,y-6,color_white)
	draw.SimpleText("Ders: "..fx_ders_hp_table[dersno].ders,"fx_d_magic_s",x+10,y-6,color_white)

	local kalan = math.Round(fx_ders_hp_table[dersno].time-CurTime())
	y = y+23
	DrawOutlinedRect(x+6, y+14, 48, 48, c_cerc, c_ic)	

	if fx_d.dersler[fx_ders_hp_table[dersno].ders].logo and (fx_d.dersler[fx_ders_hp_table[dersno].ders].logo:len()>1) then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(Material(fx_d.dersler[fx_ders_hp_table[dersno].ders].logo))
		surface.DrawTexturedRect(x+6,y+14,48,48)
	else
		surface.SetDrawColor(color_white)
		surface.SetMaterial(Material(fx_d.default_logo))
		surface.DrawTexturedRect(x+6,y+14,48,48)
	end

	draw.SimpleText((string.len(math.floor((kalan/60)))==1 and "0"..(math.floor((kalan/60))) or (math.floor((kalan/60))))..":"..(string.len(kalan%60)==1 and "0"..(kalan%60) or (kalan%60)),"fx_d_strange_s",x+30,y+63,Color(255,255,255),TEXT_ALIGN_CENTER)

	x = x + 50
	draw.SimpleText("Sınıf: "..fx_ders_hp_table[dersno].sinif,"fx_d_strange",x+10,y+10,Color(255,255,255))
	draw.SimpleText("Konu: "..fx_ders_hp_table[dersno].konu,"fx_d_strange",x+10,y+27,Color(255,255,255))

	y = y - 27
	if (fx_ders_hp_table[dersno].classtext:len()>1) then
		surface.SetMaterial(Material("icon16/accept.png","unlitgeneric"))
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(x+10,y+74,16,16)
		surface.SetFont("fx_d_strange_s")
		class_len = surface.GetTextSize(fx_ders_hp_table[dersno].classtext)
		draw.SimpleText(fx_ders_hp_table[dersno].classtext,"fx_d_strange_s",x+28,y+72.5,Color(121,201,107))
		class_drawed = true
	else
		class_drawed = false
		class_len = 0
	end	

	if (fx_ders_hp_table[dersno].seviyetext:len()>0) then
		surface.SetMaterial(Material("icon16/accept.png","unlitgeneric"))
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(x+10,y+74+(class_drawed and 18 or 0),16,16)
		draw.SimpleText(fx_ders_hp_table[dersno].seviyetext,"fx_d_strange_s",x+28,y+70.5+(class_drawed and 18 or 0),Color(121,201,107))
	end	
end

local hog2 = Material("ders_sistemi/ders.png")

local function DrawTenefusStuff(x, y)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(hog2)
	surface.DrawTexturedRect(x+3,y+3,bos_w-6,66)

	draw.SimpleText("Teneffüs","fx_d_strange_s",x+bos_w/2,y+bos_h,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
end

hook.Add("HUDPaint","fx_ders_hpaint",function()
	for i=1, 2 do
		if not fx_ders_hp_table[i] then continue end

		if isDersActive(i) then
			if i==2 then
				if isDersActive(1) then
					local x,y = gap, ScrH()/3+(i-1)*(dolu_h+gap)
					DrawOutlinedRect(x, y, dolu_w+(#fx_ders_hp_table[i].ders>27 and 92 or 0), dolu_h, c_cerc, c_ic)	

					DrawDersStuff(i,x,y)
					--draw.SimpleText(fx_ders_hp_table[i].ders,"fx_d_magic_s",gap*5,ScrH()/3+(i-1)*(dolu_h+gap),color_white)
				else
					local x,y = gap, ScrH()/3+(i-1)*(bos_h+gap)
					DrawOutlinedRect(x, y, dolu_w+(#fx_ders_hp_table[i].ders>27 and 92 or 0), dolu_h, c_cerc, c_ic)	

					DrawDersStuff(i,x,y)
					--draw.SimpleText(fx_ders_hp_table[i].ders,"fx_d_magic_s",gap*5,ScrH()/3+(i-1)*(bos_h+gap),color_white)					
				end		
			else
				local x,y = gap, ScrH()/3+(i-1)*(bos_h+gap)
				DrawOutlinedRect(x, y, dolu_w+(#fx_ders_hp_table[i].ders>27 and 92 or 0), dolu_h, c_cerc, c_ic)	

				DrawDersStuff(i,x,y)
				--draw.SimpleText(fx_ders_hp_table[i].ders,"fx_d_magic_s",gap*5,ScrH()/3+(i-1)*(bos_h+gap),color_white)
			end
		else
			-- DERS YOKSA --
			if i==2 then
				if isDersActive(1) then
					local x,y = gap, ScrH()/3+(i-1)*(dolu_h+gap)
					DrawOutlinedRect(x, y, bos_w, bos_h, c_cerc, c_ic)
					
					DrawTenefusStuff(x, y)			
				else
					local x,y = gap, ScrH()/3+(i-1)*(bos_h+gap)
					DrawOutlinedRect(x, y, bos_w, bos_h, c_cerc, c_ic)	

					DrawTenefusStuff(x, y)					
				end
			else
				local x,y = gap, ScrH()/3+(i-1)*(bos_h+gap)
				DrawOutlinedRect(x, y, bos_w, bos_h, c_cerc, c_ic)

				DrawTenefusStuff(x, y)				
			end
		end
	end

	for i=1,2 do
		if isDersActive(i) then
			if fx_ders_hp_table[i].sinif and not LocalPlayer():isInAnyDers() and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.min and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.max then
				local min, max = fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.min, fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.max

				local center = (min+(max-min)/2):ToScreen()
				drawShadowyText(fx_ders_hp_table[i].ders.." Dersi", "siniftitle", center.x, center.y, (fx_d.siniflar[fx_ders_hp_table[i].sinif].renk or Color(7,229,142)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				drawShadowyText(fx_ders_hp_table[i].sinif, "siniftitle", center.x, center.y+15, (fx_d.siniflar[fx_ders_hp_table[i].sinif].renk or Color(7,229,142)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				drawShadowyText(".", "siniftitle", center.x, center.y+22, (fx_d.siniflar[fx_ders_hp_table[i].sinif].renk or Color(7,229,142)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	if LocalPlayer():GetNWInt("ders",0)!=0 then
		if (CurTime()<=ders_draw) then
			drawShadowyText(fx_ders_hp_table[LocalPlayer():GetNWInt("ders",0)].ders.." Dersi","siniftitle_big", ScrW()/2, ScrH()/6-32, (fx_d.siniflar[fx_ders_hp_table[LocalPlayer():GetNWInt("ders",0)].sinif].renk or Color(7,229,142)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
			drawShadowyText(fx_ders_hp_table[LocalPlayer():GetNWInt("ders",0)].sinif, "siniftitle_big", ScrW()/2, ScrH()/6, (fx_d.siniflar[fx_ders_hp_table[LocalPlayer():GetNWInt("ders",0)].sinif].renk or Color(7,229,142)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		end
	end
--fx_ders_hp_table.ders[id].time
end)

if not fx_d then
	fx_d = {}
end

function fx_d.ders_state_changed(status)
	if status=="in" then
		ders_draw = CurTime()+4
		chat.AddText(Color(7,229,142),"Derse girdin.")
	elseif status=="out" then
		chat.AddText(Color(7,229,142),"Dersten çıktın.")
	end
end

local function drawYovarlank( x, y, radius, seg ) -- Bunu kendim yapmadım, mantığı çoxor. 
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, 72 do
		local a = math.rad( ( i / 72 ) * -360 +180)
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	draw.NoTexture()
	surface.DrawPoly( cir )
end

fx_d.yontoggle = fx_d.yontoggle or true

hook.Add("PostDrawOpaqueRenderables","ders",function()
	for i=1,2 do
		if isDersActive(i) then
			local tr = {}
			tr.HitPos = (LocalPlayer():GetPos()-Vector(0,0,0))

			if fx_ders_hp_table[i].sinif and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.min and fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.max and not LocalPlayer():isInAnyDers() then
				if (fx_d.yontoggle==false) then 
					cam.Start3D2D(tr.HitPos+Vector(0,0,4),Angle(0,LocalPlayer():EyeAngles().y-90,0),0.09)
						surface.SetFont("siniftitle_big")
						local w,t = surface.GetTextSize("Yön yardımını açmak için 'E' tuşuna bas.")
						draw.WordBox(4,-w/2,-t/2,"Yön yardımını açmak için 'E' tuşuna bas.","siniftitle_big",Color(30,30,30),color_white)
					cam.End3D2D()	

					return
				end

				local min, max = fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.min, fx_d.siniflar[fx_ders_hp_table[i].sinif].konum.max

				local center = (min+(max-min)/2)

				if i==1 then
					cam.Start3D2D(tr.HitPos+Vector(0,0,3),Angle(0,(center-LocalPlayer():GetPos()):Angle().y+45,0),0.1)
						local size = 150*2
						surface.SetDrawColor(fx_d.siniflar[fx_ders_hp_table[i].sinif].renk or Color(7,229,142))
						surface.DrawRect(0,0,size,size)
						drawYovarlank(0,0,size,32)
						surface.SetDrawColor(30,30,30)
						surface.DrawRect(0,0,size-16,size-16)
						drawYovarlank(0,0,size-16,32)
					--	draw.SimpleText("up","chatfont",25,5,color_white,TEXT_ALIGN_CENTER)
					cam.End3D2D()	

					cam.Start3D2D(tr.HitPos+Vector(0,0,3),Angle(0,(center-LocalPlayer():GetPos()):Angle().y-90,0),0.09)
						surface.SetFont("siniftitle_big")
						local w,t = surface.GetTextSize(fx_ders_hp_table[i].ders.." Dersi")
						draw.WordBox(4,0-w/2-5,-530,fx_ders_hp_table[i].ders.." Dersi","siniftitle_big",Color(30,30,30),color_white)
					cam.End3D2D()									
				else
					cam.Start3D2D(tr.HitPos+Vector(0,0,3),Angle(0,(center-LocalPlayer():GetPos()):Angle().y+45,0),0.1)
						local size = 125*2
						surface.SetDrawColor(fx_d.siniflar[fx_ders_hp_table[i].sinif].renk or Color(30,30,30))
						surface.DrawRect(0,0,size,size)
						drawYovarlank(0,0,size,32)
						surface.SetDrawColor(30,30,30)
						surface.DrawRect(0,0,size-16,size-16)
						drawYovarlank(0,0,size-16,32)
					cam.End3D2D()

					cam.Start3D2D(tr.HitPos+Vector(0,0,3),Angle(0,(center-LocalPlayer():GetPos()):Angle().y-90,0),0.09)
						surface.SetFont("siniftitle_big")
						local w,t = surface.GetTextSize(fx_ders_hp_table[i].ders.." Dersi")
						draw.WordBox(4,0-w/2-5,-450,fx_ders_hp_table[i].ders.." Dersi","siniftitle_big",Color(30,30,30),color_white)
					cam.End3D2D()
				end
					
				cam.Start3D2D(tr.HitPos+Vector(0,0,4),Angle(0,LocalPlayer():EyeAngles().y-90,0),0.09)
					surface.SetFont("siniftitle_big")
					local w,t = surface.GetTextSize("Kapatmak için 'E' tuşuna bas.")
					draw.WordBox(4,-w/2,-t/2,"Kapatmak için 'E' tuşuna bas.","siniftitle_big",Color(30,30,30),color_white)
				cam.End3D2D()
			end
		end
	end	
end)


local delay = 0
hook.Add("KeyPress","fx_d_keypress",function(ply, key)
	if (key==IN_USE) then
		local tr = util.QuickTrace(LocalPlayer():GetPos(),LocalPlayer():GetPos()-Vector(0,0,100))

		if (LocalPlayer():GetEyeTrace().HitPos:DistToSqr(tr.HitPos)<=900) and CurTime()>=delay then
			fx_d.yontoggle = !fx_d.yontoggle
			delay = CurTime()+0.1
		end
	end
end)