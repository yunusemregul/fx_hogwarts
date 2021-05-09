donatortimer = {}
donatortimer.config = {}

donatortimer.config.whocangiveremove = { -- hangi steamidler donatorluk verebilir/donatorluk alabilir
	/*
		örnek:
			["STEAM_0:0:93803013"] = true -- fexa
	*/
}

/*
	sol tarafa donator olan yetkiyi yazıyorsunuz, sağ tarafa hangi yetkiden geldiğini yazıyorsunuz
*/
donatortimer.config.donators = {
	["moderator+"] = "moderator",
	["helper+"] = "helper",
	["donator"] = "user"
}