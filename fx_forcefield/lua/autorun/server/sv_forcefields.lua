hook.Add("EntityTakeDamage", "forcefields_damage", function(target, dmg)
	if dmg:GetAttacker():IsPlayer() then
		if dmg:GetAttacker():inForceField() then
			return true
		end
	end

	if target:IsPlayer() then
		if target:inForceField() then
			return true
		end
	end
end)