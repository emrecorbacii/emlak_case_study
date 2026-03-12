SELECT
    AVG(fiyat_farki) AS ortalama_fark,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fiyat_farki) AS medyan_fark,
    MIN(fiyat_farki) AS en_dusuk_fark,
    MAX(fiyat_farki) AS en_yuksek_fark
FROM (
    SELECT
        (CASE
            WHEN i.para_birimi='TRY' THEN i.brut_islem_tutari
            WHEN i.para_birimi='USD' THEN i.brut_islem_tutari*25
            WHEN i.para_birimi='EUR' THEN i.brut_islem_tutari*30
        END
        -
        CASE
            WHEN p.para_birimi='TRY' THEN p.liste_fiyati
            WHEN p.para_birimi='USD' THEN p.liste_fiyati*25
            WHEN p.para_birimi='EUR' THEN p.liste_fiyati*30
        END
        )
        /
        NULLIF(
        CASE
            WHEN p.para_birimi='TRY' THEN p.liste_fiyati
            WHEN p.para_birimi='USD' THEN p.liste_fiyati*25
            WHEN p.para_birimi='EUR' THEN p.liste_fiyati*30
        END,0) *100 AS fiyat_farki
    FROM case_emlak.portfoy p
    JOIN case_emlak.islem i
        ON p.id=i.portfoy_id
    WHERE p.liste_fiyati>0 AND i.brut_islem_tutari>0
) sub;
-- Liste fiyati ile gerceklesen satis fiyati arasindaki yuzde farki hesaplar.
-- Ortalama, medyan, minimum ve maksimum fark degerleri raporlanir.
-- Fiyatlar kura gore TL'ye donusturuldukten sonra karsılastırılır.
-- Negatif fark = liste fiyatinin altinda satildi; pozitif = liste fiyatinin uzerinde.
