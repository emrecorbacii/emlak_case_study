SELECT 
    o.id,
    o.ad,
    COUNT(i.ofis_id) AS toplam_islem_sayisi
FROM case_emlak.ofis o
LEFT JOIN case_emlak.islem i
ON o.id = i.ofis_id
GROUP BY o.id, o.ad
ORDER BY toplam_islem_sayisi DESC;
-- Ofis bazinda toplam islem sayisini hesaplar (tum durumlar dahil).
-- En cok islem yapan ofisleri siralar.
