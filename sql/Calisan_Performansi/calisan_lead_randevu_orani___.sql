-- Satış danışmanı bazında lead → randevu dönüşüm oranı
SELECT
	c.id,
	c.eposta,
    c.ad || ' ' || c.soyad AS calisan_adi,
    COUNT(l.id) AS toplam_lead,
    COUNT(l.randevu_tarihi) AS randevuya_donen_lead,
    ROUND(
        COUNT(l.randevu_tarihi)::numeric / NULLIF(COUNT(l.id),0) * 100, 2
    ) AS randevu_orani_yuzde
FROM case_emlak.lead l
LEFT JOIN case_emlak.calisan c
    ON l.atanan_calisan_id = c.id
GROUP BY calisan_adi,c.id
ORDER BY randevu_orani_yuzde ASC;
-- Calisan bazinda lead -> randevu donusum oranini hesaplar.
-- lead.randevu_tarihi dolu olan kayitlar randevuya donusmussayilir.
-- Hangi calisanin atanan leadleri daha etkin takip ettigini gosterir.
