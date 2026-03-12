SELECT
    s.ad AS sehir,
    il.ad AS ilce,
    COUNT(p.id) AS portfoy_sayisi,
    COUNT(CASE WHEN p.durum = 'isleme_donustu' OR p.durum = 'kapali' THEN 1 END) AS satilan_portfoy,
    ROUND(
        COUNT(CASE WHEN p.durum = 'isleme_donustu' OR p.durum = 'kapali' THEN 1 END)::numeric
        / NULLIF(COUNT(p.id), 0) * 100, 2
    ) AS satis_orani_pct,
    ROUND(AVG(
        p.liste_fiyati * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
    )::numeric, 2) AS ort_liste_fiyati_try,
    ROUND(AVG(
        p.kapanis_fiyati * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
    )::numeric, 2) AS ort_kapanis_fiyati_try
FROM case_emlak.portfoy p
JOIN case_emlak.ilce il ON p.ilce_id = il.id
JOIN case_emlak.sehir s ON il.sehir_id = s.id
GROUP BY s.ad, il.ad
HAVING COUNT(p.id) >= 5
ORDER BY portfoy_sayisi DESC
LIMIT 30;

-- Sehir ve ilce bazinda portfoy sayisi, satis orani ve ortalama fiyatlari hesaplar.
-- Sehir bilgisi portfoy.sehir_id'den degil, ilce.sehir_id'den turetilir.
-- Neden: portfoy tablosundaki sehir_id ve ilce_id alanları kasitli olarak tutarsiz birakilmistir
-- (ornegin portfoy.sehir_id=Antalya iken portfoy.ilce_id=Uskudar/Istanbul gibi).
-- Dogru eslesmeyi saglamak icin sehir ilcenin kendi sehir_id'si uzerinden belirlenir.
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye donusturulur.
