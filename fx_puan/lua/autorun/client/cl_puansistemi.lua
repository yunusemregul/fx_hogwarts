puanlar = puanlar or {}
showpuan = showpuan or 0;

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

local w, t = 100, 100
surface.CreateFont( "puanfont", {
	font = "Open Sans",
	extended = false,
	size = 15,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )


hook.Add("HUDPaint","puan_show",function()
	if showpuan>=CurTime() then
		for i, data in pairs(puanlar) do
			draw.RoundedBox(0,ScrW()/4+(i-1)*ScrW()/8,20,w,t,Color(0,0,0,200))
			surface.SetDrawColor(242,108,79)
			surface.DrawOutlinedRect(ScrW()/4+(i-1)*ScrW()/8,20,w,t)
			
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material(mats[mats_string_id[data.ev]]))
			surface.DrawTexturedRect(ScrW()/4+(i-1)*ScrW()/8,20,100,100)

			draw.RoundedBox(0,ScrW()/4+(i-1)*ScrW()/8,20+t+5,w,t/5,Color(0,0,0,200))
			surface.SetDrawColor(242,108,79)
			surface.DrawOutlinedRect(ScrW()/4+(i-1)*ScrW()/8,20+t+5,w,t/5)
			draw.SimpleText(data.puan,"puanfont",ScrW()/4+(i-1)*ScrW()/8+w/2,t+34,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
end)

net.Receive("puan_show",function()
	for i=1,4 do
		local str = net.ReadString()
		str = string.Explode(":",str);
		
		data = {};
		data.puan = tonumber(str[2]);
		data.ev = str[1];
		
		puanlar[i] = data;
	end
	showpuan = CurTime() + 5;
end)