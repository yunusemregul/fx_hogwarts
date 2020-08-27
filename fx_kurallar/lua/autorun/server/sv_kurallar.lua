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

hook.Add("PlayerFullLoad", "kurallar-menu", function(ply)
	net.Start("kurallar-menu")
	net.Send(ply)
end)

hook.Add("PlayerSay", "kurallar-chathook", function(ply, text, unused)
	if table.HasValue(kurallarcommands,text) then 
		net.Start("kurallar-menu") 
		net.Send(ply)
	end
end)