WITH funnel AS (
SELECT
    COUNT(DISTINCT l.id) AS lead_sayisi,
    COUNT(DISTINCT r.id) AS randevu_sayisi,
    COUNT(DISTINCT p.id) AS portfoy_sayisi,
    COUNT(DISTINCT i.id) AS islem_sayisi
FROM case_emlak.lead l
LEFT JOIN case_emlak.portfoy p 
       ON l.id = p.lead_id
LEFT JOIN case_emlak.randevu r 
       ON p.id = r.portfoy_id
LEFT JOIN case_emlak.islem i 
       ON p.id = i.portfoy_id
)

SELECT
lead_sayisi,
randevu_sayisi,
portfoy_sayisi,
islem_sayisi,

ROUND(randevu_sayisi::numeric / lead_sayisi * 100,2) AS lead_to_randevu,

ROUND(portfoy_sayisi::numeric / randevu_sayisi * 100,2) AS randevu_to_portfoy,

ROUND(islem_sayisi::numeric / portfoy_sayisi * 100,2) AS portfoy_to_islem

FROM funnel;
-- Genel lead funnel analizini hesaplar: lead -> randevu -> portfoy -> islem.
-- Lead baslangic noktasindan satisa kadar her asamadaki mutlak sayi ve donusum oranlari sunulur.
-- Tum sistemin en ust duzey funnel performansini gosterir.
