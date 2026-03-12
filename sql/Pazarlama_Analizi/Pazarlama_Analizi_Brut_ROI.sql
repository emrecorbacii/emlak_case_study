SELECT
    ph.kanal,
    SUM(ph.lead_sayisi) AS toplam_lead_sayisi,
    COUNT(DISTINCT ph.portfoy_id) AS portfoy_sayisi,
    SUM(
        CASE 
            WHEN ph.para_birimi='TRY' THEN ph.harcama_tutari
            WHEN ph.para_birimi='USD' THEN ph.harcama_tutari*25
            WHEN ph.para_birimi='EUR' THEN ph.harcama_tutari*30
        END
    ) AS toplam_harcama_try,
    ROUND(
        SUM(
            CASE 
                WHEN ph.para_birimi='TRY' THEN ph.harcama_tutari
                WHEN ph.para_birimi='USD' THEN ph.harcama_tutari*25
                WHEN ph.para_birimi='EUR' THEN ph.harcama_tutari*30
            END
        )::numeric / NULLIF(SUM(ph.lead_sayisi),0), 2
    ) AS lead_basina_maliyet_try,
    ROUND(
        SUM(
            CASE 
                WHEN ph.para_birimi='TRY' THEN ph.harcama_tutari
                WHEN ph.para_birimi='USD' THEN ph.harcama_tutari*25
                WHEN ph.para_birimi='EUR' THEN ph.harcama_tutari*30
            END
        )::numeric / NULLIF(COUNT(DISTINCT ph.portfoy_id),0), 2
    ) AS portfoy_basina_maliyet_try,
    ROUND(
        SUM(
            CASE 
                WHEN i.para_birimi='TRY' THEN i.brut_islem_tutari
                WHEN i.para_birimi='USD' THEN i.brut_islem_tutari*25
                WHEN i.para_birimi='EUR' THEN i.brut_islem_tutari*30
            END
            * COALESCE(i.komisyon_orani,0)
        ) 
        /
        NULLIF(
            SUM(
                CASE 
                    WHEN ph.para_birimi='TRY' THEN ph.harcama_tutari
                    WHEN ph.para_birimi='USD' THEN ph.harcama_tutari*25
                    WHEN ph.para_birimi='EUR' THEN ph.harcama_tutari*30
                END
            ),0
        ), 2
    ) AS pazarlama_roi
FROM case_emlak.pazarlama_harcama ph
LEFT JOIN case_emlak.islem i
    ON ph.portfoy_id = i.portfoy_id
WHERE ph.harcama_tutari IS NOT NULL
GROUP BY ph.kanal
ORDER BY pazarlama_roi DESC;
-- Pazarlama kanali bazinda harcama, lead maliyeti ve brut komisyon uzerinden ROI hesaplar.
-- Brut ROI: (brut_islem_tutari * komisyon_orani) / toplam_harcama.
-- Tum tutarlar EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
