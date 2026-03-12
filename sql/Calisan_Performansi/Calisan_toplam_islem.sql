SELECT 
    c.id,
    c.ad,
	c.soyad,
    COUNT(i.calisan_id) AS toplam_islem_sayisi
FROM case_emlak.calisan c
LEFT JOIN case_emlak.islem i
ON c.id = i.calisan_id
GROUP BY c.id, c.ad, c.soyad
ORDER BY toplam_islem_sayisi DESC;
-- Calisan bazinda toplam islem sayisini hesaplar (tum durumlar dahil).
-- En cok islem yapan calisanlari siralar.
