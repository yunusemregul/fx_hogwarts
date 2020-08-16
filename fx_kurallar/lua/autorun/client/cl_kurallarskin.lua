-- buna da uğraştım o yüzden yaneeeeeee dinlemezsin muhtemelen ama azıcık düşün, öğrenmeye çalış. scripthook da seni geliştirir elbet

local SKIN = {}
SKIN.PrintName = "Kurallar Skin"
SKIN.Author = "Fexa"
SKIN.DermaVersion = 1

function SKIN:PaintFrame(panel)
	surface.SetDrawColor(44, 62, 80, 240)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	surface.SetDrawColor(44, 62, 80, 255)
	surface.DrawRect(0, 0, panel:GetWide(), 23)
end

function SKIN:PaintListView(panel)
	if panel.m_bBackground then
		surface.SetDrawColor(149, 142, 146, 120)
		panel:DrawFilledRect()
	end
end

function SKIN:PaintListViewLine(panel)
	local Col = nil

	if panel:IsSelected() then
		Col = Color(52, 73, 94)
	elseif panel.Hovered then
		Col = Color(149, 165, 166)
	elseif panel.m_bAlt then
		Col = Color(189, 195, 199)
	else
		return
	end

	surface.SetDrawColor(Col.r, Col.g, Col.b, Col.a)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
end

function SKIN:PaintButton(panel)
	panel:SetTextColor(Color(255, 255, 255))

	if panel.m_bBackground then
		if panel:GetDisabled() then
			surface.SetDrawColor(149, 165, 166)
			surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

			return
		elseif panel.Depressed then
			surface.SetDrawColor(41, 128, 185)
			surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

			return
		elseif panel.Hovered then
			surface.SetDrawColor(41, 128, 230)
			surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

			return
		end

		surface.SetDrawColor(52, 152, 219)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	end
end

function SKIN:PaintOverButton(panel)
end

function SKIN:DrawButtonBorder(x, y, w, h, depressed)
end

function SKIN:DrawDisabledButtonBorder(x, y, w, h, depressed)
end

function SKIN:PaintPropertySheet(panel)
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0

	if ActiveTab then
		local w, h, padding = panel:GetWide(), panel:GetTall(), panel:GetPadding()
		Offset = ActiveTab:GetTall()
		surface.SetDrawColor(Color(255, 255, 255))
		local tab = ActiveTab:GetWide()
		local x, _ = ActiveTab:GetPos()
		local tab_offset = -panel.tabScroller.pnlCanvas.x
		local x1, x2 = math.Round(x + padding + 1 - tab_offset), math.Round(x + padding + tab - 2 - tab_offset)
		surface.SetDrawColor(200, 200, 200, 200)
		local left, right = (x1 >= 0 and x1 <= w), (x2 >= 0 and x2 <= w)

		if left then
			surface.DrawRect(2, Offset, x1 - 1, 1)
			surface.DrawRect(x1, Offset, 1, 2)
		end

		if right then
			surface.DrawRect(x2, Offset, w - x2 - 2, 1)
			surface.DrawRect(x2, Offset, 1, 2)
		end

		if not left and not right then
			surface.DrawRect(2, Offset, w - 4, 1)
		end
	end
end

function SKIN:PaintTab(panel)
	local w, h = panel:GetWide(), panel:GetTall()

	if panel:GetPropertySheet():GetActiveTab() == panel then
		surface.SetDrawColor(39, 174, 96, 170)
		surface.DrawRect(0, 0, w, h - 8)
	else
	end
end

function SKIN:PaintTextEntry(panel)
	surface.SetDrawColor(189, 195, 199)

	if panel.m_bBackground then
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
	end

	panel:DrawTextEntryText(panel.m_colText, panel.m_colHighlight, panel.m_colCursor)
end

derma.DefineSkin("kurallarskin", "kurallar_skin_senisiksin", SKIN)