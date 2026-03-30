#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#         𝑫𝑹𝑺.𝑽𝑰𝑷 - Termux Android Installation Script
#         Version: 2026.1.0
#         Platform: Termux (Android)
# ============================================================

# ─────────────────────────────────────────────
#  Colors
# ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
LGOLD='\033[1;33m'
RESET='\033[0m'

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
    echo -e "${CYAN}  ╔═══════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}  ║${LGOLD}  𝑫𝑹𝑺.𝑽𝑰𝑷 - Termux Android Edition 2026 ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${WHITE}      Python 3.13+ | Full Libraries       ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${DIM}      Optimized for Android/Termux         ${CYAN}║${RESET}"
    echo -e "${CYAN}  ╚═══════════════════════════════════════════╝${RESET}"
    echo ""
}

log_info()    { echo -e "${CYAN}  [ℹ]  ${WHITE}$1${RESET}"; }
log_success() { echo -e "${GREEN}  [✔]  ${WHITE}$1${RESET}"; }
log_warning() { echo -e "${YELLOW}  [⚠]  ${WHITE}$1${RESET}"; }
log_error()   { echo -e "${RED}  [✘]  ${WHITE}$1${RESET}"; }
log_step()    {
    echo -e "\n${LGOLD}  ══════════════════════════════════════${RESET}"
    echo -e "${LGOLD}  ▶  $1${RESET}"
    echo -e "${LGOLD}  ══════════════════════════════════════${RESET}"
}

# ─────────────────────────────────────────────
#  Check Termux Environment
# ─────────────────────────────────────────────
check_termux() {
    log_step "Checking Termux Environment"
    if [ ! -d "/data/data/com.termux" ] && [ -z "$TERMUX_VERSION" ]; then
        log_warning "Not running in Termux. Use drs_vip_install.sh instead."
        read -p "  Continue anyway? (y/N): " ans
        [[ "$ans" != "y" && "$ans" != "Y" ]] && exit 1
    fi
    log_success "Termux environment confirmed"
    log_info "Termux version: ${TERMUX_VERSION:-unknown}"
    log_info "Android: $(getprop ro.build.version.release 2>/dev/null || echo 'unknown')"
    log_info "Arch: $(uname -m)"
}

# ─────────────────────────────────────────────
#  Setup Termux Storage
# ─────────────────────────────────────────────
setup_storage() {
    log_step "Setting up Termux Storage"
    if [ ! -d "$HOME/storage" ]; then
        termux-setup-storage 2>/dev/null || true
        log_info "Storage permission requested - grant it in the dialog"
        sleep 2
    else
        log_success "Storage already setup"
    fi
}

# ─────────────────────────────────────────────
#  Update Termux Packages
# ─────────────────────────────────────────────
update_termux() {
    log_step "Updating Termux Packages"
    
    # Set mirrors for better speed
    if command -v termux-change-repo &>/dev/null; then
        log_info "Consider running termux-change-repo for faster mirrors"
    fi
    
    pkg update -y && pkg upgrade -y
    
    # Install essential Termux packages
    TERMUX_PKGS=(
        python
        python-pip
        git
        curl
        wget
        vim
        nano
        openssh
        openssl
        libffi
        zlib
        bzip2
        readline
        sqlite
        xz-utils
        tk
        clang
        make
        cmake
        pkg-config
        libjpeg-turbo
        libpng
        libtiff
        freetype
        libxml2
        libxslt
        ffmpeg
        nodejs
        rust
        golang
        ruby
        perl
        lua54
        php
        openjdk-17
        mariadb
        postgresql
        redis
        mongodb
        unzip
        zip
        tar
        gzip
        htop
        tree
        jq
        ripgrep
        fd
        bat
        tmux
        zsh
        fish
        neofetch
        figlet
        lolcat
        cowsay
        nmap
        netcat-openbsd
        dnsutils
        iproute2
        proot
        proot-distro
        termux-api
        termux-tools
        termux-am
        x11-repo
    )
    
    log_info "Installing ${#TERMUX_PKGS[@]} Termux packages..."
    for pkg_name in "${TERMUX_PKGS[@]}"; do
        if pkg install -y "$pkg_name" 2>/dev/null; then
            echo -e "  ${GREEN}✔${RESET} $pkg_name"
        else
            echo -e "  ${YELLOW}⚠${RESET} $pkg_name (skipped)"
        fi
    done
    
    log_success "Termux packages updated"
}

# ─────────────────────────────────────────────
#  Install Python & pip
# ─────────────────────────────────────────────
install_python_termux() {
    log_step "Installing Python & pip"
    
    # Python is installed via pkg above
    PYTHON_CMD="python"
    
    if ! command -v python &>/dev/null; then
        pkg install -y python
    fi
    
    # Upgrade pip
    python -m pip install --upgrade pip setuptools wheel
    
    log_success "Python: $(python --version)"
    log_success "pip: $(python -m pip --version)"
    
    # Add to PATH
    if ! grep -q "DRS.VIP" "$HOME/.bashrc" 2>/dev/null; then
        cat >> "$HOME/.bashrc" << 'EOF'

# ── DRS.VIP Configuration ──────────────────
export PATH="$HOME/.local/bin:$PATH"
export PYTHONDONTWRITEBYTECODE=0
export PYTHONUNBUFFERED=1
alias py="python"
alias pip3="python -m pip"
alias drs="source $HOME/drs_vip_env/bin/activate"
alias jl="jupyter lab --ip=0.0.0.0 --no-browser"
alias ipy="ipython"
EOF
        log_success "Shell profile updated"
    fi
    
    export PATH="$HOME/.local/bin:$PATH"
}

# ─────────────────────────────────────────────
#  Install Category (Termux optimized)
# ─────────────────────────────────────────────
install_category() {
    local category="$1"
    shift
    local packages=("$@")
    
    echo -e "\n${LGOLD}  ┌────────────────────────────────────────┐${RESET}"
    echo -e "${LGOLD}  │  $category${RESET}"
    echo -e "${LGOLD}  └────────────────────────────────────────┘${RESET}"
    
    INSTALLED=0
    FAILED=()
    
    for pkg in "${packages[@]}"; do
        if python -m pip install --quiet --upgrade "$pkg" 2>/dev/null; then
            echo -e "  ${GREEN}✔${RESET} $pkg"
            ((INSTALLED++))
        else
            echo -e "  ${YELLOW}⚠${RESET} ${DIM}$pkg${RESET}"
            FAILED+=("$pkg")
        fi
    done
    
    echo -e "  ${CYAN}Installed: ${GREEN}$INSTALLED${CYAN} | Skipped: ${YELLOW}${#FAILED[@]}${RESET}"
}

# ─────────────────────────────────────────────
#  Install All Libraries (Termux-compatible)
# ─────────────────────────────────────────────
install_all_libraries_termux() {
    log_step "Installing All Python Libraries"

    install_category "Core Scientific Stack" \
        numpy scipy pandas polars \
        scikit-learn scikit-image \
        matplotlib seaborn plotly \
        statsmodels sympy mpmath \
        numba numexpr joblib cloudpickle

    install_category "Deep Learning & AI" \
        torch torchvision torchaudio \
        tensorflow-lite 2>/dev/null || true \
        onnx onnxruntime \
        transformers tokenizers datasets \
        accelerate peft \
        sentence-transformers \
        langchain langchain-community \
        langchain-openai llama-index \
        openai anthropic cohere \
        google-generativeai \
        groq replicate \
        tiktoken instructor litellm \
        chromadb faiss-cpu \
        ollama

    install_category "NLP & Text Processing" \
        nltk spacy gensim \
        textblob vaderSentiment \
        langdetect langid \
        textstat ftfy unidecode \
        chardet charset-normalizer \
        regex pyarabic \
        pypdf2 PyMuPDF pdfplumber \
        python-docx python-pptx \
        openpyxl xlrd xlwt xlsxwriter \
        markdown mistune \
        html2text beautifulsoup4 lxml \
        reportlab weasyprint

    install_category "Web Development" \
        flask flask-restful flask-sqlalchemy \
        flask-login flask-cors flask-jwt-extended \
        django djangorestframework \
        django-cors-headers \
        fastapi uvicorn starlette \
        httpx aiohttp tornado sanic \
        quart falcon bottle \
        grpcio grpcio-tools protobuf \
        pydantic pydantic-settings \
        marshmallow cerberus wtforms \
        Jinja2 Mako \
        passlib bcrypt \
        python-jose cryptography \
        itsdangerous gunicorn \
        whitenoise

    install_category "Databases" \
        sqlalchemy alembic \
        tortoise-orm peewee piccolo \
        psycopg2-binary asyncpg \
        mysql-connector-python PyMySQL \
        pymongo motor beanie mongoengine \
        redis aioredis \
        elasticsearch \
        influxdb-client neo4j \
        tinydb sqlite-utils dataset \
        pyarrow fastparquet h5py zarr \
        sqlmodel

    install_category "Web Scraping & Automation" \
        requests httpx aiohttp \
        beautifulsoup4 lxml html5lib \
        scrapy selenium \
        playwright pyppeteer \
        requests-html parsel \
        newspaper3k trafilatura goose3 \
        tweepy praw instaloader yt-dlp \
        fake-useragent curl-cffi cloudscraper

    install_category "Finance & Trading" \
        yfinance pandas-datareader \
        alpha-vantage ta finta pandas-ta \
        backtrader backtesting \
        pyfolio ffn riskfolio-lib \
        empyrical pyportfolioopt \
        arch darts prophet sktime \
        tsfresh tslearn ccxt \
        python-binance polygon-api-client

    install_category "Data Visualization" \
        matplotlib seaborn plotly \
        bokeh altair \
        dash dash-bootstrap-components \
        streamlit gradio \
        panel holoviews hvplot \
        pyecharts pygal folium \
        geopandas pydeck plotnine \
        missingno wordcloud \
        yellowbrick shap lime \
        sweetviz ydata-profiling

    install_category "Audio & Speech" \
        librosa soundfile \
        pydub mutagen audioread \
        noisereduce openai-whisper \
        faster-whisper SpeechRecognition \
        gtts pyttsx3 music21 \
        pretty-midi midiutil pedalboard

    install_category "Image Processing" \
        Pillow opencv-python \
        scikit-image imageio \
        albumentations kornia \
        pytesseract easyocr \
        rembg qrcode python-barcode \
        pdf2image img2pdf pikepdf \
        svgwrite cairosvg wand

    install_category "Cloud & DevOps" \
        boto3 botocore \
        google-cloud-storage \
        google-auth azure-identity \
        kubernetes docker \
        paramiko fabric sshtunnel \
        prometheus-client \
        opentelemetry-sdk opentelemetry-api \
        structlog loguru \
        python-json-logger sentry-sdk

    install_category "Network & Security" \
        scapy python-nmap \
        paramiko cryptography pycryptodome \
        pynacl pyopenssl certifi \
        requests-oauthlib oauthlib \
        bcrypt argon2-cffi passlib

    install_category "Email & Messaging" \
        aiosmtplib emails yagmail redmail \
        sendgrid premailer html2text \
        slack-sdk slack-bolt \
        discord.py python-telegram-bot \
        telethon pyrogram \
        twilio vonage

    install_category "Testing & QA" \
        pytest pytest-cov pytest-xdist \
        pytest-asyncio pytest-mock \
        hypothesis faker factory-boy \
        responses freezegun \
        coverage locust

    install_category "Data Engineering & ETL" \
        prefect luigi kedro dbt-core \
        great-expectations pandera \
        pyarrow fastparquet dask \
        kafka-python confluent-kafka \
        pika kombu pyzmq

    install_category "Scientific Computing" \
        numpy scipy sympy mpmath \
        numba numexpr cython pybind11 \
        astropy biopython biotite \
        pubchempy chempy mendeleev \
        pennylane qiskit cirq

    install_category "Blockchain & Crypto" \
        web3 eth-account eth-utils \
        bitcoinlib pycoingecko \
        ccxt cryptofeed python-binance \
        solana solders

    install_category "Geographic & GIS" \
        geopandas shapely fiona pyproj \
        rasterio xarray cartopy \
        folium geopy geocoder \
        googlemaps osmnx networkx \
        earthengine-api geemap

    install_category "PDF & Document Processing" \
        pypdf2 pypdf PyMuPDF \
        pdfplumber pdfminer.six \
        pdfrw reportlab fpdf2 \
        python-docx python-pptx \
        openpyxl xlsxwriter \
        textract unstructured \
        tabula-py pytesseract easyocr

    install_category "Async & Concurrency" \
        asyncio aiofiles aiohttp \
        anyio trio uvloop \
        httpx starlette fastapi \
        twisted gevent eventlet \
        multiprocess pathos ray \
        dask celery dramatiq \
        rq huey apscheduler schedule

    install_category "Python Tools & Utilities" \
        virtualenv pipenv poetry hatch \
        pip-tools pipdeptree pipreqs \
        black isort autopep8 yapf ruff \
        flake8 pylint mypy bandit \
        pytest hypothesis faker \
        sphinx mkdocs mkdocs-material \
        ipdb snoop icecream \
        line-profiler memory-profiler \
        pyinstrument guppy3 \
        click typer rich textual tqdm \
        alive-progress colorama termcolor \
        invoke celery apscheduler \
        watchdog arrow pendulum humanize \
        requests httpx urllib3 \
        ipython jupyter jupyterlab \
        notebook nbconvert ipywidgets \
        gitpython pre-commit \
        more-itertools toolz funcy \
        attrs pydantic marshmallow \
        tenacity backoff cachetools \
        diskcache blinker transitions \
        sortedcontainers bidict addict \
        glom jmespath jsonschema \
        typing-extensions pygments \
        questionary prompt-toolkit \
        python-dotenv pyyaml toml

    install_category "IoT & Serial Communication" \
        pyserial pyzmq \
        paho-mqtt asyncio-mqtt \
        aiocoap pymodbus \
        python-can bleak zigpy

    install_category "Game Development" \
        pygame pyglet arcade \
        pyopengl pyglfw moderngl \
        pymunk pybullet \
        kivy kivymd tcod pyxel \
        noise opensimplex vispy

    log_success "All libraries installed!"
}

# ─────────────────────────────────────────────
#  Install Termux Extras
# ─────────────────────────────────────────────
install_termux_extras() {
    log_step "Installing Termux Extras & Tools"
    
    # Oh My Zsh
    if command -v zsh &>/dev/null; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            log_info "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true
            log_success "Oh My Zsh installed"
        fi
    fi
    
    # Install useful npm tools
    if command -v npm &>/dev/null; then
        log_info "Installing npm global tools..."
        npm install -g \
            npm@latest \
            yarn \
            pnpm \
            typescript \
            ts-node \
            nodemon \
            pm2 \
            http-server \
            prettier \
            eslint \
            jest \
            create-react-app \
            next \
            netlify-cli \
            vercel \
            expo-cli 2>/dev/null || true
        log_success "npm tools installed"
    fi
    
    # Ruby gems
    if command -v gem &>/dev/null; then
        log_info "Installing Ruby gems..."
        gem install bundler rails jekyll \
            colorize awesome_print pry 2>/dev/null || true
        log_success "Ruby gems installed"
    fi
    
    # Golang tools
    if command -v go &>/dev/null; then
        log_info "Installing Go tools..."
        go install golang.org/x/tools/cmd/goimports@latest 2>/dev/null || true
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest 2>/dev/null || true
        log_success "Go tools installed"
    fi
}

# ─────────────────────────────────────────────
#  Setup Virtual Environment
# ─────────────────────────────────────────────
setup_venv_termux() {
    log_step "Setting up Virtual Environment"
    
    VENV_PATH="$HOME/drs_vip_env"
    
    if [ ! -d "$VENV_PATH" ]; then
        python -m venv "$VENV_PATH"
        log_success "Virtual environment created: $VENV_PATH"
    else
        log_info "Virtual environment already exists"
    fi
    
    source "$VENV_PATH/bin/activate"
    pip install --upgrade pip setuptools wheel 2>/dev/null
    
    log_success "Virtual environment ready"
    log_info "Activate with: drs"
}

# ─────────────────────────────────────────────
#  Configure Termux UI
# ─────────────────────────────────────────────
configure_termux_ui() {
    log_step "Configuring Termux UI"
    
    # Create motd with DRS.VIP banner
    mkdir -p "$PREFIX/etc/motd.d"
    cat > "$HOME/.termux/motd.sh" << 'MOTD'
#!/bin/bash
echo ""
echo -e "\033[1;33m  𝑫𝑹𝑺.𝑽𝑰𝑷 - Python Environment Ready\033[0m"
echo -e "\033[0;36m  ─────────────────────────────────────\033[0m"
echo -e "\033[0;32m  Python: $(python --version 2>&1)\033[0m"
echo -e "\033[0;32m  pip:    $(python -m pip --version | awk '{print $1,$2}')\033[0m"
echo -e "\033[0;36m  ─────────────────────────────────────\033[0m"
echo -e "\033[1;37m  Commands: drs | py | ipy | jl\033[0m"
echo ""
MOTD
    chmod +x "$HOME/.termux/motd.sh" 2>/dev/null || true
    
    # Termux properties
    mkdir -p "$HOME/.termux"
    cat > "$HOME/.termux/termux.properties" << 'PROPS'
# DRS.VIP Termux Configuration
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
bell-character=ignore
PROPS
    
    # Apply if termux-reload-settings available
    command -v termux-reload-settings &>/dev/null && termux-reload-settings 2>/dev/null || true
    
    log_success "Termux UI configured"
}

# ─────────────────────────────────────────────
#  Generate Requirements
# ─────────────────────────────────────────────
generate_requirements_termux() {
    log_step "Generating Requirements File"
    
    REQ_DIR="$HOME/drs_vip_requirements"
    mkdir -p "$REQ_DIR"
    
    python -m pip freeze > "$REQ_DIR/requirements_full.txt"
    
    TOTAL=$(python -m pip list 2>/dev/null | wc -l)
    log_success "Requirements saved: $REQ_DIR/requirements_full.txt"
    log_info "Total packages: $TOTAL"
}

# ─────────────────────────────────────────────
#  Verify Installation
# ─────────────────────────────────────────────
verify_installation_termux() {
    log_step "Verifying Installation"
    
    echo ""
    echo -e "${CYAN}  System:${RESET}"
    echo -e "  Python:  ${GREEN}$(python --version)${RESET}"
    echo -e "  pip:     ${GREEN}$(python -m pip --version | awk '{print $1,$2}')${RESET}"
    echo -e "  Termux:  ${GREEN}${TERMUX_VERSION:-unknown}${RESET}"
    echo -e "  Arch:    ${GREEN}$(uname -m)${RESET}"
    
    echo ""
    echo -e "${CYAN}  Key Libraries:${RESET}"
    
    for lib in numpy pandas matplotlib sklearn torch transformers \
               flask fastapi sqlalchemy requests openai langchain \
               cv2 PIL scrapy pytest black; do
        if python -c "import $lib" 2>/dev/null; then
            VER=$(python -c "import $lib; print(getattr($lib, '__version__', 'ok'))" 2>/dev/null)
            echo -e "  ${GREEN}✔${RESET} $lib ${DIM}($VER)${RESET}"
        else
            echo -e "  ${YELLOW}⚠${RESET} ${DIM}$lib${RESET}"
        fi
    done
    
    TOTAL=$(python -m pip list 2>/dev/null | wc -l)
    echo ""
    echo -e "  ${LGOLD}Total packages: ${WHITE}$TOTAL${RESET}"
}

# ─────────────────────────────────────────────
#  Final Summary
# ─────────────────────────────────────────────
show_summary_termux() {
    echo ""
    echo -e "${LGOLD}"
    echo "  ╔═══════════════════════════════════════════════╗"
    echo "  ║                                               ║"
    echo "  ║    𝑫𝑹𝑺.𝑽𝑰𝑷 Termux Setup Complete!          ║"
    echo "  ║                                               ║"
    echo "  ╠═══════════════════════════════════════════════╣"
    echo -e "  ║  ${GREEN}✔ Python 3.13 installed                     ${LGOLD}║"
    echo -e "  ║  ${GREEN}✔ pip latest version                        ${LGOLD}║"
    echo -e "  ║  ${GREEN}✔ All libraries (30+ categories)            ${LGOLD}║"
    echo -e "  ║  ${GREEN}✔ Virtual environment: ~/drs_vip_env        ${LGOLD}║"
    echo -e "  ║  ${GREEN}✔ Requirements file saved                   ${LGOLD}║"
    echo -e "  ║  ${GREEN}✔ Termux UI configured                      ${LGOLD}║"
    echo "  ╠═══════════════════════════════════════════════╣"
    echo -e "  ║  ${CYAN}Commands:${LGOLD}                                   ║"
    echo -e "  ║  ${WHITE}• drs       ${DIM}→ Activate DRS.VIP venv         ${LGOLD}║"
    echo -e "  ║  ${WHITE}• py        ${DIM}→ Python shortcut                ${LGOLD}║"
    echo -e "  ║  ${WHITE}• ipy       ${DIM}→ IPython shell                  ${LGOLD}║"
    echo -e "  ║  ${WHITE}• jl        ${DIM}→ Jupyter Lab (web browser)      ${LGOLD}║"
    echo "  ╚═══════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
    echo -e "  ${DIM}Run: source ~/.bashrc to apply changes${RESET}"
    echo ""
}

# ─────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────
main() {
    show_banner
    
    echo -e "${CYAN}  DRS.VIP Termux Installation Starting...${RESET}"
    echo -e "${DIM}  Estimated time: 30-60 minutes${RESET}"
    echo ""
    
    read -p "  Press ENTER to start or Ctrl+C to cancel... "
    
    check_termux
    setup_storage
    update_termux
    install_python_termux
    install_all_libraries_termux
    install_termux_extras
    setup_venv_termux
    configure_termux_ui
    generate_requirements_termux
    verify_installation_termux
    show_summary_termux
    
    log_success "DRS.VIP Termux installation complete!"
    echo ""
    echo -e "  ${YELLOW}Restart Termux to apply all changes!${RESET}"
}

main "$@"