hogshop_f = hogshop_f or nil

if hogshop_f and IsValid(hogshop_f) then
	hogshop_f:Remove()
	hogshop_f = nil
end

local cls = function(s,w,h)
	local dn = s:GetName()=="DFrame" and 40 or (s:GetParent():GetName()=="DFrame" and 30 or 25)
	surface.SetDrawColor(dn,dn,dn)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(242,108,79)
	//surface.DrawOutlinedRect(0,0,w,h)
end

surface.CreateFont("hogshop", {
	font = "Open Sans", 
	size = 28,
	weight = 500,
	blursize = 0,
	extended = true
})

surface.CreateFont("hogshop2", {
	font = "Open Sans", 
	size = 18,
	weight = 500,
	blursize = 0,
	extended = true
})

surface.CreateFont("hogshop3", {
	font = "Open Sans", 
	size = 28,
	weight = 800,
	blursize = 0,
	extended = true
})

// sıkıldım yapmaktan kötü kodlayacam
local selectedspell = nil
local selectedbyu = nil
local selectedthing = ""
local selectedindex = nil

local function H(str)
	string.Replace(str,"#","")
	r = tonumber(string.sub(str,1,2),16)
	g = tonumber(string.sub(str,3,4),16)
	b = tonumber(string.sub(str,5,6),16)

	return Color(r,g,b)
end

local color_grayishwhite = H("C5CBD3")

local function fill()
	if hogshop_f and IsValid(hogshop_f) then
		hogshop_f:Remove()
		hogshop_f = nil
		selectedspell = nil
	end
	seletedspell = nil
	selectedbyu = nil
	selectedthing = ""
	selectedindex = nil
	local satinal

	local w,h = 1000,600;

	local f = vgui.Create("DFrame");
	f:SetSize(w,h);
	f:SetTitle("");
	f:SetDraggable(false);
	f:Center();
	f:MakePopup();
	hogshop_f = f;
	f.Paint = cls
	f:DockPadding(0,0,0,0);
	f:ShowCloseButton(false);
	function f:Close()
		f:Remove()
		isopen = false
		selectedspell = nil
		selectedbyu = nil
		selectedthing = ""
		selectedindex = nil
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

	/* BÜYÜ MENÜSÜ */
		local byu = vgui.Create("DButton",t)
		byu:Dock(LEFT)
		byu:DockMargin(0,0,0,0)
		byu:SetText("Büyüler")
		byu:SetTextColor(color_grayishwhite)
		byu.Paint = cls;
		byu.DoClick = function()
			grid:Clear()
			for _, spell in pairs(hogshop.spells) do
				local byu = HpwRewrite:GetSpell(spell.ad)
				if not byu then continue end

				bt = grid:Add("DButton")
				bt:Dock(TOP)
				bt:DockMargin(6,6,6,0)
				bt:SetSize(259,70)
				bt:SetText("")
				bt.Paint = function(s,w,h)
					surface.SetDrawColor(35,35,35)
					surface.DrawRect(0,0,w,h)
					draw.SimpleText(spell.ad,"hogshop",76,10,H("DDA448"))
					if not HpwRewrite:PlayerHasSpell(LocalPlayer(), spell.ad) and not HpwRewrite:PlayerHasLearnableSpell(LocalPlayer(), spell.ad) then
						draw.SimpleText(DarkRP.formatMoney(spell.fiyat),"hogshop3",w-8,8,LocalPlayer():canAfford(spell.fiyat) and H("42BC7D") or color_grayishwhite,TEXT_ALIGN_RIGHT)
					end
					local text = string.Replace(byu.Description,"\n"," "):Replace("\t","")
					if string.len(text)>70 then
						text = text:sub(0,70).."..."
					end
					draw.SimpleText(text,"hogshop2",76,4+33,color_grayishwhite)
				end
				bt.DoClick = function()
					/*net.Start("hogshop_buy")
						net.WriteString("spell|".._)
					net.SendToServer()*/
					selectedspell = byu
					selectedbyu = spell
					if LocalPlayer():canAfford(spell.fiyat) then
						satinal:Show()
					else
						satinal:Hide()
					end
					selectedthing="spell"
					selectedindex = _
				end

				if HpwRewrite:PlayerHasSpell(LocalPlayer(), spell.ad) or HpwRewrite:PlayerHasLearnableSpell(LocalPlayer(), spell.ad) then
					bt.bought = true
					bt.DoClick = function() end
				end

				vg = vgui.Create("DImageButton",bt)
				vg:Dock(LEFT)
				vg:SetWide(64)
				vg:SetImage(HpwRewrite:GetSpellIcon(spell.ad):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(spell.ad):GetName())
				vg.PaintOver = function(s,w,h)  end;
				vg.DoClick = bt.DoClick
			end
		end
		hogshop_f.buyu = byu
	/* END */

	/* ASA MENÜSÜ */
		local asa = vgui.Create("DButton",t)
		asa:Dock(LEFT)
		asa:DockMargin(-1,0,0,0)
		asa:SetText("Asalar")
		asa:SetTextColor(color_grayishwhite)
		asa.Paint = cls;
		asa.DoClick = function()
			grid:Clear()
			for _, wand in pairs(hogshop.wands) do
				local byu = HpwRewrite:GetSpell(wand.ad)

				bt = grid:Add("DButton")
				bt:Dock(TOP)
				bt:DockMargin(6,6,6,0)
				bt:SetSize(259,70)
				bt:SetText("")
				bt.Paint = function(s,w,h)
					surface.SetDrawColor(35,35,35)
					surface.DrawRect(0,0,w,h)
					draw.SimpleText(wand.ad,"hogshop",76,10,H("8D6A9F"))
					if not HpwRewrite:PlayerHasSpell(LocalPlayer(), wand.ad) then
						draw.SimpleText(DarkRP.formatMoney(wand.fiyat),"hogshop3",w-8,8,LocalPlayer():canAfford(wand.fiyat) and H("42BC7D") or color_grayishwhite,TEXT_ALIGN_RIGHT)
					end

					local text = string.Replace(byu.Description,"\n"," "):Replace("\t","")
					if string.len(text)>70 then
						text = text:sub(0,70).."..."
					end
					draw.SimpleText(text,"hogshop2",76,4+33,color_grayishwhite)
				end
				bt.DoClick = function()
					/*net.Start("hogshop_buy")
						net.WriteString("wand|".._)
					net.SendToServer()*/
					selectedspell = byu
					selectedbyu = wand
					if LocalPlayer():canAfford(wand.fiyat) then
						satinal:Show()
					else
						satinal:Hide()
					end
					selectedthing="wand"
					selectedindex=_
				end

				if HpwRewrite:PlayerHasSpell(LocalPlayer(), wand.ad) then
					bt.bought = true
					bt.DoClick = function() end
				end

				vg = vgui.Create("DImageButton",bt)
				vg:Dock(LEFT)
				vg:SetImage(HpwRewrite:GetSpellIcon(wand.ad):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(wand.ad):GetName())
				vg.PaintOver = function(s,w,h)  end;
				vg.DoClick = bt.DoClick
			end
		end
		hogshop_f.asa = asa
	/* END */

	/* PET MENÜSÜ */
		local petgui = vgui.Create("DButton",t)
		petgui:Dock(LEFT)
		petgui:DockMargin(-1,0,0,0)
		petgui:SetText("Evcil Hayvanlar")
		petgui:SetWide(100)
		petgui:SetTextColor(color_grayishwhite)
		petgui.Paint = cls;
		petgui.DoClick = function()
			grid:Clear()
			for _, pet in pairs(hogshop.pets) do
				local byu = HpwRewrite:GetSpell(pet.ad)

				if not byu then continue end

				bt = grid:Add("DButton")
				bt:Dock(TOP)
				bt:DockMargin(6,6,6,0)
				bt:SetSize(259,70)
				bt:SetText("")
				bt.Paint = function(s,w,h)
					surface.SetDrawColor(35,35,35)
					surface.DrawRect(0,0,w,h)
					draw.SimpleText(pet.ad,"hogshop",76,10,H("8D6A9F"))
					if not HpwRewrite:PlayerHasSpell(LocalPlayer(), pet.ad) then
						draw.SimpleText(DarkRP.formatMoney(pet.fiyat),"hogshop3",w-8,8,LocalPlayer():canAfford(pet.fiyat) and H("42BC7D") or color_grayishwhite,TEXT_ALIGN_RIGHT)
					end

					local text = string.Replace(byu.Description,"\n"," "):Replace("\t","")
					if string.len(text)>70 then
						text = text:sub(0,70).."..."
					end
					draw.SimpleText(text,"hogshop2",76,4+33,color_grayishwhite)
				end
				bt.DoClick = function()
					/*net.Start("hogshop_buy")
						net.WriteString("pet|".._)
					net.SendToServer()*/
					selectedspell = byu
					selectedbyu = pet
					if LocalPlayer():canAfford(pet.fiyat) then
						satinal:Show()
					else
						satinal:Hide()
					end
					selectedthing="pet"
					selectedindex=_
				end

				if HpwRewrite:PlayerHasSpell(LocalPlayer(), pet.ad) then
					bt.bought = true
					bt.DoClick = function() end
				end

				vg = vgui.Create("DImageButton",bt)
				vg:Dock(LEFT)
				vg:SetImage(HpwRewrite:GetSpellIcon(pet.ad):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(pet.ad):GetName())
				vg.PaintOver = function(s,w,h)  end;
				vg.DoClick = bt.DoClick
			end
		end
		hogshop_f.petgui = petgui
	/* END */

	grid = vgui.Create("DScrollPanel",f)
	grid:SetPos(2,30)
	grid:SetSize(w-240,h-38)
	grid.Paint = function() end;

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

		draw.SimpleText("Hoşgeldin "..string.Explode(" ",LocalPlayer():GetName())[1]..",","hogshop2",x+8,y+8,color_grayishwhite)
		draw.DrawText("İlgini çekebilecek çeşitli büyüler, \nasalar ve evcil hayvanlar\nsatıyorum. Üzerlerine tıklaya-\nrak daha detaylı bilgi edinebilirsin.","hogshop2",x+8,y+28,color_grayishwhite)

		if selectedspell then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(Material(HpwRewrite:GetSpellIcon(selectedspell.Name):IsError() and "vgui/entities/entity_hpwand_spell_hocus" or HpwRewrite:GetSpellIcon(selectedspell.Name):GetName()))
			surface.DrawTexturedRect(110-164/2,128,164,164)

			draw.SimpleText(selectedspell.Name,"hogshop",110,128+164+8,H("DDA448"),TEXT_ALIGN_CENTER)
			draw.DrawText(selectedspell.Description:Replace("\t",""),"hogshop2",30,128+164+44,color_grayishwhite)
		end
	end

	satinal = vgui.Create("DButton",aciklama)
	local sh = 30
	satinal:SetPos(0,h-8-sh-30)
	satinal:SetSize(240-10-8,sh)
	satinal.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(20,20,20))

		if s:IsHovered() then
			draw.SimpleText("-"..DarkRP.formatMoney(selectedbyu.fiyat),"hogshop",w/2,h/2,H("BB342F"),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Satın Al","hogshop",w/2,h/2,color_grayishwhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	satinal:SetText("")
	satinal:Hide()
	satinal.DoClick = function()
		net.Start("hogshop_buy")
			net.WriteString(selectedthing.."|"..selectedindex)
		net.SendToServer()	
	end

	byu.DoClick()
end

net.Receive("hogshop_menu", function()
	fill();
end)

net.Receive("hogshop_menu_refresh", function()
	local msg = net.ReadString()
	if hogshop_f and IsValid(hogshop_f) then
		if msg=="spell" then
			hogshop_f.buyu.DoClick()
		else
			hogshop_f.asa.DoClick()
		end
	end
end)