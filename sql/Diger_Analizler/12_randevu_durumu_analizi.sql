SELECT
    r.durum AS randevu_durumu,
    COUNT(r.id) AS randevu_sayisi,
    ROUND(COUNT(r.id)::numeric / SUM(COUNT(r.id)) OVER () * 100, 2) AS oran_pct
FROM case_emlak.randevu r
GROUP BY r.durum
ORDER BY randevu_sayisi DESC;

-- Randevu durumlarinin (tamamlandi, iptal, no_show, ertelendi vb.) dagilimini ve yuzdelerini hesaplar.
-- Yuksek no_show veya iptal orani, randevu onaylama ve hatirlatma sureclerinin gozden gecirilmesi gerektigine isaret eder.
