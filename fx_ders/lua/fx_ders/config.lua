fx_d = fx_d or {} -- buna ellemeyin

fx_d.kacsaniyekalabuyudagitilabilir = 90; -- kendini açıklıyor.
fx_d.siraliderstenefusu = 300; -- saniye cinsinden sıralı dersler arası tenefüs süresi
fx_d.profsiraliderslimiti = 3; -- 1 prof kaç ders sıraya koyabilir

fx_d.xp_araligi = 60 -- saniye cinsinden XP verme aralığı
fx_d.xp_miktari = 300 -- belirlenen aralıkta verilecek XP miktarı

fx_d.default_logo = "fx_ders/undefined.png" -- ders logosu boş olursa bu logo kullanılır.

fx_d.dersler = { -- Dersler
	["Eski Tılsımlar"] = {logo = "fx_ders/tilsim.png"},
	["Büyücülük"] = {logo = "fx_ders/buyuculuk.png"},
	["Muggle Bilimleri"] = {logo = "fx_ders/muggle.png"},
	["Kehanet ve Geleceği Yorumlama"] = {logo = "fx_ders/kehanet.png"},
	["Karanlık Sanatlara Karşı Savunma"] = {logo = "fx_ders/ksks.png"},
	["Astronomi ve Uzay Bilimleri"] = {logo = "fx_ders/astronomi.png"},
	["Sihirli Yaratıkların Bakımı"] = {logo = "fx_ders/yaratiklar.png"},
	["Quidditch ve Uçuş"] = {logo = "fx_ders/quidditch.png"},
	["Düello"] = {logo = "fx_ders/ksks.png"},
	["Iksir"] = {logo = "fx_ders/iksir.png"},
	["Botanik"] = {logo = "fx_ders/botanik.png"},
	["Tarih"] = {logo = "fx_ders/tarih.png"},
	["Büyük Salonda Yemek"] = {logo = "fx_ders/yemek.png"},
	["Metamorfoz"] = {logo = "fx_ders/metamorfoz.png"},
	["Simya"] = {logo = "fx_ders/iksir.png"},
	["Büyü Tarihi"] = {logo = "fx_ders/tarih2.png"},
	["Metafiziksel Büyüler"] = {logo = "fx_ders/metafizik.png"},
	["Müzik"] = {logo = "fx_ders/muzik.png"},
	["Gezi"] = {logo = "fx_ders/gezi.png"},
	["Ödül Töreni"] = {logo = "fx_ders/kupa.png"}
}

--[[
	Örnek sınıf:

	["Sınıf 1"] = {
		konum = {min = Vector(-383.97, -1023.96, -12799.91), max = Vector(383.97, 1023.94, -12544)}
		renk = Color(255,128,0) -- tercihen, size kalmış. çok fazla şeyi etkilemiyor sadece toolda ve biraz hudda gözüküyor. koymazsanız default renk olan mor u kullanır.
	},
]]--
-- benim editlediğim maptaki sınıflar

/* 
	rp_hogwarts_community haritası için sınıflar
 	https://steamcommunity.com/sharedfiles/filedetails/?id=2170599335

 	harita yapımcısından: 
 		ravenclaw kulesine çıkan merdivenin yürüyüşü bozmasını istemiyorlarsa o entitynin açısını değiştirmeleri lazım
*/
fx_d.siniflar = { -- Sınıflar
	["KSKS Sınıfı"] = {
		--konum = {min = Vector(x,x,x), max = Vector(x,x,x)}
		konum = {min = Vector(-2486.67, -9323.54, -9719.97), max = Vector(-1353.03, -9905.51, -9441.47)},
		renk = Color(255,191,0)
	},
	["İksir Sınıfı"] = {
		konum = {min = Vector(-9101.42, -5683.97, -10591.79), max = Vector(-8753.49, -4572.26, -10215.03)},
		renk = Color(255,0,0)
	},
	["Düello Kulubü"] = {
		konum = {min = Vector(-11036.41, -3953.8, -9974.97), max = Vector(-12420.61, -2218.01, -9560.03)},
		renk = Color(0,63,255)
	},
	["Sınıf 4"] = {
		--konum = {min = Vector(x,x,x), max = Vector(x,x,x)}
		konum = {min = Vector(-936.03, -8512.53, -9750.31), max = Vector(-1782.64, -9205.01, -9442.16)},
		renk = Color(255,191,0)
	},
	["Sınıf 5"] = {
		konum = {min = Vector(-494.4, -4329.03, -9723.29), max = Vector(256.97, -5230.8, -9416.94)},
		renk = Color(0,63,255)
	},
	["Tılsım Sınıfı"] = {
		konum = {min = Vector(-4468.27, -3648.03, -9720.23), max = Vector(-4007.88, -4575.97, -9391.88)},
		renk = Color(127,159,255)
	},
	["Kehanet Sınıfı"] = {
		konum = {min = Vector(-5236.97, -5128.69, -9722.22), max = Vector(-4661.18, -6100.97, -9238.46)},
		renk = Color(255,128,128)
	},
	["Sınıf 3"] = {
		konum = {min = Vector(-3950.82, -9661.33, -9723.97), max = Vector(-2798.97, -10202.77, -9333.55)},
		renk = Color(127,0,95)
	},
	["Büyük Salon"] = {
		konum = {min = Vector(-13476.85, -5161.15, -9933.97), max = Vector(-12433.6, -3081.64, -8983.03)},
	},
	["Botanik"] = {
		konum = {min = Vector(79.39, -9120.94, -9702), max = Vector(586.44, -10139.97, -9413.63)},
		renk = Color(0,0,0)
	},
	["Astronomi"] = {
		konum = {min = Vector(-5467.67, -7323.16, -8447.97), max = Vector(-4457.03, -5822.83, -7823.17)},
		renk = Color(255,255,255)
	},
	["Quidditch"] = {
		konum = {min = Vector(1147.04, 2950.17, 9600.51), max = Vector(-2776.94, -6350.3, 11631.31)},
		renk = Color(255,255,255)
	},
	["Karanlık Sınıf"] = {
		konum = {min = Vector(13943.83, 13831.29, 5167.91), max = Vector(14695.77, 13304.28, 5383.47)},
		renk = Color(255,255,255)
	},
	["Muggle Bilimleri"] = {
	konum = {min = Vector(-9220.73, -5286.71, -9752.97), max = Vector(-10169.97, -4028.44, -9266.08)},
		renk = Color(0,63,255)
	},
	["Seherbaz Sınıfı"] = {
	konum = {min = Vector(-19.28, -1318.97, 4912.04), max = Vector(721.69, -484.02, 5183.97)},
		renk = Color(0,63,255)
	},
	["SYB Alanı"] = {
	konum = {min = Vector(13544.235352, -8289.862305, -12037.139648), max = Vector(12292.869141, -6854.891113, -11142.518555)},
		renk = Color(0,63,255)
	},
	["Sinif 2"] = {
	konum = {min = Vector(-11389.896484, -5348.518066, -9372.791992), max = Vector(-12351.107422, -4667.968262, -8922.453125)},
		renk = Color(0,63,255)
	},
	["Sahne"] = {
	konum = {min = Vector(-12789.154297, -2046.213013, -11003.195313), max = Vector(-11393.913086, -3590.576660, -10511.676758)},
		renk = Color(0,63,255)
	},
}

fx_d.acabilecekler = { -- Menüyü açabilecekler
	"Profesor",
	"Profesör",
	"Hagrid",
	"Bekçi",
	"Prof",
	"Profesörü",
	"Koçu",
	"Moody",
	"Umbridge",
	"Dumbledore"
}