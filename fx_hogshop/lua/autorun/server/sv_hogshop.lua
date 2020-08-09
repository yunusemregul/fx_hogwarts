util.AddNetworkString("hogshop_buy")
util.AddNetworkString("hogshop_menu_refresh")

net.Receive("hogshop_buy", function(len, ply)
	local msg = net.ReadString()

	if not msg:find("|") then
		return
	end

	local prt = string.Explode("|",msg)
	if #prt!=2 then
		return
	end
	if not tonumber(prt[2]) then
		return
	end
	prt[2] = tonumber(prt[2])

	if prt[1]!="spell" and prt[1]!="wand" and prt[1]!="pet" then
		return
	end

	local item = nil
	if prt[1]=="spell" then
		if not hogshop.spells[prt[2]] then
			return
		end
		item = hogshop.spells[prt[2]]
	end
	if prt[1]=="wand" then
		if not hogshop.wands[prt[2]] then
			return
		end
		item = hogshop.wands[prt[2]]
	end
	if prt[1]=="pet" then
		if not hogshop.pets[prt[2]] then
			return
		end
		item = hogshop.pets[prt[2]]			
	end
	if HpwRewrite:PlayerHasSpell(ply, item.ad) or HpwRewrite:PlayerHasLearnableSpell(ply, item.ad) then
		return
	end
	if item then
		if not ply:canAfford(item.fiyat) then
			DarkRP.notify(ply,1,5,"Yeterli miktarda GL ye sahip degilsin.")
			return
		end

		if prt[1]=="spell" || prt[1]=="pet" then
			HpwRewrite:PlayerGiveLearnableSpell(ply, item.ad)
		end
		if prt[1]=="wand" then
			HpwRewrite:SaveAndGiveSpell(ply, item.ad)
		end
		ply:addMoney(-item.fiyat)
		DarkRP.notify(ply,0,5,item.ad.." isimli esyayi satin aldin!")

		timer.Simple(0,function()
			net.Start("hogshop_menu_refresh")
				net.WriteString(prt[1])
			net.Send(ply)
		end)
	end
end)