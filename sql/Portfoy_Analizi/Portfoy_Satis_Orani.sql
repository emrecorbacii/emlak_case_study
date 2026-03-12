SELECT
    COUNT(DISTINCT p.id) AS toplam_portfoy,
    COUNT(DISTINCT i.portfoy_id) AS satilan_portfoy,

    ROUND(
        COUNT(DISTINCT i.portfoy_id)::numeric /
        NULLIF(COUNT(DISTINCT p.id),0) * 100,
        2
    ) AS portfoy_satis_orani

FROM case_emlak.portfoy p
LEFT JOIN case_emlak.islem i
       ON p.id = i.portfoy_id;
-- Tum portfoyler icinde herhangi bir isleme donusen portfoylerin oranini (%) hesaplar.
-- Genel portfoy satis verimliligi metrigini tek bir deger olarak sunar.
