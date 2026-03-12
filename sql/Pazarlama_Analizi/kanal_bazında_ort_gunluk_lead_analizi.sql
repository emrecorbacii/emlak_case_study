SELECT
    ph.kanal,
    SUM(ph.lead_sayisi) AS toplam_lead,
    SUM(
        CASE 
            WHEN ph.bitis_tarihi IS NOT NULL THEN (ph.bitis_tarihi - ph.baslangic_tarihi)
            ELSE 1  -- bitiş yoksa 1 gün varsayıyoruz
        END
    ) AS toplam_kampanya_suresi_gun,
    ROUND(
        SUM(ph.lead_sayisi)::numeric /
        NULLIF(SUM(
            CASE 
                WHEN ph.bitis_tarihi IS NOT NULL THEN (ph.bitis_tarihi - ph.baslangic_tarihi)
                ELSE 1
            END
        ),0), 2
    ) AS ortalama_gunluk_lead
FROM case_emlak.pazarlama_harcama ph
WHERE ph.lead_sayisi IS NOT NULL
GROUP BY ph.kanal
ORDER BY ortalama_gunluk_lead DESC;
-- Pazarlama kanali bazinda toplam lead sayisi, kampanya suresi ve gunluk ortalama lead uretimini hesaplar.
-- Kampanya bitis tarihi olmayan kayitlar icin 1 gun varsayilmistir.
-- Kanalların gunluk lead uretim verimliligi karsılastırılır.
