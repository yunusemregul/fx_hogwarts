AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("config.lua")
include("shared.lua")
include("config.lua")
util.AddNetworkString("ev_net_menu")
util.AddNetworkString("ev_net_belirle")

function ENT:Initialize()
	self:SetModel("models/sortinghat/sortinghat.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(_, ply)
	net.Start("ev_net_menu")
	net.Send(ply)
end

local homes = {"gryffindor", "hufflepuff", "ravenclaw", "slytherin"}

local order = {
	["hufflepuff"] = 1,
	["gryffindor"] = 2,
	["slytherin"] = 3,
	["ravenclaw"] = 4,
	["yok"] = 5
}

local function table_HasKey(tbl, ki)
	local answer = false

	for key, value in pairs(tbl) do
		if key == ki then
			answer = true
			break
		end
	end

	return answer
end

local function table_GetLowestKeys(tbl)
	local keys = {}
	local to_compare = {}

	for key, value in pairs(tbl) do
		table.insert(to_compare, value)
	end

	local lowest_val = math.min(unpack(to_compare))

	for key, value in pairs(tbl) do
		if (value == lowest_val) then
			table.insert(keys, key)
		end
	end

	return keys
end

local function random_home(ply)
	local check_if_already_chosen = sql.QueryValue("SELECT ev FROM ev_sistemi WHERE id=" .. ply:SteamID64() .. "")
	if check_if_already_chosen ~= nil then return false end
	local query = sql.Query("SELECT ev FROM ev_sistemi")
	local to_return = nil

	if (query == nil) then
		to_return = homes[math.random(1, #homes)]
	else
		if istable(query) then
			local count = {}

			for i = 1, #query do
				count[query[i].ev] = count[query[i].ev] and (count[query[i].ev] + 1) or 1
			end

			for i = 1, #homes do
				if not table_HasKey(count, homes[i]) then
					count[homes[i]] = 0
				end
			end

			local lowests = table_GetLowestKeys(count)

			if (#lowests == 1) then
				to_return = lowests[1]
			else
				to_return = lowests[math.random(1, #lowests)]
			end
		end
	end

	if (to_return ~= nil) then
		sql.Query("INSERT INTO ev_sistemi (ev, id) VALUES ('" .. to_return .. "', " .. ply:SteamID64() .. ")")
		ev_print(ply:Nick() .. " isimli oyuncunun evi " .. to_return:upper() .. " olarak belirlendi!")
	end

	return to_return
end


net.Receive("ev_net_belirle", function(len, ply)
	local chosen = random_home(ply)

	if chosen then
		local setTeam = ply.changeTeam or ply.SetTeam

		timer.Simple(8, function()
			setTeam(ply, ev_sistemi[chosen], true)
			ply:SetNWString("hogwarts_ev", chosen)
			ply:SetNWString("Evcek", tostring(order[chosen]))

			for i = 1, #player.GetAll() do
				player.GetAll()[i]:SendLua("chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,'" .. ply:Nick() .. " artık bir " .. chosen:upper() .. "!')")
			end
		end)

		net.Start("ev_net_belirle")
		net.WriteString(chosen)
		net.Send(ply)
	elseif (chosen == false) then
		ply:SendLua("chat.AddText(Color(255,128,128),'[EV SISTEMI] ',color_white,' Zaten evin var!')")
	end
end)