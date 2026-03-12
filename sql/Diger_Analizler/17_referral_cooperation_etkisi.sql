SELECT
    CASE
        WHEN i.referral_var_mi AND i.cooperation_var_mi THEN 'Referral + Cooperation'
        WHEN i.referral_var_mi THEN 'Sadece Referral'
        WHEN i.cooperation_var_mi THEN 'Sadece Cooperation'
        ELSE 'Tek Başına'
    END AS islem_turu,
    COUNT(i.id) AS islem_sayisi,
    ROUND(AVG( i.brut_islem_tutari *
        CASE i.para_birimi
            WHEN 'EUR' THEN 30
            WHEN 'USD' THEN 25
            ELSE 1
        END)::numeric, 2) AS ort_brut_tutar,
     ROUND(SUM( i.brut_islem_tutari *
        CASE i.para_birimi
            WHEN 'EUR' THEN 30
            WHEN 'USD' THEN 25
            ELSE 1
        END)::numeric, 2) AS toplam_brut_ciro_try,
    ROUND(AVG(i.komisyon_orani)::numeric, 4) AS ort_komisyon_orani,
    ROUND(AVG(
        i.brut_islem_tutari *
        CASE i.para_birimi
            WHEN 'EUR' THEN 30
            WHEN 'USD' THEN 25
            ELSE 1
        END 
        * i.komisyon_orani / 100
        * CASE WHEN i.referral_var_mi THEN 0.8 ELSE 1 END
        * CASE WHEN i.cooperation_var_mi THEN 0.5 ELSE 1 END
    )::numeric, 2) AS ort_net_komisyon
FROM case_emlak.islem i
WHERE i.islem_durumu = 'tamamlandi'
GROUP BY
    CASE
        WHEN i.referral_var_mi AND i.cooperation_var_mi THEN 'Referral + Cooperation'
        WHEN i.referral_var_mi THEN 'Sadece Referral'
        WHEN i.cooperation_var_mi THEN 'Sadece Cooperation'
        ELSE 'Tek Başına'
    END
ORDER BY islem_sayisi DESC;

-- Referral ve cooperation kombinasyonlarina gore islem sayisi, ortalama brut tutar ve net komisyon hesaplar.
-- Referral: komisyondan 0.20 kesinti, Cooperation: komisyondan 0.50 kesinti uygulanir.
-- Brut tutarlar EUR=30, USD=25 kuruyla TL'ye cevrilerek hesaplanir.
