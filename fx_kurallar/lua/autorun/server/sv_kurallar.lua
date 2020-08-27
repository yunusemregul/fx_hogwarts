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
hook.Add( "Move", "kurallarmenusu", function( ply, mv )
	if (ply.firstmove == undefined) then
	net.Start("kurallar-menu") 
	net.Send(ply)
	ply.firstmove == true
	end
end)



hook.Add("PlayerSay", "kurallar-chathook", function(ply, text, unused)
	if table.HasValue(kurallarcommands,text) then 
		net.Start("kurallar-menu") 
		net.Send(ply)
	end
end)
