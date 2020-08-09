local PANEL = {}

function PANEL:Init()
	self.text = nil
	self.font = "chatfont"
	self.color = color_white
end

function PANEL:UpdateLayout()
	surface.SetFont(self.font)
	local w,t = surface.GetTextSize(self.text)
	self:SetTall(t+8.5)
end

function PANEL:SetText(text, font)
	self.text = text
	self.font = font or "chatfont"
	self:UpdateLayout()
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:Paint(w,h)
	draw.RoundedBox(2,0,0,w,h,Color(51,51,51))
	draw.DrawText(self.text or "null",self.font,5,4,self.color)
	return true
end

vgui.Register("fx_d_labelpanel", PANEL, "DPanel")

--[[
	TITLE PANEL
]]--

local PANEL = {}

function PANEL:Init()
	self.text = nil
	self.font = "chatfont"
	self.color = color_white
end

function PANEL:UpdateLayout()
	surface.SetFont(self.font)
	local w,t = surface.GetTextSize(self.text)
	self:SetTall(t+8.5)
	self:DockPadding(5,t+15,5,0)
end

function PANEL:SetText(text, font)
	self.text = text
	self.font = font or "chatfont"
	self:UpdateLayout()
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:Paint(w,h)
	surface.SetFont(self.font)
	local wd,tl = surface.GetTextSize(self.text)

	draw.RoundedBox(2,0,0,w,h,Color(51,51,51))
	draw.RoundedBox(2,0,0,w,tl+8.5,Color(31,31,31))
	draw.DrawText(self.text or "null",self.font,(w/2)-(wd/2),4,self.color)
	return true
end

function PANEL:GetContentSize()
	surface.SetFont(self.font)
	local wd,tl = surface.GetTextSize(self.text)

	for k,v in pairs(self:GetChildren()) do
		tl = tl + v:GetTall()
	end

	return wd,tl+8.5
end

vgui.Register("fx_d_titlepanel", PANEL, "DPanel")


--[[
	DCheckBox with text
]]--

local PANEL = {}

function PANEL:Init()
	self.text = nil
	self.font = "chatfont"
	self.color = color_white

	self.checkbox = vgui.Create("DCheckBox",self)
	self.checkbox:SetPos(4,4)
	self.checkbox:SetValue(0)
end

function PANEL:SetText(text, font)
	self.text = text
	self.font = font or "chatfont"
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:DoClick()
	self.checkbox:SetChecked(!self.checkbox:GetChecked())
	self.checkbox:ConVarChanged(!self.checkbox:GetChecked())
	self.checkbox:OnChange(!self.checkbox:GetChecked())
end

function PANEL:Paint(w,h)
	draw.RoundedBox(2,0,0,w,h,Color(41,41,41))
	draw.DrawText(self.text or "null",self.font,24,1.75,self.color)
	return true
end

vgui.Register("fx_d_checkbox", PANEL, "DButton")

--[[
	DRomenSlid
]]--

local PANEL = {}

fx_romans_to8 = {
	[1] = "I",
	[2] = "II",
	[3] = "III",
	[4] = "IV",
	[5] = "V",
	[6] = "VI",
	[7] = "VII",
	[8] = "M",
}
function fx_numbertoroman(value)
	value = tonumber(value)

	return fx_romans_to8[value] or value
end

function fx_romantonumber(value)
	for key, val in pairs(fx_romans_to8) do
		if val==value then
			return key
		end 
	end
	return tonumber(value)
end

function PANEL:Init()
	self.TextArea:SetNumeric(false)
	self.Label:SetMouseInputEnabled(false)
	self.TextArea.OnChange = function( textarea, val ) 
		self:SetValue(fx_romantonumber(self.TextArea:GetText()))
		self.TextArea:SetText(fx_numbertoroman(self.TextArea:GetText()) or "")
	end
	self.Scratch.OnValueChanged = function() 
		local val = math.Round(self.Scratch:GetFloatValue())
		self:ValueChanged(val)
	end
end

function PANEL:ValueChanged( val )
	val = math.Clamp( tonumber( val ) || 0, self:GetMin(), self:GetMax() )

	if ( self.TextArea != vgui.GetKeyboardFocus() ) then
		self.TextArea:SetValue( fx_numbertoroman(math.Round(self.Scratch:GetFloatValue())) )
	end

	self.Slider:SetSlideX( self.Scratch:GetFraction( val ) )

	self:OnValueChanged( val )
end

function PANEL:GetValue()
	return math.Round(self.Scratch:GetFloatValue())
end

vgui.Register("fx_d_numslider", PANEL, "DNumSlider")