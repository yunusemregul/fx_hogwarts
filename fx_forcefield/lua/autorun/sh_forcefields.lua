local meta = FindMetaTable("Player")

function meta:inForceField()
	for _, ent in pairs(ents.FindByClass("force_field")) do
		if not ent._min or not ent._max then continue end

		for __, ply in pairs(ents.FindInBox(ent._min,ent._max)) do
			if not ply:IsPlayer() then continue end

			if (self==ply) then
				return true
			end
		end
	end
	return false
end

local meta = FindMetaTable("Entity")

function meta:inForceField()
	for _, ent in pairs(ents.FindByClass("force_field")) do
		if not ent._min or not ent._max then continue end

		for __, ent2 in pairs(ents.FindInBox(ent._min,ent._max)) do
			if (self==ent2) then
				return true
			end
		end
	end
	return false
end