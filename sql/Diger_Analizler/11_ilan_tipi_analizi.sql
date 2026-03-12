SELECT
    p.ilan_tipi,
    COUNT(DISTINCT p.id) AS portfoy_sayisi,
    COUNT(DISTINCT CASE WHEN i.islem_durumu = 'tamamlandi' THEN i.id END) AS tamamlanan_islem,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.islem_durumu = 'tamamlandi' THEN i.id END)::numeric
        / NULLIF(COUNT(DISTINCT p.id), 0) * 100, 2
    ) AS donusum_orani_pct,
    ROUND(AVG(CASE WHEN i.islem_durumu = 'tamamlandi' THEN i.brut_islem_tutari END)::numeric, 2) AS ort_islem_tutari,
    SUM(CASE WHEN i.islem_durumu = 'tamamlandi' THEN i.brut_islem_tutari ELSE 0 END) AS toplam_ciro,
    ROUND(AVG(
        CASE WHEN i.islem_durumu = 'tamamlandi'
            AND i.islem_tarihi::timestamp > p.yayinlanma_tarihi
        THEN EXTRACT(EPOCH FROM (i.islem_tarihi::timestamp - p.yayinlanma_tarihi)) / 86400 END
    )::numeric, 1) AS ort_satis_suresi_gun
FROM case_emlak.portfoy p
LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id
GROUP BY p.ilan_tipi
ORDER BY toplam_ciro DESC;

-- Satilik ve kiralik ilan tiplerini donusum orani, toplam ciro ve ortalama satis suresi acisindan karsılastırır.
-- Satis suresi hesabinda negatif degerler filtrelenmistir (veri kalitesi).
-- Satilik ve kiralik arasindaki is modeli farklarini ortaya koyar.
