SELECT
    m.musteri_tipi,
    COUNT(DISTINCT m.id) AS musteri_sayisi,
    COUNT(i.id) AS toplam_islem,
    ROUND(AVG(i.brut_islem_tutari)::numeric, 2) AS ort_brut_tutar,
     COALESCE(SUM(
        i.brut_islem_tutari *
        CASE i.para_birimi
            WHEN 'EUR' THEN 30
            WHEN 'USD' THEN 25
            ELSE 1
        END
    ), 0) AS toplam_brut_ciro,
    ROUND(COUNT(i.id)::numeric / NULLIF(COUNT(DISTINCT m.id), 0), 2) AS musteri_basi_ort_islem
FROM case_emlak.musteri m
LEFT JOIN case_emlak.islem i
    ON (m.id = i.alici_musteri_id OR m.id = i.satici_musteri_id)
    AND i.islem_durumu = 'tamamlandi'
GROUP BY m.musteri_tipi
ORDER BY toplam_islem DESC;

-- Musteri tipine (alici, satici, kiraci, yatirimci vb.) gore islem hacmi ve ortalama tutar hesaplar.
-- Bir musteri hem alici hem satici olabilecegi icin OR kosulu ile her iki rol de kapsanir.
-- Brut ciro EUR=30, USD=25 kuruyla TL'ye cevrilerek toplanir.
