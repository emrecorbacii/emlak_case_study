SELECT
    c.id,
    c.ad,
    c.soyad,
	c.kidem,
	c.calisan_tipi,
	c.uzmanlik_alani,
	c.aktif_mi,
	c.ise_baslama_tarihi,
	c.ayrilis_tarihi,
    AVG(
        COALESCE(i.brut_islem_tutari, 0) *
        CASE 
            WHEN i.para_birimi = 'EUR' THEN 30
            WHEN i.para_birimi = 'USD' THEN 25
            ELSE 1
        END
    ) AS ortalama_islem_tutari_tl
FROM case_emlak.calisan c
LEFT JOIN case_emlak.islem i
    ON c.id = i.calisan_id
WHERE i.islem_durumu ='tamamlandi'
GROUP BY c.id, c.ad, c.soyad
ORDER BY ortalama_islem_tutari_tl DESC;
-- Calisan bazinda ortalama islem tutarini TL cinsinden hesaplar.
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye cevrilerek ortalama alinir.
-- Yalnizca tamamlandi durumundaki islemler dahildir.
