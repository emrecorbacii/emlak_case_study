WITH portfoy_medya_say AS (
    SELECT
        p.id AS portfoy_id,
        COUNT(pm.id) AS medya_sayisi,
        p.para_birimi,
        p.liste_fiyati
    FROM case_emlak.portfoy p
    LEFT JOIN case_emlak.portfoy_medya pm
        ON p.id = pm.portfoy_id
    GROUP BY p.id, p.para_birimi, p.liste_fiyati
),

portfoy_satis AS (
    SELECT
        portfoy_id,
        MAX(CASE WHEN islem_durumu='tamamlandi' THEN 1 ELSE 0 END) AS satildi,
        MAX(
            CASE 
                WHEN para_birimi='TRY' THEN brut_islem_tutari
                WHEN para_birimi='USD' THEN brut_islem_tutari*25
                WHEN para_birimi='EUR' THEN brut_islem_tutari*30
            END
        ) AS brut_tl
    FROM case_emlak.islem
    GROUP BY portfoy_id
)

SELECT
    medya_sayisi,
    COUNT(*) AS toplam_portfoy,
    COUNT(CASE WHEN COALESCE(ps.satildi,0)=1 THEN 1 END) AS satilan_portfoy,
    ROUND(
        COUNT(CASE WHEN COALESCE(ps.satildi,0)=1 THEN 1 END)::numeric /
        NULLIF(COUNT(*),0) * 100,2
    ) AS satis_orani_yuzde,
    ROUND(AVG(
        CASE 
            WHEN p.para_birimi='TRY' THEN p.liste_fiyati
            WHEN p.para_birimi='USD' THEN p.liste_fiyati*25
            WHEN p.para_birimi='EUR' THEN p.liste_fiyati*30
        END
    ),2) AS ortalama_liste_fiyati_try,
    ROUND(AVG(ps.brut_tl),2) AS ortalama_satis_fiyati_try
FROM portfoy_medya_say p
LEFT JOIN portfoy_satis ps
    ON p.portfoy_id = ps.portfoy_id
GROUP BY medya_sayisi
ORDER BY medya_sayisi;
-- Portfoy basina medya sayisina gore satis orani ve ortalama fiyati karsılastırır.
-- Daha fazla medya eklemenin satis basarisina etkisini gostermek icin kullanilir.
