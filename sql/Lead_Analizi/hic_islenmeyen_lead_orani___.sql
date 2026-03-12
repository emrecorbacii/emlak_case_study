SELECT
    ROUND(
        COUNT(CASE WHEN randevu_tarihi IS NULL THEN 1 END)::numeric /
        COUNT(*) * 100,2
    ) AS hic_islenmeyen_lead_orani
FROM case_emlak.lead;
-- Hic randevu tarihine sahip olmayan (randevu_tarihi IS NULL) leadlerin oranini hesaplar.
-- Operasyonel problem tespiti: hic ilgilenilmeyen lead yuzdesini ortaya koyar.
