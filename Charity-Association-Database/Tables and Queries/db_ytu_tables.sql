--DROP SCHEMA public CASCADE;
--CREATE SCHEMA public;

CREATE TABLE yardim_edenler (
	id SERIAL PRIMARY KEY,
	isim VARCHAR(100) NOT NULL,
	soyisim VARCHAR(100) NOT NULL,
	yas SMALLINT NOT NULL,
	cinsiyet CHAR(1) NOT NULL,
	adres VARCHAR(200) NOT NULL,
	telefon VARCHAR(10) NOT NULL,
	CHECK (yas < 150),
	CHECK (cinsiyet in ('E', 'K'))
);

CREATE TABLE yardim_alanlar (
	id SERIAL PRIMARY KEY,
	isim VARCHAR(100) NOT NULL,
	soyisim VARCHAR(100) NOT NULL,
	yas SMALLINT NOT NULL,
	cinsiyet CHAR(1) NOT NULL,
	adres VARCHAR(200) NOT NULL,
	telefon VARCHAR(10) NOT NULL,
	aylik_gelir INT NOT NULL,
	ymk_sayisi SMALLINT NOT NULL,
	CHECK (yas < 150),
	CHECK (cinsiyet in ('E', 'K'))
);

CREATE TABLE calisanlar (
	id SERIAL PRIMARY KEY,
	isim VARCHAR(100) NOT NULL,
	soyisim VARCHAR(100) NOT NULL,
	yas SMALLINT NOT NULL,
	cinsiyet CHAR(1) NOT NULL,
	telefon VARCHAR(10) NOT NULL,
	sube_id INT,
	baslama_tarihi DATE NOT NULL,
	CHECK (yas < 150),
	CHECK (cinsiyet in ('E', 'K'))
);

CREATE TABLE subeler (
	id SERIAL PRIMARY KEY,
	isim VARCHAR(50) UNIQUE NOT NULL,
	yer VARCHAR(50) NOT NULL,
	yonetici_id INT,
	FOREIGN KEY (yonetici_id) REFERENCES calisanlar(id)
);

ALTER TABLE calisanlar ADD CONSTRAINT calisan_sube_fk FOREIGN KEY (sube_id) REFERENCES subeler(id);

CREATE TABLE yardimlasma_turleri (
	id SERIAL PRIMARY KEY,
	isim VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE etkinlikler (
	id INT PRIMARY KEY, -- burayı serial yapmadım, sequence kullanarak artırırız hocanın istediği gibi
	sube_id INT NOT NULL,
	yardimlasma_tur_id INT NOT NULL,
	yardim_eden_id INT NOT NULL,
	yardim_alan_id INT NOT NULL,
	miktar NUMERIC(10, 2) NOT NULL,
	tarih DATE NOT NULL,
	CHECK (miktar > 0),
	FOREIGN KEY (sube_id) REFERENCES subeler(id),
	FOREIGN KEY (yardimlasma_tur_id) REFERENCES yardimlasma_turleri(id),
	FOREIGN KEY (yardim_eden_id) REFERENCES yardim_edenler(id),
	FOREIGN KEY (yardim_alan_id) REFERENCES yardim_alanlar(id)
);

CREATE SEQUENCE etkinlikler_seq
INCREMENT 1
START 1;

INSERT INTO yardim_edenler (isim, soyisim, yas, cinsiyet, adres, telefon) VALUES 
	('Ahmet', 'Kara', 25, 'E', 'Çifte Havuzlar Mah. Esenler/İstanbul', '5351112222'),
	('Mehmet', 'Uzun', 45, 'E', 'Caferağa Mah. Kadıköy/İstanbul', '5361232222'),
	('Elif', 'Kara', 32, 'K', 'Çınar Mah. Bağcılar/İstanbul', '5381516222'),
	('Beyza', 'Demir', 19, 'K', 'Merkez Mah. Şişli/İstanbul', '5341516272'),
	('Tuğrul Hasan', 'Karabulut', 23, 'E', 'Akpınar Mah. Çankaya/Ankara', '5451412256'),
	('Muhammed', 'Oğuz', 55, 'E', 'Göktürk Mah. Çankaya/Ankara', '5394168242'),
	('Hüseyin Enes', 'Yılmaz', 22, 'E', 'İnönü Mah. Yenimahalle/Ankara', '5314517242'),
	('Ömer Talha', 'Baysan', 22, 'E', '29 Ekim Mah. Buca/İzmir', '5302415222'),
	('Tuğba', 'Demir', 40, 'K', 'Birlik Mah. Bornova/İzmir', '5345672222'),
	('Ayşe', 'Yıldız', 60, 'K', 'Cumhuriyet Mah. Karşıyaka/İzmir', '5331412582')
;


INSERT INTO yardim_alanlar (isim, soyisim, yas, cinsiyet, adres, telefon, aylik_gelir, ymk_sayisi) VALUES 
	('Yıldırım', 'Işık', 19, 'E', 'Merkez Mah. Bağcılar/İstanbul', '5354112222', 1500, 2),
	('Özge', 'Yetiz', 33, 'K', 'Merkez Mah. Karşıyaka/İzmir', '5361232522', 2000, 4),
	('Akın', 'Müftüoğlu', 57, 'E', 'Suadiye Mah. Kadıköy/İstanbul', '5381516222', 1200, 2),
	('Çağla', 'Özaydın', 66, 'K', 'Asmalı Mescit Mah. Beyoğlu/İstanbul', '5341516272', 750, 2),
	('Sancar', 'Demirtaştan', 44, 'E', 'Yıldıztepe Mah. Altındağ/Ankara', '5451412256', 4000, 4),
	('Şamil', 'Özçıtak', 54, 'E', 'Göktürk Mah. Çankaya/Ankara', '5394168242', 2500, 2),
	('Sedef', 'Akkutay', 28, 'K', 'Esentepe Mah. Polatlı/Ankara', '5314587242', 1100, 2),
	('Muhlis', 'Yakar', 37, 'E', 'Esentepe Mah. Aliağa/İzmir', '5302515222', 3600, 5),
	('Serhat', 'İlerigiden', 41, 'E', 'Atatürk Mah. Menemen/İzmir', '5345672222', 1200, 3),
	('Elif Nur', 'Akbaş', 42, 'K', 'Şirince Mah. Selçuk/İzmir', '5331412582', 1550, 3)
;

INSERT INTO calisanlar (isim, soyisim, yas, cinsiyet, telefon, baslama_tarihi) VALUES
	('Mukaddes', 'Suluova', 57, 'K', '5351712832', '2018-01-30'),
	('Gülsen', 'Atasayar', 35, 'E', '5351232222', '2019-01-22'),
	('Nail', 'Aşkın', 32, 'E', '5381814222', '2018-04-12'),
	('Çağrı', 'Sözer', 27, 'E', '5341516272', '2017-03-20'),
	('Yaşar Gökhan', 'Belder', 55, 'E', '5451452256', '2021-05-03'),
	('Orgül Derya', 'Gözügül', 55, 'K', '5397168242', '2020-05-30'),
	('İzzettin', 'Yaşit', 22, 'E', '5354517242', '2020-10-11'),
	('Cem Yaşar', 'Sarı', 33, 'E', '5332415222', '2020-09-15'),
	('Hilal', 'Numan', 30, 'K', '5345673672', '2015-12-05'),
	('Ceyhun', 'Anadol', 45, 'E', '5381312582', '2014-07-10'),
	('Fatma Betül', 'Morgül', 62, 'K', '5331412582', '2013-07-14'),
	('Cebrail', 'Tekeli', 68, 'E', '5341312582', '2012-04-11'),
	('Serdar Bora', 'Süveran', 55, 'E', '5451312582', '2014-09-12'),
	('Onur Kadir', 'Kuşçu', 65, 'E', '5451312582', '2014-02-22'),
	('Benay', 'Akkuş', 48, 'K', '5451312582', '2013-01-23'),
	('Veysi', 'Tavil', 39, 'E', '5431312582', '2012-03-28'),
	('Sabiha', 'Çerkez', 44, 'K', '5481352482', '2014-03-14'),
	('Edip Güvenç', 'Pürsünleri', 60, 'E', '5341312382', '2014-03-18'),
	('Füsun', 'Çeçen', 24, 'E', '5451372582', '2014-08-21'),
	('Feyza', 'Ediz', 35, 'E', '5451385371', '2014-05-22')
;
INSERT INTO yardimlasma_turleri (isim) VALUES
('para'), ('ayakkabı'), ('mont'), ('kazak'), ('battaniye'), ('kömür'), ('kitap'), ('erzak'), ('barınma'), ('pantolon');


INSERT INTO subeler (isim, yer, yonetici_id) VALUES
('Çınar Şubesi', 'İstanbul', 1), ('Davutpaşa Şubesi', 'İstanbul', 5), ('Menemen Şubesi', 'İzmir', 10),
('Esentepe Şubesi', 'İzmir', 2), ('Çankaya Şubesi', 'Ankara', 16), ('Beyoğlu Şubesi', 'İstanbul', 6),
('Buca Şubesi', 'İzmir', 18), ('Polatlı Şubesi', 'Ankara', 7), ('Suadiye Şubesi', 'İstanbul', 11),
('Merkez Şubesi', 'İstanbul', 14);


UPDATE calisanlar SET sube_id = subeler.id
FROM subeler 
WHERE subeler.yonetici_id = calisanlar.id;



UPDATE calisanlar SET sube_id = 1 WHERE id = 20;
UPDATE calisanlar SET sube_id = 2 WHERE id = 3;
UPDATE calisanlar SET sube_id = 3 WHERE id = 4;
UPDATE calisanlar SET sube_id = 4 WHERE id = 8;
UPDATE calisanlar SET sube_id = 5 WHERE id = 9;
UPDATE calisanlar SET sube_id = 6 WHERE id = 12;
UPDATE calisanlar SET sube_id = 7 WHERE id = 13;
UPDATE calisanlar SET sube_id = 8 WHERE id = 15;
UPDATE calisanlar SET sube_id = 9 WHERE id = 17;
UPDATE calisanlar SET sube_id = 10 WHERE id = 19;


-- ilk verileri doldurduktan constraint ekleyebiliriz, her çalışanın şubesi olmalı ve her şubenin yöneticisi olmalı
ALTER TABLE calisanlar ALTER COLUMN sube_id SET NOT NULL;
ALTER TABLE subeler ALTER COLUMN yonetici_id SET NOT NULL;

INSERT INTO etkinlikler (id, sube_id, yardimlasma_tur_id, yardim_eden_id, yardim_alan_id, miktar, tarih) VALUES
	(nextval('etkinlikler_seq'), 1, 1, 2, 3, 500, '2021-10-13'),
	(nextval('etkinlikler_seq'), 1, 2, 4, 2, 1, '2021-08-15'),
	(nextval('etkinlikler_seq'), 2, 3, 6, 3, 2, '2021-11-15'),
	(nextval('etkinlikler_seq'), 2, 4, 8, 1, 3, '2021-08-15'),
	(nextval('etkinlikler_seq'), 3, 5, 1, 4, 3, '2021-10-15'),
	(nextval('etkinlikler_seq'), 3, 6, 3, 5, 2, '2021-12-15'),
	(nextval('etkinlikler_seq'), 4, 7, 5, 6, 1, '2021-05-23'),
	(nextval('etkinlikler_seq'), 4, 8, 7, 7, 1, '2021-07-14'),
	(nextval('etkinlikler_seq'), 5, 9, 10, 1, 1, '2021-12-15'),
	(nextval('etkinlikler_seq'), 5, 10, 1, 3, 5, '2021-04-21'),
	(nextval('etkinlikler_seq'), 6, 1, 1, 6, 1520, '2021-04-15'),
	(nextval('etkinlikler_seq'), 6, 2, 3, 8, 1, '2021-08-18'),
	(nextval('etkinlikler_seq'), 7, 3, 3, 1, 2, '2021-04-11'),
	(nextval('etkinlikler_seq'), 7, 4, 2, 2, 4, '2021-01-15'),
	(nextval('etkinlikler_seq'), 8, 5, 3, 4, 3, '2021-04-13'),
	(nextval('etkinlikler_seq'), 8, 6, 6, 6, 2, '2021-08-15'),
	(nextval('etkinlikler_seq'), 9, 7, 5, 7, 4, '2021-11-15'),
	(nextval('etkinlikler_seq'), 9, 8, 8, 1, 5, '2021-10-23'),
	(nextval('etkinlikler_seq'), 10, 9, 9, 9, 1, '2021-10-24'),
	(nextval('etkinlikler_seq'), 10, 10, 10, 10, 2, '2021-01-14')
;


