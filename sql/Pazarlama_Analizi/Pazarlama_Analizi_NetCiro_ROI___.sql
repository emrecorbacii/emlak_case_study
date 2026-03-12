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
    -- Net ciro üzerinden ROI (her işlem için referral ve cooperation kontrolü)
    ROUND(
        SUM(
            (CASE 
                WHEN i.para_birimi='TRY' THEN i.brut_islem_tutari
                WHEN i.para_birimi='USD' THEN i.brut_islem_tutari*25
                WHEN i.para_birimi='EUR' THEN i.brut_islem_tutari*30
            END)
            *
            COALESCE(i.komisyon_orani,0)
            *
            (1
             - CASE WHEN i.referral_var_mi THEN 0.20 ELSE 0 END
             - CASE WHEN i.cooperation_var_mi THEN 0.50 ELSE 0 END
            )
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
    ) AS pazarlama_roi_net_ciro
FROM case_emlak.pazarlama_harcama ph
LEFT JOIN case_emlak.islem i
    ON ph.portfoy_id = i.portfoy_id
WHERE ph.harcama_tutari IS NOT NULL
GROUP BY ph.kanal
ORDER BY pazarlama_roi_net_ciro DESC;
-- Pazarlama kanali bazinda harcama, lead maliyeti ve net ciro uzerinden ROI hesaplar.
-- Net ciro: brut tutar * komisyon_orani * (1 - referral_kesintisi - cooperation_kesintisi).
-- Tum tutarlar EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
