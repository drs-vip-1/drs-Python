<div align="center">

```
██████╗ ██████╗ ███████╗   ██╗   ██╗██╗██████╗ 
██╔══██╗██╔══██╗██╔════╝   ██║   ██║██║██╔══██╗
██║  ██║██████╔╝███████╗   ██║   ██║██║██████╔╝
██║  ██║██╔══██╗╚════██║   ╚██╗ ██╔╝██║██╔═══╝ 
██████╔╝██║  ██║███████║    ╚████╔╝ ██║██║     
╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═══╝  ╚═╝╚═╝     
```

# 𝑫𝑹𝑺.𝑽𝑰𝑷 — Ultimate Python Installation Suite
### Version 2026.1.0 | Python 3.13+ | All Libraries | All Platforms

![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Termux-gold)
![Python](https://img.shields.io/badge/Python-3.13%2B-blue)
![Libraries](https://img.shields.io/badge/Libraries-1000%2B-green)
![Categories](https://img.shields.io/badge/Categories-30%2B-orange)
![License](https://img.shields.io/badge/License-MIT-purple)

</div>

---

## 📋 الوصف

سكريبت تثبيت شامل ومتكامل يقوم بتثبيت Python 3.13+ وجميع أدواتها ومكتباتها في أكثر من 30 مجالاً مختلفاً، يدعم جميع الأنظمة: Linux، macOS، Windows، وTermux (Android).

---

## 🚀 التثبيت السريع

### 🐧 Linux / macOS
```bash
# الطريقة 1: المشغّل الذكي (يكتشف النظام تلقائياً)
bash drs_vip_launcher.sh

# الطريقة 2: مباشرة
chmod +x drs_vip_install.sh && bash drs_vip_install.sh

# الطريقة 3: عبر curl
curl -fsSL https://raw.githubusercontent.com/drs-vip/install/main/drs_vip_install.sh | bash
```

### 📱 Termux (Android)
```bash
# الطريقة 1: المشغّل الذكي
bash drs_vip_launcher.sh

# الطريقة 2: مباشرة
chmod +x drs_vip_termux.sh && bash drs_vip_termux.sh

# الطريقة 3: عبر pkg + curl
pkg install curl git -y
curl -fsSL https://raw.githubusercontent.com/drs-vip/install/main/drs_vip_termux.sh | bash
```

### 🪟 Windows (PowerShell)
```powershell
# الطريقة 1: تشغيل مباشر (كمسؤول)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
.\drs_vip_install.ps1

# الطريقة 2: عبر PowerShell مباشرة
iwr -useb https://raw.githubusercontent.com/drs-vip/install/main/drs_vip_install.ps1 | iex
```

---

## 📁 هيكل الملفات

```
DRS.VIP/
│
├── 📄 drs_vip_launcher.sh      ← المشغّل الذكي (يكتشف النظام تلقائياً)
├── 📄 drs_vip_install.sh       ← سكريبت Linux / macOS
├── 📄 drs_vip_termux.sh        ← سكريبت Termux / Android
├── 📄 drs_vip_install.ps1      ← سكريبت Windows / PowerShell
└── 📄 README.md                ← هذا الملف
```

---

## ⚙️ ما يقوم به السكريبت

### 1️⃣ تثبيت Python 3.13+
- تثبيت Python 3.13+ من المصادر الرسمية
- إضافة Python إلى PATH تلقائياً
- إنشاء symlinks (python, python3, python3.13)
- دعم التجميع من المصدر عند الحاجة
- تثبيت Python Launcher على Windows

### 2️⃣ تحديث pip
- تحديث pip إلى آخر إصدار
- تثبيت setuptools و wheel
- تثبيت pip-tools و pipdeptree

### 3️⃣ تثبيت الأدوات
| الأداة | الوصف |
|--------|-------|
| `black`, `isort`, `ruff` | منسّقات الكود |
| `flake8`, `pylint`, `mypy` | فاحصات الكود |
| `pytest`, `hypothesis` | اختبارات |
| `virtualenv`, `poetry`, `pdm` | بيئات افتراضية |
| `ipython`, `jupyter` | بيئات تفاعلية |
| `sphinx`, `mkdocs` | توثيق |
| `bandit`, `safety` | أمان |
| `black`, `pyright` | IDE tools |

### 4️⃣ المكتبات (30+ مجال)

---

## 📦 المكتبات المُثبَّتة حسب المجال

### 🔬 علم البيانات والتعلم الآلي
```
numpy · scipy · pandas · polars · scikit-learn · xgboost · lightgbm
catboost · statsmodels · imbalanced-learn · optuna · dask · vaex
```

### 🧠 التعلم العميق والشبكات العصبية
```
torch · tensorflow · keras · jax · flax · onnx · lightning
fastai · timm · transformers · accelerate · peft · diffusers
```

### 🤖 الذكاء الاصطناعي ونماذج اللغة الكبيرة
```
openai · anthropic · cohere · langchain · llama-index
llama-cpp-python · google-generativeai · groq · chromadb
faiss · pinecone · weaviate · qdrant · tiktoken · litellm · ollama
```

### 👁️ رؤية الحاسوب ومعالجة الصور
```
opencv · Pillow · scikit-image · albumentations · ultralytics
easyocr · pytesseract · deepface · mediapipe · kornia
```

### 📝 معالجة اللغة الطبيعية والنصوص
```
nltk · spacy · gensim · transformers · textblob · flair · stanza
langdetect · pyarabic · camel-tools · pypdf2 · PyMuPDF
```

### 🎵 معالجة الصوت والكلام
```
librosa · soundfile · pydub · openai-whisper · faster-whisper
SpeechRecognition · gtts · pyttsx3 · pyannote · speechbrain
```

### 📊 تصوير البيانات
```
matplotlib · seaborn · plotly · bokeh · altair · dash · streamlit
gradio · panel · folium · geopandas · shap · wordcloud
```

### 🌐 تطوير الويب
```
flask · django · fastapi · tornado · sanic · aiohttp · starlette
grpcio · graphene · pydantic · Jinja2 · gunicorn · uvicorn
```

### 🗄️ قواعد البيانات والتخزين
```
sqlalchemy · psycopg2 · pymongo · redis · elasticsearch
cassandra · influxdb · neo4j · tinydb · pyarrow · h5py
```

### ☁️ السحابة والـ DevOps
```
boto3 · google-cloud · azure · kubernetes · docker · paramiko
prometheus · opentelemetry · loguru · sentry-sdk
```

### 🔐 الشبكات والأمن السيبراني
```
scapy · pyshark · cryptography · pycryptodome · paramiko
bcrypt · argon2 · shodan · censys · pwntools · angr
```

### 🕷️ كشط الويب والأتمتة
```
requests · httpx · beautifulsoup4 · scrapy · selenium · playwright
yt-dlp · tweepy · praw · newspaper3k · trafilatura
```

### 💹 المالية والاقتصاد
```
yfinance · pandas-ta · backtrader · pyfolio · ccxt · prophet
sktime · statsforecast · neuralforecast · python-binance
```

### 🗺️ الجغرافيا ونظم المعلومات
```
geopandas · shapely · rasterio · cartopy · folium · osmnx
earthengine-api · geemap · pystac · pyproj
```

### ⚗️ الحوسبة العلمية
```
numpy · scipy · sympy · numba · pybind11 · astropy · biopython
rdkit · qiskit · pennylane · pymatgen · mdanalysis
```

### 🤖 الروبوتات وإنترنت الأشياء
```
pyserial · paho-mqtt · pymodbus · python-can · bleak · zigpy
gpiozero · adafruit-blinka · i2cdevice · smbus2
```

### 🎮 تطوير الألعاب
```
pygame · pyglet · arcade · panda3d · kivy · moderngl
pymunk · pybullet · pyopengl · pyxel · tcod
```

### 💻 نظام التشغيل والأتمتة
```
psutil · watchdog · pyautogui · pynput · keyboard
pywin32 · plyer · mss · python-dotenv · pyyaml
```

### ⚡ البرمجة غير المتزامنة
```
asyncio · aiofiles · aiohttp · anyio · trio · uvloop
celery · dramatiq · rq · dask · ray · prefect
```

### 🔄 هندسة البيانات وETL
```
apache-airflow · prefect · luigi · kedro · dbt-core
great-expectations · kafka-python · pyspark · petl
```

### 🔗 بلوكتشين والعملات الرقمية
```
web3 · eth-account · bitcoinlib · ccxt · python-binance
solana · solders · pycoingecko · cryptofeed
```

### 📧 البريد الإلكتروني والمراسلة
```
yagmail · sendgrid · slack-sdk · discord.py
python-telegram-bot · telethon · pyrogram · twilio
```

### 🧪 الاختبار وضمان الجودة
```
pytest · hypothesis · faker · factory-boy · selenium
playwright · locust · coverage · moto · testcontainers
```

### 📄 معالجة PDF والمستندات
```
pypdf2 · PyMuPDF · pdfplumber · reportlab · python-docx
python-pptx · openpyxl · tabula-py · unstructured · tika
```

### 🏥 الرعاية الصحية والمعلوماتية الحيوية
```
biopython · biotite · scanpy · anndata · nibabel
nilearn · MNE · pysam · HTSeq · pydeseq2
```

### 📚 التعليم والتفاعل
```
manim · vpython · kivy · streamlit · gradio · dash
panel · voila · napari · ipywidgets · k3d
```

---

## 🔧 المتطلبات

### Linux
- Ubuntu 20.04+ / Debian 11+ / Fedora 35+ / Arch Linux / openSUSE
- حقوق sudo أو root
- اتصال بالإنترنت
- مساحة خالية: 5-15 GB

### macOS
- macOS 12+ (Monterey أو أحدث)
- Xcode Command Line Tools
- اتصال بالإنترنت
- مساحة خالية: 5-15 GB

### Windows
- Windows 10/11 (64-bit)
- PowerShell 5.1+
- تشغيل كمسؤول موصى به
- اتصال بالإنترنت
- مساحة خالية: 5-15 GB

### Termux
- Android 7+ 
- Termux من F-Droid (موصى به)
- اتصال Wi-Fi (مستحسن)
- مساحة خالية: 3-8 GB

---

## 🎯 الأوامر بعد التثبيت

```bash
# تفعيل بيئة DRS.VIP الافتراضية
drs                    # Linux/macOS/Termux
# أو
source ~/drs_vip_env/bin/activate

# Windows PowerShell
drs
# أو
~\drs_vip_env\Scripts\Activate.ps1

# تشغيل Python
python                 # أو py / python3

# Jupyter Lab
jupyter lab

# IPython
ipython

# التحقق من المكتبات
python -c "import numpy, torch, tensorflow; print('✔ All good!')"

# عرض جميع الحزم المثبتة
pip list

# البحث عن حزمة
pip show numpy
```

---

## ⏱️ الوقت المتوقع للتثبيت

| النظام | الوقت التقريبي |
|--------|----------------|
| Linux (سريع) | 30-60 دقيقة |
| macOS | 45-90 دقيقة |
| Windows | 60-120 دقيقة |
| Termux | 30-60 دقيقة |

> ملاحظة: يعتمد الوقت على سرعة الإنترنت وأداء الجهاز

---

## ❓ استكشاف الأخطاء

### خطأ: Permission denied
```bash
chmod +x drs_vip_install.sh
sudo bash drs_vip_install.sh
```

### خطأ: Python not found
```bash
# Linux
sudo apt install python3.13 python3.13-pip
# macOS
brew install python@3.13
# Termux
pkg install python
```

### خطأ: pip install fails
```bash
python -m pip install --upgrade pip
python -m pip install --user package-name
```

### خطأ: Windows Execution Policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Termux: Storage permission
```bash
termux-setup-storage
```

---

## 📝 الملفات المُولَّدة

بعد التثبيت، ستجد:
```
~/drs_vip_requirements/
├── requirements_full.txt     ← جميع الحزم المثبتة
└── requirements.txt          ← الحزم الأساسية
```

---

## 🌟 المميزات

- ✅ **كشف تلقائي للنظام** - يختار السكريبت المناسب
- ✅ **تثبيت Python 3.13+** - أحدث إصدار مستقر
- ✅ **1000+ مكتبة** في 30+ مجال
- ✅ **بيئة افتراضية منفصلة** - لا تعارض مع النظام
- ✅ **دعم كامل للعربية** - واجهة ثنائية اللغة
- ✅ **معالجة الأخطاء** - تخطي المكتبات غير المتوفرة
- ✅ **تقرير كامل** - ملخص ما تم تثبيته
- ✅ **متوافق مع جميع التوزيعات** - Debian, Fedora, Arch, Alpine

---

## 📜 الترخيص

```
MIT License - 𝑫𝑹𝑺.𝑽𝑰𝑷 © 2026
Free to use, modify, and distribute
```

---

<div align="center">

### 𝑫𝑹𝑺.𝑽𝑰𝑷
**Ultimate Python Environment for Everyone**

*Linux • macOS • Windows • Android/Termux*

</div>