util.AddNetworkString("donatortimer-sendclientmessage")
util.AddNetworkString("donatortimer-newdonator")

local meta = FindMetaTable("Player")

function meta:GiveDonator(whodid, endtime)
	--basic checks
		if not whodid or not endtime then return end
		if not whodid:IsPlayer() then return end
		if not isnumber(endtime) then endtime = tonumber(endtime) end
		if not donatortimer.config.whocangiveremove[whodid:SteamID()] then return end
		if endtime<=os.time() then return end
		if self:IsBot() then return end
	--end

	local datafromsql = sql.QueryValue("SELECT bitecegitarih FROM donators WHERE steamid64 = "..self:SteamID64())
	if datafromsql then return whodid:SendDonatorMessage(self:Name().." isimli oyuncu zaten donator.") end

	local ranktogive = "donator"
	for k,v in pairs(donatortimer.config.donators) do 
		if v==self:GetUserGroup() then
			ranktogive = k 
		end
	end
	ULib.ucl.addUser(self:SteamID(),{},{},ranktogive)
	sql.Query("INSERT INTO donators (name, steamid64, bitecegitarih, ekleyenadi, ekleyensteamid64) VALUES ('"..self:Name().."', "..self:SteamID64()..", "..endtime..", '"..whodid:Name().."', "..whodid:SteamID64()..")")
	local tarihstring = os.date("%d.%m.%Y", endtime)
	if tarihstring==nil then tarihstring = "bilinmeyen" end
	if self==whodid then
		donatorlog(whodid:Name().." isimli yetkili kendisine "..tarihstring.." tarihinde bitecek donatorluk verdi.")
	else
		donatorlog(whodid:Name().." isimli yetkili "..self:Name().." isimli oyuncuya "..tarihstring.." tarihinde bitecek donatorluk verdi.")
	end
	net.Start("donatortimer-newdonator")
		net.WriteString(self:Name())
	net.Broadcast()
end

function meta:RemoveDonator(whodid)
	--basic checks
		if whodid then
			if not donatortimer.config.whocangiveremove[whodid:SteamID()] then return end
		else
			whodid = "KONSOL"
		end
		if self:IsBot() then return end
	--end

	if not whodid=="KONSOL" then
		local datafromsql = sql.QueryValue("SELECT bitecegitarih FROM donators WHERE steamid64 = "..self:SteamID64())
		if not datafromsql then return whodid:SendDonatorMessage(self:Name().." isimli oyuncunun donatorlugu zaten yok.") end
	end

	local ranktogive = donatortimer.config.donators[self:GetUserGroup()] or "user"
	ULib.ucl.addUser(self:SteamID(),{},{},ranktogive)
	sql.Query("DELETE FROM donators WHERE steamid64 = "..self:SteamID64())
	if whodid=="KONSOL" then 
		donatorlog(self:Name().." isimli oyuncunun donatorlugu bitti.") 
		self:SendDonatorMessage("Donatorluğun bitti!")
	else
		if whodid==self then
			donatorlog(whodid:Name().." isimli yetkili kendi donatorlugunu sildi.")
		else
			donatorlog(whodid:Name().." isimli yetkili "..self:Name().." isimli oyuncunun donatorlugunu sildi.")
		end
	end
end

function meta:CheckDonator()
	if not self:IsDonator() then return end
	local endtime = sql.QueryValue("SELECT bitecegitarih FROM donators WHERE steamid64 = "..self:SteamID64())
	endtime = tonumber(endtime)
	
	if not endtime or endtime<=os.time() then
		self:RemoveDonator()
	end
end