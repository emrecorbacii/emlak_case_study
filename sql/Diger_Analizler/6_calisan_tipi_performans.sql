SELECT
    c.calisan_tipi,
    COUNT(DISTINCT c.id) AS calisan_sayisi,
    COUNT(i.id) AS toplam_islem,
    ROUND(AVG(
        i.brut_islem_tutari * CASE i.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
    )::numeric, 2) AS ort_brut_tutar_try,
    SUM(
        i.brut_islem_tutari * CASE i.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END
    ) AS toplam_brut_ciro_try,
    ROUND(COUNT(i.id)::numeric / NULLIF(COUNT(DISTINCT c.id), 0), 2) AS kisi_basi_ort_islem
FROM case_emlak.calisan c
LEFT JOIN case_emlak.islem i ON c.id = i.calisan_id AND i.islem_durumu = 'tamamlandi'
GROUP BY c.calisan_tipi
ORDER BY toplam_islem DESC;

-- Calisan tipine (danisman, broker, ofis muduru vb.) gore performans karsilastirir.
-- Brut islem tutarlari EUR=30, USD=25 kuruyla TL'ye cevrilerek toplanir.
-- Kisi basi ortalama islem sayisi, her tipin bireysel verimliligi hakkinda bilgi verir.
