util.AddNetworkString("fx_irk-secim")
util.AddNetworkString("fx_irk-irkdegis")

local function rate_to_number(rate)
	return tonumber((string.Right(rate, 2)))
end

local function keyed_table_getaskey(tab, key)
	local count = 0
	local to_return = nil
	if (key == 0) then return nil end

	for k, value in pairs(tab) do
		count = count + 1

		if (key == count) then
			to_return = value
		end
	end

	return to_return
end

local function ratecheck()
	local toplam = 0

	for name, data in pairs(fx_irk.irklar) do
		toplam = toplam + rate_to_number(data.rate)
	end

	if toplam ~= 100 then
		error("Rate'ler toplami '100' degil, '" .. toplam .. "'. Sistem calismayacak.")

		return false
	end
end

hook.Add("Initialize", "fx_irk_initialize", function()
	sql.Query("CREATE TABLE IF NOT EXISTS fx_irk(irk string NOT NULL, id BIGINT NOT NULL PRIMARY KEY, shouldinform INT NOT NULL)")
	print("[FX-IRK] Irk datasi hazir.")
	ratecheck()
end)

local function get_name_from_realkey(realkey)
	local to_return = nil

	for name, data in pairs(fx_irk.irklar) do
		if data.realkey == realkey then
			to_return = name
		end
	end

	return to_return
end

hook.Add("PlayerInitialSpawn", "fx_irk_initialspawn", function(ply)
	local query = sql.QueryValue("SELECT irk FROM fx_irk WHERE id=" .. ply:SteamID64() .. "")
	local shouldinform = tobool(sql.QueryValue("SELECT shouldinform FROM fx_irk WHERE id=" .. ply:SteamID64() .. ""))
	ratecheck()

	if query ~= nil and isstring(query) then
		ply:SetNWString("fx_irk", query)
		ply:SetNWString("irk", get_name_from_realkey(query))

		if shouldinform == true then
			ply.fx_irk_inform = true
		end
	else
		local check = ratecheck()

		if (check ~= false) then
			local positions = {}

			for name, data in pairs(fx_irk.irklar) do
				table.insert(positions, {
					id = data.realkey,
					num = ((#positions == 0) and rate_to_number(data.rate) or positions[#positions].num + rate_to_number(data.rate))
				})
			end

			local random = math.random(100)
			local count = 0
			local selected = ""

			for i, data in ipairs(positions) do
				count = count + 1
				local lower = (i - 1) == 0 and 0 or positions[i - 1].num
				local higher = positions[i].num

				if (random >= lower) and (random < higher) then
					selected = data.id
				end
			end

			if not IsValid(ply) then return end
			if not selected or not get_name_from_realkey(selected) then print("fxirk hata: ",ply:SteamID64(),selected) file.Append("fx_irk_hatalar.txt",ply:SteamID64()..tostring(selected)) return end
			sql.QueryValue("INSERT INTO fx_irk (irk, id, shouldinform) VALUES ('" .. selected .. "', " .. ply:SteamID64() .. ", 0)")
			ply:SetNWString("fx_irk", selected)
			ply:SetNWString("irk", get_name_from_realkey(selected))
			print("[FX-IRK] " .. ply:Nick() .. " isimli oyuncunun irki '" .. get_name_from_realkey(selected) .. "' olarak belirlendi.")
			ply.fx_irk_inform = true
		end
	end
end)

hook.Add("KeyPress", "fx_irk-bilgilendirme", function(ply, key)
	if ply.fx_irk_inform and ply.fx_irk_inform == true then
		timer.Simple(0, function()
			local query = sql.QueryValue("SELECT irk FROM fx_irk WHERE id=" .. ply:SteamID64() .. "")
			net.Start("fx_irk-secim")
			net.WriteString(query)
			net.Send(ply)
			ply:Freeze(true)

			timer.Simple(fx_irk.gostermesuresi, function()
				if IsValid(ply) then
					ply:Freeze(false)
				end
			end)

			ply.fx_irk_inform = false
		end)
	end
end)

hook.Add("PlayerSay", "fx_irk-irkdegis", function(ply, text)
	local text = string.lower(text)

	if (text == "!irkdegis") or (text == "/irkdegis") or (text == "!irkdegistir") or (text == "/irkdegistir") then
		if ply:IsSuperAdmin() or ply:IsUserGroup("headadmin") then
			net.Start("fx_irk-irkdegis")
			net.Send(ply)

			return ""
		end
	end
end)

local function info(ply, problem)
	if problem == "alreadyit" then
		if IsValid(ply) then
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Hata: ",color_white,"Oyuncu zaten degistirmek istediginiz irkta.")]])
		else
			MsgC(Color(242, 108, 79), "[FX-IRK] Hata: ", color_white, "Oyuncu zaten degistirmek istediginiz irkta.\n")
		end

		return
	end

	if problem == "plynotfound" then
		if IsValid(ply) then
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Hata: ",color_white,"Oyuncu bulunamadı.")]])
		else
			MsgC(Color(242, 108, 79), "[FX-IRK] Hata: ", color_white, "Oyuncu bulunamadi.\n")
		end

		return
	end

	if problem == "irknotfound" then
		local realkeys = ""

		for name, data in pairs(fx_irk.irklar) do
			realkeys = realkeys .. (string.len(realkeys) == 0 and "" or " | ") .. ("AD: " .. name .. ", REALKEY: " .. data.realkey)
		end

		if IsValid(ply) then
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Hata: ",color_white,"Girdiğiniz ırk bulunamadı. 'realkey' girdiğinize emin olun.")]])
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Hata: ",color_white,"Aktif realkeyler: ]] .. realkeys .. [[")]])
		else
			MsgC(Color(242, 108, 79), "[FX-IRK] Hata: ", color_white, "Girdiginiz irk bulunamadi. 'realkey' girdiginize emin olun.\n")
			MsgC(Color(242, 108, 79), "[FX-IRK] Hata: ", color_white, "Aktif realkeyler: " .. realkeys .. "\n")
		end

		return
	end

	if problem == "args" then
		if IsValid(ply) then
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Kullanım: ",color_white,"irkdegis \"<steamid>\" \"<irk realkey>\"")]])
			ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] Örnek: ",color_white,"irkdegis \"STEAM_0:1:23456789\" \"]] .. table.GetFirstValue(fx_irk.irklar).realkey .. [[\"")]])
		else
			MsgC(Color(242, 108, 79), "[FX-IRK] Kullanım: ", color_white, "irkdegis \"<steamid>\" \"<irk realkey>\"\n")
			MsgC(Color(242, 108, 79), "[FX-IRK] Örnek: ", color_white, "irkdegis \"STEAM_0:1:23456789\" \"" .. table.GetFirstValue(fx_irk.irklar).realkey .. "\"\n")
		end

		return
	end
end

local function irkdegisimconcommand(ply, cmd, args)
	if not (ply == NULL) and not (ply:IsSuperAdmin()) then return end

	if (#args ~= 2) and (#args ~= 3) then
		info(ply, "args")

		return
	end

	local query = sql.QueryValue("SELECT irk FROM fx_irk WHERE id=" .. util.SteamIDTo64(args[1]) .. "")

	if (query == nil) then
		info(ply, "plynotfound")

		return
	else
		if (query == args[2]) then
			info(ply, "alreadyit")

			return
		end

		local found = false

		for name, data in pairs(fx_irk.irklar) do
			if data.realkey == args[2] then
				found = true
			end
		end

		if found == false then
			info(ply, "irknotfound")

			return
		else
			sql.QueryValue("UPDATE fx_irk SET irk='" .. args[2] .. "' WHERE id='" .. util.SteamIDTo64(args[1]) .. "'")

			if DarkRP then
				local rpname = sql.QueryValue("SELECT rpname FROM darkrp_player WHERE uid=" .. util.SteamIDTo64(args[1])) or "(Nicki Bulunamadi)"

				if IsValid(ply) then
					ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] ",color_white,"]] .. rpname .. [[ (]] .. args[1] .. [[) oyuncusunun ırkı ]] .. get_name_from_realkey(args[2]) .. [[ olarak değiştirildi.")]])
				else
					MsgC(Color(242, 108, 79), "[FX-IRK] ", color_white, rpname .. " (" .. args[1] .. ") oyuncusunun irki " .. get_name_from_realkey(args[2]) .. " olarak degistirildi.\n")
				end
			else
				local rpname = "(Nicki Bulunamadi)"

				if IsValid(ply) then
					ply:SendLua([[chat.AddText(Color(242,108,79),"[FX-IRK] ",color_white,"]] .. rpname .. [[ (]] .. args[1] .. [[) oyuncusunun ırkı ]] .. get_name_from_realkey(args[2]) .. [[ olarak değiştirildi.")]])
				else
					MsgC(Color(242, 108, 79), "[FX-IRK] ", color_white, rpname .. " (" .. args[1] .. ") oyuncusunun irki " .. get_name_from_realkey(args[2]) .. " olarak degistirildi.\n")
				end
			end

			if (IsValid(player.GetBySteamID(args[1]))) then
				local tar = player.GetBySteamID(args[1])
				tar:SetNWString("fx_irk", args[2])
				tar:SetNWString("irk", get_name_from_realkey(args[2]))
			end

			if args[3] and (tonumber(args[3]) == 1) then
				if IsValid(player.GetBySteamID(args[1])) then
					local target = player.GetBySteamID(args[1])
					target.fx_irk_inform = true
				else
					sql.QueryValue("UPDATE fx_irk SET shouldinform=1 WHERE id=" .. util.SteamIDTo64(args[1]))
				end
			elseif not args[3] then
				if IsValid(player.GetBySteamID(args[1])) then
					local target = player.GetBySteamID(args[1])
					target.fx_irk_inform = true
				else
					sql.QueryValue("UPDATE fx_irk SET shouldinform=1 WHERE id=" .. util.SteamIDTo64(args[1]))
				end
			end
		end
	end
end

concommand.Add("irkdegis", irkdegisimconcommand)
concommand.Add("irkdegistir", irkdegisimconcommand)