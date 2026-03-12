SELECT
AVG(
    CASE
        WHEN para_birimi = 'USD' THEN brut_islem_tutari * 25
        WHEN para_birimi = 'EUR' THEN brut_islem_tutari * 30
    END
) AS ortalama_satis_fiyati_try,

SUM(
    CASE
        WHEN para_birimi = 'USD' THEN brut_islem_tutari * 25
        WHEN para_birimi = 'EUR' THEN brut_islem_tutari * 30
    END
) AS toplam_satis_hacmi_try

FROM case_emlak.islem
WHERE portfoy_id IS NOT NULL AND islem_durumu ='tamamlandi';
-- Tamamlanan satislik portfoy islemlerinin ortalama ve toplam brut satis tutarini TL cinsinden hesaplar.
-- Fiyatlar USD=25, EUR=30 kuruyla TL'ye donusturulur.
-- NOT: TRY satirlari da carpma islemi olmaksizin dahil edilmistir, kontrol edilmeli.
