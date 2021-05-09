net.Receive("donatortimer-sendclientmessage", function()
	local message = net.ReadString()
	if string.sub(message,0,14)=="[DONATORTIMER]" then message = string.sub(message,39) end
	chat.AddText(Color(34,37,46),"[DONATOR] ",color_white,message)
end)

local donats = donats or {}
local ypos = ScrH()/6
hook.Add("HUDPaint","donatortimer",function()
	if table.Count(donats)>0 then
		local randomcolor = Color(math.random(50,200),math.random(50,200),math.random(50,200))
		draw.SimpleTextOutlined("YENİ DONATOR:","bebasdonator",ScrW()/2,ypos-70,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(51,51,51))
		draw.SimpleTextOutlined(donats[1],"bebasdonator",ScrW()/2,ypos,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,randomcolor)
	end
end)

local function drawdonatorluk(isim)
	table.insert(donats,isim)
	timer.Simple(7,function() table.RemoveByValue(donats,isim) end)
end

net.Receive("donatortimer-newdonator", function()
	local ply = net.ReadString()
	surface.PlaySound("donators/donatorsatinaldi.wav")
	drawdonatorluk(ply)
end)