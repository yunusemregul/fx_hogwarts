if profesor_q_menu and IsValid(profesor_q_menu.f) then
	profesor_q_menu.f:Remove()
end

profesor_q_menu = profesor_q_menu or {}

profesor_q_menu.allowed = {
	"Botanik Profesörü",
	"Karanlık Sanatlara Karsı Savunma Profesörü",
	"Albus Dumbledore",
	"Eski Tılsımlar Profesörü",
	"Müzik Profesörü",
	"Dolores Umbridge",
	"Metamorfoz Profesörü",
	"Muggle Bilimleri Profesörü",
	"Hagrid",
	"İksir Profesörü",
	"Kehanet Profesörü",
	"Quidditch Koçu",
	"Astronomi Profesörü",
	"Tarih Profesörü",
	"Buyuculuk Profesörü",
	"Simya Profesörü",
	"Cisimsiz Varlıklar Profesörü",
	"Metafiziksel Büyüler Profesörü",
	"Büyü Tarihi Profesörü"
}
profesor_q_menu.props = {
	["Dolapçı Nuri"] = {
		["props"] = {
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_combine/weaponstripper.mdl",
			"models/props_interiors/refrigeratorDoor01a.mdl",
			"models/props_lab/blastdoor001c.mdl",
			"models/props_trainstation/trainstation_clock001.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl"
		}
	},
	["Kürek Osman"] = {
		["props"] = {
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_combine/weaponstripper.mdl",
			"models/props_interiors/refrigeratorDoor01a.mdl",
			"models/props_lab/blastdoor001c.mdl",
			"models/props_trainstation/trainstation_clock001.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl",
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_combine/weaponstripper.mdl",
			"models/props_interiors/refrigeratorDoor01a.mdl",
			"models/props_lab/blastdoor001c.mdl",
			"models/props_trainstation/trainstation_clock001.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl",
			"models/props_c17/chair_kleiner03a.mdl",
			"models/props_combine/weaponstripper.mdl",
			"models/props_interiors/refrigeratorDoor01a.mdl",
			"models/props_lab/blastdoor001c.mdl",
			"models/props_trainstation/trainstation_clock001.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl"
		}
	}
}

local PLAYER = FindMetaTable("Player")

function PLAYER:CanOpenProfQ()
	if not table.HasValue(profesor_q_menu.allowed,team.GetName(self:Team())) then
		return false
	end
	return true
end