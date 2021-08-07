fx_kutuphane = fx_kutuphane or {};

util.AddNetworkString("kutuphane_menu");
util.AddNetworkString("kutuphane_menu_transfer");

function fx_kutuphane:InitDB()
	sql.Query("CREATE TABLE IF NOT EXISTS fx_kutuphane(steamid varchar(32) NOT NULL, buyu varchar(32) NOT NULL, adet tinyint NOT NULL)");
	print("[FX KUTUPHANE] Data hazirlandi.");
end

local PLAYER = FindMetaTable("Player");

function PLAYER:FX_Notify(str)
	DarkRP.notify(self,0,8,str);
end

function PLAYER:FX_GetBuyuAdet(name)
	name = name:sub(0,32);
	local adet = sql.QueryValue("SELECT adet FROM fx_kutuphane WHERE steamid='"..self:SteamID().."' AND buyu='"..name.."'");

	return tonumber(adet) or 0;
end

function PLAYER:FX_CanAffordBuyuAdet(name, count)
	local adet = (self:FX_GetBuyuAdet(name));

	return ((adet-count)>=0),adet,count;
end

function PLAYER:FX_GetBuyus()
	local tab = sql.Query("SELECT buyu,adet FROM fx_kutuphane WHERE steamid='"..self:SteamID().."'");
	if not tab then return {} end;

	local newtab = {};

	for i=1,#tab do
		newtab[tab[i].buyu] = tonumber(tab[i].adet);
	end

	return newtab;
end

function PLAYER:FX_AddBuyu(name, count)
	count = count or 1;
	name = name:sub(0,32);
	local condition = "steamid='"..self:SteamID().."' AND buyu='"..name.."'";
	local adet = sql.QueryValue("SELECT adet FROM fx_kutuphane WHERE "..condition);

	if not adet then
		sql.QueryValue("INSERT INTO fx_kutuphane (steamid, buyu, adet) VALUES ('"..self:SteamID().."', '"..name.."', "..count..")");
	else
		sql.QueryValue("UPDATE fx_kutuphane SET adet="..(adet+count).." WHERE "..condition);
	end

	self:FX_Notify(string.format(fx_kutuphane.dil["addbuyu"],name,count));
end

function PLAYER:FX_SubtractBuyu(name, count)
	count = count or 1;
	name = name:sub(0,32);
	local adet = self:FX_GetBuyuAdet(name);

	if (adet==0) then return end;

	local condition = "steamid='"..self:SteamID().."' AND buyu='"..name.."'";

	if (adet-count)>0 then
		sql.QueryValue("UPDATE fx_kutuphane SET adet="..(adet-count).." WHERE "..condition);
	else
		sql.QueryValue("DELETE FROM fx_kutuphane WHERE "..condition);
	end

	self:FX_Notify(string.format(fx_kutuphane.dil["subtractbuyu"],name,count));
end

function PLAYER:FX_CanLearnBuyu(name)	
	local adet = self:FX_GetBuyuAdet(name);
	local gereken = (fx_kutuphane.buyubilgileri[name] and fx_kutuphane.buyubilgileri[name].gerekenadet or nil) or fx_kutuphane.varsayilangerekenbuyuadedi;

	return (adet>=gereken),adet,gereken;
end

function PLAYER:FX_LearnBuyu(name)
	local canLearn, adet, gereken = self:FX_CanLearnBuyu(name);

	if not canLearn then 
		print("[FX KUTUPHANE] ["..self:Nick().."],["..self:SteamID().."] isimli, steamidli oyuncu yeteri kadar sahip olmamasina ragmen buyu ogrenmeye calisti. Muhtemelen hile yapiyor.");
		return
	end

	self:FX_SubtractBuyu(name, gereken);
	HpwRewrite:PlayerGiveLearnableSpell(self, name);
	self:FX_Notify(string.format(fx_kutuphane.dil["learn"],name));
end

function fx_kutuphane:TransferBuyu(a, bid, name, count)
	local aid = a:SteamID();

	local aadet = sql.QueryValue("SELECT adet FROM fx_kutuphane WHERE steamid='"..aid.."' AND buyu='"..name.."'") or 0;
	local bcond = "steamid='"..bid.."' AND buyu='"..name.."'";
	local badet = sql.QueryValue("SELECT adet FROM fx_kutuphane WHERE "..bcond);

	if ((aadet-count)<0) then
		a:FX_Notify(fx_kutuphane.dil["notenough"]);
		return
	end

	a:FX_SubtractBuyu(name, count);

	local b = player.GetBySteamID(bid);

	if IsValid(b) then
		b:FX_Notify(string.format(fx_kutuphane.dil["btransfersuccess"],a:Name(),name,count));
		b:FX_AddBuyu(name, count);
	else
		if not badet then
			sql.QueryValue("INSERT INTO fx_kutuphane VALUES (steamid='"..bid.."', buyu='"..name.."', adet="..count..")");
		else
			sql.QueryValue("UPDATE fx_kutuphane SET adet="..(badet+count).." WHERE "..bcond);
		end
	end

	a:FX_Notify(string.format(fx_kutuphane.dil["atransfersuccess"],name,count));
	print("[FX KUTUPHANE] Buyu kagidi transferi > Gonderen: "..a:Name().." | Alici: "..bid.." | Buyu kagidi: "..name.." | Adet: "..count);
end

hook.Add("Initialize", "fx_kutuphane", function()
	fx_kutuphane:InitDB();
end)

net.Receive("kutuphane_menu", function(_, ply)
	if not IsValid(ply.kutuphanenpc) then return end
	if (ply:GetPos():DistToSqr(ply.kutuphanenpc:GetPos())>62500) then return end

	local order = net.ReadString();
	local name = net.ReadString();

	local adet = ply:FX_GetBuyuAdet(name);
	if (adet<=0) then
		print("[FX KUTUPHANE] ["..ply:Nick().."],["..ply:SteamID().."] isimli, steamidli oyuncu kendinde olmayan buyu ile islem yapmaya calisti. Muhtemelen hile yapiyor.");
		return
	end

	if (order=="learn") then
		if HpwRewrite:PlayerHasSpell(ply, name) or HpwRewrite:PlayerHasLearnableSpell(ply, name) then 
			ply:FX_Notify(fx_kutuphane.dil["alreadylearned"]);
			return
		end;

		ply:FX_LearnBuyu(name);

		local tab = ply:FX_GetBuyus();
		net.Start("kutuphane_menu")
			net.WriteTable(tab)
			net.WriteString("update")
		net.Send(ply)
		return;
	elseif (order=="ask_transfer") then
		local bid = net.ReadString();
		local count = net.ReadUInt(8);

		MySQLite.query("SELECT CAST(uid as CHAR) FROM playerinformation WHERE steamID='"..bid.."'", function(data)
			local buid = data[1]["CAST(uid as CHAR)"]
			if not buid then
				ply:FX_Notify(fx_kutuphane.dil["notfound"]);
				return
			end

			MySQLite.query("SELECT rpname FROM darkrp_player WHERE uid="..buid, function(data1)
				local bname = data1[1]["rpname"]
				if not bname then
					ply:FX_Notify(fx_kutuphane.dil["notfound"]);
					return
				end

				net.Start("kutuphane_menu_transfer")
					net.WriteString(bname)
				net.Send(ply)
			end);

			
		end)
		
		
		return;
	elseif (order=="transfer") then
		local bid = net.ReadString();
		local count = net.ReadUInt(8);

		if bid==ply:SteamID() then
			return
		end

		if not count or count<=0 then return end;

		fx_kutuphane:TransferBuyu(ply, bid, name, count);

		local tab = ply:FX_GetBuyus();
		net.Start("kutuphane_menu")
			net.WriteTable(tab)
			net.WriteString("update")
		net.Send(ply)
		return;
	elseif (order=="sat") then
		ply:FX_SubtractBuyu(name, 1);
		ply:FX_Notify(string.format(fx_kutuphane.dil["sold"],name,DarkRP.formatMoney(fx_kutuphane.buyubilgileri[name] and fx_kutuphane.buyubilgileri[name].satisfiyati or fx_kutuphane.varsayilanbuyufiyati)))
		ply:addMoney(fx_kutuphane.buyubilgileri[name] and fx_kutuphane.buyubilgileri[name].satisfiyati or fx_kutuphane.varsayilanbuyufiyati)

		local tab = ply:FX_GetBuyus();
		net.Start("kutuphane_menu")
			net.WriteTable(tab)
			net.WriteString("update")
		net.Send(ply)
		return;
	end
end)