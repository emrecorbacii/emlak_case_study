SELECT
    p.id,
    p.liste_fiyati
        * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END AS liste_fiyati_try,
    p.kapanis_fiyati
        * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END AS kapanis_fiyati_try,
    p.brut_metrekare,
    p.net_metrekare,
    p.bina_yasi,
    p.banyo_sayisi,
    p.bulundugu_kat,
    p.bina_kat_sayisi,
    CASE
        WHEN i.islem_durumu = 'tamamlandi' AND i.islem_tarihi::timestamp > p.yayinlanma_tarihi
        THEN EXTRACT(EPOCH FROM (i.islem_tarihi::timestamp - p.yayinlanma_tarihi)) / 86400
    END AS satis_suresi_gun
FROM case_emlak.portfoy p
LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id AND i.islem_durumu = 'tamamlandi'
WHERE
    p.brut_metrekare IS NOT NULL AND p.brut_metrekare > 0
    AND p.liste_fiyati > 0;

-- Portfoy ozelliklerini (fiyat, m2, bina yasi, kat, banyo sayisi, satis suresi) satir satir dondurur.
-- Python tarafinda korelasyon matrisi ve heatmap olusturmak icin ham veri saglayici sorgu.
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
-- Negatif satis sureleri veri kalitesi nedeniyle filtrelenmistir.
