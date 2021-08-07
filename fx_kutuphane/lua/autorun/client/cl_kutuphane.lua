fx_kutuphane = fx_kutuphane or {};
fx_kutuphane.isopen = fx_kutuphane.isopen or false;
f = f or nil;
tf = tf or nil;

surface.CreateFont("kutuphane", {
	font = "Open Sans", 
	size = 28,
	weight = 500,
	blursize = 0,
	extended = true
})

surface.CreateFont("kutuphane1", {
	font = "Open Sans", 
	size = 26,
	weight = 500,
	blursize = 0,
	extended = true
})

surface.CreateFont("kutuphane2", {
	font = "Open Sans", 
	size = 18,
	weight = 500,
	blursize = 0,
	extended = true
})

surface.CreateFont("kutuphane3", {
	font = "Open Sans", 
	size = 28,
	weight = 800,
	blursize = 0,
	extended = true
})

local function H(str)
	string.Replace(str,"#","")
	r = tonumber(string.sub(str,1,2),16)
	g = tonumber(string.sub(str,3,4),16)
	b = tonumber(string.sub(str,5,6),16)

	return Color(r,g,b)
end

local cls = function(s,w,h)
	add = add or 0;
	local dn = s:GetName()=="DFrame" and 40 or (s:GetParent():GetName()=="DFrame" and 30 or 25)
	surface.SetDrawColor(dn,dn,dn)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(dn-5,dn-5,dn-5)
	surface.DrawOutlinedRect(0,0,w,h)
end

local color_grayishwhite = H("C5CBD3")
local selectedspell = nil

local fillT;

local function fill()
	if IsValid(f) then
		f:Remove();
		f = nil;
	end

	local w,h = 1000,600;

	f = vgui.Create("DFrame");
	f:SetSize(w,h);
	f:SetTitle("");
	f:SetDraggable(false);
	f:Center();
	f:MakePopup();
	f.Paint = cls
	f:DockPadding(0,0,0,0);
	f:ShowCloseButton(false);
	function f:Close()
		f:Remove()
		if IsValid(tf) then
			tf:Remove()
		end
	end

	local t = vgui.Create("DPanel",f)
	t:Dock(TOP)
	t.Paint = cls
	t:SetTall(30)

	local clb = vgui.Create("DButton",t)
	clb:Dock(RIGHT)
	clb:DockMargin(0,4,4,4)
	clb:SetText("Kapat")
	clb:SetTextColor(color_grayishwhite)
	clb.Paint = cls;
	clb.DoClick = function() f:Close() end

	local grid;
	local sat, transfer, ogren;

	/* BÜYÜ MENÜSÜ */
		local byu = vgui.Create("DButton",t)
		byu:Dock(LEFT)
		byu:DockMargin(0,0,0,0)
		byu:SetText("Büyü Kağıtların")
		byu:SetWide(100)
		byu:SetTextColor(color_grayishwhite)
		byu.Paint = cls;
		byu.DoClick = function()
			grid:Clear()
			for spell, count in pairs(fx_kutuphane.tab) do
				local byu = HpwRewrite:GetSpell(spell)
				if not byu then continue end

				local gereken = (fx_kutuphane.buyubilgileri[spell] and fx_kutuphane.buyubilgileri[spell].gerekenadet or fx_kutuphane.varsayilangerekenbuyuadedi);
				
				local text = string.Replace(byu.Description,"\n"," "):Replace("\t","")
				if string.len(text)>70 then
					text = text:sub(0,70).."..."
				end
				bt = grid:Add("DButton")
				bt:Dock(TOP)
				bt:DockMargin(6,6,6,0)
				bt:SetSize(259,70)
				bt:SetText("")
				bt.Paint = function(s,w,h)
					surface.SetDrawColor(35,35,35,200)
					surface.DrawRect(0,0,w,h)
					draw.SimpleText(spell,"kutuphane",76,10,H("DDA448"))
					draw.SimpleText(count.." tane","kutuphane3",w-8,8,count>=gereken and H("42BC7D") or H("BC4244"),TEXT_ALIGN_RIGHT)
					draw.SimpleText("Öğrenebilmek için "..gereken.." tane gerekiyor.","kutuphane2",w-8,4+33,color_grayishwhite,TEXT_ALIGN_RIGHT)

					draw.SimpleText(text,"kutuphane2",76,4+33,color_grayishwhite)
				end
				bt.DoClick = function()
					selectedspell = byu;
					sat:Show();
					transfer:Show();
					ogren:Show();
				end

				vg = vgui.Create("DImageButton",bt)
				vg:Dock(LEFT)
				vg:SetWide(64)
				vg:SetImage(HpwRewrite:GetSpellIcon(spell):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(spell):GetName())
				vg.PaintOver = function(s,w,h)  end;
				vg.DoClick = bt.DoClick
			end
		end
	/* END */

	grid = vgui.Create("DScrollPanel",f)
	grid:SetPos(2,30)
	grid:SetSize(w-240,h-38)

	local bar = grid:GetVBar()
	bar.Paint = function(s,w,h) 
		local sw= 2
		draw.RoundedBox(0,6,15,sw,h-30,Color(30,30,30))
	end;

	bar.btnUp.Paint = function() end;
	bar.btnDown.Paint = function() end;
	bar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(0,0,h/2-14/2,14,14,H("DDA448"))
	end;

	local aciklama = vgui.Create("DPanel",f)
	aciklama:SetPos(2+w-240+8,30)
	aciklama:SetSize(240-10,h-30)
	aciklama.Paint = function(s,w,h)
		local x,y = 0,8;
		draw.RoundedBox(0,x,y,w-x-8,h-y-8,Color(30,30,30))

		draw.SimpleText("Hoşgeldin "..string.Explode(" ",LocalPlayer():GetName())[1]..",","kutuphane2",x+8,y+8,color_grayishwhite)
		draw.DrawText("Derslerde edindiğin büyü kağıtları-\nnı buradan satabilir, başkalarına\ngönderebilir veya öğrenebilirsin.","kutuphane2",x+8,y+28,color_grayishwhite)

		if selectedspell then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(Material(HpwRewrite:GetSpellIcon(selectedspell.Name):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(selectedspell.Name):GetName()))
			surface.DrawTexturedRect(110-164/2,128,164,164)

			draw.SimpleText(selectedspell.Name,"kutuphane",110,128+164+8,H("DDA448"),TEXT_ALIGN_CENTER)
			draw.DrawText(selectedspell.Description:Replace("\t",""),"kutuphane2",25,128+164+44,color_grayishwhite)
		end
	end

	sat = vgui.Create("DButton",aciklama)
	local sh = 30
	sat:SetPos(0,h-8-sh-30)
	sat:SetSize(240-10-8,sh)
	sat.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(20,20,20))

		if s:IsHovered() then
			draw.SimpleText("+"..DarkRP.formatMoney(fx_kutuphane.buyubilgileri[selectedspell.Name] and fx_kutuphane.buyubilgileri[selectedspell.Name].satisfiyati or fx_kutuphane.varsayilanbuyufiyati),"kutuphane1",w/2,h/2,H("42BC7D"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Sat","kutuphane1",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	sat:Hide()
	sat:SetText("")
	sat.DoClick = function()
		net.Start("kutuphane_menu")
			net.WriteString("sat")
			net.WriteString(selectedspell.Name)
		net.SendToServer()
	end

	transfer = vgui.Create("DButton",aciklama)
	transfer:SetPos(0,h-8-sh*2-30)
	transfer:SetSize(240-10-8,sh)
	transfer.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(25,25,25))

		draw.SimpleText("Gönder","kutuphane1",w/2,h/2,s:IsHovered() and H("DDA448") or color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	transfer:Hide()
	transfer:SetText("")
	transfer.DoClick = function()
		fillT();
		/*net.Start("kutuphane_menu")
			net.WriteString("ask_transfer")
			net.WriteString(selectedspell.Name)
		net.SendToServer()*/
	end

	ogren = vgui.Create("DButton",aciklama)
	ogren:SetPos(0,h-8-sh*3-30)
	ogren:SetSize(240-10-8,sh)
	ogren.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(30,30,30))

		draw.SimpleText("Öğren","kutuphane1",w/2,h/2,s:IsHovered() and H("4881DD") or color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	ogren:Hide()
	ogren:SetText("")
	ogren.DoClick = function()
		net.Start("kutuphane_menu")
			net.WriteString("learn")
			net.WriteString(selectedspell.Name)
		net.SendToServer()
	end

	byu.DoClick();
end

local targetname;
local plsteamid;
local bbuyu;
local bbuyuadet;

fillT = function()
	if tf and IsValid(tf) then
		tf:Remove();
		tf = nil;
	end

	local w,h = 300,260;

	tf = vgui.Create("DFrame");
	tf:SetSize(w,h);
	tf:SetTitle("");
	tf:SetDraggable(false);
	tf:Center();
	tf:MakePopup();
	tf.Paint = cls
	tf:DockPadding(0,0,0,0);
	tf:ShowCloseButton(false);
	function tf:Close()
		tf:Remove()
	end

	local t = vgui.Create("DPanel",tf)
	t:Dock(TOP)
	t.Paint = cls
	t:SetTall(30)

	local clb = vgui.Create("DButton",t)
	clb:Dock(RIGHT)
	clb:DockMargin(0,4,4,4)
	clb:SetText("Kapat")
	clb:SetTextColor(color_grayishwhite)
	clb.Paint = cls;
	clb.DoClick = function() tf:Close() end

	/* oyuncu */
		local panel = vgui.Create("DPanel",tf)
		panel:Dock(TOP)
		panel:DockMargin(4,4,4,4)
		panel.Paint = cls

		local t = vgui.Create("DLabel",panel)
		t:SetText("Gönderilecek oyuncu:");
		t:Dock(TOP)
		t:DockMargin(6,2,4,0)

		local oyuncucombo = vgui.Create("DComboBox",panel)
		oyuncucombo:Dock(TOP)
		oyuncucombo:SetValue("Gönderilecek oyuncu")
		for _, ply in pairs(player.GetAll()) do
			if ply==LocalPlayer() then continue end;
			oyuncucombo:AddChoice(ply:Nick(),ply:SteamID());
		end
		oyuncucombo:DockMargin(4,0,4,0)
		
		local t = vgui.Create("DLabel",panel)
		t:SetText("Sunucuda değilse Steam ID gir:");
		t:Dock(TOP)
		t:DockMargin(6,2,4,0)
		panel:SetTall(92)

		local dt = vgui.Create("DTextEntry",panel)
		dt:Dock(TOP)
		dt:DockMargin(4,0,4,4)
		local dtvalue = "Steam ID"
		dt:SetValue(dtvalue)
	/**/

	/* büyü */
		local panel = vgui.Create("DPanel",tf)
		panel:Dock(TOP)
		panel:DockMargin(4,4,4,4)
		panel.Paint = cls

		local t = vgui.Create("DLabel",panel)
		t:SetText("Gönderilecek büyü kağıdı:");
		t:Dock(TOP)
		t:DockMargin(6,2,4,0)

		local adet;

		local combo = vgui.Create("DComboBox",panel)
		combo:Dock(TOP)
		local comboval = "Gönderilecek Büyü Kağıdı";
		combo:SetValue(comboval)
		for buyu, adet in pairs(fx_kutuphane.tab) do
			combo:AddChoice(buyu);
		end
		combo:DockMargin(4,0,4,0)
		combo.OnSelect = function(panel, index, text, data)
			adet:SetMax(fx_kutuphane.tab[text])
		end
		panel:SetTall(92)

		local t = vgui.Create("DLabel",panel)
		t:SetText("Kaç tane gönderilecek:");
		t:Dock(TOP)
		t:DockMargin(6,2,4,0)

		adet = vgui.Create("DNumberWang",panel)
		adet:Dock(TOP)
		adet:DockMargin(4,0,4,4)
		adet:SetValue(1)
		adet:SetMin(1)
	/**/

	local transfer = vgui.Create("DButton",tf)
	transfer:SetText("")
	transfer:SetPos(0,h-30)
	transfer:SetSize(w,30)
	transfer.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(25,25,25))

		draw.SimpleText("Gönder","kutuphane1",w/2,h/2,s:IsHovered() and H("DDA448") or color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	transfer.DoClick = function()
		if combo:GetValue()==comboval then
			return
		end
		local steamid;
		if (dt:GetValue()==dtvalue) then
			steamid = select(2,oyuncucombo:GetSelected());
		else
			steamid = dt:GetValue()
		end
		if steamid==nil then return end;
		plsteamid = steamid;
		bbuyu = combo:GetValue();
		bbuyuadet = adet:GetValue();
		net.Start("kutuphane_menu")
			net.WriteString("ask_transfer")
			net.WriteString(combo:GetValue())
			net.WriteString(steamid);
			net.WriteUInt(adet:GetValue(),8)
		net.SendToServer()
	end
end

local function d3d2fill()
	local ent = fx_kutuphane.ent

	if not IsValid(ent) then
		return
	end
	fx_kutuphane.isopen = true;
	gui.EnableScreenClicker(true)
	local panel = vgui.Create("DPanel")
	panel.CalcLocation = function(vOrigin, vAngles)
		local pos, ang, scale;
	   
	    local pos = ent:GetPos()+ent:GetUp()*60+ent:GetAngles():Right()*-20
	    local ang = ent:GetAngles()
	    ang:RotateAroundAxis(ang:Up(),90)
	    ang:RotateAroundAxis(ang:Forward(),90)

		scale = 0.08;
		return pos, ang, scale
	end
	local w, h = 200, 80
	panel:SetSize(w,h)
	panel.Paint = function(s,w,h)
		local dn = 30;
		surface.SetDrawColor(dn,dn,dn)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(242,108,79))
		surface.DrawOutlinedRect(0,0,w,h)

		draw.SimpleText("Merhaba, ne istiyorsun?","kutuphane2",5,5,color_grayishwhite,TEXT_ALIGN_LEFT)
	end
	panel.OnRemove = function()
		fx_kutuphane.isopen = false 
		gui.EnableScreenClicker(false)
	end

	local kagit = vgui.Create("DButton",panel)
	kagit:Dock(TOP)
	kagit:DockMargin(5,26,5,0)
	kagit:SetText("")
	kagit.Paint = function(s,w,h)
		local dn = 35;
		surface.SetDrawColor(dn,dn,dn)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(242,108,79))
		surface.DrawOutlinedRect(0,0,w,h)

		draw.SimpleText("Kağıtlarıma bakmak","kutuphane2",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	kagit.DoClick = function()
		panel:Remove()
		fill()
	end

	local button = vgui.Create("DButton",panel)
	button:Dock(TOP)
	button:DockMargin(5,4,5,0)
	button:SetText("")
	button.Paint = function(s,w,h)
		local dn = 35;
		surface.SetDrawColor(dn,dn,dn)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(242,108,79))
		surface.DrawOutlinedRect(0,0,w,h)

		draw.SimpleText("Hiçbir şey","kutuphane2",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	button.DoClick = function()
		panel:Remove()
	end

	vgui.make3d(panel);
end

net.Receive("kutuphane_menu", function()
	fx_kutuphane.tab = net.ReadTable();
	local order = net.ReadString();
	if order=="update" then
		fill();
	else
		fx_kutuphane.ent = net.ReadEntity();
		d3d2fill();
	end
end)

net.Receive("kutuphane_menu_transfer", function()
	targetname = net.ReadString();
	
	local w,h = 300,100;

	local f = vgui.Create("DFrame");
	f:SetSize(w,h);
	f:SetTitle("");
	f:SetDraggable(false);
	f:Center();
	f:MakePopup();
	f.Paint = cls
	f:DockPadding(0,0,0,0);
	f:ShowCloseButton(false);

	local t = vgui.Create("DPanel",f)
	t:Dock(TOP)
	t.Paint = cls
	t:SetTall(30)

	local dlabel = vgui.Create("DLabel",f)
	dlabel:Dock(TOP)
	dlabel:DockMargin(4,0,4,0)
	dlabel:SetText(targetname.." isimli oyuncuya "..bbuyu.." büyü kağıdından "..bbuyuadet.." tane göndermek istediğine emin misin?");
	dlabel:SetWrap(true)
	dlabel:SetTall(50)

	local pan = vgui.Create("DPanel",f)
	pan:Dock(BOTTOM)
	pan:DockMargin(4,0,4,4)
	pan.Paint = function() end

	local evet = vgui.Create("DButton",pan)
	evet:SetText("")
	evet:Dock(LEFT)
	evet.DoClick = function()
		net.Start("kutuphane_menu")
			net.WriteString("transfer")
			net.WriteString(bbuyu)
			net.WriteString(plsteamid);
			net.WriteUInt(bbuyuadet,8)
		net.SendToServer()
	end
	evet.Paint = function(s,w,h)
		local dn = 35;
		surface.SetDrawColor(dn,dn,dn)
		surface.DrawRect(0,0,w,h)

		draw.SimpleText("Evet","kutuphane2",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)		
	end

	local hayir = vgui.Create("DButton",pan)
	hayir:SetText("")
	hayir:Dock(RIGHT)
	hayir.DoClick = function()
		if IsValid(tf) then
			tf:Close()
		end
		f:Close()
	end
	hayir.Paint = function(s,w,h)
		local dn = 35;
		surface.SetDrawColor(dn,dn,dn)
		surface.DrawRect(0,0,w,h)

		draw.SimpleText("Hayır","kutuphane2",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)	
	end
end)

local function MyCalcView(ply, pos, angles, fov)
    local view = {}
    if fx_kutuphane.isopen then
	    local ent = fx_kutuphane.ent
	    if IsValid(ent) then
		    local pos = ent:GetPos() + ent:GetUp()*65 + ent:GetAngles():Forward()*40 + ent:GetAngles():Right()*-5
		    local ang = ent:GetAngles()
		    ang:RotateAroundAxis(ang:Up(),180)
		    view.origin = pos
		    view.angles = ang
		    view.fov = fov
		    view.drawviewer = true
		    vgui.set3d2dOrigin(pos, ang)
		    return view
		end
   end
end
hook.Add("CalcView", "calcview_kutuphane", MyCalcView)

hook.Add("HUDShouldDraw","hidehuds_kutuphane",function(name)
	if fx_kutuphane.isopen then
		-- So we can change weapons
		if (name=="CHudWeaponSelection") then return true end
		if (name=="CHudChat") then return true end

		return false		
	end
end)