# Emlak Case Study — Veri Analizi Projesi

PostgreSQL veritabanı üzerinde gayrimenkul verilerini analiz eden, Docker tabanlı Jupyter Lab ortamında çalışan bir veri analizi projesi.

## İçerik

- **24+ temel analiz** (funnel, ofis/çalışan performansı, portföy, pazarlama, medya)
- **20 ek analiz** (segmentasyon, korelasyon, hareketlilik, CTR, yaşam döngüsü)
- Her analizin altında detaylı **içgörü ve yorum** markdown hücreleri
- `docker compose up` ile otomatik **PDF rapor çıktısı**

## Gereksinimler

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/) (Docker Desktop ile birlikte gelir)

## Kurulum ve Çalıştırma

### 1. Repoyu klonla

```bash
git clone https://github.com/YOUR_USERNAME/emlak_case_study.git
cd emlak_case_study
```

### 2. İlk çalıştırma (image build)

İlk çalıştırmada Docker image'ı build edilir. Bu işlem Chromium binary indirdiğinden **5-10 dakika** sürebilir.

```bash
docker compose up --build
```

### 3. Sonraki çalıştırmalar

```bash
docker compose up
```

Container ayağa kalktığında otomatik olarak:
1. **`case_study_report.pdf`** dosyası proje kök dizinine oluşturulur (kod hücreleri gizli, sadece grafikler ve yorumlar)
2. **Jupyter Lab** `http://localhost:8888` adresinde başlatılır

### 4. Jupyter Lab'a eriş

Terminalde çıkan token URL'ini tarayıcıya yapıştır:

```
http://127.0.0.1:8888/lab?token=<token>
```

### 5. Durdurma

```bash
docker compose down
```

Veritabanını da sıfırlamak istersen:

```bash
docker compose down -v
```

## Proje Yapısı

```
emlak_case_study/
├── case_study.ipynb          # Ana analiz notebook'u
├── case_study_db.sql         # PostgreSQL dump (veritabanı şeması + veriler)
├── docker-compose.yml        # Servis tanımları (db + app)
├── Dockerfile                # Python 3.11 + Jupyter + Playwright
├── requirements.txt          # Python bağımlılıkları
├── startup.sh                # PDF üretimi + Jupyter Lab başlatma scripti
└── sql/
    ├── Calisan_Performansi/  # Çalışan bazlı performans sorguları
    ├── Diger_Analizler/      # 20 ek analiz sorgusu
    ├── Islem_Analizi/        # İşlem durum sorguları
    ├── Lead_Analizi/         # Lead dönüşüm sorguları
    ├── Medya_Analizi/        # Medya tipi sorguları
    ├── Ofis_Performansi/     # Ofis bazlı performans sorguları
    ├── Pazarlama_Analizi/    # Pazarlama ROI ve CTR sorguları
    └── Portfoy_Analizi/      # Portföy satış ve fiyat sorguları
```

## Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Veritabanı | PostgreSQL 16 |
| Dil | Python 3.11 |
| Analiz | pandas, numpy |
| Görselleştirme | matplotlib, seaborn |
| Notebook | JupyterLab |
| DB Bağlantısı | SQLAlchemy, psycopg |
| PDF Export | nbconvert, Playwright/Chromium |
| Container | Docker, Docker Compose |

## Veritabanı Bağlantısı

Notebook içinde bağlantı bilgileri `docker-compose.yml`'deki environment değişkenlerinden okunur:

```python
import os
from sqlalchemy import create_engine, text

engine = create_engine(
    f"postgresql+psycopg://{os.environ['DB_USER']}:{os.environ['DB_PASSWORD']}"
    f"@{os.environ['DB_HOST']}:{os.environ['DB_PORT']}/{os.environ['DB_NAME']}"
)
```
