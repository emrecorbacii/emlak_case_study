SELECT
    o.ad AS ofis_adi,
    COUNT(DISTINCT l.id) AS lead_sayisi,
    COUNT(DISTINCT r.id) AS randevu_sayisi,
    COUNT(DISTINCT p.id) AS portfoy_sayisi,
    COUNT(DISTINCT i.id) AS islem_sayisi,
    ROUND(
        COUNT(DISTINCT r.id)::numeric
        / NULLIF(COUNT(DISTINCT l.id), 0) * 100, 2
    ) AS lead_to_randevu_pct,
    ROUND(
        COUNT(DISTINCT p.id)::numeric
        / NULLIF(COUNT(DISTINCT r.id), 0) * 100, 2
    ) AS randevu_to_portfoy_pct,
    ROUND(
        COUNT(DISTINCT i.id)::numeric
        / NULLIF(COUNT(DISTINCT p.id), 0) * 100, 2
    ) AS portfoy_to_islem_pct
FROM case_emlak.lead l
LEFT JOIN case_emlak.portfoy p ON l.id = p.lead_id
LEFT JOIN case_emlak.randevu r ON p.id = r.portfoy_id
LEFT JOIN case_emlak.islem i ON p.id = i.portfoy_id
JOIN case_emlak.calisan_ofis co ON l.atanan_calisan_id = co.calisan_id AND co.aktif = true
JOIN case_emlak.ofis o ON co.ofis_id = o.id
GROUP BY o.id, o.ad
ORDER BY lead_to_randevu_pct DESC;

-- Her ofisin lead -> randevu -> portfoy -> islem funnel donusum oranlarini hesaplar.
-- Lead ofis baglantisi, atanan calisanin aktif ofisi uzerinden kurulur.
-- Gercek funnel mantigini izler: ayni entity zinciri tum asamalarda takip edilir.
