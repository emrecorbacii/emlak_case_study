#!/bin/bash
set -e

echo "============================================"
echo "  PDF Raporu Olusturuluyor..."
echo "============================================"

jupyter nbconvert \
    --to webpdf \
    --no-input \
    --output-dir=/app \
    --output=case_study_report \
    /app/case_study.ipynb \
    && echo "PDF raporu olusturuldu: /app/case_study_report.pdf" \
    || echo "UYARI: PDF olusturulamadi. Jupyter Lab baslatiliyor..."

echo "============================================"
echo "  Jupyter Lab Baslatiliyor..."
echo "============================================"

exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
