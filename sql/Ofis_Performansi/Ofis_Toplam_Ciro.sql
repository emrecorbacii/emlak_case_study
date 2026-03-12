SELECT
    o.id AS ofis_id,
    o.ad,
    o.adres,
    SUM(
        (
            COALESCE(i.brut_islem_tutari, 0) * COALESCE(i.komisyon_orani,0)
            - COALESCE(i.brut_islem_tutari, 0) * COALESCE(i.komisyon_orani,0) *
              CASE WHEN COALESCE(i.referral_var_mi,FALSE) THEN 0.20 ELSE 0 END
            - COALESCE(i.brut_islem_tutari, 0) * COALESCE(i.komisyon_orani,0) *
              CASE WHEN COALESCE(i.cooperation_var_mi,FALSE) THEN 0.50 ELSE 0 END
        )
        *
        CASE
            WHEN i.para_birimi = 'EUR' THEN 30
            WHEN i.para_birimi = 'USD' THEN 25
            ELSE 1
        END
    ) AS toplam_net_ciro_tl
FROM case_emlak.ofis o
LEFT JOIN case_emlak.islem i
    ON o.id = i.ofis_id
WHERE i.islem_durumu ='tamamlandi'
GROUP BY o.id, o.ad, o.adres
ORDER BY toplam_net_ciro_tl DESC;
-- Ofis bazinda toplam net ciroyu TL cinsinden hesaplar.
-- Net ciro: brut_islem_tutari * komisyon_orani - referral kesintisi (%20) - cooperation kesintisi (%50).
-- Fiyatlar EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
-- Yalnizca tamamlandi durumundaki islemler dahildir.
