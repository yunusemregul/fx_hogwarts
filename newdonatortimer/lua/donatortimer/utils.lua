local meta = FindMetaTable("Player")

function meta:IsDonator()
	if donatortimer.config.donators[self:GetUserGroup()] then
		return true
	end
	return false
end

function meta:SendDonatorMessage(message)
	net.Start("donatortimer-sendclientmessage")
		net.WriteString(message)
	net.Send(self)
end

function SendDonatorMessageToAll(message)
	--for k,v in pairs(player.GetAll()) do
		--if v:GetUserGroup()!="user" and v:GetUserGroup()!="donator" then
			net.Start("donatortimer-sendclientmessage")
				net.WriteString(message)
			net.Broadcast()
		--end
	--end
end

function donatorlog(message, time)
	if not time then time = os.time() end
	local message = "[DONATORTIMER] "..os.date("[%d/%m/%Y][%H:%M:%S]", time).." "..message
	print(message)
	SendDonatorMessageToAll(message)
	sql.Query("INSERT INTO donatorlogs (date, log) VALUES ("..time.." ,'"..string.sub(message,16).."')")
end

function donatortimer:CheckDonatorsFromData()
	local data = sql.Query("SELECT * FROM donators")
	if not data then return end
	if not istable(data) then return end
	if table.Count(data)>0 then
		for k,v in pairs(data) do 
			if v.bitecegitarih-os.time()<=0 then
				sql.Query("DELETE FROM donators WHERE steamid64 = "..v.steamid64)
				donatorlog(v.name.." isimli oyuncunun donatorlugu bitti.",v.bitecegitarih)
			end
		end
	end
end