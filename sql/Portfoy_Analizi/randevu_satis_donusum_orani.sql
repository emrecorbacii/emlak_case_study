-- Randevu satış dönüşüm oranı
SELECT
    r.randevu_tipi,
    COUNT(DISTINCT r.portfoy_id) AS randevu_sayisi,
    COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu='tamamlandi' THEN r.portfoy_id END) AS satilan_portfoy,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu='tamamlandi' THEN r.portfoy_id END)::numeric /
        NULLIF(COUNT(DISTINCT r.portfoy_id),0) * 100,2
    ) AS satis_orani_yuzde
FROM case_emlak.randevu r
LEFT JOIN case_emlak.islem i
    ON r.portfoy_id = i.portfoy_id
GROUP BY r.randevu_tipi
ORDER BY satis_orani_yuzde ASC;
-- Randevu tipine gore portfoylerin satisa donusme oranini hesaplar.
-- Hangi randevu tipinin (portfoy_gosterimi, satis_gorusmesi vb.) satisa daha fazla donustugu analiz edilir.
