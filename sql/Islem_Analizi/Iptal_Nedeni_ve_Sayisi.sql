SELECT
iptal_nedeni,
    COUNT(*) AS iptal_sayisi
FROM case_emlak.islem
WHERE islem_durumu = 'iptal'
GROUP BY iptal_nedeni;
-- Iptal edilen islemleri iptal nedenine gore gruplandirarak sayar.
-- Hangi iptal nedeninin ne kadar yaygin oldugunu gostermek icin kullanilir.
