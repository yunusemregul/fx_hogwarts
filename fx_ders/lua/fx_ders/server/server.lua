util.AddNetworkString("fx_ders_menu")

util.AddNetworkString("fx_ders_start_ders")
util.AddNetworkString("fx_ders_end_ders")
util.AddNetworkString("fx_ders_buyuver")

fx_d.version = "3.8.2"

fx_ders_hp_table = fx_ders_hp_table or {}
fx_ders_hp_queue = fx_ders_hp_queue or {{},{}};

fx_d_print("Sistem v"..fx_d.version.." versiyonuyla çalışıyor.")

local function checkIfProfesor(ply)
	local ply_team = team.GetName(ply:Team())
	if (table.HasValue(fx_d.acabilecekler,ply_team)) then
		return true
	end
	for i=1,#fx_d.acabilecekler do
		if ply_team:find(fx_d.acabilecekler[i]) then
			return true
		end
	end
	return false
end

local function removeDersOnQueue(dersno)
	net.Start("fx_ders_queue_end")
		net.WriteInt(dersno,4)
		net.WriteUInt(1,5)
	net.Send(getProfessors())

	if areThereAnyDersOnQueue(dersno) then
		//fx_ders_hp_queue[dersno][1] = nil; -- sıradaki ilk dersi yani en üstteki dersi siliyoruz
		table.remove(fx_ders_hp_queue[dersno],1);
	end	
end

local function sendqueued(ply)
	for i=1,2 do
		for _, tab in ipairs(fx_ders_hp_queue[i]) do
			net.Start("fx_ders_queue_ders")
				net.WriteInt(tab.dersno,4)
				net.WriteString(tab.starter)
				net.WriteInt(table.Count(tab),8)
				for key,value in pairs(tab) do
					net.WriteString(key..";"..tostring(value))
				end
			net.Send(ply)
		end
	end
end

hook.Add("PlayerSay", "fx_ders_playersay", function(ply, text)
	local text = text:lower()

	if (text=="!ders") then
		if (checkIfProfesor(ply)) then
			net.Start("fx_ders_menu")
			net.Send(ply)
			return ""
		else
			local acabilecek_str = "Menuyu acabilmek icin uygun meslege gecmelisin!"
			ply:ChatPrint(acabilecek_str)
		end
		return ""
	end
end)

local function checkOutTime()
	for i=1, 2 do
		if fx_ders_hp_table[i] and fx_ders_hp_table[i].time then
			if fx_ders_hp_table[i].time<CurTime() then
				fx_ders_hp_table[i] = {}
			end
		end
	end
end

local function fx_d_ders_basla(dersno, tab)
	net.Start("fx_ders_start_ders")
		net.WriteInt(dersno,4)
		net.WriteString(tab.starter)
		net.WriteInt(table.Count(tab),8)
		for key,value in pairs(tab) do
			net.WriteString(key..";"..tostring(value))
		end
	net.Broadcast()
	fx_d_print("["..dersno..". DERS] "..tab.starter.." isimli profesör "..tab.ders.." dersini başlattı.")

	fx_ders_hp_table[dersno] = tab
	fx_ders_hp_table[dersno].time = CurTime()+(tab.sure*60)	

	if timer.Exists("fx_ders_timer_"..dersno) then
		timer.Remove("fx_ders_timer_"..dersno)
	end
	if timer.Exists("fx_ders_end_timer"..dersno) then
		timer.Remove("fx_ders_end_timer"..dersno)
	end
	timer.Create("fx_ders_end_timer"..dersno,(tab.sure*60),1,function()
		/* v3.feel */
			if fx_kutuphane then
				if fx_ders_hp_table[dersno].buyu then
					local buyu = fx_ders_hp_table[dersno].buyu
					if fx_d_cangivespell(buyu) then
						for _, plys in pairs(player.GetAllInDers(dersno)) do
							plys:FX_AddBuyu(buyu, 1)
						end
						fx_d_print("Ders bitti, toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsü verildi.")
					end
				end
			else
				if fx_ders_hp_table[dersno].buyu then
					local buyu = fx_ders_hp_table[dersno].buyu


					if fx_d_cangivespell(buyu) then
						local shouldGive = hook.Run("fx_ders_buyuver", dersno, buyu)

						if (shouldGive!=false) then
							for _, plys in pairs(player.GetAllInDers(dersno)) do
								HpwRewrite:PlayerGiveLearnableSpell(plys, buyu)
							end
							fx_d_print("Ders bitti, toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsü verildi.")
						end
					end
				end
			end
		/**/
		for _, ply in pairs(player.GetHumans()) do
			ply:SendLua([[surface.PlaySound("ui/achievement_earned.wav")]])
			ply:SendLua([[chat.AddText(Color(7,229,142),"[]]..dersno..[[. DERS] ]]..tab.ders..[[",color_white," dersi sona erdi.")]])
		end
		fx_d_print("["..dersno..". DERS] "..tab.ders.." dersi sona erdi.")
		hook.Run("fx_ders_end",dersno,tab)
	end)
	timer.Create("fx_ders_timer_"..dersno,1,(((tab.sure*60))+1),function()
		for _, ply in pairs(player.GetHumans()) do
			for i=1,2 do
				if ply:isInDers(i) and not (ply:GetNWInt("ders",0)==i) then
					ply:SetNWInt("ders",i)
					timer.Simple(0,function() ply:SendLua([[LocalPlayer():SetNWInt("ders",]]..i..[[) fx_d.ders_state_changed("in")]]) end)
				end
			end
			if not ply:isInAnyDers() and (ply:GetNWInt("ders",0)!=0) then
				ply:SetNWInt("ders",0)
				timer.Simple(0,function() ply:SendLua([[LocalPlayer():SetNWInt("ders",0) fx_d.ders_state_changed("out")]]) end)
			end
		end
	end)

	hook.Run("fx_ders_start",dersno,tab)
end

net.Receive("fx_ders_start_ders", function(len, ply)
	if not checkIfProfesor(ply) then return end
	local dersno = net.ReadInt(4)
	local table_count = net.ReadInt(8)
	local tab = {}
	tab.starter = ply:Name()

	for i=1,table_count do
		local str = net.ReadString()
		tab[string.Explode(";",str)[1]] = string.Explode(";",str)[2]
	end
	if areThereAnyDersOnQueue(dersno) then return ply:ChatPrint("Sirada ders varken ders acamazsin!") end;
	if not fx_d.dersler[tab.ders] then return ply:ChatPrint("Ders belirlemelisin!") end
	if not fx_d.siniflar[tab.sinif] then return ply:ChatPrint("Sinif belirlemelisin!") end

	checkOutTime()

	if fx_ders_hp_table[1] and fx_ders_hp_table[1].sinif then
		if fx_ders_hp_table[1].sinif==tab.sinif then
			return ply:ChatPrint("Bu sinifta zaten ders var!")
		end
	end
	if fx_ders_hp_table[2] and fx_ders_hp_table[2].sinif then
		if fx_ders_hp_table[2].sinif==tab.sinif then
			return ply:ChatPrint("Bu sinifta zaten ders var!")
		end
	end

	fx_d_ders_basla(dersno,tab);
end)

hook.Add("PlayerInitialSpawn","fx_ders_sendders_initialspawn",function(ply)
	timer.Simple(1, function()
		for i=1, 2 do
			if fx_ders_hp_table[i] and fx_ders_hp_table[i].time and (fx_ders_hp_table[i].time>CurTime()) then
				timer.Simple(0,function()
					net.Start("fx_ders_start_ders")
						net.WriteInt(i,4)
						net.WriteString(fx_ders_hp_table[i].starter)
						net.WriteInt(table.Count(fx_ders_hp_table[i]),8)
						for key,value in pairs(fx_ders_hp_table[i]) do
							if key=="sure" then
								value = ((fx_ders_hp_table[i].time-CurTime())/60)
								net.WriteString(key..";"..tostring(value))
							else
								net.WriteString(key..";"..tostring(value))
							end
						end
					net.Send(ply)
				end)		
			end
		end

		if ply.SH_WHITELIST and canBeProfessor(ply) then
			sendqueued(ply)
		end
	end)
end)

net.Receive("fx_ders_end_ders", function(len, ply)
	if not checkIfProfesor(ply) then return end
	local dersno = net.ReadInt(4)
	if fx_ders_hp_table[dersno].time==0 then return end
	
	fx_d_print("["..dersno..". DERS] "..ply:Nick().." isimli profesör "..fx_ders_hp_table[dersno].ders.." dersini bitirdi.")

	local save = fx_ders_hp_table[dersno]

	/* v3.feel */
		if fx_kutuphane then
			if fx_ders_hp_table[dersno].buyu then
				local buyu = fx_ders_hp_table[dersno].buyu
				if fx_d_cangivespell(buyu) then
					for _, plys in pairs(player.GetAllInDers(dersno)) do
						plys:FX_AddBuyu(buyu, 1)
					end
					DarkRP.notify(ply,0,8,"Toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsünü verdin.")
					fx_d_print("Ders bitti, toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsü verildi.")
				end
			end
		else
			if fx_ders_hp_table[dersno].buyu then
				local buyu = fx_ders_hp_table[dersno].buyu
				if fx_d_cangivespell(buyu) then
					local shouldGive = hook.Run("fx_ders_buyuver", dersno, buyu)

					if (shouldGive!=false) then
						for _, plys in pairs(player.GetAllInDers(dersno)) do
							HpwRewrite:PlayerGiveLearnableSpell(plys, buyu)
						end
						DarkRP.notify(ply,0,8,"Toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsünü verdin.")
						fx_d_print("Ders bitti, toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsü verildi.")
					end
				end
			end
		end
	/**/

	fx_ders_hp_table[dersno] = {}
	fx_ders_hp_table[dersno].time = 0

	for _, ply in pairs(player.GetHumans()) do
		if ply:isInDers(dersno) then
			ply:SetNWInt("ders",0)
		end
	end
	if timer.Exists("fx_ders_timer_"..dersno) then
		timer.Remove("fx_ders_timer_"..dersno)
	end
	if timer.Exists("fx_ders_end_timer"..dersno) then
		timer.Remove("fx_ders_end_timer"..dersno)
	end
	net.Start("fx_ders_end_ders")
		net.WriteString(ply:Nick())
		net.WriteInt(dersno,4)
	net.Broadcast()

	hook.Run("fx_ders_end",dersno,save)
end)

hook.Add("fx_ders_end","fx_ders_queue",function(dersno, tab)
	if areThereAnyDersOnQueue(dersno) then
		fx_d_print(dersno..". ders bitti ve yerine "..math.floor(fx_d.siraliderstenefusu/60).." dakika sonra siradaki "..getDersOnQueue(dersno).ders.." dersi acilacak.")
		timer.Create("fx_ders_queue_ders_"..dersno,fx_d.siraliderstenefusu,1,function()
			if areThereAnyDersOnQueue(dersno) then
				fx_d_ders_basla(dersno,getDersOnQueue(dersno));

				removeDersOnQueue(dersno);
			end
		end)
	end
end)

util.AddNetworkString("fx_ders_queue_ders")
util.AddNetworkString("fx_ders_queue_end")
net.Receive("fx_ders_queue_ders", function(_,ply)
	if not checkIfProfesor(ply) then return end
	if table.Count(getProfessorDersOnQueue(ply))>=fx_d.profsiraliderslimiti then return ply:ChatPrint("En fazla "..fx_d.profsiraliderslimiti.." ders siraya koyabilirsin."); end
	local dersno = net.ReadInt(4)
	local table_count = net.ReadInt(8)
	local tab = {}
	tab.starter = ply:Name()
	tab.steamid = ply:SteamID()

	for i=1,table_count do
		local str = net.ReadString()
		tab[string.Explode(";",str)[1]] = string.Explode(";",str)[2]
	end
	if not fx_d.dersler[tab.ders] then return ply:ChatPrint("Ders belirlemelisin!") end
	if not fx_d.siniflar[tab.sinif] then return ply:ChatPrint("Sinif belirlemelisin!") end

	if areThereAnyDersOnQueue(dersno==1 and 2 or 1) then
		if getDersOnQueue(dersno==1 and 2 or 1,table.Count(fx_ders_hp_queue[dersno])+1).sinif==tab.sinif then
			return ply:ChatPrint("Zaten "..(dersno==1 and 2 or 1)..". ders sirasinda bu sinifta ders acilacak.");
		end
	end

	fx_d_print("["..dersno..". DERS] "..tab.starter.." isimli profesör sıraya "..tab.ders.." dersini ekledi.")

	net.Start("fx_ders_queue_ders")
		net.WriteInt(dersno,4)
		net.WriteString(tab.starter)
		net.WriteInt(table.Count(tab),8)
		for key,value in pairs(tab) do
			net.WriteString(key..";"..tostring(value))
		end
	net.Send(getProfessors())

	tab.time = (tab.sure*60)
	table.insert(fx_ders_hp_queue[dersno],tab)
end)

net.Receive("fx_ders_queue_end", function(_, ply)
	if not checkIfProfesor(ply) then return end
	local dersno = net.ReadInt(4); 
	local queue_number = net.ReadUInt(5); 
	//fx_ders_hp_queue[dersno][queue_number] = nil;
	table.remove(fx_ders_hp_queue[dersno],queue_number);

	net.Start("fx_ders_queue_end")
		net.WriteInt(dersno,4)
		net.WriteUInt(queue_number,5)
	net.Send(getProfessors())
end)

hook.Add("PlayerDisconnected","fx_ders_queue_end",function(ply)
	local found = {};

	for i=1,2 do
		for _, tab in ipairs(fx_ders_hp_queue[i]) do
			if tab.steamid==ply:SteamID() then
				table.insert(found,{dersno = i, index = _});
			end
		end
	end

	if table.Count(found)>0 then
		fx_d_print("[FX DERS] "..ply:Nick().." sunucudan ayrildi ve siraya ekledigi "..table.Count(found).." ders siradan cikartildi.");
		for _, tab in pairs(found) do	
			//fx_ders_hp_queue[tab.dersno][tab.index] = nil;
			table.remove(fx_ders_hp_queue[tab.dersno],tab.index);

		end

		for __, tab in pairs(found) do
			net.Start("fx_ders_queue_end")
				net.WriteInt(tab.dersno,4)
				net.WriteUInt(tab.index,5)
			net.Send(getProfessors())
		end
	end
end)

if timer.Exists("fx_ders_xpgiver") then
	timer.Remove("fx_ders_xpgiver")
end

timer.Create("fx_ders_xpgiver",fx_d.xp_araligi,0,function()
	if isDersActive(1) or isDersActive(2) then
		for i=1, 2 do
			for _, ply in pairs(player.GetAllInDers(i)) do
				if ply.addXP then
					local shouldGive = hook.Run("fx_ders_xpver", i, ply);
					if (shouldGive!=false) then
						ply:addXP(fx_d.xp_miktari, true)
						DarkRP.notify(ply,0,4,"Derste bulundugun icin "..fx_d.xp_miktari.." XP kazandin.")
					end
				else
					ErrorNoHalt("HATA: ply:addXP() calismiyor. XP sistem girisi yanlis!\n")
				end		
			end
		end
	end
end)

net.Receive("fx_ders_buyuver",function(len,ply)
	if not checkIfProfesor(ply) then return end
	local dersno = net.ReadInt(4)
	local buyu = net.ReadString()
	if fx_ders_hp_table[dersno].time==0 then return end
	if fx_ders_hp_table[dersno].spellgiven==true then
		ply:ChatPrint("Bu derste zaten 1 kere büyü verilmiş.");
		return
	end	
	if fx_ders_hp_table[dersno].steamid then
		if player.GetBySteamID(fx_ders_hp_table[dersno].steamid) then
			ply:ChatPrint("Sadece dersi baslatan ["..player.GetBySteamID(fx_ders_hp_table[dersno].steamid).."] li profesor buyu verebilir. Oyundan cikarsa siz de verebilirsiniz.");
			return
		end
	end
	if not fx_d_cangivespell(buyu) then return end

	for _, plys in pairs(player.GetAllInDers(dersno)) do
		HpwRewrite:PlayerGiveLearnableSpell(plys, buyu)
	end
	DarkRP.notify(ply,0,8,"Toplamda "..table.Count(player.GetAllInDers(dersno)).." büyücüye "..buyu.." büyüsünü verdin.")
	fx_ders_hp_table[dersno].spellgiven = true;
end)