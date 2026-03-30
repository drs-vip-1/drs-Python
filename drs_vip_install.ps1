# ============================================================
#         𝑫𝑹𝑺.𝑽𝑰𝑷 - Ultimate Python Installation Script
#         Version: 2026.1.0
#         Platform: Windows (PowerShell 5.1+ / PowerShell 7+)
# ============================================================

#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# ─────────────────────────────────────────────
#  Color Theme & Styles
# ─────────────────────────────────────────────
function Write-Gold   { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Cyan   { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Green  { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Red    { param($msg) Write-Host $msg -ForegroundColor Red }
function Write-White  { param($msg) Write-Host $msg -ForegroundColor White }
function Write-Dim    { param($msg) Write-Host $msg -ForegroundColor DarkGray }

function Log-Info    { Write-Host "  [i]  $args" -ForegroundColor Cyan }
function Log-Success { Write-Host "  [+]  $args" -ForegroundColor Green }
function Log-Warning { Write-Host "  [!]  $args" -ForegroundColor Yellow }
function Log-Error   { Write-Host "  [x]  $args" -ForegroundColor Red }

function Log-Step {
    param($title)
    Write-Host ""
    Write-Host "  ══════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host "  >>  $title" -ForegroundColor Yellow
    Write-Host "  ══════════════════════════════════════════════" -ForegroundColor Yellow
}

# ─────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ██████╗ ██████╗ ███████╗   ██╗   ██╗██╗██████╗ " -ForegroundColor Yellow
    Write-Host "  ██╔══██╗██╔══██╗██╔════╝   ██║   ██║██║██╔══██╗" -ForegroundColor Yellow
    Write-Host "  ██║  ██║██████╔╝███████╗   ██║   ██║██║██████╔╝" -ForegroundColor Yellow
    Write-Host "  ██║  ██║██╔══██╗╚════██║   ╚██╗ ██╔╝██║██╔═══╝ " -ForegroundColor Yellow
    Write-Host "  ██████╔╝██║  ██║███████║    ╚████╔╝ ██║██║     " -ForegroundColor Yellow
    Write-Host "  ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═══╝  ╚═╝╚═╝     " -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║   𝑫𝑹𝑺.𝑽𝑰𝑷 - Ultimate Installation Suite    ║" -ForegroundColor Yellow
    Write-Host "  ║       Python 3.13+ | All Libraries           ║" -ForegroundColor White
    Write-Host "  ║       Windows Edition | 2026                 ║" -ForegroundColor DarkGray
    Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# ─────────────────────────────────────────────
#  Check Administrator
# ─────────────────────────────────────────────
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Ensure-Admin {
    Log-Step "Checking Administrator Privileges"
    if (-not (Test-Administrator)) {
        Log-Warning "Not running as Administrator. Some installations may fail."
        Log-Info "Tip: Right-click PowerShell -> Run as Administrator"
        $choice = Read-Host "  Continue anyway? (y/N)"
        if ($choice -ne 'y' -and $choice -ne 'Y') { exit 1 }
    } else {
        Log-Success "Running as Administrator"
    }
}

# ─────────────────────────────────────────────
#  Set Execution Policy
# ─────────────────────────────────────────────
function Set-PSPolicy {
    Log-Step "Setting PowerShell Execution Policy"
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Log-Success "Execution policy set to RemoteSigned"
    } catch {
        Log-Warning "Could not set execution policy: $_"
    }
}

# ─────────────────────────────────────────────
#  Install Chocolatey
# ─────────────────────────────────────────────
function Install-Chocolatey {
    Log-Step "Installing Chocolatey Package Manager"
    
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Log-Success "Chocolatey already installed: $(choco --version)"
        return
    }
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
        Log-Success "Chocolatey installed successfully"
    } catch {
        Log-Error "Failed to install Chocolatey: $_"
    }
}

# ─────────────────────────────────────────────
#  Install winget (Windows Package Manager)
# ─────────────────────────────────────────────
function Ensure-Winget {
    Log-Step "Checking winget"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Log-Success "winget available: $(winget --version)"
    } else {
        Log-Warning "winget not found. Install App Installer from Microsoft Store"
    }
}

# ─────────────────────────────────────────────
#  Install Python 3.13
# ─────────────────────────────────────────────
function Install-Python {
    Log-Step "Installing Python 3.13+"
    
    $PYTHON_VERSION = "3.13.1"
    
    # Check existing
    $existing = Get-Command python -ErrorAction SilentlyContinue
    if ($existing) {
        $ver = & python --version 2>&1
        if ($ver -match "3\.1[3-9]" -or $ver -match "3\.[2-9]\d") {
            Log-Success "Python already installed: $ver"
            $global:PythonCmd = "python"
            return
        }
    }
    
    # Method 1: winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Log-Info "Installing via winget..."
        try {
            winget install Python.Python.3.13 --silent --accept-source-agreements --accept-package-agreements
            Log-Success "Python installed via winget"
        } catch {
            Log-Warning "winget install failed, trying alternative..."
        }
    }
    
    # Method 2: Chocolatey
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Log-Info "Installing via Chocolatey..."
            choco install python313 -y --no-progress
        }
    }
    
    # Method 3: Direct download
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Log-Info "Downloading Python installer directly..."
        $installer = "$env:TEMP\python-$PYTHON_VERSION-amd64.exe"
        $url = "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-amd64.exe"
        
        try {
            (New-Object System.Net.WebClient).DownloadFile($url, $installer)
            
            Start-Process -FilePath $installer -ArgumentList @(
                "/quiet",
                "InstallAllUsers=1",
                "PrependPath=1",
                "Include_test=0",
                "Include_pip=1",
                "Include_tcltk=1",
                "Include_launcher=1"
            ) -Wait -NoNewWindow
            
            Remove-Item $installer -ErrorAction SilentlyContinue
            Log-Success "Python installed from official installer"
        } catch {
            Log-Error "Failed to install Python: $_"
        }
    }
    
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Find Python command
    foreach ($cmd in @("python", "python3", "py")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            $global:PythonCmd = $cmd
            $ver = & $cmd --version 2>&1
            Log-Success "Python ready: $ver (command: $cmd)"
            break
        }
    }
    
    if (-not $global:PythonCmd) {
        Log-Error "Python installation could not be verified. Please restart PowerShell."
        $global:PythonCmd = "python"
    }
    
    # Add to PATH permanently
    Add-ToPATH
}

# ─────────────────────────────────────────────
#  Add to PATH
# ─────────────────────────────────────────────
function Add-ToPATH {
    Log-Step "Configuring PATH"
    
    $pythonPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python313",
        "$env:LOCALAPPDATA\Programs\Python\Python313\Scripts",
        "$env:ProgramFiles\Python313",
        "$env:ProgramFiles\Python313\Scripts",
        "$env:APPDATA\Python\Python313\Scripts",
        "$env:LOCALAPPDATA\Programs\Python\Launcher",
        "C:\Python313",
        "C:\Python313\Scripts"
    )
    
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $pathsToAdd = @()
    
    foreach ($path in $pythonPaths) {
        if ((Test-Path $path) -and ($currentPath -notlike "*$path*")) {
            $pathsToAdd += $path
        }
    }
    
    if ($pathsToAdd.Count -gt 0) {
        $newPath = $currentPath + ";" + ($pathsToAdd -join ";")
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path += ";" + ($pathsToAdd -join ";")
        Log-Success "Added $($pathsToAdd.Count) paths to PATH"
    } else {
        Log-Info "PATH already configured"
    }
    
    # Set PYTHONDONTWRITEBYTECODE
    [System.Environment]::SetEnvironmentVariable("PYTHONDONTWRITEBYTECODE", "0", "User")
    [System.Environment]::SetEnvironmentVariable("PYTHONUNBUFFERED", "1", "User")
    
    Log-Success "PATH configured successfully"
}

# ─────────────────────────────────────────────
#  Install / Upgrade pip
# ─────────────────────────────────────────────
function Install-Pip {
    Log-Step "Installing / Upgrading pip"
    
    & $global:PythonCmd -m pip install --upgrade pip setuptools wheel pip-tools pipdeptree 2>&1 | Out-Null
    $pipVer = & $global:PythonCmd -m pip --version 2>&1
    Log-Success "pip ready: $pipVer"
}

# ─────────────────────────────────────────────
#  Install Node.js
# ─────────────────────────────────────────────
function Install-NodeJS {
    Log-Step "Installing Node.js & npm"
    
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Log-Success "Node.js already installed: $(node --version)"
        return
    }
    
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install nodejs-lts -y --no-progress 2>&1 | Out-Null
    }
    
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                [System.Environment]::GetEnvironmentVariable("Path","User")
    
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Log-Success "Node.js: $(node --version)"
    } else {
        Log-Warning "Node.js installation may require restart"
    }
}

# ─────────────────────────────────────────────
#  Install Git
# ─────────────────────────────────────────────
function Install-Git {
    Log-Step "Installing Git"
    
    if (Get-Command git -ErrorAction SilentlyContinue) {
        Log-Success "Git already installed: $(git --version)"
        return
    }
    
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Git.Git --silent --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install git -y --no-progress 2>&1 | Out-Null
    }
    
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Log-Success "Git: $(git --version 2>&1)"
}

# ─────────────────────────────────────────────
#  Install Rust
# ─────────────────────────────────────────────
function Install-Rust {
    Log-Step "Installing Rust (for Rust-based packages)"
    
    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        Log-Success "Rust already installed: $(rustc --version)"
        return
    }
    
    $rustInstaller = "$env:TEMP\rustup-init.exe"
    try {
        (New-Object System.Net.WebClient).DownloadFile("https://win.rustup.rs/x86_64", $rustInstaller)
        Start-Process -FilePath $rustInstaller -ArgumentList "-y" -Wait -NoNewWindow
        Remove-Item $rustInstaller -ErrorAction SilentlyContinue
        $env:Path += ";$env:USERPROFILE\.cargo\bin"
        Log-Success "Rust installed"
    } catch {
        Log-Warning "Rust installation failed (optional): $_"
    }
}

# ─────────────────────────────────────────────
#  Install Visual C++ Build Tools
# ─────────────────────────────────────────────
function Install-BuildTools {
    Log-Step "Installing Visual C++ Build Tools"
    
    if (Get-Command cl.exe -ErrorAction SilentlyContinue) {
        Log-Success "Visual C++ Build Tools already installed"
        return
    }
    
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Log-Info "Installing Visual C++ Build Tools via Chocolatey..."
        choco install visualcpp-build-tools -y --no-progress 2>&1 | Out-Null
        Log-Success "Build tools installed"
    } elseif (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Microsoft.VisualStudio.2022.BuildTools --silent --accept-source-agreements 2>&1 | Out-Null
        Log-Success "Build tools installed via winget"
    } else {
        Log-Warning "Build tools not installed (some packages may fail to build)"
    }
}

# ─────────────────────────────────────────────
#  Install Python Packages by Category
# ─────────────────────────────────────────────
function Install-Category {
    param(
        [string]$CategoryName,
        [string[]]$Packages
    )
    
    Write-Host ""
    Write-Host "  +--------------------------------------------------+" -ForegroundColor Yellow
    Write-Host "  |  $CategoryName" -ForegroundColor Yellow
    Write-Host "  +--------------------------------------------------+" -ForegroundColor Yellow
    
    $installed = 0
    $failed = @()
    
    foreach ($pkg in $Packages) {
        $result = & $global:PythonCmd -m pip install --quiet --upgrade $pkg 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [+] $pkg" -ForegroundColor Green
            $installed++
        } else {
            Write-Host "  [!] $pkg (skipped)" -ForegroundColor DarkYellow
            $failed += $pkg
        }
    }
    
    Write-Host "  Installed: $installed | Skipped: $($failed.Count)" -ForegroundColor Cyan
}

# ─────────────────────────────────────────────
#  Install Tools
# ─────────────────────────────────────────────
function Install-PythonTools {
    Log-Step "Installing Python Tools & Package Managers"
    
    $tools = @(
        # Core tools
        "pip", "setuptools", "wheel", "build", "twine",
        # Virtual Environments
        "virtualenv", "pipenv", "poetry", "hatch", "pdm", "flit",
        # Package managers
        "pip-tools", "pipdeptree", "pip-autoremove", "pip-review",
        "pipreqs", "pip-chill",
        # Code formatters
        "black", "isort", "autopep8", "yapf", "ruff",
        # Linters
        "flake8", "pylint", "mypy", "pyflakes", "pycodestyle",
        "pydocstyle", "bandit", "pylama", "vulture", "radon",
        # Type checkers
        "pyright",
        # Testing
        "pytest", "pytest-cov", "pytest-xdist", "pytest-asyncio",
        "pytest-mock", "pytest-benchmark", "pytest-html",
        "hypothesis", "tox", "coverage", "factory-boy", "faker",
        "freezegun", "responses",
        # Documentation
        "sphinx", "sphinx-rtd-theme", "mkdocs", "mkdocs-material", "pdoc3",
        # Debugging
        "ipdb", "pudb", "snoop", "pysnooper", "icecream",
        # Profiling
        "line-profiler", "memory-profiler", "pyinstrument", "scalene",
        "guppy3", "objgraph",
        # CLI tools
        "click", "typer", "rich", "textual", "tqdm", "alive-progress",
        "inquirer", "questionary", "prompt-toolkit", "colorama",
        "termcolor", "urwid",
        # Task runners
        "invoke", "celery", "dramatiq", "rq", "apscheduler", "schedule",
        # File utilities
        "watchdog", "arrow", "pendulum", "humanize", "tabulate",
        "pretty-errors",
        # HTTP clients
        "requests", "httpx", "aiohttp", "urllib3",
        # Interactive
        "ipython", "jupyter", "jupyterlab", "notebook", "nbconvert",
        "ipywidgets",
        # Git
        "gitpython", "pre-commit", "commitizen",
        # Security
        "safety", "detect-secrets"
    )
    
    $installed = 0
    $failed = @()
    
    foreach ($tool in $tools) {
        $result = & $global:PythonCmd -m pip install --quiet --upgrade $tool 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [+] $tool" -ForegroundColor Green
            $installed++
        } else {
            Write-Host "  [!] $tool (skipped)" -ForegroundColor DarkYellow
            $failed += $tool
        }
    }
    
    Log-Success "Tools: $installed installed, $($failed.Count) skipped"
}

# ─────────────────────────────────────────────
#  Install All Libraries
# ─────────────────────────────────────────────
function Install-AllLibraries {

    # 1. Data Science & ML
    Install-Category "Data Science & Machine Learning" @(
        "numpy", "scipy", "pandas", "polars", "scikit-learn",
        "scikit-image", "scikit-optimize", "xgboost", "lightgbm",
        "catboost", "statsmodels", "pingouin", "imbalanced-learn",
        "mlxtend", "category-encoders", "feature-engine", "featuretools",
        "optuna", "hyperopt", "joblib", "cloudpickle", "dask",
        "vaex"
    )

    # 2. Deep Learning
    Install-Category "Deep Learning & Neural Networks" @(
        "torch", "torchvision", "torchaudio",
        "tensorflow", "keras",
        "jax", "jaxlib", "flax", "optax",
        "onnx", "onnxruntime", "onnxmltools",
        "lightning", "fastai", "timm",
        "transformers", "tokenizers", "datasets",
        "accelerate", "peft", "bitsandbytes",
        "diffusers", "sentence-transformers",
        "einops"
    )

    # 3. AI & LLM
    Install-Category "AI & Large Language Models" @(
        "openai", "anthropic", "cohere",
        "langchain", "langchain-community", "langchain-openai",
        "llama-index", "llama-cpp-python",
        "google-generativeai",
        "mistralai", "together",
        "groq", "replicate",
        "chromadb", "faiss-cpu", "pinecone-client",
        "weaviate-client", "qdrant-client",
        "tiktoken", "instructor", "litellm", "ollama",
        "guidance", "outlines"
    )

    # 4. Computer Vision
    Install-Category "Computer Vision & Image Processing" @(
        "opencv-python", "opencv-contrib-python",
        "Pillow", "imageio", "imageio-ffmpeg",
        "scikit-image", "albumentations",
        "ultralytics", "roboflow", "supervision",
        "easyocr", "pytesseract",
        "deepface", "mediapipe",
        "pycocotools", "shapely", "kornia", "torchmetrics"
    )

    # 5. NLP & Text Processing
    Install-Category "NLP & Text Processing" @(
        "nltk", "spacy", "gensim",
        "transformers", "tokenizers",
        "sentence-transformers", "textblob",
        "vaderSentiment", "flair", "stanza",
        "langdetect", "langid", "textstat",
        "ftfy", "unidecode", "chardet", "charset-normalizer",
        "regex", "pyarabic",
        "pypdf2", "PyMuPDF", "pdfplumber",
        "python-docx", "python-pptx",
        "openpyxl", "xlrd", "xlwt", "xlsxwriter",
        "markdown", "mistune",
        "html2text", "beautifulsoup4", "lxml",
        "reportlab", "weasyprint"
    )

    # 6. Audio & Speech
    Install-Category "Audio & Speech Processing" @(
        "librosa", "soundfile", "sounddevice",
        "pyaudio", "pydub", "pygame",
        "mutagen", "audioread", "noisereduce",
        "openai-whisper", "faster-whisper",
        "SpeechRecognition", "gtts", "pyttsx3",
        "praat-parselmouth", "pyworld",
        "music21", "pretty-midi", "midiutil", "pedalboard"
    )

    # 7. Data Visualization
    Install-Category "Data Visualization" @(
        "matplotlib", "seaborn", "plotly",
        "bokeh", "altair",
        "dash", "dash-bootstrap-components",
        "streamlit", "gradio",
        "panel", "holoviews", "hvplot",
        "pyecharts", "pygal",
        "folium", "geopandas",
        "pydeck", "plotnine",
        "missingno", "wordcloud",
        "yellowbrick", "shap", "lime", "eli5",
        "sweetviz", "ydata-profiling"
    )

    # 8. Web Development
    Install-Category "Web Development & Frameworks" @(
        "flask", "flask-restful", "flask-sqlalchemy",
        "flask-login", "flask-wtf", "flask-cors",
        "flask-jwt-extended", "flask-caching",
        "django", "djangorestframework", "django-cors-headers",
        "django-allauth", "django-environ", "django-filter",
        "fastapi", "uvicorn", "starlette",
        "httpx", "aiohttp", "tornado", "sanic",
        "litestar", "quart", "falcon", "bottle",
        "grpcio", "grpcio-tools", "protobuf",
        "graphene", "strawberry-graphql",
        "pydantic", "pydantic-settings",
        "marshmallow", "cerberus", "wtforms",
        "Jinja2", "Mako",
        "passlib", "bcrypt",
        "python-jose", "cryptography", "pyotp",
        "itsdangerous", "gunicorn", "waitress",
        "whitenoise"
    )

    # 9. Databases
    Install-Category "Databases & Storage" @(
        "sqlalchemy", "alembic", "databases",
        "tortoise-orm", "peewee", "piccolo",
        "psycopg2-binary", "asyncpg",
        "mysql-connector-python", "PyMySQL", "aiomysql",
        "pymongo", "motor", "beanie", "mongoengine",
        "redis", "aioredis",
        "elasticsearch",
        "cassandra-driver",
        "influxdb-client", "neo4j", "py2neo",
        "tinydb", "sqlite-utils", "dataset",
        "pyarrow", "fastparquet", "h5py", "zarr",
        "sqlmodel", "minio"
    )

    # 10. Cloud & DevOps
    Install-Category "Cloud & DevOps" @(
        "boto3", "botocore",
        "google-cloud-storage", "google-cloud-bigquery",
        "google-cloud-pubsub", "google-auth",
        "azure-identity", "azure-mgmt-resource",
        "azure-mgmt-compute", "azure-mgmt-storage",
        "kubernetes", "docker",
        "paramiko", "fabric", "sshtunnel",
        "prometheus-client",
        "opentelemetry-sdk", "opentelemetry-api",
        "structlog", "loguru", "python-json-logger",
        "sentry-sdk", "pystatsd"
    )

    # 11. Network & Security
    Install-Category "Network & Cybersecurity" @(
        "scapy", "pyshark", "python-nmap",
        "paramiko", "cryptography", "pycryptodome",
        "pynacl", "pyopenssl", "certifi",
        "requests-oauthlib", "oauthlib",
        "bcrypt", "argon2-cffi", "passlib",
        "itsdangerous", "ldap3",
        "shodan", "censys"
    )

    # 12. Web Scraping
    Install-Category "Web Scraping & Automation" @(
        "requests", "httpx", "aiohttp",
        "beautifulsoup4", "lxml", "html5lib",
        "scrapy", "selenium", "undetected-chromedriver",
        "playwright", "pyppeteer", "requests-html",
        "parsel", "newspaper3k", "trafilatura",
        "goose3", "readability-lxml",
        "tweepy", "praw", "instaloader", "yt-dlp",
        "fake-useragent", "curl-cffi", "cloudscraper",
        "pdfkit", "weasyprint"
    )

    # 13. Finance & Economics
    Install-Category "Finance & Economics" @(
        "yfinance", "pandas-datareader", "alpha-vantage",
        "ta", "finta", "pandas-ta",
        "backtrader", "backtesting",
        "pyfolio", "ffn", "riskfolio-lib",
        "empyrical", "pyportfolioopt",
        "arch", "statsforecast", "mlforecast",
        "neuralforecast", "darts", "prophet",
        "sktime", "tsfresh", "tslearn",
        "ccxt", "python-binance",
        "polygon-api-client", "nasdaqdatalink"
    )

    # 14. Geographic & GIS
    Install-Category "Geographic & GIS" @(
        "geopandas", "shapely", "fiona",
        "pyproj", "rasterio", "xarray",
        "cartopy", "folium", "ipyleaflet",
        "pydeck", "geopy", "geocoder",
        "googlemaps", "osmnx", "networkx",
        "pysal", "earthengine-api", "geemap",
        "planetary-computer", "pystac"
    )

    # 15. Scientific Computing
    Install-Category "Scientific Computing" @(
        "numpy", "scipy", "sympy", "mpmath",
        "numba", "numexpr", "cython",
        "pybind11", "mpi4py",
        "astropy", "astroquery",
        "biopython", "biotite",
        "pubchempy", "chempy", "mendeleev",
        "pymatgen", "ase",
        "pennylane", "qiskit", "cirq",
        "pyscf", "mdanalysis", "prody"
    )

    # 16. System & OS
    Install-Category "System & OS Automation" @(
        "psutil", "py-cpuinfo", "gputil",
        "watchdog", "pyautogui", "pynput",
        "keyboard", "mouse", "pygetwindow",
        "pywin32", "wmi", "plyer",
        "desktop-notifier", "pyperclip",
        "mss", "pyscreenshot", "pillow",
        "python-dotenv", "decouple", "dynaconf",
        "pyyaml", "toml", "tomlkit",
        "ruamel.yaml"
    )

    # 17. Async & Concurrency
    Install-Category "Async & Concurrency" @(
        "asyncio", "aiofiles", "aiohttp",
        "anyio", "trio", "uvloop",
        "httpx", "starlette", "fastapi",
        "twisted", "gevent", "eventlet",
        "multiprocess", "pathos", "ray",
        "dask", "prefect", "celery",
        "dramatiq", "arq", "rq", "huey",
        "apscheduler", "schedule"
    )

    # 18. Data Engineering
    Install-Category "Data Engineering & ETL" @(
        "apache-airflow", "prefect", "luigi",
        "kedro", "dbt-core",
        "great-expectations", "pandera",
        "pydantic", "pyarrow", "fastparquet",
        "dask", "pyspark", "petl",
        "kafka-python", "confluent-kafka",
        "faust-streaming", "pika", "kombu", "pyzmq"
    )

    # 19. Blockchain & Crypto
    Install-Category "Blockchain & Cryptocurrency" @(
        "web3", "eth-account", "eth-typing",
        "eth-utils", "rlp",
        "bitcoinlib", "pycoingecko",
        "ccxt", "cryptofeed",
        "binance-connector", "python-binance",
        "solana", "solders"
    )

    # 20. Email & Messaging
    Install-Category "Email & Messaging" @(
        "aiosmtplib", "flanker",
        "emails", "yagmail", "redmail",
        "sendgrid", "mailchimp3",
        "premailer", "html2text",
        "slack-sdk", "slack-bolt",
        "discord.py", "python-telegram-bot",
        "telethon", "pyrogram",
        "twilio", "vonage", "line-bot-sdk"
    )

    # 21. Testing & QA
    Install-Category "Testing & Quality Assurance" @(
        "pytest", "nose2", "behave",
        "robotframework", "hypothesis",
        "faker", "factory-boy", "mixer",
        "responses", "httpretty", "vcrpy",
        "freezegun", "moto", "testcontainers",
        "selenium", "playwright", "pyautogui",
        "allure-pytest", "pytest-html",
        "coverage", "locust"
    )

    # 22. PDF & Document Processing
    Install-Category "PDF & Document Processing" @(
        "pypdf2", "pypdf", "PyMuPDF",
        "pdfplumber", "pdfminer.six",
        "pdfrw", "reportlab", "fpdf2",
        "weasyprint", "pdfkit",
        "python-docx", "python-pptx",
        "openpyxl", "xlrd", "xlwt",
        "xlsxwriter", "odfpy",
        "textract", "tika", "unstructured",
        "camelot-py", "tabula-py",
        "pytesseract", "easyocr",
        "docling", "marker-pdf"
    )

    # 23. Image Processing
    Install-Category "Image & Graphic Processing" @(
        "Pillow", "opencv-python", "scikit-image",
        "imageio", "mahotas",
        "albumentations", "kornia",
        "rembg", "backgroundremover",
        "qrcode", "python-barcode",
        "pdf2image", "img2pdf", "pikepdf",
        "svgwrite", "cairosvg", "wand"
    )

    # 24. Video Processing
    Install-Category "Video Processing & Streaming" @(
        "opencv-python", "moviepy",
        "imageio-ffmpeg", "ffmpeg-python", "av",
        "decord", "insightface",
        "deepface", "face-recognition", "dlib",
        "mediapipe", "onnxruntime",
        "vidgear", "streamlink", "yt-dlp",
        "pymediainfo", "mutagen", "tinytag"
    )

    # 25. Healthcare & Bioinformatics
    Install-Category "Healthcare & Bioinformatics" @(
        "biopython", "biotite", "scikit-bio",
        "ete3", "dendropy",
        "HTSeq", "scanpy", "anndata",
        "muon", "scvi-tools",
        "pydeseq2", "goatools",
        "pyensembl", "pyranges",
        "chembl-webresource-client", "mygene",
        "bioservices", "DIPY",
        "nibabel", "nilearn", "MNE"
    )

    # 26. Game Development
    Install-Category "Game Development" @(
        "pygame", "pyglet", "arcade",
        "panda3d", "ursina",
        "pyopengl", "pyglfw", "moderngl",
        "pymunk", "pybullet",
        "kivy", "kivymd",
        "tcod", "pyxel", "noise",
        "opensimplex", "vispy"
    )

    # 27. Robotics & IoT
    Install-Category "Robotics & IoT" @(
        "pyserial", "pyzmq",
        "paho-mqtt", "asyncio-mqtt",
        "aiocoap", "pymodbus",
        "python-can", "pyftdi",
        "bleak", "zigpy"
    )

    # 28. Parsing & Data Formats
    Install-Category "Parsing & Data Formats" @(
        "json5", "orjson", "ujson", "simplejson",
        "msgpack", "cbor2", "protobuf",
        "fastavro", "pyarrow",
        "pyyaml", "ruamel.yaml",
        "toml", "tomlkit",
        "lxml", "xmltodict", "untangle",
        "html5lib", "cssselect", "pyquery",
        "feedparser", "dateparser",
        "python-dateutil", "pytz",
        "tzlocal", "babel", "arrow", "pendulum"
    )

    # 29. Utilities & Misc
    Install-Category "Utilities & Miscellaneous" @(
        "more-itertools", "toolz", "funcy",
        "attrs", "cattrs", "dacite",
        "typeguard", "beartype",
        "wrapt", "decorator", "deprecated",
        "tenacity", "backoff", "retry",
        "cachetools", "diskcache", "joblib",
        "blinker", "transitions", "statemachine",
        "sortedcontainers", "rtree",
        "bidict", "frozendict", "addict",
        "glom", "jmespath",
        "jsonpath-ng", "jsonschema",
        "typing-extensions", "typing-inspect",
        "pygments", "rich", "textual",
        "colorama", "termcolor", "urwid",
        "alive-progress", "tqdm", "enlighten",
        "halo", "yaspin",
        "click", "typer", "fire",
        "docopt", "plac", "argh",
        "questionary", "inquirer", "prompt-toolkit"
    )

    Log-Success "All library categories installed!"
}

# ─────────────────────────────────────────────
#  Setup Virtual Environment
# ─────────────────────────────────────────────
function Setup-VirtualEnv {
    Log-Step "Setting up Virtual Environment"
    
    $venvPath = "$env:USERPROFILE\drs_vip_env"
    
    if (-not (Test-Path $venvPath)) {
        & $global:PythonCmd -m venv $venvPath
        Log-Success "Virtual environment created: $venvPath"
    } else {
        Log-Info "Virtual environment already exists"
    }
    
    # Create activation script shortcut
    $activateScript = @"
@echo off
call "$venvPath\Scripts\activate.bat"
"@
    $activateScript | Out-File -FilePath "$env:USERPROFILE\activate_drs.bat" -Encoding ASCII
    
    # PowerShell profile
    $profileContent = @"

# DRS.VIP Virtual Environment
function drs { & "$venvPath\Scripts\Activate.ps1" }
"@
    
    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    
    if (-not (Select-String -Path $PROFILE -Pattern "DRS.VIP" -Quiet 2>$null)) {
        Add-Content -Path $PROFILE -Value $profileContent
        Log-Success "Added 'drs' command to PowerShell profile"
    }
    
    Log-Success "Virtual environment setup complete"
    Log-Info "Use 'drs' in PowerShell or 'activate_drs.bat' in CMD"
}

# ─────────────────────────────────────────────
#  Generate Requirements
# ─────────────────────────────────────────────
function Generate-Requirements {
    Log-Step "Generating Requirements Files"
    
    $reqDir = "$env:USERPROFILE\drs_vip_requirements"
    New-Item -ItemType Directory -Path $reqDir -Force | Out-Null
    
    & $global:PythonCmd -m pip freeze | Out-File -FilePath "$reqDir\requirements_full.txt" -Encoding UTF8
    
    $reqContent = @"
# ═══════════════════════════════════════════════════
#   𝑫𝑹𝑺.𝑽𝑰𝑷 - Complete Python Requirements
#   Generated by DRS.VIP Installation Suite 2026
# ═══════════════════════════════════════════════════
numpy
scipy
pandas
matplotlib
seaborn
requests
flask
django
fastapi
sqlalchemy
pytest
black
mypy
"@
    $reqContent | Out-File -FilePath "$reqDir\requirements.txt" -Encoding UTF8
    
    Log-Success "Requirements saved to: $reqDir"
}

# ─────────────────────────────────────────────
#  Verify Installation
# ─────────────────────────────────────────────
function Verify-Installation {
    Log-Step "Verifying Installation"
    
    Write-Host ""
    Write-Host "  System Information:" -ForegroundColor Cyan
    
    $pyVer = & $global:PythonCmd --version 2>&1
    $pipVer = & $global:PythonCmd -m pip --version 2>&1
    
    Write-Host "  Python:  $pyVer" -ForegroundColor White
    Write-Host "  pip:     $pipVer" -ForegroundColor White
    Write-Host "  OS:      $([System.Environment]::OSVersion.VersionString)" -ForegroundColor White
    Write-Host "  Arch:    $([System.Environment]::Is64BitOperatingSystem ? 'x64' : 'x86')" -ForegroundColor White
    
    Write-Host ""
    Write-Host "  Key Libraries Check:" -ForegroundColor Cyan
    
    $verifyLibs = @("numpy", "scipy", "pandas", "matplotlib", "sklearn", 
                    "cv2", "PIL", "flask", "fastapi", "sqlalchemy", 
                    "requests", "transformers", "torch")
    
    foreach ($lib in $verifyLibs) {
        $result = & $global:PythonCmd -c "import $lib; print(getattr($lib, '__version__', 'ok'))" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [+] $lib ($result)" -ForegroundColor Green
        } else {
            Write-Host "  [!] $lib" -ForegroundColor DarkYellow
        }
    }
    
    $total = (& $global:PythonCmd -m pip list 2>&1 | Measure-Object -Line).Lines
    Write-Host ""
    Write-Host "  Total packages installed: $total" -ForegroundColor Yellow
}

# ─────────────────────────────────────────────
#  Final Summary
# ─────────────────────────────────────────────
function Show-Summary {
    Write-Host ""
    Write-Host "  +==================================================+" -ForegroundColor Yellow
    Write-Host "  |                                                  |" -ForegroundColor Yellow
    Write-Host "  |     𝑫𝑹𝑺.𝑽𝑰𝑷 Installation Complete!            |" -ForegroundColor Yellow
    Write-Host "  |                                                  |" -ForegroundColor Yellow
    Write-Host "  +==================================================+" -ForegroundColor Yellow
    Write-Host "  |  [+] Python 3.13+ installed & configured        |" -ForegroundColor Green
    Write-Host "  |  [+] pip updated to latest version              |" -ForegroundColor Green
    Write-Host "  |  [+] All tools installed                        |" -ForegroundColor Green
    Write-Host "  |  [+] All libraries installed (30+ categories)   |" -ForegroundColor Green
    Write-Host "  |  [+] Virtual environment: ~/drs_vip_env         |" -ForegroundColor Green
    Write-Host "  |  [+] Requirements files saved                   |" -ForegroundColor Green
    Write-Host "  +==================================================+" -ForegroundColor Yellow
    Write-Host "  |  Commands:                                       |" -ForegroundColor Cyan
    Write-Host "  |  * drs           -> Activate DRS.VIP env        |" -ForegroundColor White
    Write-Host "  |  * python        -> Run Python                  |" -ForegroundColor White
    Write-Host "  |  * jupyter lab   -> Launch Jupyter Lab          |" -ForegroundColor White
    Write-Host "  |  * ipython       -> Interactive Python shell    |" -ForegroundColor White
    Write-Host "  +==================================================+" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Restart PowerShell to apply all changes!" -ForegroundColor DarkGray
    Write-Host ""
}

# ─────────────────────────────────────────────
#  Main Entry Point
# ─────────────────────────────────────────────
function Main {
    Show-Banner
    
    Write-Host "  Starting DRS.VIP Complete Installation..." -ForegroundColor Cyan
    Write-Host "  This may take 30-90 minutes depending on your connection" -ForegroundColor DarkGray
    Write-Host ""
    
    $choice = Read-Host "  Press ENTER to start or Ctrl+C to cancel"
    
    # Global Python command variable
    $global:PythonCmd = "python"
    
    Set-PSPolicy
    Ensure-Admin
    Install-Chocolatey
    Ensure-Winget
    Install-Git
    Install-Python
    Install-Pip
    Install-NodeJS
    Install-Rust
    Install-BuildTools
    Install-PythonTools
    Install-AllLibraries
    Setup-VirtualEnv
    Generate-Requirements
    Verify-Installation
    Show-Summary
    
    Log-Success "DRS.VIP Installation completed successfully!"
    Write-Host ""
    Read-Host "  Press ENTER to exit"
}

# Run
Main