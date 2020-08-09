local evler = {"gryffindor", "hufflepuff", "ravenclaw", "slytherin"}
util.AddNetworkString("puan_show")

hook.Add("Initialize", "fxpuan", function()
	sql.QueryValue("CREATE TABLE IF NOT EXISTS fxpuan(ev TEXT NOT NULL PRIMARY KEY, puan INT);")

	for _, ev in pairs(evler) do
		if not sql.QueryValue("SELECT ev FROM fxpuan WHERE ev=\"" .. ev .. "\";") then
			sql.QueryValue("INSERT INTO fxpuan(ev,puan) VALUES (\"" .. ev .. "\", 0);")
		end
	end

	print("[FX-PUAN] Data hazir.")
end)

local checkIfProfesor

local function puanekle(ev, puan)
	if not table.HasValue(evler, ev) then return false end
	local suankipuan = tonumber(sql.QueryValue("SELECT puan FROM fxpuan WHERE ev=\"" .. ev .. "\";"))
	local yenipuan = suankipuan + puan
	sql.QueryValue("UPDATE fxpuan SET puan=" .. yenipuan .. " WHERE ev=\"" .. ev .. "\";")

	return yenipuan
end

local function fxpuan(ply, text)
	text = text:lower()

	if text:sub(0, 5) == "!puan" or text:sub(0, 5) == "/puan" then
		if checkIfProfesor(ply) then
			local args = string.Explode(" ", text)

			if not #args == 3 then
				ply:ChatPrint("kullanim ornegi: !puan gryffindor 10")

				return ""
			end

			if not table.HasValue(evler, args[2]) then
				ply:ChatPrint("ev bulunamadi, evler: gryffindor,  hufflepuff, ravenclaw, slytherin")

				return
			end

			if not tonumber(args[3]) then
				ply:ChatPrint("kullanim ornegi: !puan gryffindor 10")

				return ""
			end

			local yenipuan = puanekle(args[2], tonumber(args[3]))

			for _, _ply in pairs(player.GetAll()) do
				_ply:SendLua([[chat.AddText(Color(255,128,0),"PUAN - ",color_white,"]] .. ply:Nick() .. [[ isimli profesor ",Color(255,0,128),"]] .. string.upper(args[2]) .. [[",color_white," evine ",Color(255,0,128),"]] .. tonumber(args[3]) .. [[",color_white," puan verdi.")]])
			end

			net.Start("puan_show")

			for _, ev in pairs(evler) do
				local puan = tonumber(sql.QueryValue("SELECT puan FROM fxpuan WHERE ev=\"" .. ev .. "\";"))
				net.WriteString(ev .. ":" .. puan)
			end

			net.Broadcast()
			notify_server(ply:Nick() .. " [" .. ply:SteamID() .. "] isimli profesör " .. string.upper(args[2]) .. " evine " .. tonumber(args[3]) .. " puan verdi. " .. string.upper(args[2]) .. " evinin yeni puanı " .. yenipuan .. " oldu.", tonumber(args[3])>0 and "green" or "red")

			return ""
		else
			net.Start("puan_show")

			for _, ev in pairs(evler) do
				local puan = tonumber(sql.QueryValue("SELECT puan FROM fxpuan WHERE ev=\"" .. ev .. "\";"))
				net.WriteString(ev .. ":" .. puan)
			end

			net.Send(ply)

			return ""
		end
	end
end
hook.Add("PlayerSay", "fxpuan", fxpuan)


if not fx_d then
	error("[FX-PUAN] Ders sistemi bulunamadi.")
else
	checkIfProfesor = function(ply)
		local ply_team = team.GetName(ply:Team())
		if (table.HasValue(fx_d.acabilecekler, ply_team)) then return true end

		for i = 1, #fx_d.acabilecekler do
			if ply_team:find(fx_d.acabilecekler[i]) then return true end
		end
		return false
	end
end