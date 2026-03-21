#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
#                    C O D I N G   P R I M E   S Y S T E M
#                         ULTIMATE CONTROL CENTER
#                              PREMIUM EDITION v13.0
#                    ═══════════════════════════════════
#                         CODING PRIME + Nobita
# ═══════════════════════════════════════════════════════════════════════════════

# ==============================================================================
#                         COLOR & STYLE DEFINITIONS
# ==============================================================================
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'
italic='\033[3m'
underline='\033[4m'

# Foreground Colors
black='\033[30m'
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[34m'
magenta='\033[35m'
cyan='\033[36m'
white='\033[37m'
gray='\033[90m'

# Bright Colors
bright_red='\033[91m'
bright_green='\033[92m'
bright_yellow='\033[93m'
bright_blue='\033[94m'
bright_magenta='\033[95m'
bright_cyan='\033[96m'
bright_white='\033[97m'

# Background Colors
bg_black='\033[40m'
bg_red='\033[41m'
bg_green='\033[42m'
bg_yellow='\033[43m'
bg_blue='\033[44m'
bg_magenta='\033[45m'
bg_cyan='\033[46m'
bg_white='\033[47m'

# Icons
ICON_STAR="🌟"
ICON_GEAR="⚙️"
ICON_DB="💾"
ICON_NET="🌐"
ICON_VM="🖥️"
ICON_CLOUD="☁️"
ICON_LOCK="🔒"
ICON_UNLOCK="🔓"
ICON_CHECK="✅"
ICON_ERROR="❌"
ICON_WARN="⚠️"
ICON_INFO="ℹ️"
ICON_RUN="▶"
ICON_STOP="■"
ICON_ARROW="➜"
ICON_DIAMOND="💎"
ICON_BOLT="⚡"
ICON_FIRE="🔥"
ICON_MICRO="🎯"
ICON_TIME="⏱️"
ICON_MEM="🧠"
ICON_CPU="🎛️"
ICON_DISK="📀"

# ==============================================================================
#                         SYSTEM METRICS FUNCTIONS
# ==============================================================================
get_cpu_usage() {
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1 2>/dev/null)
    if [[ -z "$cpu_idle" ]]; then
        cpu_idle=$(top -bn1 | grep "%Cpu" | awk '{print $8}' | cut -d'%' -f1 2>/dev/null)
    fi
    cpu_usage=$(echo "100 - ${cpu_idle:-0}" | bc 2>/dev/null || echo "0")
    printf "%.0f" "$cpu_usage"
}

get_ram_usage() {
    total_ram=$(free -m | awk '/^Mem:/{print $2}' 2>/dev/null)
    used_ram=$(free -m | awk '/^Mem:/{print $3}' 2>/dev/null)
    if [[ -n "$total_ram" && "$total_ram" -gt 0 ]]; then
        ram_percent=$(echo "scale=0; $used_ram * 100 / $total_ram" | bc 2>/dev/null || echo "0")
        echo "$ram_percent"
    else
        echo "0"
    fi
}

get_network_status() {
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null 2>&1; then
        echo -e "${bright_green}● CONNECTED${reset}"
    else
        echo -e "${bright_red}● DISCONNECTED${reset}"
    fi
}

get_uptime() {
    uptime_seconds=$(awk '{print $1}' /proc/uptime | cut -d'.' -f1 2>/dev/null)
    uptime_days=$((uptime_seconds / 86400))
    uptime_hours=$(((uptime_seconds % 86400) / 3600))
    uptime_mins=$(((uptime_seconds % 3600) / 60))
    echo "${uptime_days}d ${uptime_hours}h ${uptime_mins}m"
}

# ==============================================================================
#                         BIG CODING PRIME BANNER
# ==============================================================================
show_coding_prime_banner() {
    echo -e "${bright_cyan}${bold}"
    echo "   ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ██████╗ ██████╗ ██╗███╗   ███╗███████╗"
    echo "  ██╔════╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝     ██╔══██╗██╔══██╗██║████╗ ████║██╔════╝"
    echo "  ██║     ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗    ██████╔╝██████╔╝██║██╔████╔██║█████╗  "
    echo "  ██║     ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║    ██╔══██╗██╔══██╗██║██║╚██╔╝██║██╔══╝  "
    echo "  ╚██████╗╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝    ██║  ██║██║  ██║██║██║ ╚═╝ ██║███████╗"
    echo "   ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝"
    echo -e "${reset}"
}

# ==============================================================================
#                         HEADER WITH METRICS
# ==============================================================================
draw_header() {
    clear
    show_coding_prime_banner
    
    # Get live metrics
    hostname=$(hostname)
    uptime=$(get_uptime)
    cpu=$(get_cpu_usage)
    ram=$(get_ram_usage)
    network=$(get_network_status)
    
    # Color for CPU based on usage
    if [[ $cpu -lt 30 ]]; then
        cpu_color=$bright_green
    elif [[ $cpu -lt 70 ]]; then
        cpu_color=$bright_yellow
    else
        cpu_color=$bright_red
    fi
    
    # Color for RAM based on usage
    if [[ $ram -lt 30 ]]; then
        ram_color=$bright_green
    elif [[ $ram -lt 70 ]]; then
        ram_color=$bright_yellow
    else
        ram_color=$bright_red
    fi
    
    # Create progress bar for CPU
    cpu_bar_len=$((cpu / 5))
    cpu_bar=$(printf "%-${cpu_bar_len}s" "█" | tr ' ' '█')
    cpu_empty_len=$((20 - cpu_bar_len))
    cpu_empty=$(printf "%-${cpu_empty_len}s" " " | tr ' ' '░')
    
    # Create progress bar for RAM
    ram_bar_len=$((ram / 5))
    ram_bar=$(printf "%-${ram_bar_len}s" "█" | tr ' ' '█')
    ram_empty_len=$((20 - ram_bar_len))
    ram_empty=$(printf "%-${ram_empty_len}s" " " | tr ' ' '░')
    
    echo -e "${bold}${bright_cyan}╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_STAR} ${bright_white}SYSTEM STATUS${reset}                                                              ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_DIAMOND} ${bright_white}HOSTNAME${reset}   : ${bright_green}$hostname${reset}                                                ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_TIME} ${bright_white}UPTIME${reset}      : ${bright_yellow}$uptime${reset}                                                ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_CPU} ${bright_white}CPU USAGE${reset}   : ${cpu_color}${cpu}%${reset}  [${cpu_color}${cpu_bar}${cpu_empty}${reset}]                                         ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_MEM} ${bright_white}RAM USAGE${reset}   : ${ram_color}${ram}%${reset}  [${ram_color}${ram_bar}${ram_empty}${reset}]                                         ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}║${reset}  ${ICON_NET} ${bright_white}NETWORK${reset}     : ${network}                                                  ${bold}${bright_cyan}║${reset}"
    echo -e "${bold}${bright_cyan}╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""
}

# ==============================================================================
#                         MAIN MENU DISPLAY
# ==============================================================================
show_main_menu() {
    echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${ICON_GEAR} ${bright_yellow}${bold}MAIN MENU${reset}                                                                           ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_GEAR}  ${bright_white}IDX / SETUP${reset}              ${bright_green}[5]${reset}  ${ICON_CLOUD}  ${bright_white}TAILSCALE MESH${reset}                      ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_CLOUD}  ${bright_white}CLOUDFLARE${reset}                ${bright_green}[6]${reset}  ${ICON_VM}    ${bright_white}XRDP INSTALL${reset}                        ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_DB}    ${bright_white}TOOLS${reset}                     ${bright_green}[7]${reset}  ${ICON_LOCK}  ${bright_white}ROOT ACCESS${reset}                         ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_VM}    ${bright_white}VM MANAGER (KVM)${reset}          ${bright_green}[8]${reset}  ${ICON_VM}    ${bright_white}NO KVM VM${reset}                           ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_red}${bold}EXIT SYSTEM${reset}                                                           ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
    echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
    echo ""
    echo -e "  ${dim}${gray}CODING PRIME + Nobita  |  Premium System Control Center  |  v13.0${reset}"
    echo ""
    echo -ne "${bold}${bright_cyan}┌─[${bright_white}CODING PRIME${bright_cyan}]─[${bright_yellow}MENU${bright_cyan}]${reset}\n"
    echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
}

# ==============================================================================
#                         IDX / SETUP MENU
# ==============================================================================
idx_setup_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_GEAR} ${bright_yellow}${bold}IDX / SETUP - SYSTEM INITIALIZATION${reset}                                                 ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_BOLT}  ${bright_white}System Update & Upgrade${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_DB}    ${bright_white}Install Essential Packages${reset}                                             ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_LOCK}  ${bright_white}Configure Firewall (UFW)${reset}                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_TIME}  ${bright_white}Set Timezone${reset}                                                           ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_DISK}  ${bright_white}Create Swap Space${reset}                                                       ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[6]${reset}  ${ICON_BOLT}  ${bright_white}System Optimization${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[7]${reset}  ${ICON_CHECK}  ${bright_white}System Health Check${reset}                                                   ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}IDX/SETUP${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r idx_choice
        
        case $idx_choice in
            1)
                echo -e "\n${ICON_BOLT} ${bright_blue}Updating system...${reset}"
                sudo apt update && sudo apt upgrade -y
                echo -e "${ICON_CHECK} ${bright_green}System updated!${reset}"
                sleep 2
                ;;
            2)
                echo -e "\n${ICON_DB} ${bright_blue}Installing packages...${reset}"
                sudo apt install -y curl wget git vim htop net-tools ufw build-essential
                echo -e "${ICON_CHECK} ${bright_green}Packages installed!${reset}"
                sleep 2
                ;;
            3)
                echo -e "\n${ICON_LOCK} ${bright_blue}Configuring firewall...${reset}"
                sudo ufw allow 22/tcp
                sudo ufw allow 80/tcp
                sudo ufw allow 443/tcp
                sudo ufw --force enable
                echo -e "${ICON_CHECK} ${bright_green}Firewall configured!${reset}"
                sleep 2
                ;;
            4)
                echo -e "\n${ICON_TIME} ${bright_blue}Setting timezone...${reset}"
                sudo timedatectl set-timezone UTC
                echo -e "${ICON_CHECK} ${bright_green}Timezone set to UTC!${reset}"
                sleep 2
                ;;
            5)
                echo -e "\n${ICON_DISK} ${bright_blue}Creating swap space...${reset}"
                sudo fallocate -l 2G /swapfile 2>/dev/null || sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
                sudo chmod 600 /swapfile
                sudo mkswap /swapfile
                sudo swapon /swapfile
                echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
                echo -e "${ICON_CHECK} ${bright_green}Swap space created!${reset}"
                sleep 2
                ;;
            6)
                echo -e "\n${ICON_BOLT} ${bright_blue}Optimizing system...${reset}"
                echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
                echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
                echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
                echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
                sudo sysctl -p
                echo -e "${ICON_CHECK} ${bright_green}System optimized!${reset}"
                sleep 2
                ;;
            7)
                echo -e "\n${ICON_CHECK} ${bright_blue}System Health Check:${reset}"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo -e "${ICON_CPU} CPU: $(get_cpu_usage)%"
                echo -e "${ICON_MEM} RAM: $(get_ram_usage)%"
                echo -e "${ICON_DISK} DISK: $(df -h / | awk 'NR==2 {print $5}')"
                echo -e "${ICON_NET} NETWORK: $(ping -c 1 -W 2 8.8.8.8 &>/dev/null && echo "ONLINE" || echo "OFFLINE")"
                echo -e "${ICON_TIME} UPTIME: $(get_uptime)"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         CLOUDFLARE MENU
# ==============================================================================
cloudflare_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_CLOUD} ${bright_yellow}${bold}CLOUDFLARE TUNNEL MANAGER${reset}                                                           ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        if command -v cloudflared &>/dev/null; then
            if systemctl is-active --quiet cloudflared; then
                echo -e "${bold}${bright_cyan}│${reset}  ${ICON_CHECK} ${bright_green}STATUS: RUNNING${reset}                                                      ${bold}${bright_cyan}│${reset}"
            else
                echo -e "${bold}${bright_cyan}│${reset}  ${ICON_WARN} ${bright_yellow}STATUS: STOPPED${reset}                                                      ${bold}${bright_cyan}│${reset}"
            fi
        else
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_ERROR} ${bright_red}STATUS: NOT INSTALLED${reset}                                                 ${bold}${bright_cyan}│${reset}"
        fi
        
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_CLOUD}  ${bright_white}Install Cloudflared${reset}                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_GEAR}   ${bright_white}Configure Tunnel${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_RUN}   ${bright_white}Start Tunnel${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_STOP}  ${bright_white}Stop Tunnel${reset}                                                      ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_INFO}  ${bright_white}View Logs${reset}                                                        ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[6]${reset}  ${ICON_ERROR} ${bright_white}Uninstall${reset}                                                        ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}CLOUDFLARE${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r cf_choice
        
        case $cf_choice in
            1)
                echo -e "\n${ICON_CLOUD} ${bright_blue}Installing Cloudflared...${reset}"
                sudo mkdir -p --mode=0755 /usr/share/keyrings
                curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
                echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null
                sudo apt update && sudo apt install -y cloudflared
                echo -e "${ICON_CHECK} ${bright_green}Cloudflared installed!${reset}"
                sleep 2
                ;;
            2)
                echo -e "\n${ICON_GEAR} ${bright_blue}Configuring tunnel...${reset}"
                echo -e "${bright_yellow}Paste your tunnel token:${reset}"
                read -r tunnel_token
                sudo cloudflared service install "$tunnel_token"
                echo -e "${ICON_CHECK} ${bright_green}Tunnel configured!${reset}"
                sleep 2
                ;;
            3)
                echo -e "\n${ICON_RUN} ${bright_blue}Starting tunnel...${reset}"
                sudo systemctl start cloudflared
                sudo systemctl enable cloudflared
                echo -e "${ICON_CHECK} ${bright_green}Tunnel started!${reset}"
                sleep 2
                ;;
            4)
                echo -e "\n${ICON_STOP} ${bright_blue}Stopping tunnel...${reset}"
                sudo systemctl stop cloudflared
                echo -e "${ICON_CHECK} ${bright_green}Tunnel stopped!${reset}"
                sleep 2
                ;;
            5)
                echo -e "\n${ICON_INFO} ${bright_blue}Tunnel logs:${reset}"
                sudo journalctl -u cloudflared -n 30 --no-pager
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            6)
                echo -e "\n${ICON_ERROR} ${bright_red}Uninstalling Cloudflared...${reset}"
                sudo cloudflared service uninstall 2>/dev/null
                sudo apt remove -y cloudflared
                echo -e "${ICON_CHECK} ${bright_green}Cloudflared removed!${reset}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         TOOLS MENU
# ==============================================================================
tools_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_DB} ${bright_yellow}${bold}SYSTEM TOOLS & UTILITIES${reset}                                                         ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_INFO}  ${bright_white}System Information${reset}                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_DISK}  ${bright_white}Disk Usage Analyzer${reset}                                               ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_NET}   ${bright_white}Network Diagnostics${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_CPU}   ${bright_white}Process Manager${reset}                                                    ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_GEAR}  ${bright_white}Service Manager${reset}                                                    ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[6]${reset}  ${ICON_INFO}  ${bright_white}Log Viewer${reset}                                                         ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[7]${reset}  ${ICON_NET}   ${bright_white}Port Scanner${reset}                                                       ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[8]${reset}  ${ICON_BOLT}  ${bright_white}Speed Test${reset}                                                         ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}TOOLS${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r tool_choice
        
        case $tool_choice in
            1)
                clear
                echo -e "${ICON_INFO} ${bright_blue}System Information:${reset}"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo -e "Hostname   : $(hostname)"
                echo -e "OS         : $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo "Unknown")"
                echo -e "Kernel     : $(uname -r)"
                echo -e "Uptime     : $(get_uptime)"
                echo -e "CPU        : $(nproc) cores"
                echo -e "Memory     : $(free -h | awk '/^Mem:/{print $2}') total"
                echo -e "Disk       : $(df -h / | awk 'NR==2{print $2}') total"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            2)
                clear
                echo -e "${ICON_DISK} ${bright_blue}Disk Usage:${reset}"
                df -h
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            3)
                clear
                echo -e "${ICON_NET} ${bright_blue}Network Information:${reset}"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo -e "IP Address : $(hostname -I | awk '{print $1}')"
                echo -e "Gateway    : $(ip route | grep default | awk '{print $3}')"
                echo -e "DNS        : $(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')"
                echo -e "${bright_white}────────────────────────────────────────${reset}"
                echo ""
                echo -e "${bright_blue}Ping Test:${reset}"
                ping -c 4 google.com
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            4)
                clear
                echo -e "${ICON_CPU} ${bright_blue}Top Processes by CPU:${reset}"
                ps aux --sort=-%cpu | head -20
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            5)
                clear
                echo -e "${ICON_GEAR} ${bright_blue}Running Services:${reset}"
                systemctl list-units --type=service --state=running | head -20
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            6)
                clear
                echo -e "${ICON_INFO} ${bright_blue}Last 20 System Logs:${reset}"
                journalctl -n 20 --no-pager
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            7)
                clear
                echo -e "${ICON_NET} ${bright_blue}Open Ports:${reset}"
                ss -tuln | head -30
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            8)
                clear
                echo -e "${ICON_BOLT} ${bright_blue}Running Speed Test...${reset}"
                if command -v speedtest-cli &>/dev/null; then
                    speedtest-cli --simple
                else
                    echo -e "${ICON_WARN} ${bright_yellow}Installing speedtest-cli...${reset}"
                    sudo apt install -y speedtest-cli
                    speedtest-cli --simple
                fi
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         VM MANAGER (KVM)
# ==============================================================================
vm_manager() {
    # Check and install dependencies
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "\n${ICON_DB} ${bright_blue}Installing QEMU/KVM dependencies...${reset}"
        sudo apt update
        sudo apt install -y qemu-system-x86 qemu-utils cloud-image-utils wget lsof
    fi
    
    # Check if KVM is available
    KVM_AVAILABLE=false
    if [ -e /dev/kvm ]; then
        KVM_AVAILABLE=true
        echo -e "${ICON_CHECK} ${bright_green}KVM acceleration available${reset}"
    else
        echo -e "${ICON_WARN} ${bright_yellow}KVM not available - using software emulation${reset}"
    fi
    sleep 2
    
    VM_DIR="${HOME}/vms"
    mkdir -p "$VM_DIR"
    
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_VM} ${bright_yellow}${bold}VIRTUAL MACHINE MANAGER (KVM)${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        # List existing VMs
        vms=($(find "$VM_DIR" -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort))
        vm_count=${#vms[@]}
        
        if [ $vm_count -gt 0 ]; then
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_VM} ${bright_white}Existing VMs:${reset}                                                         ${bold}${bright_cyan}│${reset}"
            for i in "${!vms[@]}"; do
                status="💤"
                if pgrep -f "qemu-system.*${vms[$i]}" >/dev/null; then
                    status="🚀"
                fi
                printf "${bold}${bright_cyan}│${reset}      %2d) %s %s\n" $((i+1)) "${vms[$i]}" "$status"
            done
            echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        fi
        
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_VM}    ${bright_white}Create New VM${reset}                                                    ${bold}${bright_cyan}│${reset}"
        if [ $vm_count -gt 0 ]; then
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_RUN}   ${bright_white}Start VM${reset}                                                         ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_STOP}  ${bright_white}Stop VM${reset}                                                          ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_ERROR} ${bright_white}Delete VM${reset}                                                        ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_INFO}  ${bright_white}VM Information${reset}                                                   ${bold}${bright_cyan}│${reset}"
        fi
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}VM MANAGER${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r vm_choice
        
        case $vm_choice in
            1)
                create_new_vm "$VM_DIR" "$KVM_AVAILABLE"
                ;;
            2)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number to start: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        start_vm "${vms[$((vm_num-1))]}" "$VM_DIR" "$KVM_AVAILABLE"
                    fi
                fi
                ;;
            3)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number to stop: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        stop_vm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            4)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_red}Enter VM number to delete: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        delete_vm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            5)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number for info: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        show_vm_info "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         VM HELPER FUNCTIONS
# ==============================================================================
create_new_vm() {
    VM_DIR=$1
    KVM_AVAILABLE=$2
    
    echo -e "\n${ICON_VM} ${bright_blue}Creating New Virtual Machine${reset}"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    
    # OS Selection
    echo -e "${bright_white}Select OS:${reset}"
    echo -e "  ${bright_green}[1]${reset} Ubuntu 22.04 (Jammy)"
    echo -e "  ${bright_green}[2]${reset} Ubuntu 24.04 (Noble)"
    echo -e "  ${bright_green}[3]${reset} Debian 12 (Bookworm)"
    echo -e "  ${bright_green}[4]${reset} Debian 13 (Trixie)"
    echo -e "  ${bright_green}[5]${reset} Fedora 40"
    echo -ne "${ICON_ARROW} ${bright_yellow}Choice: ${reset}"
    read -r os_choice
    
    case $os_choice in
        1) IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"; OS_NAME="ubuntu22" ;;
        2) IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"; OS_NAME="ubuntu24" ;;
        3) IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"; OS_NAME="debian12" ;;
        4) IMG_URL="https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-generic-amd64-daily.qcow2"; OS_NAME="debian13" ;;
        5) IMG_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2"; OS_NAME="fedora40" ;;
        *) echo -e "${ICON_ERROR} ${bright_red}Invalid selection${reset}"; return ;;
    esac
    
    echo -ne "${ICON_ARROW} ${bright_yellow}VM Name: ${reset}"
    read -r VM_NAME
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Memory (MB) [2048]: ${reset}"
    read -r MEMORY
    MEMORY=${MEMORY:-2048}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}CPUs [2]: ${reset}"
    read -r CPUS
    CPUS=${CPUS:-2}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Disk Size [20G]: ${reset}"
    read -r DISK_SIZE
    DISK_SIZE=${DISK_SIZE:-20G}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}SSH Port [2222]: ${reset}"
    read -r SSH_PORT
    SSH_PORT=${SSH_PORT:-2222}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Username [root]: ${reset}"
    read -r USERNAME
    USERNAME=${USERNAME:-root}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Password [root]: ${reset}"
    read -r PASSWORD
    PASSWORD=${PASSWORD:-root}
    
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"
    
    # Download image
    echo -e "\n${ICON_CLOUD} ${bright_blue}Downloading image...${reset}"
    if [ ! -f "$IMG_FILE" ]; then
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE"
    fi
    
    # Resize disk
    echo -e "${ICON_DISK} ${bright_blue}Resizing disk...${reset}"
    qemu-img resize "$IMG_FILE" "$DISK_SIZE"
    
    # Create cloud-init
    echo -e "${ICON_GEAR} ${bright_blue}Creating cloud-init...${reset}"
    cat > user-data <<EOF
#cloud-config
hostname: $VM_NAME
ssh_pwauth: true
disable_root: false
users:
  - name: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    password: $(openssl passwd -6 "$PASSWORD" | tr -d '\n')
chpasswd:
  list: |
    root:$PASSWORD
    $USERNAME:$PASSWORD
  expire: false
EOF
    
    cat > meta-data <<EOF
instance-id: iid-$VM_NAME
local-hostname: $VM_NAME
EOF
    
    cloud-localds "$SEED_FILE" user-data meta-data
    
    # Save config
    cat > "$VM_DIR/$VM_NAME.conf" <<EOF
VM_NAME="$VM_NAME"
OS_NAME="$OS_NAME"
IMG_URL="$IMG_URL"
MEMORY="$MEMORY"
CPUS="$CPUS"
DISK_SIZE="$DISK_SIZE"
SSH_PORT="$SSH_PORT"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
IMG_FILE="$IMG_FILE"
SEED_FILE="$SEED_FILE"
CREATED="$(date)"
EOF
    
    rm -f user-data meta-data
    
    echo -e "\n${ICON_CHECK} ${bright_green}VM '$VM_NAME' created successfully!${reset}"
    echo -e "${ICON_NET} ${bright_yellow}SSH: ssh -p $SSH_PORT $USERNAME@localhost${reset}"
    echo -e "${ICON_LOCK} ${bright_yellow}Password: $PASSWORD${reset}"
    sleep 3
}

start_vm() {
    VM_NAME=$1
    VM_DIR=$2
    KVM_AVAILABLE=$3
    
    source "$VM_DIR/$VM_NAME.conf"
    
    if pgrep -f "qemu-system.*$IMG_FILE" >/dev/null; then
        echo -e "\n${ICON_WARN} ${bright_yellow}VM already running${reset}"
        sleep 2
        return
    fi
    
    echo -e "\n${ICON_RUN} ${bright_blue}Starting VM: $VM_NAME${reset}"
    
    # QEMU command
    qemu_cmd=(
        qemu-system-x86_64
        -m "$MEMORY"
        -smp "$CPUS"
        -drive "file=$IMG_FILE,format=qcow2,if=virtio"
        -drive "file=$SEED_FILE,format=raw,if=virtio"
        -device virtio-net-pci,netdev=n0
        -netdev "user,id=n0,hostfwd=tcp::$SSH_PORT-:22"
        -nographic
        -serial mon:stdio
    )
    
    # Add KVM if available
    if [ "$KVM_AVAILABLE" = true ]; then
        qemu_cmd+=(-enable-kvm -cpu host)
    else
        qemu_cmd+=(-cpu qemu64 -machine type=pc,accel=tcg)
    fi
    
    echo -e "${ICON_CHECK} ${bright_green}VM started! SSH: ssh -p $SSH_PORT $USERNAME@localhost${reset}"
    echo -e "${ICON_INFO} ${bright_yellow}Press Ctrl+A then X to exit console${reset}"
    sleep 2
    
    "${qemu_cmd[@]}"
}

stop_vm() {
    VM_NAME=$1
    VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    pkill -f "qemu-system.*$IMG_FILE"
    echo -e "\n${ICON_CHECK} ${bright_green}VM stopped${reset}"
    sleep 2
}

delete_vm() {
    VM_NAME=$1
    VM_DIR=$2
    
    echo -e "\n${ICON_WARN} ${bright_red}This will permanently delete VM '$VM_NAME'${reset}"
    echo -ne "${ICON_ARROW} ${bright_yellow}Are you sure? (y/N): ${reset}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        source "$VM_DIR/$VM_NAME.conf"
        pkill -f "qemu-system.*$IMG_FILE" 2>/dev/null
        rm -f "$IMG_FILE" "$SEED_FILE" "$VM_DIR/$VM_NAME.conf"
        echo -e "${ICON_CHECK} ${bright_green}VM deleted${reset}"
    fi
    sleep 2
}

show_vm_info() {
    VM_NAME=$1
    VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    echo -e "\n${ICON_INFO} ${bright_blue}VM Information: $VM_NAME${reset}"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    echo -e "OS        : $OS_NAME"
    echo -e "Memory    : $MEMORY MB"
    echo -e "CPUs      : $CPUS"
    echo -e "Disk      : $DISK_SIZE"
    echo -e "SSH Port  : $SSH_PORT"
    echo -e "Username  : $USERNAME"
    echo -e "Password  : $PASSWORD"
    echo -e "Created   : $CREATED"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    echo -e "\n${dim}Press Enter to continue...${reset}"
    read
}

# ==============================================================================
#                         NO KVM VM MANAGER
# ==============================================================================
no_kvm_manager() {
    # Check and install dependencies
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "\n${ICON_DB} ${bright_blue}Installing QEMU dependencies...${reset}"
        sudo apt update
        sudo apt install -y qemu-system-x86 qemu-utils cloud-image-utils wget lsof
    fi
    
    VM_DIR="${HOME}/vms-nokvm"
    mkdir -p "$VM_DIR"
    
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_VM} ${bright_yellow}${bold}VIRTUAL MACHINE MANAGER (NO KVM)${reset}                                                 ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_WARN} ${bright_yellow}Running in pure software emulation mode (no KVM)${reset}                                    ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        # List existing VMs
        vms=($(find "$VM_DIR" -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort))
        vm_count=${#vms[@]}
        
        if [ $vm_count -gt 0 ]; then
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_VM} ${bright_white}Existing VMs:${reset}                                                         ${bold}${bright_cyan}│${reset}"
            for i in "${!vms[@]}"; do
                status="💤"
                if pgrep -f "qemu-system.*${vms[$i]}" >/dev/null; then
                    status="🚀"
                fi
                printf "${bold}${bright_cyan}│${reset}      %2d) %s %s\n" $((i+1)) "${vms[$i]}" "$status"
            done
            echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        fi
        
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_VM}    ${bright_white}Create New VM${reset}                                                    ${bold}${bright_cyan}│${reset}"
        if [ $vm_count -gt 0 ]; then
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_RUN}   ${bright_white}Start VM${reset}                                                         ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_STOP}  ${bright_white}Stop VM${reset}                                                          ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_ERROR} ${bright_white}Delete VM${reset}                                                        ${bold}${bright_cyan}│${reset}"
            echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_INFO}  ${bright_white}VM Information${reset}                                                   ${bold}${bright_cyan}│${reset}"
        fi
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}NO KVM${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r vm_choice
        
        case $vm_choice in
            1)
                create_new_vm_nokvm "$VM_DIR"
                ;;
            2)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number to start: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        start_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            3)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number to stop: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        stop_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            4)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_red}Enter VM number to delete: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        delete_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            5)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${ICON_ARROW} ${bright_yellow}Enter VM number for info: ${reset}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        show_vm_info_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

create_new_vm_nokvm() {
    VM_DIR=$1
    
    echo -e "\n${ICON_VM} ${bright_blue}Creating New VM (Software Emulation)${reset}"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    
    echo -e "${bright_white}Select OS:${reset}"
    echo -e "  ${bright_green}[1]${reset} Ubuntu 22.04"
    echo -e "  ${bright_green}[2]${reset} Ubuntu 24.04"
    echo -e "  ${bright_green}[3]${reset} Debian 12"
    echo -e "  ${bright_green}[4]${reset} Debian 13"
    echo -ne "${ICON_ARROW} ${bright_yellow}Choice: ${reset}"
    read -r os_choice
    
    case $os_choice in
        1) IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"; OS_NAME="ubuntu22" ;;
        2) IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"; OS_NAME="ubuntu24" ;;
        3) IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"; OS_NAME="debian12" ;;
        4) IMG_URL="https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-generic-amd64-daily.qcow2"; OS_NAME="debian13" ;;
        *) echo -e "${ICON_ERROR} ${bright_red}Invalid selection${reset}"; return ;;
    esac
    
    echo -ne "${ICON_ARROW} ${bright_yellow}VM Name: ${reset}"
    read -r VM_NAME
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Memory (MB) [1024]: ${reset}"
    read -r MEMORY
    MEMORY=${MEMORY:-1024}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}CPUs [1]: ${reset}"
    read -r CPUS
    CPUS=${CPUS:-1}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}Disk Size [10G]: ${reset}"
    read -r DISK_SIZE
    DISK_SIZE=${DISK_SIZE:-10G}
    
    echo -ne "${ICON_ARROW} ${bright_yellow}SSH Port [2222]: ${reset}"
    read -r SSH_PORT
    SSH_PORT=${SSH_PORT:-2222}
    
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"
    
    echo -e "\n${ICON_CLOUD} ${bright_blue}Downloading image...${reset}"
    if [ ! -f "$IMG_FILE" ]; then
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE"
    fi
    
    echo -e "${ICON_DISK} ${bright_blue}Resizing disk...${reset}"
    qemu-img resize "$IMG_FILE" "$DISK_SIZE"
    
    echo -e "${ICON_GEAR} ${bright_blue}Creating cloud-init...${reset}"
    cat > user-data <<EOF
#cloud-config
hostname: $VM_NAME
ssh_pwauth: true
disable_root: false
users:
  - name: root
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    password: $(openssl passwd -6 "root" | tr -d '\n')
chpasswd:
  list: |
    root:root
  expire: false
EOF
    
    cat > meta-data <<EOF
instance-id: iid-$VM_NAME
local-hostname: $VM_NAME
EOF
    
    cloud-localds "$SEED_FILE" user-data meta-data
    
    cat > "$VM_DIR/$VM_NAME.conf" <<EOF
VM_NAME="$VM_NAME"
OS_NAME="$OS_NAME"
IMG_URL="$IMG_URL"
MEMORY="$MEMORY"
CPUS="$CPUS"
DISK_SIZE="$DISK_SIZE"
SSH_PORT="$SSH_PORT"
IMG_FILE="$IMG_FILE"
SEED_FILE="$SEED_FILE"
CREATED="$(date)"
EOF
    
    rm -f user-data meta-data
    
    echo -e "\n${ICON_CHECK} ${bright_green}VM '$VM_NAME' created successfully!${reset}"
    echo -e "${ICON_NET} ${bright_yellow}SSH: ssh -p $SSH_PORT root@localhost (password: root)${reset}"
    sleep 3
}

start_vm_nokvm() {
    VM_NAME=$1
    VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    if pgrep -f "qemu-system.*$IMG_FILE" >/dev/null; then
        echo -e "\n${ICON_WARN} ${bright_yellow}VM already running${reset}"
        sleep 2
        return
    fi
    
    echo -e "\n${ICON_RUN} ${bright_blue}Starting VM: $VM_NAME (Software Emulation)${reset}"
    
    qemu-system-x86_64 \
        -m "$MEMORY" \
        -smp "$CPUS" \
        -cpu qemu64 \
        -machine type=pc,accel=tcg \
        -drive "file=$IMG_FILE,format=qcow2,if=virtio" \
        -drive "file=$SEED_FILE,format=raw,if=virtio" \
        -device virtio-net-pci,netdev=n0 \
        -netdev "user,id=n0,hostfwd=tcp::$SSH_PORT-:22" \
        -nographic \
        -serial mon:stdio
    
    echo -e "${ICON_CHECK} ${bright_green}VM started! SSH: ssh -p $SSH_PORT root@localhost${reset}"
}

stop_vm_nokvm() {
    VM_NAME=$1
    VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    pkill -f "qemu-system.*$IMG_FILE"
    echo -e "\n${ICON_CHECK} ${bright_green}VM stopped${reset}"
    sleep 2
}

delete_vm_nokvm() {
    VM_NAME=$1
    VM_DIR=$2
    
    echo -e "\n${ICON_WARN} ${bright_red}This will permanently delete VM '$VM_NAME'${reset}"
    echo -ne "${ICON_ARROW} ${bright_yellow}Are you sure? (y/N): ${reset}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        source "$VM_DIR/$VM_NAME.conf"
        pkill -f "qemu-system.*$IMG_FILE" 2>/dev/null
        rm -f "$IMG_FILE" "$SEED_FILE" "$VM_DIR/$VM_NAME.conf"
        echo -e "${ICON_CHECK} ${bright_green}VM deleted${reset}"
    fi
    sleep 2
}

show_vm_info_nokvm() {
    VM_NAME=$1
    VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    echo -e "\n${ICON_INFO} ${bright_blue}VM Information: $VM_NAME${reset}"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    echo -e "OS        : $OS_NAME"
    echo -e "Memory    : $MEMORY MB"
    echo -e "CPUs      : $CPUS"
    echo -e "Disk      : $DISK_SIZE"
    echo -e "SSH Port  : $SSH_PORT"
    echo -e "Username  : root"
    echo -e "Password  : root"
    echo -e "Created   : $CREATED"
    echo -e "${bright_white}────────────────────────────────────────${reset}"
    echo -e "\n${dim}Press Enter to continue...${reset}"
    read
}

# ==============================================================================
#                         TAILSCALE MENU
# ==============================================================================
tailscale_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_NET} ${bright_yellow}${bold}TAILSCALE MESH NETWORK MANAGER${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        if command -v tailscale &>/dev/null; then
            if systemctl is-active --quiet tailscaled; then
                ts_ip=$(tailscale ip -4 2>/dev/null || echo "Not connected")
                echo -e "${bold}${bright_cyan}│${reset}  ${ICON_CHECK} ${bright_green}STATUS: RUNNING${reset}  ${ICON_NET} IP: ${bright_cyan}$ts_ip${reset}                         ${bold}${bright_cyan}│${reset}"
            else
                echo -e "${bold}${bright_cyan}│${reset}  ${ICON_WARN} ${bright_yellow}STATUS: STOPPED${reset}                                                      ${bold}${bright_cyan}│${reset}"
            fi
        else
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_ERROR} ${bright_red}STATUS: NOT INSTALLED${reset}                                                 ${bold}${bright_cyan}│${reset}"
        fi
        
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_NET}   ${bright_white}Install Tailscale${reset}                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_LOCK}  ${bright_white}Connect/Authenticate${reset}                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_INFO}  ${bright_white}Show Network Map${reset}                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_STOP}  ${bright_white}Disconnect${reset}                                                       ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_ERROR} ${bright_white}Uninstall${reset}                                                         ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}TAILSCALE${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r ts_choice
        
        case $ts_choice in
            1)
                echo -e "\n${ICON_NET} ${bright_blue}Installing Tailscale...${reset}"
                curl -fsSL https://tailscale.com/install.sh | sh
                sudo systemctl enable --now tailscaled
                echo -e "${ICON_CHECK} ${bright_green}Tailscale installed!${reset}"
                sleep 2
                ;;
            2)
                echo -e "\n${ICON_LOCK} ${bright_blue}Connecting to Tailscale...${reset}"
                sudo tailscale up
                echo -e "${ICON_CHECK} ${bright_green}Connected!${reset}"
                sleep 2
                ;;
            3)
                echo -e "\n${ICON_INFO} ${bright_blue}Network Map:${reset}"
                tailscale status
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            4)
                echo -e "\n${ICON_STOP} ${bright_blue}Disconnecting...${reset}"
                sudo tailscale down
                echo -e "${ICON_CHECK} ${bright_green}Disconnected!${reset}"
                sleep 2
                ;;
            5)
                echo -e "\n${ICON_ERROR} ${bright_red}Uninstalling Tailscale...${reset}"
                sudo apt purge -y tailscale
                sudo rm -rf /var/lib/tailscale
                echo -e "${ICON_CHECK} ${bright_green}Tailscale removed!${reset}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         XRDP INSTALL MENU
# ==============================================================================
xrdp_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_VM} ${bright_yellow}${bold}XRDP REMOTE DESKTOP INSTALLER${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        if systemctl is-active --quiet xrdp; then
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_CHECK} ${bright_green}STATUS: RUNNING${reset}                                                      ${bold}${bright_cyan}│${reset}"
        else
            echo -e "${bold}${bright_cyan}│${reset}  ${ICON_ERROR} ${bright_red}STATUS: NOT RUNNING${reset}                                                  ${bold}${bright_cyan}│${reset}"
        fi
        
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_VM}    ${bright_white}Install XRDP with XFCE4${reset}                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_RUN}   ${bright_white}Start XRDP Service${reset}                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[3]${reset}  ${ICON_STOP}  ${bright_white}Stop XRDP Service${reset}                                                   ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_GEAR}  ${bright_white}Restart XRDP Service${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_INFO}  ${bright_white}View Status${reset}                                                        ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[6]${reset}  ${ICON_ERROR} ${bright_white}Uninstall${reset}                                                         ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}XRDP${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r xrdp_choice
        
        case $xrdp_choice in
            1)
                echo -e "\n${ICON_VM} ${bright_blue}Installing XRDP and XFCE4...${reset}"
                sudo apt update
                sudo apt install -y xrdp xfce4 xfce4-goodies dbus-x11
                sudo systemctl enable xrdp
                echo -e "root\nroot" | sudo passwd root
                sudo sed -i 's/^AllowRootLogin=false/AllowRootLogin=true/' /etc/xrdp/sesman.ini || true
                sudo sed -i 's/^auth required pam_succeed_if.so user != root quiet_success/#&/' /etc/pam.d/xrdp-sesman || true
                echo "startxfce4" > ~/.xsession
                chmod +x ~/.xsession
                sudo systemctl restart xrdp
                echo -e "${ICON_CHECK} ${bright_green}XRDP installed! Login: root / root${reset}"
                sleep 3
                ;;
            2)
                echo -e "\n${ICON_RUN} ${bright_blue}Starting XRDP...${reset}"
                sudo systemctl start xrdp
                echo -e "${ICON_CHECK} ${bright_green}XRDP started!${reset}"
                sleep 2
                ;;
            3)
                echo -e "\n${ICON_STOP} ${bright_blue}Stopping XRDP...${reset}"
                sudo systemctl stop xrdp
                echo -e "${ICON_CHECK} ${bright_green}XRDP stopped!${reset}"
                sleep 2
                ;;
            4)
                echo -e "\n${ICON_GEAR} ${bright_blue}Restarting XRDP...${reset}"
                sudo systemctl restart xrdp
                echo -e "${ICON_CHECK} ${bright_green}XRDP restarted!${reset}"
                sleep 2
                ;;
            5)
                echo -e "\n${ICON_INFO} ${bright_blue}XRDP Status:${reset}"
                sudo systemctl status xrdp --no-pager
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            6)
                echo -e "\n${ICON_ERROR} ${bright_red}Uninstalling XRDP...${reset}"
                sudo systemctl stop xrdp
                sudo apt purge -y xrdp xfce4 xfce4-goodies
                sudo rm -rf /etc/xrdp
                echo -e "${ICON_CHECK} ${bright_green}XRDP removed!${reset}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         ROOT ACCESS MENU
# ==============================================================================
root_access_menu() {
    while true; do
        clear
        show_coding_prime_banner
        echo -e "${bold}${bright_cyan}┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${ICON_LOCK} ${bright_yellow}${bold}ROOT ACCESS & SSH MANAGER${reset}                                                       ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}├──────────────────────────────────────────────────────────────────────────────────────────────────────┤${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        
        # Show current SSH config
        root_login=$(sudo grep -E "^PermitRootLogin" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' 2>/dev/null || echo "not set")
        pass_auth=$(sudo grep -E "^PasswordAuthentication" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' 2>/dev/null || echo "not set")
        ssh_port=$(sudo grep -E "^Port" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' 2>/dev/null || echo "22")
        
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_white}Current SSH Configuration:${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}    ${ICON_LOCK} Root Login     : ${bright_yellow}$root_login${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}    ${ICON_KEY} Password Auth  : ${bright_yellow}$pass_auth${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}    ${ICON_NET} SSH Port       : ${bright_yellow}$ssh_port${reset}                                                ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[1]${reset}  ${ICON_UNLOCK} ${bright_white}Enable Root Login (Password)${reset}                                            ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[2]${reset}  ${ICON_LOCK}  ${bright_white}Enable Root Login (Key Only)${reset}                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[3]${reset}  ${ICON_STOP}  ${bright_white}Disable Root Login${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[4]${reset}  ${ICON_KEY}   ${bright_white}Change Root Password${reset}                                                   ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[5]${reset}  ${ICON_NET}   ${bright_white}Change SSH Port${reset}                                                        ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[6]${reset}  ${ICON_GEAR}  ${bright_white}Restart SSH Service${reset}                                                    ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_green}[7]${reset}  ${ICON_INFO}  ${bright_white}View SSH Logs${reset}                                                          ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_yellow}[b]${reset}  ${ICON_ARROW}  ${bright_white}Back to Main Menu${reset}                                                     ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}  ${bright_red}[0]${reset}  ${ICON_STOP}  ${bright_white}Exit${reset}                                                                  ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}│${reset}                                                                                              ${bold}${bright_cyan}│${reset}"
        echo -e "${bold}${bright_cyan}└──────────────────────────────────────────────────────────────────────────────────────────────────────┘${reset}"
        echo ""
        echo -ne "${bold}${bright_cyan}┌─[${bright_white}ROOT ACCESS${bright_cyan}]─[${bright_yellow}OPTION${bright_cyan}]${reset}\n"
        echo -ne "${bold}${bright_cyan}└─[${bright_green}➜${bright_cyan}]~${reset} "
        read -r root_choice
        
        case $root_choice in
            1)
                echo -e "\n${ICON_UNLOCK} ${bright_blue}Enabling Root Login with Password...${reset}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
                echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
                echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${ICON_CHECK} ${bright_green}Root login enabled!${reset}"
                sleep 2
                ;;
            2)
                echo -e "\n${ICON_LOCK} ${bright_blue}Enabling Root Login (Key Only)...${reset}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
                echo "PermitRootLogin prohibit-password" | sudo tee -a /etc/ssh/sshd_config
                echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${ICON_CHECK} ${bright_green}Root login with keys only enabled!${reset}"
                sleep 2
                ;;
            3)
                echo -e "\n${ICON_STOP} ${bright_red}Disabling Root Login...${reset}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${ICON_CHECK} ${bright_green}Root login disabled!${reset}"
                sleep 2
                ;;
            4)
                echo -e "\n${ICON_KEY} ${bright_blue}Changing Root Password...${reset}"
                sudo passwd root
                echo -e "${ICON_CHECK} ${bright_green}Password changed!${reset}"
                sleep 2
                ;;
            5)
                echo -ne "\n${ICON_NET} ${bright_yellow}Enter new SSH port: ${reset}"
                read -r new_port
                if [[ "$new_port" =~ ^[0-9]+$ ]] && [ "$new_port" -ge 22 ] && [ "$new_port" -le 65535 ]; then
                    sudo sed -i '/^Port/d' /etc/ssh/sshd_config
                    echo "Port $new_port" | sudo tee -a /etc/ssh/sshd_config
                    sudo systemctl restart sshd
                    echo -e "${ICON_CHECK} ${bright_green}SSH port changed to $new_port${reset}"
                else
                    echo -e "${ICON_ERROR} ${bright_red}Invalid port number${reset}"
                fi
                sleep 2
                ;;
            6)
                echo -e "\n${ICON_GEAR} ${bright_blue}Restarting SSH service...${reset}"
                sudo systemctl restart sshd
                echo -e "${ICON_CHECK} ${bright_green}SSH restarted!${reset}"
                sleep 2
                ;;
            7)
                echo -e "\n${ICON_INFO} ${bright_blue}SSH Logs:${reset}"
                sudo journalctl -u sshd -n 30 --no-pager
                echo -e "\n${dim}Press Enter to continue...${reset}"
                read
                ;;
            b|B)
                break
                ;;
            0)
                echo -e "\n${ICON_STOP} ${bright_red}Exiting...${reset}"
                exit 0
                ;;
            *)
                echo -e "\n${ICON_ERROR} ${bright_red}Invalid option!${reset}"
                sleep 1
                ;;
        esac
    done
}

# ==============================================================================
#                         MAIN PROGRAM LOOP
# ==============================================================================
while true; do
    draw_header
    show_main_menu
    read -r main_choice
    
    case $main_choice in
        1) idx_setup_menu ;;
        2) cloudflare_menu ;;
        3) tools_menu ;;
        4) vm_manager ;;
        5) tailscale_menu ;;
        6) xrdp_menu ;;
        7) root_access_menu ;;
        8) no_kvm_manager ;;
        0)
            echo -e "\n${ICON_STAR} ${bright_green}Thank you for using CODING PRIME System!${reset}"
            echo -e "${ICON_DIAMOND} ${bright_cyan}Developed by CODING PRIME + Nobita${reset}"
            echo -e "${ICON_STOP} ${bright_yellow}Exiting...${reset}"
            exit 0
            ;;
        *)
            echo -e "\n${ICON_ERROR} ${bright_red}Invalid option! Please enter 0-8${reset}"
            sleep 1
            ;;
    esac
done
