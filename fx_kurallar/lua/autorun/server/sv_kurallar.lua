util.AddNetworkString("kurallar-menu")

local kurallarcommands = {
	"!kurallar",
	"/kurallar",
	"!kural",
	"/kural",
	"/rules",
	"!rules",
	"!rule",
	"/rule"
}

hook.Add("PlayerInitialSpawn", "kurallar-menu", function(ply)
	timer.Simple(3, function() net.Start("kurallar-menu") net.Send(ply) end)
end)

hook.Add("PlayerSay", "kurallar-chathook", function(ply, text, unused)
	if table.HasValue(kurallarcommands,text) then 
		net.Start("kurallar-menu") 
		net.Send(ply)
	end
end)