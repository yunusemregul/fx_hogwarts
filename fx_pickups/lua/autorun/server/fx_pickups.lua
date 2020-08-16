include("fx_pickups_config.lua")

fx_pickups_spawned = fx_pickups_spawned or {};

function fx_pickups_createpickups()
	local amount = math.floor(player.GetCount()/fx_pickups.playerperpickup);
	math.randomseed(os.time());

	if amount==0 then
		print("[FX PICKUPS] Mezun şapkası spawn etmek için yeterli oyuncu yok. En az ["..fx_pickups.playerperpickup.."] oyuncu gerekli.")
		return
	end

	for _, ent in pairs(fx_pickups_spawned) do 
		if IsValid(ent) then
			ent:Remove();
		end
	end
	table.Empty(fx_pickups_spawned);

	local pos = fx_pickups.positions;

	for i=1,amount do
		local rand = math.random(1,#pos);
		local posx = pos[rand];

		local pckp = ents.Create("base_fxpickup");
		pckp:SetPos(posx);
		pckp:Spawn();
		pckp:Activate();

		table.remove(pos,rand)
		table.insert(fx_pickups_spawned,pckp)
	end

	print("[FX PICKUPS] ["..amount.."] tane mezun şapkası spawn edildi!")
end

function fx_pickups_award(ply)
	local msg = "Tebrikler! Mezun şapkası buldun ve "..fx_pickups_givexp.."XP ile ödüllendirildin!";

	ply:ChatPrint(msg);
	PrintMessage(HUD_PRINTTALK,"["..ply:Nick().."] isimli oyuncu mezun şapkası buldu ve "..fx_pickups_givexp.."XP ile ödüllendirildi!");
	DarkRP.notify(ply,0,5,msg);
	ply:AddXP(fx_pickups_givexp);
end

hook.Add("Initialize","fx_pickups",function()
	timer.Create("fx_pickups_creator",fx_pickups.delay,0,fx_pickups_createpickups);
end)