WITH segmentler AS (
    SELECT
        p.*,
        CASE
            WHEN p.liste_fiyati < 5000000 THEN '1- Düşük (<5M)'
            WHEN p.liste_fiyati < 20000000 THEN '2- Orta (5M-20M)'
            WHEN p.liste_fiyati < 100000000 THEN '3- Yüksek (20M-100M)'
            ELSE '4- Premium (100M+)'
        END AS fiyat_segmenti,
        i.id AS islem_id,
        i.islem_durumu,
        i.islem_tarihi
    FROM case_emlak.portfoy p
    LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id
)
SELECT
    fiyat_segmenti,
    COUNT(DISTINCT id) AS portfoy_sayisi,
    COUNT(DISTINCT CASE WHEN islem_durumu = 'tamamlandi' THEN id END) AS satilan,
    ROUND(
        COUNT(DISTINCT CASE WHEN islem_durumu = 'tamamlandi' THEN id END)::numeric
        / NULLIF(COUNT(DISTINCT id), 0) * 100, 2
    ) AS satis_orani_pct,
    ROUND(AVG(
        CASE WHEN islem_durumu = 'tamamlandi'
            AND islem_tarihi::timestamp > yayinlanma_tarihi
        THEN EXTRACT(EPOCH FROM (islem_tarihi::timestamp - yayinlanma_tarihi)) / 86400 END
    )::numeric, 1) AS ort_satis_suresi_gun
FROM segmentler
GROUP BY fiyat_segmenti
ORDER BY fiyat_segmenti;

-- Portfoyleri liste fiyatina gore 4 segmente ayirir: Dusuk, Orta, Yuksek, Premium.
-- Her segment icin portfoy sayisi, satis orani ve ortalama satis suresi hesaplar.
-- Negatif satis sureleri veri kalitesi nedeniyle filtrelenmistir.
