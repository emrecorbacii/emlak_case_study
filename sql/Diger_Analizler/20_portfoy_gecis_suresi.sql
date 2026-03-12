SELECT
    ROUND(AVG(
        CASE WHEN p.yayinlanma_tarihi > p.ilan_giris_tarihi
        THEN EXTRACT(EPOCH FROM (p.yayinlanma_tarihi - p.ilan_giris_tarihi)) / 86400 END
    )::numeric, 1) AS taslak_to_yayinda_gun,
    ROUND(AVG(
        CASE WHEN p.isleme_donusme_tarihi > p.yayinlanma_tarihi
        THEN EXTRACT(EPOCH FROM (p.isleme_donusme_tarihi - p.yayinlanma_tarihi)) / 86400 END
    )::numeric, 1) AS yayinda_to_isleme_gun,
    ROUND(AVG(
        CASE WHEN p.kapanis_tarihi > p.isleme_donusme_tarihi
        THEN EXTRACT(EPOCH FROM (p.kapanis_tarihi - p.isleme_donusme_tarihi)) / 86400 END
    )::numeric, 1) AS isleme_to_kapanis_gun,
    ROUND(AVG(
        CASE WHEN p.kapanis_tarihi > p.ilan_giris_tarihi
        THEN EXTRACT(EPOCH FROM (p.kapanis_tarihi - p.ilan_giris_tarihi)) / 86400 END
    )::numeric, 1) AS toplam_surec_gun,
    COUNT(CASE WHEN p.yayinlanma_tarihi IS NOT NULL THEN 1 END) AS yayinlanan,
    COUNT(CASE WHEN p.isleme_donusme_tarihi IS NOT NULL THEN 1 END) AS isleme_donusen,
    COUNT(CASE WHEN p.kapanis_tarihi IS NOT NULL THEN 1 END) AS kapanan,
    COUNT(p.id) AS toplam_portfoy
FROM case_emlak.portfoy p
WHERE p.ilan_giris_tarihi IS NOT NULL;

-- Portfoy yasam dongusu asamalari arasindaki ortalama gecis surelerini hesaplar.
-- Taslak->Yayinda, Yayinda->Isleme, Isleme->Kapanis ve toplam surec gunleri olculmektedir.
-- Negatif sureler veri kalitesi nedeniyle CASE WHEN ile filtrelenmistir.
-- Asamalardaki portfoy sayilari da raporlanarak huni kayiplari goruntulenebilir.
