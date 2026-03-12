WITH calisan_ofis_sayisi AS (
    SELECT
        co.calisan_id,
        COUNT(DISTINCT co.ofis_id) AS ofis_sayisi
    FROM case_emlak.calisan_ofis co
    GROUP BY co.calisan_id
),
performans AS (
    SELECT
        c.id AS calisan_id,
        c.ad || ' ' || c.soyad AS ad_soyad,
        c.calisan_tipi,
        cos.ofis_sayisi,
        COUNT(i.id) AS toplam_islem,
        COALESCE(SUM(i.brut_islem_tutari), 0) AS toplam_brut_ciro
    FROM case_emlak.calisan c
    JOIN calisan_ofis_sayisi cos ON c.id = cos.calisan_id
    LEFT JOIN case_emlak.islem i ON c.id = i.calisan_id AND i.islem_durumu = 'tamamlandi'
    GROUP BY c.id, c.ad, c.soyad, c.calisan_tipi, cos.ofis_sayisi
)
SELECT
    CASE
        WHEN ofis_sayisi = 1 THEN '1 Ofis'
        WHEN ofis_sayisi = 2 THEN '2 Ofis'
        ELSE '3+ Ofis'
    END AS ofis_grubu,
    COUNT(*) AS calisan_sayisi,
    ROUND(AVG(toplam_islem)::numeric, 2) AS ort_islem,
    ROUND(AVG(toplam_brut_ciro)::numeric, 2) AS ort_brut_ciro
FROM performans
GROUP BY
    CASE
        WHEN ofis_sayisi = 1 THEN '1 Ofis'
        WHEN ofis_sayisi = 2 THEN '2 Ofis'
        ELSE '3+ Ofis'
    END
ORDER BY ofis_grubu;

-- Calisanlarin kac farkli ofiste gorev yaptigini gruplandirarak (1, 2, 3+ ofis) performansla iliskilendirir.
-- Ofis hareketliliginin (mobilite) satis performansina etkisini olcer.
-- calisan_ofis tablosu uzerinden hesaplanir.
