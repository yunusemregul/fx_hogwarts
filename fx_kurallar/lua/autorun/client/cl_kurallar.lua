local isopen = isopen or false

surface.CreateFont("kuralbaslik", {
	font = "Trebuchet28",
	antialias = true,
	size = 24,
	weight = 700
})

surface.CreateFont("kuraltext", {
	font = "Trebuchet28",
	antialias = true,
	size = 16,
	weight = 700
})

local rgb = Color
local baslik = rgb(27, 38, 50)
local kuralkutucugu = rgb(231, 76, 60)
local arkaplan = rgb(52, 73, 94)

net.Receive("kurallar-menu", function()
	if (isopen == true) then return end
	isopen = true
	local f = vgui.Create("DFrame")
	f:SetSize(900, 600)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	f:ShowCloseButton(false)

	f.OnClose = function()
		isopen = false
		f:Remove()
	end

	f.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, arkaplan)
	end

	local dp = vgui.Create("DScrollPanel", f)
	dp:SetSize(f:GetWide(),f:GetTall()-35)
	local sbar = dp:GetVBar()

	local okudumanladim = vgui.Create("DButton", f)
	okudumanladim:SetPos(5,f:GetTall()-28)
	okudumanladim:SetSize(f:GetWide()-10,23)
	okudumanladim:SetText("")
	okudumanladim.DoClick = function()
		f:Close()
		LocalPlayer().isokudu = true
	end
	okudumanladim.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(27,38,50	))
		draw.SimpleText((LocalPlayer().isokudu==true) and "Kapat" or "Okudum, anladım.","kuraltext",w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, arkaplan)
	end

	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, rgb(192, 57, 43))
	end

	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, rgb(192, 57, 43))
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, kuralkutucugu)
	end

	local suankibaslik = 0
	local kutucukno = 0

	for k, v in pairs(kurallar) do
		if (string.sub(v, 0, 2) == "**") then
			local kp = vgui.Create("DPanel", dp)
			kp:DockMargin(5, 10, 5, 0)
			kp:Dock(TOP)

			suankibaslik = suankibaslik + 1
			kutucukno = 0

			kp.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, baslik)
				draw.SimpleText(string.sub(v,3,string.len(v)),"kuralbaslik",w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		else
			local kp = vgui.Create("DPanel", dp)
			kp:DockMargin(10, 5, 10, 0)
			kp:Dock(TOP)

			local baslikno = suankibaslik
			kutucukno = kutucukno + 1
			local suankikutucuk = kutucukno

			kp.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, kuralkutucugu)
				draw.RoundedBox(0,0,0,30,h,baslik)
				draw.SimpleText(v,"kuraltext",w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText(baslikno.."."..suankikutucuk,"kuraltext",5,12,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
		end
	end
end)