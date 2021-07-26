if SERVER then
	AddCSLuaFile("fx_irk/config.lua")
	include("fx_irk/config.lua")
	include("fx_irk/server.lua")
	AddCSLuaFile("fx_irk/client/client.lua")
end

if CLIENT then
	include("fx_irk/config.lua")
	include("fx_irk/client/client.lua")
end