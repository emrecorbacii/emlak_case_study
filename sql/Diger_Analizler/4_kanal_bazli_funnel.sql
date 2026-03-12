SELECT
    l.kaynak,
    COUNT(DISTINCT l.id) AS lead_sayisi,
    COUNT(DISTINCT CASE WHEN l.durum IN ('randevu_alindi','portfoye_donustu') OR r.id IS NOT NULL THEN l.id END) AS randevu_sayisi,
    COUNT(DISTINCT p.id) AS portfoy_sayisi,
    COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu = 'tamamlandi' THEN i.id END) AS islem_sayisi,
    ROUND(
        COUNT(DISTINCT CASE WHEN l.durum IN ('randevu_alindi','portfoye_donustu') OR r.id IS NOT NULL THEN l.id END)::numeric
        / NULLIF(COUNT(DISTINCT l.id), 0) * 100, 2
    ) AS lead_to_randevu_pct,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu = 'tamamlandi' THEN i.id END)::numeric
        / NULLIF(COUNT(DISTINCT l.id), 0) * 100, 2
    ) AS lead_to_islem_pct
FROM case_emlak.lead l
LEFT JOIN case_emlak.portfoy p ON l.id = p.lead_id
LEFT JOIN case_emlak.randevu r ON p.id = r.portfoy_id
LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id
GROUP BY l.kaynak
ORDER BY lead_sayisi DESC;

-- Lead kaynagi (kaynak) bazinda funnel donusum oranlarini hesaplar.
-- Her kanalin lead -> randevu ve lead -> islem donusum oranini karsılastırır.
-- Pazarlama butcesi optimizasyonu icin hangi kanalin daha kaliteli lead urettigi analiz edilir.
