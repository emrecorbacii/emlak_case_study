SELECT
    pm.medya_tipi,
    COUNT(DISTINCT p.id) AS toplam_portfoy,
    COUNT(DISTINCT CASE WHEN i.id IS NOT NULL THEN p.id END) AS satilan_portfoy,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.id IS NOT NULL THEN p.id END)::numeric /
        NULLIF(COUNT(DISTINCT p.id),0) * 100, 2
    ) AS satis_orani_yuzde,
    ROUND(
        AVG(
            CASE 
                WHEN EXTRACT(EPOCH FROM (i.tapu_tarihi - p.ilan_giris_tarihi))/86400 > 0
                     AND EXTRACT(EPOCH FROM (i.tapu_tarihi - p.ilan_giris_tarihi))/86400 <= 365
                THEN EXTRACT(EPOCH FROM (i.tapu_tarihi - p.ilan_giris_tarihi))/86400
            END
        ), 2
    ) AS ortalama_satis_suresi_gun,
    ROUND(
        AVG(
            CASE 
                WHEN p.para_birimi='TRY' THEN p.liste_fiyati
                WHEN p.para_birimi='USD' THEN p.liste_fiyati*25
                WHEN p.para_birimi='EUR' THEN p.liste_fiyati*30
            END
        )::numeric,2
    ) AS ortalama_liste_fiyati_try,
    ROUND(
        AVG(
            CASE 
                WHEN i.para_birimi='TRY' THEN i.brut_islem_tutari
                WHEN i.para_birimi='USD' THEN i.brut_islem_tutari*25
                WHEN i.para_birimi='EUR' THEN i.brut_islem_tutari*30
            END
        )::numeric,2
    ) AS ortalama_satis_fiyati_try
FROM case_emlak.portfoy_medya pm
LEFT JOIN case_emlak.portfoy p
    ON pm.portfoy_id = p.id
LEFT JOIN case_emlak.islem i
    ON p.id = i.portfoy_id
    AND i.islem_durumu='tamamlandi'
WHERE p.liste_fiyati IS NOT NULL
GROUP BY pm.medya_tipi
ORDER BY satis_orani_yuzde DESC;
-- Medya tipine gore portfoy satis orani, ortalama satis suresi ve ortalama fiyatlari karsılastırır.
-- Satis suresi hesabinda 0-365 gun araliginin disindaki degerler aykiri veri olarak filtrelenmistir.
-- Hangi medya tipinin daha hizli ve daha yuksek fiyatli satisla iliskili oldugunu analiz eder.
