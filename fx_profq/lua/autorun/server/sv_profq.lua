hook.Add("PlayerSpawnProp","profesor-q-menu",function(ply, model)
	if not ply:IsAdmin() and not ply:CanOpenProfQ() then return false end

	if not ply:IsAdmin() then
		local allowed_models = {}

		for catname, data in pairs(profesor_q_menu.props) do
			for i=1,#data.props do
				table.insert(allowed_models,data.props[i])
			end
		end

		if not table.HasValue(allowed_models,model) then
			return false
		end
	end
end)