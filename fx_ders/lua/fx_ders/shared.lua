function fx_d_print(msg)
	MsgC(Color(7,229,142),"[DERS SİSTEMİ] "..msg.."\n")
end

local PLAYER = FindMetaTable("Player")

function PLAYER:isInDers(dersno)
	if fx_ders_hp_table[dersno]==nil then return false end
	if fx_ders_hp_table[dersno].sinif==nil then return false end
	local sinif = fx_ders_hp_table[dersno].sinif
	if fx_d.siniflar[sinif]==nil then return false end
	sinif = fx_d.siniflar[sinif]
	if sinif.konum==nil then return false end
	if sinif.konum.min==nil then return false end
	if sinif.konum.max==nil then return false end

	local min, max = sinif.konum.min, sinif.konum.max
		
	OrderVectors(min,max)
	if (self:GetPos()+self:OBBCenter()):WithinAABox(min,max) then
		return true
	end

	return false
end

function isDersActive(dersno)
	if not fx_ders_hp_table[dersno] then return false end

	if fx_ders_hp_table[dersno].time and fx_ders_hp_table[dersno].time>=CurTime() then
		return true
	end
	
	return false
end

function PLAYER:isInAnyDers()
	local to_turn = false
	for i=1,2 do
		if self:isInDers(i) then
			to_turn = true
		end
	end
	return to_turn
end

function PLAYER:getDers()
	local to_turn = 0
	for i=1,2 do
		if self:isInDers(i) then
			to_turn = i
		end
	end
	return to_turn
end

function PLAYER:isProfessor()
	local ply_team = team.GetName(self:Team())
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

function player.GetAllInDers(dersno)
	local to_turn = {}
	for _, ply in pairs(player.GetHumans()) do
		if ply:isInDers(dersno) then
			table.insert(to_turn,ply)
		end
	end
	return to_turn
end

-- returns proffesor job tables
function getProfessorJobs()
	local ret = {}

	for id, tab in pairs(RPExtraTeams) do
		if (table.HasValue(fx_d.acabilecekler,id)) then
			ret[id] = tab
		end
		for i=1,#fx_d.acabilecekler do
			if tab.name:find(fx_d.acabilecekler[i]) then
				ret[id] = tab
			end
		end		
	end

	return ret
end

function getProfessors()
	local jobs = getProfessorJobs()
	local profs = {}

	for _, ply in pairs(player.GetAll()) do
		for __, job in pairs(jobs) do
			if ply.SH_WHITELIST[job.name] then
				table.insert(profs,ply)
				break
			end
		end
	end

	return profs
end

function canBeProfessor(ply)
	local jobs = getProfessorJobs()
	local ret = false;

	for __, job in pairs(jobs) do
		if ply.SH_WHITELIST[job.name] then
			ret = true;
			break
		end
	end

	return ret	
end

--returns how many proffesors exist by whitelist
function getProfessorCount()
	local jobs = getProfessorJobs()
	local count = 0

	for _, ply in pairs(player.GetAll()) do
		for __, job in pairs(jobs) do
			if ply.SH_WHITELIST[job.name] then
				count = count + 1
				break
			end
		end
	end

	return count
end

function areThereAnyDersOnQueue(dersno)
	return (table.Count(fx_ders_hp_queue[dersno])>0)
end

function getDersOnQueue(dersno, queuenumber)
	if queuenumber==nil then
		queuenumber = 1
	end
	if areThereAnyDersOnQueue(dersno) then
		return fx_ders_hp_queue[dersno][queuenumber]; -- sıradaki ilk dersi yani en üstteki dersi dönderiyoruz, en son eklenen en aşşağıdaki
	end

	return nil
end

function getProfessorDersOnQueue(ply)
	local toret = {};
	for i=1, 2 do
		for _, tab in pairs(fx_ders_hp_queue[i]) do
			if tab.steamid==ply:SteamID() then
				table.insert(toret,tab);
			end
		end
	end
	return toret;
end

function fx_d_cangivespell(var)
	if not HpwRewrite:GetSpell(var) then return false end
	if HpwRewrite:IsSpellInBlacklist(var) then return false end

	/*local spell = HpwRewrite:GetSpell(var)

	if not spell.Year then
		return false
	end*/

	/*if (spell.Ders and spell.Ders!=ders) || (spell.ders and spell.ders!=ders) then
		return false
	end*/

	return true
end