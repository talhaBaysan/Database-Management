CREATE TYPE yeni_tur AS (sube_ismi VARCHAR, calisan_sayisi INT);

CREATE OR REPLACE FUNCTION sube_calisan_sayisi (sube_ismi VARCHAR)
RETURNS yeni_tur AS $$
DECLARE
	sube_tur yeni_tur;
BEGIN
	SELECT s.isim, COUNT(*) INTO sube_tur  FROM subeler s
	INNER JOIN calisanlar c
	ON c.sube_id = s.id
	WHERE s.isim = sube_ismi
	GROUP BY s.id;
	RETURN sube_tur;
END;
$$ language 'plpgsql';


SELECT sube_calisan_sayisi('Davutpaşa Şubesi');


CREATE OR REPLACE FUNCTION tur_yardim_miktari (yardim_turu VARCHAR, OUT yardim_miktari numeric)
RETURNS NUMERIC AS $$
DECLARE
	yardim_cursor CURSOR FOR SELECT miktar FROM etkinlikler e
						 INNER JOIN yardimlasma_turleri y
						 ON y.id = e.yardimlasma_tur_id
						 WHERE y.isim = yardim_turu;
BEGIN
	yardim_miktari := 0;
	FOR yardim IN yardim_cursor LOOP
	yardim_miktari := yardim_miktari + yardim.miktar;
	END LOOP;	
END;
$$ language 'plpgsql';

SELECT tur_yardim_miktari('erzak')

CREATE OR REPLACE FUNCTION etkinlik_trigger_fonk()
RETURNS TRIGGER AS $$
DECLARE
	yardim_alma_sayisi INT;
BEGIN
	SELECT COUNT(*) INTO yardim_alma_sayisi
	FROM etkinlikler e
	WHERE e.yardim_alan_id = new.yardim_alan_id;
	IF (yardim_alma_sayisi >= 4) THEN
		RAISE EXCEPTION 'Bir kişi en fazla 4 sefer yardım alabilir.';
		RETURN null;
	ELSE
		return new;
	END IF;
END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER etkinlik_trigger
BEFORE INSERT
ON etkinlikler
FOR EACH ROW EXECUTE PROCEDURE etkinlik_trigger_fonk();


INSERT INTO etkinlikler (id, sube_id, yardimlasma_tur_id, yardim_eden_id, yardim_alan_id, miktar, tarih) VALUES
	(nextval('etkinlikler_seq'), 2, 2, 2, 3, 500, '2021-10-17');
	



CREATE OR REPLACE FUNCTION sube_yonetici_trigger_fonk()
RETURNS TRIGGER AS $$
DECLARE
	sube_id_var INT;
BEGIN
	sube_id_var := 0;
	
	SELECT s.id INTO sube_id_var
	FROM subeler s
	WHERE s.yonetici_id = old.id;
	
	IF (sube_id_var > 0) THEN
		UPDATE subeler
		SET yonetici_id = tablo.id
		FROM (SELECT c.id FROM subeler s
			 INNER JOIN calisanlar c
			 ON s.id = c.sube_id
			 WHERE s.id = sube_id_var
			 AND c.yas = (SELECT MAX(yas) FROM calisanlar c1 WHERE c1.sube_id = sube_id_var AND c1.id != old.id)
			 ) tablo
		WHERE subeler.id = sube_id_var;
		
		RAISE NOTICE 'Şube yöneticisi güncellendi.';
		
	RETURN new;
	END IF;
	
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER sube_yonetici_trigger
BEFORE DELETE
ON calisanlar
FOR EACH ROW EXECUTE PROCEDURE sube_yonetici_trigger_fonk();


DELETE FROM calisanlar WHERE id = 14;
SELECT * FROM subeler;
