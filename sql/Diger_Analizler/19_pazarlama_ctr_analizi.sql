SELECT
    ph.kanal,
    COUNT(ph.id) AS kampanya_sayisi,
    SUM(ph.gosterim) AS toplam_gosterim,
    SUM(ph.tiklama) AS toplam_tiklama,
    SUM(ph.lead_sayisi) AS toplam_lead,
    ROUND(
        SUM(ph.tiklama)::numeric / NULLIF(SUM(ph.gosterim), 0) * 100, 2
    ) AS ctr_pct,
    ROUND(
        SUM(ph.lead_sayisi)::numeric / NULLIF(SUM(ph.tiklama), 0) * 100, 2
    ) AS tiklama_to_lead_pct,
    ROUND(
        SUM(ph.harcama_tutari * CASE ph.para_birimi WHEN 'EUR' THEN 30 WHEN 'USD' THEN 25 ELSE 1 END)::numeric
        / NULLIF(SUM(ph.lead_sayisi), 0), 2
    ) AS lead_basi_maliyet_try
FROM case_emlak.pazarlama_harcama ph
WHERE ph.gosterim IS NOT NULL AND ph.gosterim > 0
GROUP BY ph.kanal
ORDER BY ctr_pct DESC;

-- Pazarlama kanali bazinda CTR (tiklama/gosterim), tiklama->lead donusumu ve lead basina maliyeti hesaplar.
-- Harcama tutarlari EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
-- Yalnizca gosterim verisi olan kampanyalar dahil edilir (gosterim IS NOT NULL AND > 0).
