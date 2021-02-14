fx_kutuphane = fx_kutuphane or {};

fx_kutuphane.varsayilangerekenbuyuadedi = 2; // bir büyüyü öğrenmek için aşağıdaki tabloda yoksa varsayılan olarak gereken adet
fx_kutuphane.varsayilanbuyufiyati = 500; // bir büyüyü satarken aşağıdaki tabloda yoksa varsayılan olarak satış fiyatı

fx_kutuphane.buyubilgileri = { // bir büyüyü kütüphaneden alabilmek için gereken sayı
	["Leverio"] = {
		gerekenadet = 2,
		satisfiyati = 500
	},
};

fx_kutuphane.dil = fx_kutuphane.dil or {};
fx_kutuphane.dil["learn"] = "%s isimli buyu icin gerekli kagitlari kutuphaneden aldin. Ogrenmeye baslayabilirsin.";
fx_kutuphane.dil["notfound"] = "Belirtilen Steam ID'ye sahip oyuncu bulunamadi veya sunucuya hic girmemis.";
fx_kutuphane.dil["notenough"] = "Yeteri kadar kagida sahip degilsin.";
fx_kutuphane.dil["addbuyu"] = "Kutuphanene %s isimli buyu kagidindan %d tane eklendi.";
fx_kutuphane.dil["subtractbuyu"] = "Kutuphanenden %s isimli buyu kagidindan %d tane eksildi.";
fx_kutuphane.dil["btransfersuccess"] = "%s isimli oyuncu sana %s isimli buyu kagidindan %d tane gonderdi!";
fx_kutuphane.dil["atransfersuccess"] = "Islem basarili! %s buyu kagidindan %d tane gonderdin!";
fx_kutuphane.dil["alreadylearned"] = "Zaten bu buyuyu ogrenebilirsin!";
fx_kutuphane.dil["sold"] = "%s buyusunu satarak %s kazandin."