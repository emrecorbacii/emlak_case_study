WITH portfoy_medya AS (
    SELECT
        p.id AS portfoy_id,
        pm.medya_tipi,
        bool_or(pm.profesyonel_cekim_mi) AS profesyonel_cekim,
        p.para_birimi,
        p.liste_fiyati
    FROM case_emlak.portfoy p
    LEFT JOIN case_emlak.portfoy_medya pm
        ON p.id = pm.portfoy_id
    GROUP BY p.id, pm.medya_tipi, p.para_birimi, p.liste_fiyati
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
    pm.medya_tipi,
    pm.profesyonel_cekim,
    COUNT(*) AS toplam_portfoy,
    COUNT(CASE WHEN COALESCE(ps.satildi,0)=1 THEN 1 END) AS satilan_portfoy,
    ROUND(
        COUNT(CASE WHEN COALESCE(ps.satildi,0)=1 THEN 1 END)::numeric /
        NULLIF(COUNT(*),0) * 100,2
    ) AS satis_orani_yuzde,
    ROUND(AVG(
        CASE 
            WHEN pm.para_birimi='TRY' THEN pm.liste_fiyati
            WHEN pm.para_birimi='USD' THEN pm.liste_fiyati*25
            WHEN pm.para_birimi='EUR' THEN pm.liste_fiyati*30
        END
    ),2) AS ortalama_liste_fiyati_try,
    ROUND(AVG(ps.brut_tl),2) AS ortalama_satis_fiyati_try
FROM portfoy_medya pm
LEFT JOIN portfoy_satis ps
    ON pm.portfoy_id = ps.portfoy_id
GROUP BY pm.medya_tipi, pm.profesyonel_cekim
ORDER BY pm.medya_tipi, pm.profesyonel_cekim DESC;
-- Medya tipi ve profesyonel cekim durumuna gore portfoy sayisi, satis orani ve fiyatlari karsılastırır.
-- Profesyonel cekim kullaniminin satis oranina ve fiyata etkisini analiz eder.
