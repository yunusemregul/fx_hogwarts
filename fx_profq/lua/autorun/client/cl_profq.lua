if profesor_q_menu and IsValid(profesor_q_menu.f) then
	profesor_q_menu.f:Remove()
end

profesor_q_menu.isopen = false

function profesor_q_menu:Open()
	if IsValid(profesor_q_menu.f) then
		profesor_q_menu.f:Show()
		profesor_q_menu.isopen = true
		return
	end

	profesor_q_menu.f = vgui.Create("DFrame")
	profesor_q_menu.f:SetTitle("")
	profesor_q_menu.f:SetSize(800,600)
	profesor_q_menu.f:ShowCloseButton(false)
	profesor_q_menu.f:MakePopup()
	profesor_q_menu.f:Center()
	profesor_q_menu.f:SetDraggable(false)
	profesor_q_menu.f:SetKeyBoardInputEnabled(false)
	profesor_q_menu.f:DockPadding(4,4,4,4)
	profesor_q_menu.f.Paint = function(s,w,h)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(242,108,79)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	profesor_q_menu.li = vgui.Create("DScrollPanel",profesor_q_menu.f)
	profesor_q_menu.li:Dock(FILL)

	for category, data in pairs(profesor_q_menu.props) do
		profesor_q_menu.li[category] = vgui.Create("DCollapsibleCategory",profesor_q_menu.f)
		profesor_q_menu.li[category]:Dock(TOP)
		profesor_q_menu.li[category]:DockMargin(0,0,0,8)
		profesor_q_menu.li[category]:SetExpanded(1)
		profesor_q_menu.li[category]:SetLabel(category)
		profesor_q_menu.li[category].Paint = function(s,w,h)
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(0,0,w,h)
		end
		profesor_q_menu.li[category].Header.Paint = function(s,w,h)
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(0,0,w,h)	
			surface.SetDrawColor(242,108,79)
			surface.DrawOutlinedRect(0,0,w,h)					
		end				
		profesor_q_menu.li[category].ilay = vgui.Create("DIconLayout",profesor_q_menu.li[category])
		profesor_q_menu.li[category].ilay:Dock(FILL)
		profesor_q_menu.li[category].ilay:SetSpaceX(0)
		profesor_q_menu.li[category].ilay:SetSpaceY(0)
		profesor_q_menu.li[category]:SetContents(profesor_q_menu.li[category].ilay)

		if not data.props then continue end
		for i=1, #data.props do
			local model = data.props[i]

			local sp = profesor_q_menu.li[category].ilay:Add("SpawnIcon")
			sp:SetModel(model)
			sp.DoClick = function()
				LocalPlayer():ConCommand("gm_spawn \""..model.."\"")
				surface.PlaySound("ui\\buttonclickrelease.wav")
			end
		end
	end

	profesor_q_menu.isopen = true
end

function profesor_q_menu:Close()
	if IsValid(profesor_q_menu.f) then
		profesor_q_menu.f:Hide()
		profesor_q_menu.isopen = false
	end
end

local function toggleQ()
	if profesor_q_menu.isopen then
		profesor_q_menu:Close()
	else
		profesor_q_menu:Open()
	end
end

hook.Add("Move","profesor-q-menu",function(_, key)
	if LocalPlayer():CanOpenProfQ() then
		if input.IsKeyDown(KEY_B) then
			if not profesor_q_menu.isopen then
				profesor_q_menu:Open()
			end
		else
			if profesor_q_menu.isopen then
				profesor_q_menu:Close()
			end
		end
	end
end)