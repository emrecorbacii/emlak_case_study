SELECT
    c.kidem,
    COUNT(DISTINCT c.id) AS calisan_sayisi,
    COUNT(i.id) AS toplam_islem,
    ROUND(AVG(i.brut_islem_tutari)::numeric, 2) AS ort_brut_tutar,
    SUM(i.brut_islem_tutari) AS toplam_brut_ciro,
    ROUND(COUNT(i.id)::numeric / NULLIF(COUNT(DISTINCT c.id), 0), 2) AS kisi_basi_ort_islem
FROM case_emlak.calisan c
LEFT JOIN case_emlak.islem i ON c.id = i.calisan_id AND i.islem_durumu = 'tamamlandi'
WHERE c.kidem IS NOT NULL
GROUP BY c.kidem
ORDER BY kisi_basi_ort_islem DESC;

-- Calisan kidem seviyesine gore toplam islem, ortalama brut tutar ve kisi basi islem hesaplar.
-- Kidemin satis performansina etkisini olcmek icin kullanilir.
-- NOT: Bu sorguda kur donusumu yapilmamistir; brut_islem_tutari karma para birimli olabilir.
