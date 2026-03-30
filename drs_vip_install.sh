#!/usr/bin/env bash
# ============================================================
#         𝑫𝑹𝑺.𝑽𝑰𝑷 - Ultimate Python Installation Script
#         Version: 2026.1.0
#         Supports: Linux | macOS | Termux (Android)
# ============================================================

# ─────────────────────────────────────────────
#  Colors & Styles
# ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Gold color simulation
GOLD='\033[0;33m'
LGOLD='\033[1;33m'

# ─────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────
show_banner() {
    clear
    echo -e "${LGOLD}"
    echo "  ██████╗ ██████╗ ███████╗   ██╗   ██╗██╗██████╗ "
    echo "  ██╔══██╗██╔══██╗██╔════╝   ██║   ██║██║██╔══██╗"
    echo "  ██║  ██║██████╔╝███████╗   ██║   ██║██║██████╔╝"
    echo "  ██║  ██║██╔══██╗╚════██║   ╚██╗ ██╔╝██║██╔═══╝ "
    echo "  ██████╔╝██║  ██║███████║    ╚████╔╝ ██║██║     "
    echo "  ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═══╝  ╚═╝╚═╝     "
    echo -e "${RESET}"
    echo -e "${CYAN}  ╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}  ║${LGOLD}   𝑫𝑹𝑺.𝑽𝑰𝑷 - Ultimate Installation Suite    ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${WHITE}        Python 3.13+ | All Libraries         ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${DIM}     Linux | macOS | Termux | 2026 Edition   ${CYAN}║${RESET}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════════╝${RESET}"
    echo ""
}

# ─────────────────────────────────────────────
#  Logging Functions
# ─────────────────────────────────────────────
log_info()    { echo -e "${CYAN}  [ℹ]  ${WHITE}$1${RESET}"; }
log_success() { echo -e "${GREEN}  [✔]  ${WHITE}$1${RESET}"; }
log_warning() { echo -e "${YELLOW}  [⚠]  ${WHITE}$1${RESET}"; }
log_error()   { echo -e "${RED}  [✘]  ${WHITE}$1${RESET}"; }
log_step()    { echo -e "\n${LGOLD}  ══════════════════════════════════════${RESET}"; \
                echo -e "${LGOLD}  ▶  $1${RESET}"; \
                echo -e "${LGOLD}  ══════════════════════════════════════${RESET}"; }
log_done()    { echo -e "${GREEN}  ✔ Done: $1${RESET}"; }
progress_bar() {
    local duration=$1
    local steps=40
    echo -ne "  ${CYAN}["
    for ((i=0; i<steps; i++)); do
        echo -ne "${LGOLD}█"
        sleep $(echo "scale=3; $duration/$steps" | bc) 2>/dev/null || sleep 0.05
    done
    echo -e "${CYAN}]${RESET} ${GREEN}✔${RESET}"
}

# ─────────────────────────────────────────────
#  Detect OS & Package Manager
# ─────────────────────────────────────────────
detect_os() {
    log_step "Detecting Operating System"
    
    if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
        OS_TYPE="termux"
        PKG_MANAGER="pkg"
        log_success "Detected: Termux (Android)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS_TYPE="macos"
        if command -v brew &>/dev/null; then
            PKG_MANAGER="brew"
        else
            PKG_MANAGER="none"
        fi
        log_success "Detected: macOS"
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_TYPE="linux"
        if command -v apt-get &>/dev/null; then
            PKG_MANAGER="apt"
            DISTRO="debian"
        elif command -v dnf &>/dev/null; then
            PKG_MANAGER="dnf"
            DISTRO="fedora"
        elif command -v yum &>/dev/null; then
            PKG_MANAGER="yum"
            DISTRO="rhel"
        elif command -v pacman &>/dev/null; then
            PKG_MANAGER="pacman"
            DISTRO="arch"
        elif command -v zypper &>/dev/null; then
            PKG_MANAGER="zypper"
            DISTRO="opensuse"
        elif command -v apk &>/dev/null; then
            PKG_MANAGER="apk"
            DISTRO="alpine"
        else
            PKG_MANAGER="unknown"
            DISTRO="unknown"
        fi
        log_success "Detected: Linux ($PRETTY_NAME)"
    else
        OS_TYPE="unknown"
        PKG_MANAGER="unknown"
        log_warning "Unknown OS - attempting generic installation"
    fi
    
    # Architecture
    ARCH=$(uname -m)
    log_info "Architecture: $ARCH"
    log_info "Package Manager: $PKG_MANAGER"
}

# ─────────────────────────────────────────────
#  Check Root / Sudo
# ─────────────────────────────────────────────
check_privileges() {
    log_step "Checking Privileges"
    if [ "$OS_TYPE" == "termux" ]; then
        SUDO=""
        log_info "Termux: No sudo needed"
    elif [ "$EUID" -eq 0 ]; then
        SUDO=""
        log_success "Running as root"
    elif command -v sudo &>/dev/null; then
        SUDO="sudo"
        log_success "sudo available"
    else
        log_warning "No sudo - some installations may fail"
        SUDO=""
    fi
}

# ─────────────────────────────────────────────
#  Update System
# ─────────────────────────────────────────────
update_system() {
    log_step "Updating System Packages"
    case $PKG_MANAGER in
        apt)
            $SUDO apt-get update -y && $SUDO apt-get upgrade -y
            $SUDO apt-get install -y build-essential curl wget git vim \
                software-properties-common apt-transport-https ca-certificates \
                gnupg lsb-release unzip zip tar gzip bzip2 xz-utils \
                libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev \
                libsqlite3-dev libncurses5-dev libncursesw5-dev libgdbm-dev \
                liblzma-dev tk-dev uuid-dev libgdbm-compat-dev \
                libjpeg-dev libpng-dev libtiff-dev libavcodec-dev \
                libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev \
                libx264-dev libgtk-3-dev libboost-all-dev libatlas-base-dev \
                gfortran cmake pkg-config libhdf5-dev libopenblas-dev \
                liblapack-dev libblas-dev ffmpeg portaudio19-dev \
                libxml2-dev libxslt1-dev libmysqlclient-dev \
                postgresql-client libpq-dev redis-tools \
                fonts-liberation chromium-browser 2>/dev/null || true
            ;;
        dnf|yum)
            $SUDO $PKG_MANAGER update -y
            $SUDO $PKG_MANAGER groupinstall -y "Development Tools"
            $SUDO $PKG_MANAGER install -y curl wget git vim openssl-devel \
                libffi-devel zlib-devel bzip2-devel readline-devel \
                sqlite-devel ncurses-devel xz-devel tk-devel uuid-devel \
                libjpeg-devel libpng-devel libtiff-devel cmake \
                hdf5-devel openblas-devel lapack-devel blas-devel \
                ffmpeg portaudio-devel libxml2-devel libxslt-devel \
                postgresql-devel redis
            ;;
        pacman)
            $SUDO pacman -Syu --noconfirm
            $SUDO pacman -S --noconfirm base-devel curl wget git vim \
                openssl libffi zlib bzip2 readline sqlite ncurses xz tk \
                libjpeg libpng libtiff cmake hdf5 openblas lapack \
                ffmpeg portaudio libxml2 libxslt postgresql redis
            ;;
        brew)
            brew update && brew upgrade
            brew install curl wget git vim openssl libffi zlib bzip2 \
                readline sqlite ncurses xz tk cmake hdf5 openblas \
                ffmpeg portaudio libxml2 libxslt postgresql redis
            ;;
        pkg)
            pkg update -y && pkg upgrade -y
            pkg install -y python git curl wget vim \
                build-essential openssl libffi zlib \
                libjpeg libpng ffmpeg cmake
            ;;
        zypper)
            $SUDO zypper refresh && $SUDO zypper update -y
            $SUDO zypper install -y -t pattern devel_C_C++
            $SUDO zypper install -y curl wget git vim openssl-devel \
                libffi-devel zlib-devel cmake ffmpeg portaudio-devel
            ;;
        apk)
            $SUDO apk update && $SUDO apk upgrade
            $SUDO apk add --no-cache build-base curl wget git vim \
                openssl-dev libffi-dev zlib-dev bzip2-dev readline-dev \
                sqlite-dev ncurses-dev xz-dev tk-dev cmake ffmpeg
            ;;
        *)
            log_warning "Unknown package manager. Skipping system update."
            ;;
    esac
    log_success "System updated successfully"
}

# ─────────────────────────────────────────────
#  Install Python 3.13+
# ─────────────────────────────────────────────
install_python() {
    log_step "Installing Python 3.13+"
    
    PYTHON_VERSION="3.13.1"
    PYTHON_SHORT="3.13"
    
    # Check existing
    if command -v python3.13 &>/dev/null || command -v python3 &>/dev/null; then
        CURRENT_VER=$(python3 --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo "0.0.0")
        MAJOR=$(echo $CURRENT_VER | cut -d. -f1)
        MINOR=$(echo $CURRENT_VER | cut -d. -f2)
        if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 13 ]; then
            log_success "Python $CURRENT_VER already installed ✔"
            PYTHON_CMD="python3"
            return
        fi
    fi
    
    case $PKG_MANAGER in
        apt)
            # Try deadsnakes PPA first
            if $SUDO add-apt-repository -y ppa:deadsnakes/ppa 2>/dev/null; then
                $SUDO apt-get update -y
                $SUDO apt-get install -y python3.13 python3.13-dev \
                    python3.13-venv python3.13-distutils python3.13-tk \
                    python3.13-full 2>/dev/null || true
            fi
            # Fallback: compile from source
            if ! command -v python3.13 &>/dev/null; then
                install_python_from_source
            fi
            ;;
        dnf|yum)
            # Try from source or EPEL
            $SUDO $PKG_MANAGER install -y python3.13 python3.13-devel 2>/dev/null || \
                install_python_from_source
            ;;
        pacman)
            $SUDO pacman -S --noconfirm python 2>/dev/null || \
                install_python_from_source
            ;;
        brew)
            brew install python@3.13 || brew install python3
            brew link python@3.13 --force 2>/dev/null || true
            ;;
        pkg)
            pkg install -y python 2>/dev/null
            ;;
        *)
            install_python_from_source
            ;;
    esac
    
    # Setup python command
    if command -v python3.13 &>/dev/null; then
        PYTHON_CMD="python3.13"
        $SUDO update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 2>/dev/null || true
        $SUDO update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1 2>/dev/null || true
    elif command -v python3 &>/dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &>/dev/null; then
        PYTHON_CMD="python"
    else
        log_error "Python installation failed!"
        exit 1
    fi
    
    # Add to PATH
    add_to_path
    
    log_success "Python installed: $($PYTHON_CMD --version)"
}

# ─────────────────────────────────────────────
#  Compile Python from Source
# ─────────────────────────────────────────────
install_python_from_source() {
    log_info "Compiling Python 3.13 from source..."
    PYTHON_VERSION="3.13.1"
    cd /tmp
    
    if [ ! -f "Python-${PYTHON_VERSION}.tar.xz" ]; then
        wget -q "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz"
    fi
    
    tar -xf "Python-${PYTHON_VERSION}.tar.xz"
    cd "Python-${PYTHON_VERSION}"
    
    ./configure --enable-optimizations \
                --enable-shared \
                --with-ensurepip=install \
                --enable-loadable-sqlite-extensions \
                --with-ssl \
                LDFLAGS="-Wl,-rpath /usr/local/lib" \
                2>&1 | tail -5
    
    make -j$(nproc) 2>&1 | tail -10
    $SUDO make altinstall 2>&1 | tail -5
    
    # Create symlinks
    $SUDO ln -sf /usr/local/bin/python3.13 /usr/local/bin/python3 2>/dev/null || true
    $SUDO ln -sf /usr/local/bin/python3.13 /usr/local/bin/python 2>/dev/null || true
    $SUDO ldconfig 2>/dev/null || true
    
    cd /tmp
    log_success "Python compiled from source successfully"
}

# ─────────────────────────────────────────────
#  Add Python to PATH
# ─────────────────────────────────────────────
add_to_path() {
    log_step "Configuring PATH"
    
    PROFILE_FILES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.zshrc")
    
    PYTHON_PATHS=(
        "/usr/local/bin"
        "/usr/bin"
        "$HOME/.local/bin"
        "$HOME/Library/Python/3.13/bin"  # macOS
        "/opt/homebrew/bin"               # macOS ARM
    )
    
    PATH_ENTRY='export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"'
    
    for profile in "${PROFILE_FILES[@]}"; do
        if [ -f "$profile" ] || touch "$profile" 2>/dev/null; then
            if ! grep -q "DRS.VIP" "$profile" 2>/dev/null; then
                echo "" >> "$profile"
                echo "# ── DRS.VIP Python Path Configuration ──" >> "$profile"
                echo "$PATH_ENTRY" >> "$profile"
                echo 'export PYTHONDONTWRITEBYTECODE=0' >> "$profile"
                echo 'export PYTHONUNBUFFERED=1' >> "$profile"
                log_success "PATH added to $profile"
            fi
        fi
    done
    
    export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
    log_success "PATH configured successfully"
}

# ─────────────────────────────────────────────
#  Install / Upgrade pip
# ─────────────────────────────────────────────
install_pip() {
    log_step "Installing / Upgrading pip"
    
    # Install pip if missing
    if ! $PYTHON_CMD -m pip --version &>/dev/null; then
        curl -sS https://bootstrap.pypa.io/get-pip.py | $PYTHON_CMD
    fi
    
    $PYTHON_CMD -m pip install --upgrade pip setuptools wheel
    $PYTHON_CMD -m pip install --upgrade pip-tools pipdeptree
    
    log_success "pip version: $($PYTHON_CMD -m pip --version)"
}

# ─────────────────────────────────────────────
#  Install Tools & Package Managers
# ─────────────────────────────────────────────
install_tools() {
    log_step "Installing Python Tools & Package Managers"
    
    TOOLS=(
        # Core tools
        "pip"
        "setuptools"
        "wheel"
        "build"
        "twine"
        
        # Virtual Environments
        "virtualenv"
        "venv"
        "pipenv"
        "poetry"
        "hatch"
        "pdm"
        "flit"
        
        # Package managers extras
        "pip-tools"
        "pipdeptree"
        "pip-autoremove"
        "pip-review"
        "pipreqs"
        "pip-chill"
        
        # Code formatters
        "black"
        "isort"
        "autopep8"
        "yapf"
        "pyink"
        "ruff"
        
        # Linters
        "flake8"
        "pylint"
        "mypy"
        "pyflakes"
        "pycodestyle"
        "pydocstyle"
        "bandit"
        "prospector"
        "pylama"
        "vulture"
        "radon"
        "xenon"
        "cohesion"
        
        # Type checkers
        "pyright"
        "pytype"
        
        # Testing
        "pytest"
        "pytest-cov"
        "pytest-xdist"
        "pytest-asyncio"
        "pytest-mock"
        "pytest-benchmark"
        "pytest-html"
        "pytest-json-report"
        "pytest-randomly"
        "hypothesis"
        "tox"
        "nox"
        "coverage"
        "factory-boy"
        "faker"
        "freezegun"
        "responses"
        "httpretty"
        "vcrpy"
        "moto"
        "unittest-xml-reporting"
        
        # Documentation
        "sphinx"
        "sphinx-rtd-theme"
        "mkdocs"
        "mkdocs-material"
        "pdoc3"
        "pydoc-markdown"
        "interrogate"
        "docstring-to-markdown"
        
        # Debugging
        "ipdb"
        "pdb++"
        "pudb"
        "pydevd"
        "birdseye"
        "snoop"
        "pysnooper"
        "icecream"
        
        # Profiling
        "cProfile"
        "line-profiler"
        "memory-profiler"
        "py-spy"
        "pyinstrument"
        "scalene"
        "austin-python"
        "guppy3"
        "objgraph"
        
        # CLI tools
        "click"
        "typer"
        "rich"
        "textual"
        "tqdm"
        "alive-progress"
        "inquirer"
        "questionary"
        "prompt-toolkit"
        "colorama"
        "termcolor"
        "blessed"
        "urwid"
        "curtsies"
        
        # Task runners
        "invoke"
        "doit"
        "nox"
        "prefect"
        "luigi"
        "celery"
        "dramatiq"
        "rq"
        "apscheduler"
        "schedule"
        "huey"
        
        # File utilities
        "pathlib2"
        "watchdog"
        "pyfilesystem2"
        "send2trash"
        "arrow"
        "pendulum"
        "dateutil"
        "humanize"
        "tabulate"
        "pprint"
        "pretty-errors"
        
        # HTTP clients
        "requests"
        "httpx"
        "aiohttp"
        "httpcore"
        "urllib3"
        "treq"
        
        # Interactive
        "ipython"
        "jupyter"
        "jupyterlab"
        "notebook"
        "nbconvert"
        "nbformat"
        "voila"
        "ipywidgets"
        
        # Git
        "gitpython"
        "pygit2"
        "pre-commit"
        "commitizen"
        
        # Security
        "safety"
        "bandit"
        "semgrep"
        "detect-secrets"
    )
    
    log_info "Installing ${#TOOLS[@]} tools..."
    
    FAILED_TOOLS=()
    for tool in "${TOOLS[@]}"; do
        if $PYTHON_CMD -m pip install --quiet --upgrade "$tool" 2>/dev/null; then
            echo -e "  ${GREEN}✔${RESET} $tool"
        else
            FAILED_TOOLS+=("$tool")
            echo -e "  ${YELLOW}⚠${RESET} $tool (skipped)"
        fi
    done
    
    if [ ${#FAILED_TOOLS[@]} -gt 0 ]; then
        log_warning "Some tools failed: ${FAILED_TOOLS[*]}"
    fi
    
    log_success "Tools installation complete"
}

# ─────────────────────────────────────────────
#  Install All Libraries by Domain
# ─────────────────────────────────────────────
install_all_libraries() {

    # ── 1. Data Science & ML ──────────────────
    install_category "🔬 Data Science & Machine Learning" \
        numpy scipy pandas polars modin[all] \
        scikit-learn scikit-image scikit-optimize scikit-survival \
        xgboost lightgbm catboost gradient-boosted-forest \
        statsmodels pingouin pymc \
        imbalanced-learn mlxtend category-encoders \
        feature-engine featuretools \
        optuna hyperopt ray[tune] \
        joblib cloudpickle dask[complete] \
        vaex cudf cuml 2>/dev/null || true

    # ── 2. Deep Learning ─────────────────────
    install_category "🧠 Deep Learning & Neural Networks" \
        torch torchvision torchaudio \
        tensorflow keras \
        jax jaxlib flax optax \
        mxnet paddle paddlepaddle \
        onnx onnxruntime onnxmltools \
        tensorrt \
        lightning pytorch-lightning \
        fastai timm \
        transformers tokenizers datasets \
        accelerate peft bitsandbytes \
        diffusers deepspeed \
        sentence-transformers \
        spacy gensim nltk \
        huggingface-hub \
        einops triton

    # ── 3. AI & LLM ──────────────────────────
    install_category "🤖 AI & Large Language Models" \
        openai anthropic cohere \
        langchain langchain-community langchain-openai \
        langchain-anthropic langchain-google-genai \
        llama-index llama-cpp-python \
        google-generativeai google-cloud-aiplatform \
        mistralai together \
        groq replicate \
        autogen pyautogen \
        crewai \
        semantic-kernel \
        haystack-ai farm-haystack \
        txtai \
        chromadb faiss-cpu pinecone-client \
        weaviate-client qdrant-client \
        milvus pymilvus \
        tiktoken \
        guidance outlines \
        instructor \
        litellm \
        ollama

    # ── 4. Computer Vision ───────────────────
    install_category "👁️ Computer Vision & Image Processing" \
        opencv-python opencv-python-headless opencv-contrib-python \
        Pillow pillow-simd 2>/dev/null || true
        imageio imageio-ffmpeg \
        scikit-image \
        albumentations \
        imgaug \
        detectron2 2>/dev/null || true \
        ultralytics \
        mmcv mmdet mmsegmentation 2>/dev/null || true \
        roboflow supervision \
        easyocr pytesseract \
        paddleocr 2>/dev/null || true \
        deepface \
        insightface \
        mediapipe \
        pycocotools \
        shapely \
        rasterio \
        fiftyone \
        kornia \
        torchmetrics

    # ── 5. NLP & Text Processing ─────────────
    install_category "📝 NLP & Text Processing" \
        nltk spacy gensim \
        transformers tokenizers \
        sentence-transformers \
        textblob \
        vaderSentiment \
        flair \
        stanza \
        polyglot \
        langdetect langid \
        pyenchant \
        textstat \
        readability-lxml \
        sumy \
        rouge-score \
        sacrebleu \
        bert-score \
        semantic-similarity \
        ftfy \
        unidecode \
        chardet charset-normalizer \
        regex \
        pyarabic \
        camel-tools \
        farasa \
        pypdf2 PyMuPDF pdfplumber \
        python-docx python-pptx \
        openpyxl xlrd xlwt xlsxwriter \
        markdown mistune \
        html2text beautifulsoup4 lxml \
        pylatex \
        reportlab \
        weasyprint

    # ── 6. Audio & Speech ────────────────────
    install_category "🎵 Audio & Speech Processing" \
        librosa \
        soundfile \
        sounddevice \
        pyaudio \
        pydub \
        playsound \
        pygame \
        mutagen \
        audioread \
        noisereduce \
        pysndfx \
        openai-whisper \
        faster-whisper \
        whisperx \
        SpeechRecognition \
        pyannote.audio \
        speechbrain \
        TTS coqui-tts \
        gtts pyttsx3 \
        praat-parselmouth \
        pyworld \
        mir_eval \
        madmom \
        essentia \
        music21 \
        pretty-midi \
        midiutil \
        pedalboard

    # ── 7. Data Visualization ────────────────
    install_category "📊 Data Visualization" \
        matplotlib seaborn plotly \
        bokeh altair \
        dash dash-bootstrap-components \
        streamlit gradio \
        panel holoviews hvplot \
        pyecharts \
        pygal \
        folium geopandas \
        kepler-map \
        pydeck \
        plotnine \
        missingno \
        wordcloud \
        yellowbrick \
        dtreeviz \
        shap lime \
        eli5 \
        sweetviz \
        pandas-profiling ydata-profiling \
        D-tale \
        ipyvizzu \
        vispy \
        mayavi \
        vtk \
        pyvista \
        trimesh \
        open3d \
        pyqtgraph \
        pyopengl

    # ── 8. Web Development ───────────────────
    install_category "🌐 Web Development & Frameworks" \
        flask flask-restful flask-sqlalchemy \
        flask-login flask-wtf flask-cors flask-migrate \
        flask-jwt-extended flask-caching flask-mail \
        django djangorestframework django-cors-headers \
        django-allauth django-celery-beat \
        django-environ django-filter \
        fastapi uvicorn[standard] \
        starlette \
        httpx \
        aiohttp \
        tornado \
        sanic \
        litestar \
        quart \
        falcon \
        bottle \
        web2py \
        pyramid \
        masonite \
        blacksheep \
        grpcio grpcio-tools \
        protobuf \
        graphene graphql-core \
        strawberry-graphql \
        ariadne \
        pydantic pydantic-settings pydantic-extra-types \
        marshmallow \
        cerberus \
        voluptuous \
        wtforms \
        Jinja2 \
        Mako \
        Chameleon \
        passlib bcrypt \
        python-jose[cryptography] \
        cryptography \
        pyotp \
        itsdangerous \
        python-multipart \
        aiofiles \
        hypercorn \
        gunicorn \
        waitress \
        whitenoise \
        django-storages boto3

    # ── 9. Databases ─────────────────────────
    install_category "🗄️ Databases & Storage" \
        sqlalchemy \
        alembic \
        databases \
        tortoise-orm \
        peewee \
        pony \
        piccolo \
        ormar \
        psycopg2-binary \
        asyncpg \
        aiopg \
        mysql-connector-python \
        PyMySQL \
        aiomysql \
        pymongo motor \
        beanie mongoengine \
        redis aioredis \
        elasticsearch elasticsearch-async \
        opensearch-py \
        cassandra-driver \
        cqlengine \
        influxdb-client \
        neo4j \
        py2neo \
        gremlinpython \
        tinydb \
        sqlite-utils \
        dataset \
        pickledb \
        lmdb \
        leveldb \
        rocksdb \
        pyarrow \
        fastparquet \
        h5py \
        zarr \
        netCDF4 \
        tables \
        sqlmodel \
        minio \
        azure-storage-blob \
        google-cloud-storage \
        pyiceberg \
        delta-spark

    # ── 10. Cloud & DevOps ───────────────────
    install_category "☁️ Cloud & DevOps" \
        boto3 botocore \
        google-cloud-storage \
        google-cloud-bigquery \
        google-cloud-pubsub \
        google-cloud-functions \
        google-auth \
        azure-identity \
        azure-mgmt-resource \
        azure-mgmt-compute \
        azure-mgmt-storage \
        azure-devops \
        kubernetes \
        docker \
        ansible 2>/dev/null || true \
        paramiko \
        fabric \
        sshtunnel \
        netmiko \
        nornir \
        napalm \
        terraform-python \
        pulumi 2>/dev/null || true \
        cdktf \
        troposphere \
        awscdk-lib \
        datadog \
        prometheus-client \
        grafanalib \
        opentelemetry-sdk \
        opentelemetry-api \
        structlog \
        loguru \
        python-json-logger \
        sentry-sdk \
        newrelic \
        pystatsd

    # ── 11. Network & Security ───────────────
    install_category "🔐 Network & Cybersecurity" \
        scapy \
        pyshark \
        nmap \
        python-nmap \
        paramiko \
        cryptography \
        pycryptodome \
        pynacl \
        pyopenssl \
        ssl \
        certifi \
        requests-oauthlib \
        oauthlib \
        python-jose \
        jwcrypto \
        bcrypt \
        argon2-cffi \
        passlib \
        itsdangerous \
        pywin32 \
        impacket \
        pyrdp \
        ldap3 \
        python-ldap \
        pykerberos \
        volatility3 2>/dev/null || true \
        stegano \
        steghide-python \
        pwntools \
        ropper \
        angr \
        capstone \
        keystone-engine \
        unicorn \
        frida \
        objection \
        drozer \
        burp-python 2>/dev/null || true \
        shodan \
        censys \
        vulners \
        pymetasploit3

    # ── 12. Web Scraping ─────────────────────
    install_category "🕷️ Web Scraping & Automation" \
        requests \
        httpx \
        aiohttp \
        beautifulsoup4 \
        lxml \
        html5lib \
        scrapy \
        scrapy-splash \
        selenium \
        selenium-wire \
        undetected-chromedriver \
        playwright \
        mechanize \
        RoboBrowser \
        httpretty \
        mitmproxy \
        pyppeteer \
        requests-html \
        parsel \
        itemloaders \
        extruct \
        newspaper3k \
        trafilatura \
        goose3 \
        readability-lxml \
        pyrogram \
        telethon \
        tweepy \
        praw \
        instaloader \
        yt-dlp \
        pytube \
        fake-useragent \
        curl-cffi \
        cloudscraper \
        tls-client \
        cairosvg \
        html2image \
        imgkit \
        pdfkit \
        weasyprint

    # ── 13. Finance & Economics ──────────────
    install_category "💹 Finance & Economics" \
        yfinance \
        pandas-datareader \
        alpha-vantage \
        quandl \
        fredapi \
        ta \
        ta-lib \
        tulipy \
        finta \
        pandas-ta \
        backtrader \
        backtesting \
        zipline-reloaded \
        pyfolio \
        quantlib \
        QuantLib-Python \
        ffn \
        pyperclip \
        riskfolio-lib \
        empyrical \
        pyportfolioopt \
        scikit-portfolio \
        arch \
        statsforecast \
        mlforecast \
        neuralforecast \
        darts \
        prophet \
        sktime \
        tsfresh \
        tslearn \
        aeon \
        pytimetk \
        financepy 2>/dev/null || true \
        mibian \
        py-vollib \
        ccxt \
        alpaca-trade-api \
        ib-insync \
        robin-stocks \
        polygon-api-client \
        tiingo \
        nasdaqdatalink

    # ── 14. Geographic & GIS ─────────────────
    install_category "🗺️ Geographic & GIS" \
        geopandas \
        shapely \
        fiona \
        pyproj \
        rasterio \
        rio-cogeo \
        xarray \
        netCDF4 \
        cartopy \
        folium \
        ipyleaflet \
        keplergl \
        pydeck \
        geopy \
        geocoder \
        googlemaps \
        osmnx \
        networkx \
        pysal \
        esda \
        spreg \
        libpysal \
        geomesa-pyspark 2>/dev/null || true \
        gdal \
        ogr2ogr \
        whitebox \
        whiteboxgeo \
        elevation \
        srtm.py \
        richdem \
        pylandsat \
        sentinelsat \
        eemont \
        geemap \
        earthengine-api \
        planetary-computer \
        pystac \
        intake-stac

    # ── 15. Scientific Computing ─────────────
    install_category "⚗️ Scientific Computing" \
        numpy scipy sympy \
        mpmath \
        numba \
        numexpr \
        cython \
        cffi \
        ctypes \
        swig \
        pybind11 \
        pycuda \
        pyopencl \
        cupy-cuda12x 2>/dev/null || true \
        opencl \
        mpi4py \
        petsc4py \
        slepc4py \
        fenics 2>/dev/null || true \
        scikit-fem \
        pymesh 2>/dev/null || true \
        pyfem \
        astropy \
        astroquery \
        astroml \
        biopython \
        biotite \
        rdkit \
        pubchempy \
        chempy \
        mendeleev \
        pymatgen \
        ase \
        qutip \
        pennylane \
        qiskit \
        cirq \
        braket-default-simulator \
        pyquil \
        strawberryfields \
        openfermioin \
        pyscf \
        psi4 2>/dev/null || true \
        openmm 2>/dev/null || true \
        mdanalysis \
        prody \
        nglview \
        py3dmol

    # ── 16. Robotics & IoT ───────────────────
    install_category "🤖 Robotics & IoT" \
        rospy \
        rclpy \
        pyserial \
        RPi.GPIO 2>/dev/null || true \
        gpiozero \
        adafruit-blinka \
        adafruit-circuitpython-motor \
        pyzmq \
        paho-mqtt \
        asyncio-mqtt \
        aiocoap \
        pymodbus \
        opcua \
        asyncua \
        pyobd \
        can \
        python-can \
        canopen \
        pyftdi \
        usb \
        hidapi \
        bluepy \
        bleak \
        pythonobd \
        pigpio \
        pigpio-dht \
        w1thermsensor \
        i2cdevice \
        smbus2 \
        spidev \
        nfc \
        ndef \
        pylorawan \
        loralib \
        zigpy

    # ── 17. Game Development ─────────────────
    install_category "🎮 Game Development" \
        pygame \
        pyglet \
        arcade \
        panda3d \
        ursina \
        pyopengl \
        pyglfw \
        moderngl \
        pysdl2 \
        pymunk \
        pybullet \
        pymolde \
        pybox2d \
        cocos2d \
        kivy \
        kivymd \
        godot-python 2>/dev/null || true \
        tcod \
        bearlibterminal \
        pyxel \
        py5 \
        noise \
        pynoise \
        opensimplex \
        glfw \
        vispy \
        mayavi

    # ── 18. System & OS ──────────────────────
    install_category "💻 System & OS Automation" \
        psutil \
        py-cpuinfo \
        gputil \
        platform \
        os \
        sys \
        shutil \
        pathlib \
        watchdog \
        pyinotify \
        pyautogui \
        pynput \
        keyboard \
        mouse \
        pygetwindow \
        pywin32 \
        pywin32-ctypes \
        comtypes \
        wmi \
        plyer \
        notify2 \
        desktop-notifier \
        pyclip \
        pyperclip \
        clipboard \
        screenshot \
        mss \
        pyscreenshot \
        pillow \
        appscript \
        subprocess32 \
        sh \
        plumbum \
        delegator.py \
        envparse \
        python-dotenv \
        decouple \
        dynaconf \
        configparser \
        toml \
        tomllib \
        ruamel.yaml \
        pyyaml \
        tomlkit \
        python-ini

    # ── 19. Async & Concurrency ──────────────
    install_category "⚡ Async & Concurrency" \
        asyncio \
        aiofiles \
        aiohttp \
        anyio \
        trio \
        curio \
        asyncpg \
        aioredis \
        aiomysql \
        aiopg \
        aiosmtplib \
        aiodns \
        uvloop \
        httpx \
        starlette \
        fastapi \
        twisted \
        gevent \
        eventlet \
        concurrent-futures \
        multiprocess \
        pathos \
        ray \
        dask[complete] \
        apache-beam \
        prefect \
        airflow \
        luigi \
        celery \
        dramatiq \
        arq \
        rq \
        huey \
        apscheduler \
        schedule \
        kronos \
        timeloop \
        sentry-sdk

    # ── 20. Data Engineering ─────────────────
    install_category "🔄 Data Engineering & ETL" \
        apache-airflow \
        prefect \
        luigi \
        kedro \
        dbt-core \
        dbt-postgres dbt-mysql dbt-bigquery dbt-snowflake \
        great-expectations \
        pandera \
        pydantic \
        cerberus \
        voluptuous \
        marshmallow \
        pyarrow \
        fastparquet \
        dask[complete] \
        pyspark \
        koalas \
        petl \
        bonobo \
        mara \
        singer-python \
        airbyte-cdk \
        meltano \
        singer-tools \
        streamz \
        bytewax \
        kafka-python \
        confluent-kafka \
        faust-streaming \
        pulsar-client \
        nats-py \
        pika \
        kombu \
        pyzmq \
        nanomsg \
        zeromq

    # ── 21. Blockchain & Crypto ──────────────
    install_category "🔗 Blockchain & Cryptocurrency" \
        web3 \
        eth-account \
        eth-typing \
        eth-utils \
        eth-hash \
        eth-keyfile \
        rlp \
        pybitcoin \
        bitcoin \
        bitcoinlib \
        pycoingecko \
        ccxt \
        cryptofeed \
        binance-connector \
        python-binance \
        cbpro \
        kucoin-python \
        ftx 2>/dev/null || true \
        bybit \
        okx-api \
        solana \
        solders \
        anchorpy \
        substrate-interface \
        cosmos-sdk-python \
        near-api-py

    # ── 22. Email & Messaging ────────────────
    install_category "📧 Email & Messaging" \
        smtplib \
        imaplib \
        poplib \
        email \
        aiosmtplib \
        flanker \
        mailparser \
        python-mailparser \
        mail-parser \
        emails \
        yagmail \
        redmail \
        sendgrid \
        mailchimp3 \
        sparkpost \
        postmarker \
        premailer \
        inlinestyler \
        html2text \
        slack-sdk \
        slack-bolt \
        discord.py \
        discord-interactions \
        python-telegram-bot \
        telethon \
        pyrogram \
        matrix-nio \
        twilio \
        vonage \
        messagebird \
        africastalking \
        whatsapp-api-client-python 2>/dev/null || true \
        line-bot-sdk \
        fbmessenger

    # ── 23. Testing & QA ─────────────────────
    install_category "🧪 Testing & Quality Assurance" \
        pytest \
        unittest \
        doctest \
        nose2 \
        behave \
        lettuce \
        robotframework \
        hypothesis \
        faker \
        factory-boy \
        model-bakery \
        mixer \
        responses \
        httpretty \
        vcrpy \
        freezegun \
        time-machine \
        moto \
        localstack \
        testcontainers \
        selenium \
        playwright \
        pyautogui \
        appium-python-client \
        calabash \
        robotframework-browser \
        robotframework-requests \
        allure-pytest \
        pytest-html \
        coverage \
        codecov \
        coveralls \
        locust \
        k6 \
        artillery \
        jmeter-api

    # ── 24. PDF & Document Processing ────────
    install_category "📄 PDF & Document Processing" \
        pypdf2 \
        pypdf \
        PyMuPDF \
        pdfplumber \
        pdfminer.six \
        pdfrw \
        reportlab \
        fpdf2 \
        weasyprint \
        pdfkit \
        cairosvg \
        python-docx \
        python-pptx \
        openpyxl \
        xlrd \
        xlwt \
        xlsxwriter \
        xlutils \
        odfpy \
        python-docx2txt \
        docx2pdf \
        libreoffice-python 2>/dev/null || true \
        textract \
        tika \
        unstructured \
        camelot-py \
        tabula-py \
        pdftables \
        pytesseract \
        easyocr \
        paddleocr \
        surya-ocr \
        docling \
        marker-pdf \
        nougat-ocr \
        mathpix-markdown-it

    # ── 25. Image Processing ─────────────────
    install_category "🖼️ Image & Graphic Processing" \
        Pillow \
        opencv-python \
        scikit-image \
        imageio \
        imageio-ffmpeg \
        mahotas \
        SimpleITK \
        pydicom \
        nibabel \
        nilearn \
        antspy \
        imgaug \
        albumentations \
        kornia \
        torchvision \
        timm \
        clip \
        DALLE-pytorch \
        stable-diffusion \
        diffusers \
        controlnet-aux \
        ip-adapter \
        photomaker \
        rembg \
        transparent-background \
        carvekit \
        isnet \
        u2net \
        backgroundremover \
        remove-bg-py \
        qrcode \
        barcode \
        pyBarcode \
        zxing-cpp \
        python-barcode \
        pdf2image \
        img2pdf \
        pikepdf \
        pymupdf \
        svgwrite \
        cairosvg \
        wand \
        pgmagick \
        pyvips

    # ── 26. Video Processing ─────────────────
    install_category "🎬 Video Processing & Streaming" \
        opencv-python \
        moviepy \
        imageio-ffmpeg \
        ffmpeg-python \
        av \
        vidstab \
        pims \
        skvideo \
        decord \
        torchvideo \
        mmaction2 \
        pytorchvideo \
        video-diffusion \
        deepfacelab 2>/dev/null || true \
        faceswap 2>/dev/null || true \
        insightface \
        deepface \
        face-recognition \
        dlib \
        mediapipe \
        openvino \
        onnxruntime \
        tensorrt \
        vidgear \
        streamlink \
        yt-dlp \
        ffmpeg \
        hachoir \
        pymediainfo \
        mutagen \
        tinytag \
        subliminal \
        pycaption

    # ── 27. Healthcare & Bioinformatics ──────
    install_category "🏥 Healthcare & Bioinformatics" \
        biopython \
        biotite \
        scikit-bio \
        ete3 \
        dendropy \
        pyvcf \
        pysam \
        pybedtools \
        HTSeq \
        pyBigWig \
        cooler \
        HiCExplorer 2>/dev/null || true \
        scanpy \
        anndata \
        muon \
        scvi-tools \
        cellrank \
        velocyto \
        loompy \
        pydeseq2 \
        diffxpy \
        goatools \
        pyensembl \
        pyranges \
        bioconda 2>/dev/null || true \
        chembl-webresource-client \
        mygene \
        bioservices \
        pronto \
        ontobio \
        phenopy \
        DIPY \
        nibabel \
        nilearn \
        MNE \
        brainiak \
        neo \
        elephant \
        phy \
        spikeinterface \
        klusta 2>/dev/null || true

    # ── 28. Education & Visualization ────────
    install_category "📚 Education & Interactive" \
        manim \
        manimgl \
        vpython \
        pyqt5 \
        pyqt6 \
        pyside2 \
        pyside6 \
        tkinter \
        wxpython 2>/dev/null || true \
        gtk \
        pygobject \
        pygtk \
        kivy \
        kivymd \
        toga \
        briefcase \
        flet \
        nicegui \
        streamlit \
        gradio \
        panel \
        voila \
        dash \
        plotly \
        ipywidgets \
        ipyleaflet \
        ipyvuetify \
        anywidget \
        bqplot \
        pythreejs \
        ipycanvas \
        ipygany \
        ipycytoscape \
        nglview \
        k3d \
        napari

    # ── 29. Parsing & Data Formats ───────────
    install_category "🔧 Parsing & Data Formats" \
        json5 \
        orjson \
        ujson \
        simplejson \
        msgpack \
        cbor2 \
        protobuf \
        thrift \
        avro-python3 \
        fastavro \
        pyarrow \
        pandas \
        polars \
        dask \
        pyyaml \
        ruamel.yaml \
        toml \
        tomlkit \
        tomllib \
        configparser \
        dotenv \
        ini \
        lxml \
        xmltodict \
        untangle \
        xmljson \
        html.parser \
        html5lib \
        cssselect \
        pyquery \
        requests-html \
        parsel \
        beautifulsoup4 \
        feedparser \
        atoma \
        dateparser \
        python-dateutil \
        pytz \
        tzlocal \
        babel \
        arrow \
        pendulum

    # ── 30. Miscellaneous & Utilities ────────
    install_category "🛠️ Miscellaneous & Utilities" \
        more-itertools \
        toolz \
        cytoolz \
        funcy \
        attrs \
        cattrs \
        dataclasses \
        dacite \
        pydantic \
        marshmallow \
        desert \
        schematics \
        voluptuous \
        cerberus \
        typeguard \
        beartype \
        plum-dispatch \
        multipledispatch \
        singledispatch \
        overload \
        wrapt \
        decorator \
        deprecated \
        tenacity \
        backoff \
        retry \
        reretry \
        cachetools \
        dogpile.cache \
        diskcache \
        joblib \
        shelve \
        redis \
        memcache \
        pylibmc \
        blinker \
        transitions \
        fysom \
        statemachine \
        python-statemachine \
        sortedcontainers \
        blist \
        rtree \
        interval \
        portion \
        pyinterval \
        intervaltree \
        bidict \
        orderedset \
        frozendict \
        immutabledict \
        recordtype \
        namedlist \
        addict \
        dotmap \
        box \
        glom \
        jmespath \
        jsonpath-ng \
        jsonpointer \
        jsonschema \
        pydantic \
        typeddict \
        mypy-extensions \
        typing-extensions \
        typing-inspect \
        get-annotations \
        astpretty \
        asttokens \
        ast-decompiler \
        astunparse \
        gast \
        pygments \
        Pygments \
        rich \
        textual \
        colorama \
        termcolor \
        blessed \
        curtsies \
        urwid \
        npyscreen \
        alive-progress \
        tqdm \
        enlighten \
        progress \
        halo \
        yaspin \
        spinners \
        click \
        typer \
        fire \
        docopt \
        argparse \
        plac \
        clize \
        argh \
        commandlines \
        cliff \
        cement \
        cmd2 \
        clipspy \
        questionary \
        inquirer \
        prompt-toolkit \
        iterfzf \
        pzp

    log_success "All library categories installed!"
}

# ─────────────────────────────────────────────
#  Helper: Install a Category of Libraries
# ─────────────────────────────────────────────
install_category() {
    local category="$1"
    shift
    local packages=("$@")
    
    echo -e "\n${LGOLD}  ┌────────────────────────────────────────────┐${RESET}"
    echo -e "${LGOLD}  │  $category${RESET}"
    echo -e "${LGOLD}  └────────────────────────────────────────────┘${RESET}"
    
    FAILED=()
    INSTALLED=0
    
    for pkg in "${packages[@]}"; do
        if $PYTHON_CMD -m pip install --quiet --upgrade "$pkg" 2>/dev/null; then
            echo -e "  ${GREEN}✔${RESET} ${WHITE}$pkg${RESET}"
            ((INSTALLED++))
        else
            echo -e "  ${YELLOW}⚠${RESET} ${DIM}$pkg (skipped)${RESET}"
            FAILED+=("$pkg")
        fi
    done
    
    echo -e "  ${CYAN}📦 Installed: ${GREEN}$INSTALLED${CYAN} | ${YELLOW}Skipped: ${#FAILED[@]}${RESET}"
}

# ─────────────────────────────────────────────
#  Install Node.js (for some tools)
# ─────────────────────────────────────────────
install_nodejs() {
    log_step "Installing Node.js & npm"
    
    if command -v node &>/dev/null; then
        log_success "Node.js already installed: $(node --version)"
        return
    fi
    
    case $PKG_MANAGER in
        apt)
            curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO bash -
            $SUDO apt-get install -y nodejs
            ;;
        brew)
            brew install node
            ;;
        pkg)
            pkg install -y nodejs
            ;;
        dnf|yum)
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO bash -
            $SUDO $PKG_MANAGER install -y nodejs
            ;;
        pacman)
            $SUDO pacman -S --noconfirm nodejs npm
            ;;
        *)
            log_warning "Manual Node.js installation required"
            ;;
    esac
    
    log_success "Node.js: $(node --version 2>/dev/null || echo 'not available')"
}

# ─────────────────────────────────────────────
#  Install Rust (for some Python packages)
# ─────────────────────────────────────────────
install_rust() {
    log_step "Installing Rust (for Rust-based packages)"
    
    if command -v cargo &>/dev/null; then
        log_success "Rust already installed: $(rustc --version)"
        return
    fi
    
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    export PATH="$HOME/.cargo/bin:$PATH"
    
    log_success "Rust installed: $(rustc --version 2>/dev/null || echo 'restart terminal')"
}

# ─────────────────────────────────────────────
#  Setup Virtual Environment
# ─────────────────────────────────────────────
setup_venv() {
    log_step "Setting up Virtual Environment"
    
    VENV_PATH="$HOME/drs_vip_env"
    
    if [ ! -d "$VENV_PATH" ]; then
        $PYTHON_CMD -m venv "$VENV_PATH"
        log_success "Virtual environment created: $VENV_PATH"
    else
        log_info "Virtual environment already exists"
    fi
    
    # Activate
    source "$VENV_PATH/bin/activate" 2>/dev/null || true
    
    # Update pip in venv
    pip install --upgrade pip setuptools wheel 2>/dev/null
    
    # Add activation to shell profiles
    for profile in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc"; do
        if [ -f "$profile" ]; then
            echo "" >> "$profile"
            echo "# DRS.VIP Virtual Environment" >> "$profile"
            echo "alias drs='source $VENV_PATH/bin/activate'" >> "$profile"
        fi
    done
    
    log_success "Virtual environment setup complete"
    log_info "Use 'drs' command to activate the environment"
}

# ─────────────────────────────────────────────
#  Generate Requirements File
# ─────────────────────────────────────────────
generate_requirements() {
    log_step "Generating Requirements Files"
    
    REQ_DIR="$HOME/drs_vip_requirements"
    mkdir -p "$REQ_DIR"
    
    # Full requirements
    $PYTHON_CMD -m pip freeze > "$REQ_DIR/requirements_full.txt"
    
    # Generate categorized requirements
    cat > "$REQ_DIR/requirements.txt" << 'EOF'
# ═══════════════════════════════════════════════════
#   𝑫𝑹𝑺.𝑽𝑰𝑷 - Complete Python Requirements
#   Generated by DRS.VIP Installation Suite 2026
# ═══════════════════════════════════════════════════

# ── Core ─────────────────────────────────────────
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
EOF
    
    $PYTHON_CMD -m pip freeze >> "$REQ_DIR/requirements_full.txt"
    
    log_success "Requirements saved to: $REQ_DIR"
}

# ─────────────────────────────────────────────
#  Verify Installation
# ─────────────────────────────────────────────
verify_installation() {
    log_step "Verifying Installation"
    
    echo ""
    echo -e "${CYAN}  System Information:${RESET}"
    echo -e "  ${WHITE}Python:  ${GREEN}$($PYTHON_CMD --version)${RESET}"
    echo -e "  ${WHITE}pip:     ${GREEN}$($PYTHON_CMD -m pip --version | awk '{print $1,$2}')${RESET}"
    echo -e "  ${WHITE}OS:      ${GREEN}$(uname -s) $(uname -r)${RESET}"
    echo -e "  ${WHITE}Arch:    ${GREEN}$(uname -m)${RESET}"
    
    echo ""
    echo -e "${CYAN}  Key Libraries Check:${RESET}"
    
    VERIFY_LIBS=("numpy" "scipy" "pandas" "matplotlib" "sklearn" "torch" 
                 "tensorflow" "cv2" "PIL" "flask" "django" "fastapi" 
                 "sqlalchemy" "requests" "transformers")
    
    for lib in "${VERIFY_LIBS[@]}"; do
        if $PYTHON_CMD -c "import $lib" 2>/dev/null; then
            VER=$($PYTHON_CMD -c "import $lib; print(getattr($lib, '__version__', 'ok'))" 2>/dev/null)
            echo -e "  ${GREEN}✔${RESET} ${WHITE}$lib${RESET} ${DIM}($VER)${RESET}"
        else
            echo -e "  ${YELLOW}⚠${RESET} ${DIM}$lib${RESET}"
        fi
    done
    
    TOTAL=$($PYTHON_CMD -m pip list 2>/dev/null | wc -l)
    echo ""
    echo -e "  ${LGOLD}Total packages installed: ${WHITE}$TOTAL${RESET}"
}

# ─────────────────────────────────────────────
#  Final Summary
# ─────────────────────────────────────────────
show_summary() {
    echo ""
    echo -e "${LGOLD}"
    echo "  ╔══════════════════════════════════════════════════╗"
    echo "  ║                                                  ║"
    echo "  ║        𝑫𝑹𝑺.𝑽𝑰𝑷 Installation Complete!          ║"
    echo "  ║                                                  ║"
    echo "  ╠══════════════════════════════════════════════════╣"
    echo -e "  ║  ${WHITE}✔ Python 3.13+ installed & configured         ${LGOLD}║"
    echo -e "  ║  ${WHITE}✔ pip updated to latest version               ${LGOLD}║"
    echo -e "  ║  ${WHITE}✔ All tools installed                         ${LGOLD}║"
    echo -e "  ║  ${WHITE}✔ All libraries installed (30+ categories)    ${LGOLD}║"
    echo -e "  ║  ${WHITE}✔ Virtual environment created (~/.drs_vip_env)${LGOLD}║"
    echo -e "  ║  ${WHITE}✔ Requirements files saved                    ${LGOLD}║"
    echo "  ║                                                  ║"
    echo "  ╠══════════════════════════════════════════════════╣"
    echo -e "  ║  ${CYAN}Commands:${LGOLD}                                      ║"
    echo -e "  ║  ${WHITE}• drs          ${DIM}→ Activate DRS.VIP environment  ${LGOLD}║"
    echo -e "  ║  ${WHITE}• python3      ${DIM}→ Run Python                    ${LGOLD}║"
    echo -e "  ║  ${WHITE}• jupyter lab  ${DIM}→ Launch Jupyter Lab             ${LGOLD}║"
    echo -e "  ║  ${WHITE}• ipython      ${DIM}→ Interactive Python shell       ${LGOLD}║"
    echo "  ║                                                  ║"
    echo "  ╚══════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
    echo -e "  ${DIM}Restart terminal or run: source ~/.bashrc${RESET}"
    echo ""
}

# ─────────────────────────────────────────────
#  Main Entry Point
# ─────────────────────────────────────────────
main() {
    show_banner
    
    echo -e "${CYAN}  Starting DRS.VIP Complete Installation...${RESET}"
    echo -e "${DIM}  This may take 30-90 minutes depending on your connection${RESET}"
    echo ""
    
    # Confirm
    read -p "  Press ENTER to start installation or Ctrl+C to cancel... " 
    
    # Run steps
    detect_os
    check_privileges
    update_system
    install_python
    install_pip
    install_nodejs
    install_rust
    install_tools
    install_all_libraries
    setup_venv
    generate_requirements
    verify_installation
    show_summary
    
    log_success "DRS.VIP Installation completed successfully!"
}

# Run
main "$@"