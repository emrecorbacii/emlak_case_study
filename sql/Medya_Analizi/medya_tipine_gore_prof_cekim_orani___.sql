SELECT
    medya_tipi,
    ROUND(SUM(profesyonel_cekim_mi::int)::numeric / NULLIF(COUNT(*),0) * 100, 2) AS profesyonel_cekim_orani_yuzde
FROM case_emlak.portfoy_medya
GROUP BY medya_tipi
ORDER BY profesyonel_cekim_orani_yuzde DESC;
-- Medya tipine gore profesyonel cekim oranini yuzde olarak hesaplar.
-- Hangi medya tipinde profesyonel cekim kullaniminin daha yaygin oldugunu gosterir.
