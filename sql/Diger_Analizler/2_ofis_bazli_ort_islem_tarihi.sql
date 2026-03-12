WITH islem_aralik AS (
    SELECT
        i.ofis_id,
        i.islem_tarihi,
        i.islem_tarihi - LAG(i.islem_tarihi) OVER (PARTITION BY i.ofis_id ORDER BY i.islem_tarihi) AS gun_farki
    FROM case_emlak.islem i
    WHERE i.islem_durumu = 'tamamlandi'
)
SELECT
    o.ad AS ofis_adi,
    COUNT(i.id) AS toplam_islem,
    MIN(i.islem_tarihi) AS ilk_islem_tarihi,
    MAX(i.islem_tarihi) AS son_islem_tarihi,
    ROUND(AVG(i.islem_tarihi - o.acilis_tarihi)::numeric, 1) AS ort_acilistan_isleme_gun,
    ROUND(AVG(ia.gun_farki)::numeric, 1) AS ort_islemler_arasi_gun
FROM case_emlak.ofis o
JOIN case_emlak.islem i ON o.id = i.ofis_id AND i.islem_durumu = 'tamamlandi'
LEFT JOIN islem_aralik ia ON o.id = ia.ofis_id AND i.islem_tarihi = ia.islem_tarihi
GROUP BY o.id, o.ad
ORDER BY ort_islemler_arasi_gun ASC NULLS LAST;

-- Ofis bazinda tamamlanan islemler arasindaki ortalama sure (gun) hesaplar.
-- LAG() pencere fonksiyonu ile iki ardisik islem arasindaki gun farki bulunur.
-- Dusuk deger = o ofisin islem temposu yuksek anlamina gelir.
