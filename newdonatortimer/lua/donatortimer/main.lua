hook.Add("Initialize","donatortimer-initsql", function()
	sql.Query("CREATE TABLE IF NOT EXISTS donators (name string NOT NULL, steamid64 int NOT NULL, bitecegitarih int NOT NULL, ekleyenadi string NOT NULL, ekleyensteamid64 int NOT NULL)")
	sql.Query("CREATE TABLE IF NOT EXISTS donatorlogs (date int NOT NULL, log string NOT NULL)")
	print("[DONATORTIMER] SQLite DBs initialized.")
	donatortimer:CheckDonatorsFromData()
end)

local function preparekalaninfo(time)
	local kalan = "Bitti"
	local color = color_white
	local brut = time-os.time()
	local days 
	local hours

	if brut>86400 then
		days = math.floor(brut/86400)
		brut = brut-(days*86400)
		hours = math.floor((brut%86400)/3600,1)
		kalan = days.." gün "..(hours==0 and "" or hours.." saat")
	else 
		if brut<86400 and brut>0 then
			days = 0
			hours = math.floor(brut/3600)
			local mins = math.floor((brut%3600)/60)
			kalan = hours==0 and (mins==0 and "" or mins.." dakika") or hours..(" saat "..(mins==0 and "" or mins.." dakika"))
		end
	end
	return kalan
end


hook.Add("PlayerInitialSpawn","donatortimer-firstcheck", function(ply)
	if ply:IsDonator() then
		ply:CheckDonator()
		local data = sql.Query("SELECT bitecegitarih FROM donators WHERE steamid64 = "..ply:SteamID64())
		if data then 
			local kalan = preparekalaninfo(data[1].bitecegitarih)
			ply:SendDonatorMessage("Tekrar hoşgeldin! Sunucumuzda donatorsun. Kalan süren: "..kalan)
		end
	end
end)

util.AddNetworkString("donatortimer-menu")

--[[
	0 = admin
	1 = donator
	2 = customer
]]

hook.Add("PlayerSay", "donatortimer-menucall", function(ply, text, unused)
	if (text == "!donator") then
		net.Start("donatortimer-menu")
		local done = false
		if donatortimer.config.whocangiveremove[ply:SteamID()] then
			net.WriteInt(0,4)
			net.WriteInt(os.time(),32)
			local data = sql.Query("SELECT * FROM donators")
			local logs = sql.Query("SELECT * FROM donatorlogs")
			net.WriteTable(data or {})
			net.WriteTable(logs or {})
			done = true
		end

		if ply:IsDonator() then
			if not done then
				local data = sql.Query("SELECT * FROM donators WHERE steamid64 = "..ply:SteamID64())
				net.WriteInt(1,4)
				net.WriteInt(os.time(),32)
				net.WriteTable(data)
				done = true
			end
		end

		if not donatortimer.config.whocangiveremove[ply:SteamID()] and not ply:IsDonator() then
			if not done then
				net.WriteInt(2,4)
				done = true
			end
		end
		net.Send(ply)
	end
end)

concommand.Add("givedonator", function(ply, cmd, args)
	if not args then return end
	if not donatortimer.config.whocangiveremove[ply:SteamID()] then return end

	if IsValid(player.GetBySteamID64(args[1])) then
		if args[2] then
			local target = player.GetBySteamID64(args[1])
			target:GiveDonator(ply,tonumber(args[2]))
		else
			ply:SendDonatorMessage("Bir süre belirtmelisin.")			
		end
	else
		ply:SendDonatorMessage(args[1] or "Girilmemiş".." SteamID64lü bir oyuncu bulunamadı.")
	end
end)

concommand.Add("removedonator", function(ply, cmd, args)
	if not args then return end
	if not donatortimer.config.whocangiveremove[ply:SteamID()] then return end

	if IsValid(player.GetBySteamID64(args[1])) then
		local target = player.GetBySteamID64(args[1])
		target:RemoveDonator(ply)
	else
		donatortimer.RDSteamID64(ply, args[1])
	end
end)

timer.Create("donatortimer-checktimer", 30, 0, function() 
	for k,v in pairs(player.GetAll()) do 
		if v:IsDonator() then 
			v:CheckDonator() 
		end 
	end
end)