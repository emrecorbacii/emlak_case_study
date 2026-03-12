SELECT
    c.id,
    c.ad || ' ' || c.soyad AS ad_soyad,
    c.calisan_tipi,
    c.kidem,
    c.ise_baslama_tarihi,
    c.ayrilis_tarihi,
    (c.ayrilis_tarihi - c.ise_baslama_tarihi) AS calisma_suresi_gun,
    COUNT(i.id) AS toplam_islem,
    COALESCE(SUM(
        i.brut_islem_tutari *
        CASE i.para_birimi
            WHEN 'EUR' THEN 30
            WHEN 'USD' THEN 25
            ELSE 1
        END
    ), 0) AS toplam_brut_ciro_try
FROM case_emlak.calisan c
LEFT JOIN case_emlak.islem i ON c.id = i.calisan_id AND i.islem_durumu = 'tamamlandi'
WHERE c.aktif_mi = false OR c.ayrilis_tarihi IS NOT NULL
GROUP BY c.id, c.ad, c.soyad, c.calisan_tipi, c.kidem, c.ise_baslama_tarihi, c.ayrilis_tarihi
ORDER BY calisma_suresi_gun ASC NULLS LAST;

-- Aktif olmayan (ayrilan) calisanlarin profili, calisma suresi ve toplam cirosunu listeler.
-- Brut islem tutarlari EUR=30, USD=25 kuruyla TL'ye cevrilerek toplanir.
-- Turnover analizi ve degerli calisanlarin ayrilis maliyetini degerlendirmek icin kullanilir.
