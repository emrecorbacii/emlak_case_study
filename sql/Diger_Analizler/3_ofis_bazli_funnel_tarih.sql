SELECT
    o.ad AS ofis_adi,
    ROUND(AVG(
        CASE WHEN r.baslangic_tarihi > l.olusturulma_tarihi
        THEN EXTRACT(EPOCH FROM (r.baslangic_tarihi - l.olusturulma_tarihi)) / 86400 END
    )::numeric, 1) AS lead_to_randevu_gun,
    ROUND(AVG(
        CASE WHEN p.olusturulma_tarihi > r.baslangic_tarihi
        THEN EXTRACT(EPOCH FROM (p.olusturulma_tarihi - r.baslangic_tarihi)) / 86400 END
    )::numeric, 1) AS randevu_to_portfoy_gun,
    ROUND(AVG(
        CASE WHEN i.islem_tarihi::timestamp > p.olusturulma_tarihi
        THEN EXTRACT(EPOCH FROM (i.islem_tarihi::timestamp - p.olusturulma_tarihi)) / 86400 END
    )::numeric, 1) AS portfoy_to_islem_gun,
    ROUND(AVG(
        CASE WHEN i.islem_tarihi::timestamp > l.olusturulma_tarihi
        THEN EXTRACT(EPOCH FROM (i.islem_tarihi::timestamp - l.olusturulma_tarihi)) / 86400 END
    )::numeric, 1) AS toplam_donusum_gun
FROM case_emlak.lead l
JOIN case_emlak.portfoy p ON l.id = p.lead_id
JOIN case_emlak.randevu r ON p.id = r.portfoy_id
JOIN case_emlak.islem i ON p.id = i.portfoy_id
JOIN case_emlak.calisan_ofis co ON l.atanan_calisan_id = co.calisan_id AND co.aktif = true
JOIN case_emlak.ofis o ON co.ofis_id = o.id
WHERE i.islem_durumu = 'tamamlandi'
GROUP BY o.id, o.ad
ORDER BY toplam_donusum_gun ASC;

-- Ofis bazinda funnel asama gecis surelerini (gun) hesaplar.
-- Lead olusturulmadan randevuya, randevudan portfoye, portfoyden isleme gecis sureleri.
-- Negatif sureler veri kalitesi sorunu oldugu icin filtrelenmistir (CASE WHEN ... > kosulu).
-- Lead ofis baglantisi atanan calisanin aktif ofisi uzerinden kurulur.
