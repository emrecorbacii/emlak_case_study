WITH egitim AS (
    SELECT
        cu.calisan_id,
        COUNT(cu.id) AS toplam_egitim,
        COUNT(CASE WHEN cu.durum = 'tamamlandi' THEN 1 END) AS tamamlanan_egitim,
        ROUND(AVG(cu.puan)::numeric, 2) AS ort_puan,
        ROUND(
            COUNT(CASE WHEN cu.durum = 'tamamlandi' THEN 1 END)::numeric
            / NULLIF(COUNT(cu.id), 0) * 100, 2
        ) AS tamamlama_orani_pct
    FROM case_emlak.calisan_urun cu
    GROUP BY cu.calisan_id
)
SELECT
    CASE
        WHEN e.tamamlama_orani_pct = 100 THEN 'Tümünü Tamamladı'
        WHEN e.tamamlama_orani_pct >= 50 THEN 'Yarısından Fazlasını Tamamladı'
        WHEN e.tamamlama_orani_pct > 0 THEN 'Kısmen Tamamladı'
        ELSE 'Hiç Tamamlamadı'
    END AS egitim_grubu,
    COUNT(DISTINCT c.id) AS calisan_sayisi,
    ROUND(AVG(e.ort_puan)::numeric, 2) AS ort_egitim_puani,
    COALESCE(SUM(islem_count.toplam_islem), 0) AS toplam_islem,
    ROUND(AVG(islem_count.toplam_islem)::numeric, 2) AS ort_islem_per_calisan,
    ROUND(AVG(islem_count.toplam_ciro)::numeric, 2) AS ort_ciro_per_calisan
FROM case_emlak.calisan c
JOIN egitim e ON c.id = e.calisan_id
LEFT JOIN (
    SELECT calisan_id, COUNT(*) AS toplam_islem, SUM(brut_islem_tutari) AS toplam_ciro
    FROM case_emlak.islem WHERE islem_durumu = 'tamamlandi'
    GROUP BY calisan_id
) islem_count ON c.id = islem_count.calisan_id
GROUP BY
    CASE
        WHEN e.tamamlama_orani_pct = 100 THEN 'Tümünü Tamamladı'
        WHEN e.tamamlama_orani_pct >= 50 THEN 'Yarısından Fazlasını Tamamladı'
        WHEN e.tamamlama_orani_pct > 0 THEN 'Kısmen Tamamladı'
        ELSE 'Hiç Tamamlamadı'
    END
ORDER BY ort_islem_per_calisan DESC;

-- Calisanlari egitim tamamlama oranlarina gore gruplandirarak satis performansiyla iliskilendirir.
-- calisan_urun tablosundaki egitim kayitlarindan tamamlama orani ve ortalama puan hesaplanir.
-- Egitim yatirimi ile is sonuclari arasindaki iliskiyi test eder.
