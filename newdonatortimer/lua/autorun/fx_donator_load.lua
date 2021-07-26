if SERVER then
	include("donatorconfig.lua")
	include("donatortimer/utils.lua")
	include("donatortimer/meta.lua")
	include("donatortimer/offlinemeta.lua")
	include("donatortimer/main.lua")
	AddCSLuaFile("donatortimer/client/fonts.lua")
	AddCSLuaFile("donatortimer/client/client.lua")	
	AddCSLuaFile("donatortimer/client/vgui.lua")
end
if CLIENT then
	include("donatortimer/client/fonts.lua")
	include("donatortimer/client/client.lua")
	include("donatortimer/client/vgui.lua")
end