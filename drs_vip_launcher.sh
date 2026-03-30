#!/usr/bin/env bash
# ============================================================
#         𝑫𝑹𝑺.𝑽𝑰𝑷 - Universal Smart Launcher
#         Auto-detects OS and runs the right script
# ============================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; WHITE='\033[1;37m'; DIM='\033[2m'
LGOLD='\033[1;33m'; RESET='\033[0m'

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
    echo -e "${CYAN}  ╔══════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}  ║${LGOLD}      𝑫𝑹𝑺.𝑽𝑰𝑷 - Smart Universal Launcher       ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${WHITE}   Detects your OS and runs the right script    ${CYAN}║${RESET}"
    echo -e "${CYAN}  ║${DIM}   Linux | macOS | Android/Termux | 2026        ${CYAN}║${RESET}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════════════╝${RESET}"
    echo ""
}

show_banner

# ── Detect Platform ──────────────────────────
if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
    echo -e "${GREEN}  [✔] Detected: Termux (Android)${RESET}"
    echo -e "${CYAN}  Launching Termux installation script...${RESET}"
    sleep 1
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    chmod +x "$SCRIPT_DIR/drs_vip_termux.sh"
    bash "$SCRIPT_DIR/drs_vip_termux.sh"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}  [✔] Detected: macOS${RESET}"
    echo -e "${CYAN}  Launching macOS/Linux installation script...${RESET}"
    sleep 1
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    chmod +x "$SCRIPT_DIR/drs_vip_install.sh"
    bash "$SCRIPT_DIR/drs_vip_install.sh"

elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo -e "${GREEN}  [✔] Detected: Linux ($PRETTY_NAME)${RESET}"
    echo -e "${CYAN}  Launching Linux installation script...${RESET}"
    sleep 1
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    chmod +x "$SCRIPT_DIR/drs_vip_install.sh"
    bash "$SCRIPT_DIR/drs_vip_install.sh"

else
    echo -e "${YELLOW}  [!] Unknown OS detected${RESET}"
    echo ""
    echo -e "${WHITE}  Please run manually:${RESET}"
    echo -e "  ${CYAN}Linux/macOS:${RESET} bash drs_vip_install.sh"
    echo -e "  ${CYAN}Termux:${RESET}      bash drs_vip_termux.sh"
    echo -e "  ${CYAN}Windows:${RESET}     .\\drs_vip_install.ps1"
    echo ""
fi