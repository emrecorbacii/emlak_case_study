-- Portföy satış performansı
SELECT
    p.portfoy_tipi,
    COUNT(DISTINCT p.id) AS toplam_portfoy,
    COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu='tamamlandi' THEN p.id END) AS satilan_portfoy,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.islem_durumu='tamamlandi' THEN p.id END)::numeric /
        NULLIF(COUNT(DISTINCT p.id),0) * 100,2
    ) AS satis_orani_yuzde
FROM case_emlak.portfoy p
LEFT JOIN case_emlak.islem i
    ON p.id = i.portfoy_id AND i.islem_durumu='tamamlandi'
GROUP BY p.portfoy_tipi
ORDER BY satis_orani_yuzde ASC;
-- Portfoy tipine (konut, ticari, arsa_arazi, tarihi eser) gore satis oranini hesaplar.
-- Hangi portfoy tipinin en yuksek satisa donusme oranina sahip oldugunu gosterir.
