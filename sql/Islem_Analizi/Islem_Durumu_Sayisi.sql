SELECT
islem_durumu,
    COUNT(*) AS islem_durumu_sayisi
FROM case_emlak.islem
GROUP BY islem_durumu;
-- Tum islemleri durumuna (bekliyor, tamamlandi, iptal) gore gruplandirarak sayar.
-- Islem havuzunun genel durumunu ozet olarak gosterir.
