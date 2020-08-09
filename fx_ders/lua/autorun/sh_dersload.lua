include("fx_ders/config.lua")
include("fx_ders/shared.lua")

if SERVER then
	AddCSLuaFile("fx_ders/config.lua")
	AddCSLuaFile("fx_ders/shared.lua")	
	include("fx_ders/server/server.lua")

	AddCSLuaFile("fx_ders/client/fonts.lua")	
	AddCSLuaFile("fx_ders/client/guis.lua")	
	AddCSLuaFile("fx_ders/client/menu.lua")
end

if CLIENT then
	include("fx_ders/shared.lua")

	include("fx_ders/client/fonts.lua")	
	include("fx_ders/client/guis.lua")	
	include("fx_ders/client/menu.lua")
end