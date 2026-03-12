SELECT
    p.portfoy_tipi,
    COUNT(p.id) AS portfoy_sayisi,
    ROUND(AVG(
        p.liste_fiyati
        * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
        / NULLIF(p.brut_metrekare, 0)
    )::numeric, 2) AS ort_brut_m2_fiyat_try,
    ROUND(AVG(
        p.liste_fiyati
        * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
        / NULLIF(p.net_metrekare, 0)
    )::numeric, 2) AS ort_net_m2_fiyat_try,
    ROUND(AVG(p.brut_metrekare)::numeric, 1) AS ort_brut_m2,
    ROUND(AVG(p.net_metrekare)::numeric, 1) AS ort_net_m2,
    ROUND(AVG(
        p.liste_fiyati
        * CASE p.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
    )::numeric, 2) AS ort_liste_fiyati_try
FROM case_emlak.portfoy p
WHERE p.brut_metrekare IS NOT NULL AND p.brut_metrekare > 0
GROUP BY p.portfoy_tipi
ORDER BY ort_brut_m2_fiyat_try DESC;

-- Portfoy tipine gore brut ve net m2 basina ortalama liste fiyatini hesaplar.
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye cevrilerek m2'ye bolunur.
-- brut_metrekare NULL veya 0 olan portfoyler dahil edilmez.
