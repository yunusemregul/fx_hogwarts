fx_irk = fx_irk or {}

fx_irk.gostermesuresi = 15 -- saniye biçiminden bildirimin ne kadar ekranda kalacağı

--	["Safkan"] = {
--		renk = Color(255,0,0),
--		ozellik = "- Safkan, 2 büyücü anne babadan doğan bir büyücüdür. 
--		Bazı safkan aileler, muggle doğumlulardan üstün olduklarını düşünürler.",
-- 		rate = "%40",
-- 		realkey = "safkan" -- sql datası için, doğru düzgün içinde türkçe şeyler geçmeyen birşey bulun id gibi
--	}

-- Dikkat:
-- Ratelerin toplamı 100 yapmalı.

fx_irk.irklar = {
	["Safkan"] = {
		renk = Color(128,0,128), -- mor asillik rengiymiş
		ozellik = "- Safkan, 2 büyücü anne babadan doğan bir büyücüdür.\nBazı safkan aileler, muggle doğumlulardan\nüstün olduklarını düşünürler.",
		rate = "%20",
		realkey = "safkan" -- sql datası için, doğru düzgün içinde türkçe şeyler geçmeyen birşey bulun id gibi
	},
	["Melez"] = {
		renk = Color(238, 203, 108),
		ozellik = "- Melez anne, melez babadan doğan büyücüler, melez anne\nveya baba ve muggle doğumlu anne veya babadan doğan büyücüler,\nanne veya babadan biri safkan diğeri muggle olan büyücüler,\nanne veya babadan biri melez diğeri safkan olan büyücüler\niçin kullanılır.",
		rate = "%40",
		realkey = "melez"
	},
	["Muggle Doğumlular"] = {
		renk = Color(112, 133, 79), 
		ozellik = "- Muggle doğumlu büyücüler büyü dışı insanlar\nyani muggle ailelerinden gelen fakat bir büyü\ngücüne sahip büyücülerdir.",
		rate = "%40",
		realkey = "muggle"
	}
}