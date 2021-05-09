function donatortimer.RDSteamID64(whodid, steamid64)
	--basic checks	
		if not donatortimer.config.whocangiveremove[whodid:SteamID()] then return end
	--end

	local datafromsql = sql.QueryValue("SELECT bitecegitarih FROM donators WHERE steamid64 = "..steamid64)
	if not datafromsql then return whodid:SendDonatorMessage(util.SteamIDFrom64(steamid64).." SteamIDli oyuncunun donatorlugu zaten yok.") end

	local name = sql.QueryValue("SELECT name FROM donators WHERE steamid64 = "..steamid64)
	if not name then return end
	sql.Query("DELETE FROM donators WHERE steamid64 = "..steamid64)
	donatorlog(whodid:Name().." isimli yetkili "..name.." isimli oyuncunun donatorlugunu aldi.")
end