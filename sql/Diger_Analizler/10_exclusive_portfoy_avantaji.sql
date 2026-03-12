SELECT
    CASE WHEN p.exclusive_mi THEN 'Exclusive' ELSE 'Non-Exclusive' END AS portfoy_turu,
    COUNT(p.id) AS portfoy_sayisi,
    COUNT(CASE WHEN i.id IS NOT NULL AND i.islem_durumu = 'tamamlandi' THEN 1 END) AS satilan,
    ROUND(
        COUNT(CASE WHEN i.id IS NOT NULL AND i.islem_durumu = 'tamamlandi' THEN 1 END)::numeric
        / NULLIF(COUNT(p.id), 0) * 100, 2
    ) AS satis_orani_pct,
    ROUND(AVG(
        CASE WHEN i.islem_durumu = 'tamamlandi'
            AND i.islem_tarihi::timestamp > p.yayinlanma_tarihi
        THEN EXTRACT(EPOCH FROM (i.islem_tarihi::timestamp - p.yayinlanma_tarihi)) / 86400 END
    )::numeric, 1) AS ort_satis_suresi_gun,
    ROUND(AVG(
        CASE WHEN i.islem_durumu = 'tamamlandi' AND p.liste_fiyati > 0
        THEN ((p.kapanis_fiyati - p.liste_fiyati) / p.liste_fiyati * 100) END
    )::numeric, 2) AS ort_fiyat_farki_pct
FROM case_emlak.portfoy p
LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id
GROUP BY p.exclusive_mi
ORDER BY portfoy_turu;

-- Exclusive ve non-exclusive portfoyleri satis orani, satis suresi ve fiyat farki acisindan karsılastırır.
-- Satis suresi hesabinda negatif degerler veri kalitesi sorunlari icin filtrelenmistir.
-- Exclusive portfoy stratejisinin is degerini test eder.
