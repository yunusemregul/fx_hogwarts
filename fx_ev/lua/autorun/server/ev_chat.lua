local homes = {
	"gryffindor",
	"hufflepuff",
	"ravenclaw",
	"slytherin",
	"evsiz"
}

local order = {
	["hufflepuff"] = 1,
	["gryffindor"] = 2,
	["slytherin"] = 3,
	["ravenclaw"] = 4,
	["yok"] = 5
}

util.AddNetworkString("ev_degisim_menu")
util.AddNetworkString("ev_degistir")

hook.Add("PlayerSay", "ev_sistemi_evdegistir", function(ply, text)
	local text = string.lower(text)

	if (string.sub(text,0,11)=="!evdegistir") or (string.sub(text,0,11)=="/evdegistir") then
		if ply:IsAdmin() then
			net.Start("ev_degisim_menu")
			net.Send(ply)
			return ""
		else
			ply:ChatPrint("Yetkin yok!")
		end
	end
end)

net.Receive("ev_degistir", function(len, ply)
	if not ply:IsSuperAdmin() then return end

	local target = net.ReadEntity()
	local new_home = net.ReadString()

	if target==nil then
		ply:SendLua("chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'Hedef bulunamadi!')")
		return
	end	
	if not table.HasValue(homes,new_home) then
		ply:SendLua("chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'Girdiginiz ev bulunamadi!')")
		return
	end

	if (target!=nil) and table.HasValue(homes,new_home) then
		local sec = sql.QueryValue("SELECT ev FROM ev_sistemi WHERE id="..target:SteamID64())
		local setTeam = target.changeTeam or target.SetTeam
		timer.Simple(0,function() setTeam(target, ev_sistemi[new_home], true) end)
		if (new_home=="evsiz") then
			target:SetNWString("hogwarts_ev","yok")
			target:SetNWString("Evcek",tostring(order["yok"]))
		else
			target:SetNWString("hogwarts_ev",new_home)
			target:SetNWString("Evcek",tostring(order[new_home]))
		end

		for i=1,#player.GetAll() do
			player.GetAll()[i]:SendLua("chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'"..target:Nick().." artık bir "..new_home:upper().."!')")
		end

		if (new_home=="evsiz") then
			if (sec!=nil) and isstring(sec) then
				sql.Query("DELETE FROM ev_sistemi WHERE id="..target:SteamID64())
			end
		else
			if (sec!=nil) and isstring(sec) then
				sql.Query("UPDATE ev_sistemi SET ev = '"..new_home.."' WHERE id="..target:SteamID64())
			else
				sql.Query("INSERT INTO ev_sistemi (ev, id) VALUES ('"..new_home.."', "..target:SteamID64()..")")
			end
		end
	end	
end)