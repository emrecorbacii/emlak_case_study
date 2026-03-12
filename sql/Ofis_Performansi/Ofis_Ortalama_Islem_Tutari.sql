SELECT
    o.id AS ofis_id,
    o.ad,
    o.adres,
    AVG(
        COALESCE(i.brut_islem_tutari, 0) *
        CASE 
            WHEN i.para_birimi = 'EUR' THEN 30
            WHEN i.para_birimi = 'USD' THEN 25
            ELSE 1
        END
    ) AS ortalama_islem_tutari_tl
FROM case_emlak.ofis o
LEFT JOIN case_emlak.islem i
    ON o.id = i.ofis_id
WHERE i.islem_durumu ='tamamlandi'
GROUP BY o.id, o.ad, o.adres
ORDER BY ortalama_islem_tutari_tl DESC;
-- Ofis bazinda ortalama islem tutarini TL cinsinden hesaplar.
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye cevrilerek ortalama alinir.
-- Yalnizca tamamlandi durumundaki islemler dahildir.
