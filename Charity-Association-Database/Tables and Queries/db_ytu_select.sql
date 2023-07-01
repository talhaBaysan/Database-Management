-- Örnek Sorgular

SELECT * FROM yardim_edenler;
SELECT * FROM etkinlikler;

-- sube ve yöneticisi
SELECT subeler.isim, calisanlar.isim, calisanlar.soyisim 
FROM subeler
INNER JOIN calisanlar
ON subeler.yonetici_id = calisanlar.id;

-- şubeye ait yardım sayısı, view olabilir
SELECT subeler.isim, COUNT(*)
FROM etkinlikler
INNER JOIN subeler
ON subeler.id = etkinlikler.sube_id
GROUP BY etkinlikler.sube_id, subeler.isim

-- yardım eden kişinin yaptığı yardım sayısı
SELECT yardim_edenler.id, CONCAT(yardim_edenler.isim, ' ', yardim_edenler.soyisim), COUNT(*)
FROM yardim_edenler
INNER JOIN etkinlikler
ON yardim_edenler.id = etkinlikler.yardim_eden_id
GROUP BY yardim_edenler.id, CONCAT(yardim_edenler.isim, ' ', yardim_edenler.soyisim)


--yardım alanların her bir türde aldığı toplam yardım miktarı
SELECT 
	CONCAT(yardim_alanlar.isim, ' ', yardim_alanlar.soyisim) AS isim_soyisim, 
	yardimlasma_turleri.isim, 
SUM(etkinlikler.miktar)
FROM yardim_alanlar
INNER JOIN etkinlikler
ON yardim_alanlar.id = etkinlikler.yardim_alan_id
INNER JOIN yardimlasma_turleri
ON etkinlikler.yardimlasma_tur_id = yardimlasma_turleri.id
GROUP BY 
	yardim_alanlar.id, 
	CONCAT(yardim_alanlar.isim, ' ', yardim_alanlar.soyisim), 
	yardimlasma_turleri.id, 
	yardimlasma_turleri.isim
ORDER BY isim_soyisim
