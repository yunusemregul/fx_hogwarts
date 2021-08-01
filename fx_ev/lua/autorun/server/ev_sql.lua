include("ev_config.lua")

hook.Add("Initialize","ev_hook_initialize",function()
	sql.Query("CREATE TABLE IF NOT EXISTS ev_sistemi(ev string NOT NULL, id BIGINT NOT NULL)")
	ev_print("SQL table kuruldu!")
end)

local order = {
	["hufflepuff"] = 1,
	["gryffindor"] = 2,
	["slytherin"] = 3,
	["ravenclaw"] = 4,
	["yok"] = 5
}

hook.Add("PlayerInitialSpawn","ev_hook_initialspawn",function(ply)
	
	local query = sql.QueryValue("SELECT ev FROM ev_sistemi WHERE id="..ply:SteamID64().."")
	local setTeam = ply.changeTeam or ply.SetTeam

	if query != nil and isstring(query) then
		ply:SetNWString("hogwarts_ev",query)
		ply:SetNWString("Evcek",tostring(order[query]))
		
		if FX_EV.AutoJob then 	
			timer.Simple(0, function() 
				setTeam(ply, FX_EV.Jobs[query or "evsiz"], true) 
			end) 
		end
	elseif FX_EV.AutoJob then
		timer.Simple(0,function() setTeam(ply, FX_EV.Jobs["evsiz"], true) end)
	end

end)