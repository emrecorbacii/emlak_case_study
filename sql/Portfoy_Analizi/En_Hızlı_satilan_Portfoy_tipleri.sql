SELECT
    p.portfoy_tipi,
    COUNT(i.id) AS toplam_satis,
    AVG(i.islem_tarihi - p.ilan_giris_tarihi) AS ortalama_satis_suresi_interval,
    MIN(i.islem_tarihi - p.ilan_giris_tarihi) AS en_kisa_sure_interval,
    MAX(i.islem_tarihi - p.ilan_giris_tarihi) AS en_uzun_sure_interval
FROM case_emlak.portfoy p
JOIN case_emlak.islem i
    ON p.id = i.portfoy_id
WHERE i.islem_durumu='tamamlandi'
  AND p.ilan_giris_tarihi IS NOT NULL
  AND i.islem_tarihi IS NOT NULL
  AND i.islem_tarihi >= p.ilan_giris_tarihi
GROUP BY p.portfoy_tipi
ORDER BY ortalama_satis_suresi_interval ASC;
-- Portfoy tipine gore ortalama, minimum ve maksimum satis suresini hesaplar.
-- Negatif sureler WHERE filtresiyle dislanmistir.
-- Hangi portfoy tipinin piyasada en hizli satildigini gostermek icin kullanilir.
