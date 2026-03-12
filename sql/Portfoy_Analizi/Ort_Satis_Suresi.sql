SELECT
AVG(
    EXTRACT(DAY FROM (i.islem_tarihi - p.olusturulma_tarihi))
) AS ortalama_satis_suresi_gun

FROM case_emlak.portfoy p
JOIN case_emlak.islem i
     ON p.id = i.portfoy_id

WHERE i.islem_tarihi >= p.olusturulma_tarihi;
-- Tamamlanan islemlerde portfoy olusturulmadan satisa kadar gecen ortalama gun sayisini hesaplar.
-- Negatif sureler WHERE filtresiyle dislanmistir.
