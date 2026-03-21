#!/bin/bash

# ===================================================================
#              CODINGPRIME - ULTIMATE SYSTEM CONTROL CENTER
#           Complete System Management Suite | v5.0
# ===================================================================
#                    Developed by CODING PRIME + Nobita
# ===================================================================

# ===================================================================
#                         COLOR THEME & STYLES
# ===================================================================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
DARK='\033[0;30m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
NC='\033[0m'

# Icons
ICON_CHECK="${GREEN}✓${NC}"
ICON_ERROR="${RED}✗${NC}"
ICON_WARN="${YELLOW}⚠${NC}"
ICON_INFO="${BLUE}ℹ${NC}"
ICON_RUN="${GREEN}▶${NC}"
ICON_STOP="${RED}■${NC}"
ICON_ARROW="${CYAN}→${NC}"
ICON_STAR="${YELLOW}★${NC}"

# ===================================================================
#                         SYSTEM DETECTION
# ===================================================================
get_cpu_usage() {
    local cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1 2>/dev/null)
    if [[ -z "$cpu_idle" ]]; then
        cpu_idle=$(top -bn1 | grep "%Cpu" | awk '{print $8}' | cut -d'%' -f1 2>/dev/null)
    fi
    local cpu_usage=$(echo "100 - ${cpu_idle:-0}" | bc 2>/dev/null || echo "0")
    printf "%.0f" "$cpu_usage"
}

get_ram_usage() {
    local total_ram=$(free -m | awk '/^Mem:/{print $2}' 2>/dev/null)
    local used_ram=$(free -m | awk '/^Mem:/{print $3}' 2>/dev/null)
    if [[ -n "$total_ram" && "$total_ram" -gt 0 ]]; then
        local ram_percent=$(echo "scale=0; $used_ram * 100 / $total_ram" | bc 2>/dev/null || echo "0")
        echo "$ram_percent"
    else
        echo "0"
    fi
}

get_network_status() {
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null 2>&1; then
        echo "${GREEN}CONNECTED${NC}"
    else
        echo "${RED}DISCONNECTED${NC}"
    fi
}

get_uptime_minutes() {
    if [[ -f /proc/uptime ]]; then
        local uptime_seconds=$(awk '{print $1}' /proc/uptime | cut -d'.' -f1)
        echo $((uptime_seconds / 60))
    else
        echo "0"
    fi
}

# ===================================================================
#                         BIG FONT GENERATOR
# ===================================================================
CodingPrime() {
    echo -e "${PURPLE}${BOLD}"
    echo "   ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ██████╗ ██████╗ ██╗███╗   ███╗███████╗"
    echo "  ██╔════╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝     ██╔══██╗██╔══██╗██║████╗ ████║██╔════╝"
    echo "  ██║     ██║   ██║██║  ██║██║██╔██╗ ██║██║  ███╗    ██████╔╝██████╔╝██║██╔████╔██║█████╗  "
    echo "  ██║     ██║   ██║██║  ██║██║██║╚██╗██║██║   ██║    ██╔     ██╔══██╗██║██║╚██╔╝██║██╔══╝  "
    echo "  ╚██████╗╚██████╔╝██████╔╝██║██║ ╚████║╚██████╔╝    ██║    ║██║  ██║██║██║ ╚═╝ ██║███████╗"
    echo "   ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝"
    echo -e "${NC}"
}

# ===================================================================
#                         HEADER & UI
# ===================================================================
draw_header() {
    clear
    local hostname=$(hostname)
    local uptime=$(get_uptime_minutes)
    local cpu=$(get_cpu_usage)
    local ram=$(get_ram_usage)
    local network=$(get_network_status)
    
    # Show big CODINGPRIME font
    show_codingprime_big
    
    echo -e "${PURPLE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    printf "║${WHITE} HOST:${NC} ${GREEN}%-10s${NC} ${WHITE}UPTIME:${NC} ${YELLOW}%-10s${NC} ${WHITE}LOAD:${NC} ${GREEN}%3s%%${NC}              ${PURPLE}║\n" "$hostname" "${uptime}min" "$cpu"
    printf "║${WHITE} SYSTEM HEALTH:${NC}  CPU: ${GREEN}%3s%%${NC}  RAM: ${GREEN}%3s%%${NC}  NETWORK: %-12s${PURPLE}║\n" "$cpu" "$ram" "$network"
    echo "╠══════════════════════════════════════════════════════════════════════╣"
    echo -e "${PURPLE}║${NC}                                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${WHITE}main menu${NC}                                                         ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${GREEN}[1]${NC} IDX / SETUP       ${GREEN}[5]${NC} TAILSCALE MESH                              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${GREEN}[2]${NC} CLOUDFLARE       ${GREEN}[6]${NC} XRDP INSTALL                                ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${GREEN}[3]${NC} TOOLS            ${GREEN}[7]${NC} ROOT ACCESS                                 ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${GREEN}[4]${NC} VM MANAGER       ${GREEN}[8]${NC} NO KVM VM                                   ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${RED}[0]${NC} EXIT                                                                    ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                                  ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${GRAY}                         CODING PRIME + Nobita${NC}"
    echo ""
}

# ===================================================================
#                         IDX / SETUP MENU
# ===================================================================
idx_setup_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - IDX / SETUP                          ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${WHITE}Available Setup Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} System Update & Upgrade"
        echo -e "  ${GREEN}[2]${NC} Install Essential Packages"
        echo -e "  ${GREEN}[3]${NC} Configure Firewall"
        echo -e "  ${GREEN}[4]${NC} Set Timezone"
        echo -e "  ${GREEN}[5]${NC} Create Swap Space"
        echo -e "  ${GREEN}[6]${NC} System Optimization"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r idx_choice
        
        case $idx_choice in
            1)
                echo -e "\n${BLUE}🔄 Updating system...${NC}"
                sudo apt update && sudo apt upgrade -y
                echo -e "${GREEN}✅ System updated!${NC}"
                sleep 2
                ;;
            2)
                echo -e "\n${BLUE}📦 Installing essential packages...${NC}"
                sudo apt install -y curl wget git vim htop net-tools ufw
                echo -e "${GREEN}✅ Packages installed!${NC}"
                sleep 2
                ;;
            3)
                echo -e "\n${BLUE}🔥 Configuring firewall...${NC}"
                sudo ufw allow 22
                sudo ufw allow 80
                sudo ufw allow 443
                sudo ufw --force enable
                echo -e "${GREEN}✅ Firewall configured!${NC}"
                sleep 2
                ;;
            4)
                echo -e "\n${BLUE}🌍 Setting timezone...${NC}"
                sudo timedatectl set-timezone UTC
                echo -e "${GREEN}✅ Timezone set to UTC!${NC}"
                sleep 2
                ;;
            5)
                echo -e "\n${BLUE}💾 Creating swap space...${NC}"
                sudo fallocate -l 2G /swapfile
                sudo chmod 600 /swapfile
                sudo mkswap /swapfile
                sudo swapon /swapfile
                echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
                echo -e "${GREEN}✅ Swap space created!${NC}"
                sleep 2
                ;;
            6)
                echo -e "\n${BLUE}⚡ Running system optimization...${NC}"
                echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
                echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
                sudo sysctl -p
                echo -e "${GREEN}✅ System optimized!${NC}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         CLOUDFLARE MENU
# ===================================================================
cloudflare_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - CLOUDFLARE MANAGER                   ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        # Check status
        if command -v cloudflared &>/dev/null; then
            if systemctl is-active --quiet cloudflared; then
                echo -e "${GREEN}✓ Cloudflared is RUNNING${NC}"
            else
                echo -e "${RED}✗ Cloudflared is STOPPED${NC}"
            fi
        else
            echo -e "${YELLOW}⚠ Cloudflared is NOT INSTALLED${NC}"
        fi
        
        echo ""
        echo -e "${WHITE}Available Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Install Cloudflared"
        echo -e "  ${GREEN}[2]${NC} Configure Tunnel"
        echo -e "  ${GREEN}[3]${NC} Start Tunnel"
        echo -e "  ${GREEN}[4]${NC} Stop Tunnel"
        echo -e "  ${GREEN}[5]${NC} View Logs"
        echo -e "  ${GREEN}[6]${NC} Uninstall"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r cf_choice
        
        case $cf_choice in
            1)
                echo -e "\n${BLUE}📥 Installing Cloudflared...${NC}"
                sudo mkdir -p --mode=0755 /usr/share/keyrings
                curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
                echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null
                sudo apt update && sudo apt install -y cloudflared
                echo -e "${GREEN}✅ Cloudflared installed!${NC}"
                sleep 2
                ;;
            2)
                echo -e "\n${BLUE}🔧 Configuring tunnel...${NC}"
                echo -e "${YELLOW}Paste your tunnel token:${NC}"
                read -r tunnel_token
                sudo cloudflared service install "$tunnel_token"
                echo -e "${GREEN}✅ Tunnel configured!${NC}"
                sleep 2
                ;;
            3)
                echo -e "\n${BLUE}🚀 Starting tunnel...${NC}"
                sudo systemctl start cloudflared
                sudo systemctl enable cloudflared
                echo -e "${GREEN}✅ Tunnel started!${NC}"
                sleep 2
                ;;
            4)
                echo -e "\n${BLUE}🛑 Stopping tunnel...${NC}"
                sudo systemctl stop cloudflared
                echo -e "${GREEN}✅ Tunnel stopped!${NC}"
                sleep 2
                ;;
            5)
                echo -e "\n${BLUE}📋 Showing logs...${NC}"
                sudo journalctl -u cloudflared -n 50 --no-pager
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            6)
                echo -e "\n${RED}⚠️ Uninstalling Cloudflared...${NC}"
                sudo cloudflared service uninstall 2>/dev/null
                sudo apt remove -y cloudflared
                echo -e "${GREEN}✅ Cloudflared removed!${NC}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         TOOLS MENU
# ===================================================================
tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - SYSTEM TOOLS                         ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${WHITE}Available Tools:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} System Information"
        echo -e "  ${GREEN}[2]${NC} Disk Usage Analyzer"
        echo -e "  ${GREEN}[3]${NC} Network Diagnostics"
        echo -e "  ${GREEN}[4]${NC} Process Manager"
        echo -e "  ${GREEN}[5]${NC} Service Manager"
        echo -e "  ${GREEN}[6]${NC} Log Viewer"
        echo -e "  ${GREEN}[7]${NC} Port Scanner"
        echo -e "  ${GREEN}[8]${NC} Speed Test"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select tool: ${NC}"
        read -r tool_choice
        
        case $tool_choice in
            1)
                clear
                echo -e "${BLUE}📊 System Information:${NC}"
                echo "================================"
                echo "Hostname: $(hostname)"
                echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
                echo "Kernel: $(uname -r)"
                echo "Uptime: $(uptime -p)"
                echo "CPU: $(nproc) cores"
                echo "Memory: $(free -h | awk '/^Mem:/{print $2}') total"
                echo "Disk: $(df -h / | awk 'NR==2{print $2}') total"
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            2)
                clear
                echo -e "${BLUE}💾 Disk Usage:${NC}"
                df -h
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            3)
                clear
                echo -e "${BLUE}🌐 Network Diagnostics:${NC}"
                echo "IP Address: $(hostname -I | awk '{print $1}')"
                echo "Gateway: $(ip route | grep default | awk '{print $3}')"
                echo "DNS: $(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')"
                echo ""
                echo "Ping Test:"
                ping -c 4 google.com
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            4)
                clear
                echo -e "${BLUE}⚡ Top Processes:${NC}"
                ps aux --sort=-%cpu | head -15
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            5)
                clear
                echo -e "${BLUE}⚙️ Running Services:${NC}"
                systemctl list-units --type=service --state=running | head -20
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            6)
                clear
                echo -e "${BLUE}📋 Last 20 System Logs:${NC}"
                journalctl -n 20 --no-pager
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            7)
                clear
                echo -e "${BLUE}🔌 Open Ports:${NC}"
                ss -tuln
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            8)
                clear
                echo -e "${BLUE}📡 Running Speed Test...${NC}"
                if command -v speedtest-cli &>/dev/null; then
                    speedtest-cli --simple
                else
                    echo -e "${YELLOW}Installing speedtest-cli...${NC}"
                    sudo apt install -y speedtest-cli
                    speedtest-cli --simple
                fi
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         VM MANAGER (KVM)
# ===================================================================
vm_manager() {
    # Check and install dependencies
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "${BLUE}📦 Installing QEMU/KVM dependencies...${NC}"
        sudo apt update
        sudo apt install -y qemu-system-x86 qemu-utils cloud-image-utils wget lsof
    fi
    
    # Check if KVM is available
    KVM_AVAILABLE=false
    if [ -e /dev/kvm ]; then
        KVM_AVAILABLE=true
        echo -e "${GREEN}✓ KVM acceleration available${NC}"
    else
        echo -e "${YELLOW}⚠ KVM not available - using software emulation${NC}"
    fi
    sleep 2
    
    # VM directory
    VM_DIR="${HOME}/vms"
    mkdir -p "$VM_DIR"
    
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - VM MANAGER (KVM)                     ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        # List existing VMs
        local vms=($(find "$VM_DIR" -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort))
        local vm_count=${#vms[@]}
        
        if [ $vm_count -gt 0 ]; then
            echo -e "${WHITE}Existing VMs:${NC}"
            for i in "${!vms[@]}"; do
                local status="💤"
                if pgrep -f "qemu-system.*${vms[$i]}" >/dev/null; then
                    status="🚀"
                fi
                printf "  %2d) %s %s\n" $((i+1)) "${vms[$i]}" "$status"
            done
            echo ""
        fi
        
        echo -e "${WHITE}Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Create New VM"
        if [ $vm_count -gt 0 ]; then
            echo -e "  ${GREEN}[2]${NC} Start VM"
            echo -e "  ${GREEN}[3]${NC} Stop VM"
            echo -e "  ${GREEN}[4]${NC} Delete VM"
            echo -e "  ${GREEN}[5]${NC} VM Info"
        fi
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r vm_choice
        
        case $vm_choice in
            1)
                create_new_vm "$VM_DIR" "$KVM_AVAILABLE"
                ;;
            2)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number to start: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        start_vm "${vms[$((vm_num-1))]}" "$VM_DIR" "$KVM_AVAILABLE"
                    fi
                fi
                ;;
            3)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number to stop: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        stop_vm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            4)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${RED}Enter VM number to delete: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        delete_vm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            5)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number for info: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        show_vm_info "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         VM HELPER FUNCTIONS
# ===================================================================
create_new_vm() {
    local VM_DIR=$1
    local KVM_AVAILABLE=$2
    
    echo -e "\n${BLUE}🆕 Creating New VM${NC}"
    
    # OS Selection
    echo -e "${WHITE}Select OS:${NC}"
    echo "  1) Ubuntu 22.04"
    echo "  2) Ubuntu 24.04"
    echo "  3) Debian 12"
    echo "  4) Debian 13"
    echo "  5) Fedora 40"
    
    echo -ne "${YELLOW}Choice: ${NC}"
    read -r os_choice
    
    case $os_choice in
        1) IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"; OS_NAME="ubuntu22" ;;
        2) IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"; OS_NAME="ubuntu24" ;;
        3) IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"; OS_NAME="debian12" ;;
        4) IMG_URL="https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-generic-amd64-daily.qcow2"; OS_NAME="debian13" ;;
        5) IMG_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2"; OS_NAME="fedora40" ;;
        *) echo -e "${RED}Invalid selection${NC}"; return ;;
    esac
    
    echo -ne "${YELLOW}VM Name: ${NC}"
    read -r VM_NAME
    
    echo -ne "${YELLOW}Memory (MB) [2048]: ${NC}"
    read -r MEMORY
    MEMORY=${MEMORY:-2048}
    
    echo -ne "${YELLOW}CPUs [2]: ${NC}"
    read -r CPUS
    CPUS=${CPUS:-2}
    
    echo -ne "${YELLOW}Disk Size [20G]: ${NC}"
    read -r DISK_SIZE
    DISK_SIZE=${DISK_SIZE:-20G}
    
    echo -ne "${YELLOW}SSH Port [2222]: ${NC}"
    read -r SSH_PORT
    SSH_PORT=${SSH_PORT:-2222}
    
    echo -ne "${YELLOW}Username [root]: ${NC}"
    read -r USERNAME
    USERNAME=${USERNAME:-root}
    
    echo -ne "${YELLOW}Password [root]: ${NC}"
    read -r PASSWORD
    PASSWORD=${PASSWORD:-root}
    
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"
    
    # Download image
    echo -e "${BLUE}📥 Downloading image...${NC}"
    if [ ! -f "$IMG_FILE" ]; then
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE"
    fi
    
    # Resize disk
    echo -e "${BLUE}💾 Resizing disk...${NC}"
    qemu-img resize "$IMG_FILE" "$DISK_SIZE"
    
    # Create cloud-init
    echo -e "${BLUE}☁️ Creating cloud-init...${NC}"
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
    
    echo -e "${GREEN}✅ VM '$VM_NAME' created successfully!${NC}"
    echo -e "${YELLOW}SSH: ssh -p $SSH_PORT $USERNAME@localhost${NC}"
    sleep 2
}

start_vm() {
    local VM_NAME=$1
    local VM_DIR=$2
    local KVM_AVAILABLE=$3
    
    source "$VM_DIR/$VM_NAME.conf"
    
    if pgrep -f "qemu-system.*$IMG_FILE" >/dev/null; then
        echo -e "${YELLOW}⚠ VM already running${NC}"
        sleep 2
        return
    fi
    
    echo -e "${BLUE}🚀 Starting VM: $VM_NAME${NC}"
    
    # QEMU command
    local qemu_cmd=(
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
    
    echo -e "${GREEN}✅ VM started! SSH: ssh -p $SSH_PORT $USERNAME@localhost${NC}"
    echo -e "${YELLOW}Press Ctrl+A then X to exit console${NC}"
    sleep 2
    
    "${qemu_cmd[@]}"
}

stop_vm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    pkill -f "qemu-system.*$IMG_FILE"
    echo -e "${GREEN}✅ VM stopped${NC}"
    sleep 2
}

delete_vm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    echo -e "${RED}⚠ This will permanently delete VM '$VM_NAME'${NC}"
    echo -ne "${YELLOW}Are you sure? (y/N): ${NC}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        source "$VM_DIR/$VM_NAME.conf"
        pkill -f "qemu-system.*$IMG_FILE" 2>/dev/null
        rm -f "$IMG_FILE" "$SEED_FILE" "$VM_DIR/$VM_NAME.conf"
        echo -e "${GREEN}✅ VM deleted${NC}"
    fi
    sleep 2
}

show_vm_info() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    echo -e "\n${BLUE}📊 VM Information: $VM_NAME${NC}"
    echo "================================"
    echo "OS: $OS_NAME"
    echo "Memory: $MEMORY MB"
    echo "CPUs: $CPUS"
    echo "Disk: $DISK_SIZE"
    echo "SSH Port: $SSH_PORT"
    echo "Username: $USERNAME"
    echo "Password: $PASSWORD"
    echo "Created: $CREATED"
    echo -e "\n${GRAY}Press Enter to continue...${NC}"
    read
}

# ===================================================================
#                         NO KVM VM MANAGER
# ===================================================================
no_kvm_manager() {
    # Check and install dependencies
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "${BLUE}📦 Installing QEMU dependencies...${NC}"
        sudo apt update
        sudo apt install -y qemu-system-x86 qemu-utils cloud-image-utils wget lsof
    fi
    
    # VM directory
    VM_DIR="${HOME}/vms-nokvm"
    mkdir -p "$VM_DIR"
    
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - NO KVM VM MANAGER                    ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${YELLOW}⚠ Running in pure software emulation mode (no KVM)${NC}"
        echo ""
        
        # List existing VMs
        local vms=($(find "$VM_DIR" -name "*.conf" -exec basename {} .conf \; 2>/dev/null | sort))
        local vm_count=${#vms[@]}
        
        if [ $vm_count -gt 0 ]; then
            echo -e "${WHITE}Existing VMs:${NC}"
            for i in "${!vms[@]}"; do
                local status="💤"
                if pgrep -f "qemu-system.*${vms[$i]}" >/dev/null; then
                    status="🚀"
                fi
                printf "  %2d) %s %s\n" $((i+1)) "${vms[$i]}" "$status"
            done
            echo ""
        fi
        
        echo -e "${WHITE}Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Create New VM"
        if [ $vm_count -gt 0 ]; then
            echo -e "  ${GREEN}[2]${NC} Start VM"
            echo -e "  ${GREEN}[3]${NC} Stop VM"
            echo -e "  ${GREEN}[4]${NC} Delete VM"
            echo -e "  ${GREEN}[5]${NC} VM Info"
        fi
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r vm_choice
        
        case $vm_choice in
            1)
                create_new_vm_nokvm "$VM_DIR"
                ;;
            2)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number to start: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        start_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            3)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number to stop: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        stop_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            4)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${RED}Enter VM number to delete: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        delete_vm_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            5)
                if [ $vm_count -gt 0 ]; then
                    echo -ne "${YELLOW}Enter VM number for info: ${NC}"
                    read -r vm_num
                    if [[ "$vm_num" =~ ^[0-9]+$ ]] && [ "$vm_num" -ge 1 ] && [ "$vm_num" -le $vm_count ]; then
                        show_vm_info_nokvm "${vms[$((vm_num-1))]}" "$VM_DIR"
                    fi
                fi
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

create_new_vm_nokvm() {
    local VM_DIR=$1
    
    echo -e "\n${BLUE}🆕 Creating New VM (No KVM)${NC}"
    
    # OS Selection
    echo -e "${WHITE}Select OS:${NC}"
    echo "  1) Ubuntu 22.04"
    echo "  2) Ubuntu 24.04"
    echo "  3) Debian 12"
    echo "  4) Debian 13"
    
    echo -ne "${YELLOW}Choice: ${NC}"
    read -r os_choice
    
    case $os_choice in
        1) IMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"; OS_NAME="ubuntu22" ;;
        2) IMG_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"; OS_NAME="ubuntu24" ;;
        3) IMG_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"; OS_NAME="debian12" ;;
        4) IMG_URL="https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-generic-amd64-daily.qcow2"; OS_NAME="debian13" ;;
        *) echo -e "${RED}Invalid selection${NC}"; return ;;
    esac
    
    echo -ne "${YELLOW}VM Name: ${NC}"
    read -r VM_NAME
    
    echo -ne "${YELLOW}Memory (MB) [1024]: ${NC}"
    read -r MEMORY
    MEMORY=${MEMORY:-1024}
    
    echo -ne "${YELLOW}CPUs [1]: ${NC}"
    read -r CPUS
    CPUS=${CPUS:-1}
    
    echo -ne "${YELLOW}Disk Size [10G]: ${NC}"
    read -r DISK_SIZE
    DISK_SIZE=${DISK_SIZE:-10G}
    
    echo -ne "${YELLOW}SSH Port [2222]: ${NC}"
    read -r SSH_PORT
    SSH_PORT=${SSH_PORT:-2222}
    
    IMG_FILE="$VM_DIR/$VM_NAME.img"
    SEED_FILE="$VM_DIR/$VM_NAME-seed.iso"
    
    # Download image
    echo -e "${BLUE}📥 Downloading image...${NC}"
    if [ ! -f "$IMG_FILE" ]; then
        wget -q --show-progress "$IMG_URL" -O "$IMG_FILE"
    fi
    
    # Resize disk
    echo -e "${BLUE}💾 Resizing disk...${NC}"
    qemu-img resize "$IMG_FILE" "$DISK_SIZE"
    
    # Create cloud-init
    echo -e "${BLUE}☁️ Creating cloud-init...${NC}"
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
    
    # Save config
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
    
    echo -e "${GREEN}✅ VM '$VM_NAME' created successfully!${NC}"
    echo -e "${YELLOW}SSH: ssh -p $SSH_PORT root@localhost (password: root)${NC}"
    sleep 2
}

start_vm_nokvm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    if pgrep -f "qemu-system.*$IMG_FILE" >/dev/null; then
        echo -e "${YELLOW}⚠ VM already running${NC}"
        sleep 2
        return
    fi
    
    echo -e "${BLUE}🚀 Starting VM: $VM_NAME (Software Emulation)${NC}"
    
    # Pure QEMU command without KVM
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
    
    echo -e "${GREEN}✅ VM started! SSH: ssh -p $SSH_PORT root@localhost${NC}"
}

stop_vm_nokvm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    pkill -f "qemu-system.*$IMG_FILE"
    echo -e "${GREEN}✅ VM stopped${NC}"
    sleep 2
}

delete_vm_nokvm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    echo -e "${RED}⚠ This will permanently delete VM '$VM_NAME'${NC}"
    echo -ne "${YELLOW}Are you sure? (y/N): ${NC}"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        source "$VM_DIR/$VM_NAME.conf"
        pkill -f "qemu-system.*$IMG_FILE" 2>/dev/null
        rm -f "$IMG_FILE" "$SEED_FILE" "$VM_DIR/$VM_NAME.conf"
        echo -e "${GREEN}✅ VM deleted${NC}"
    fi
    sleep 2
}

show_vm_info_nokvm() {
    local VM_NAME=$1
    local VM_DIR=$2
    
    source "$VM_DIR/$VM_NAME.conf"
    
    echo -e "\n${BLUE}📊 VM Information: $VM_NAME${NC}"
    echo "================================"
    echo "OS: $OS_NAME"
    echo "Memory: $MEMORY MB"
    echo "CPUs: $CPUS"
    echo "Disk: $DISK_SIZE"
    echo "SSH Port: $SSH_PORT"
    echo "Username: root"
    echo "Password: root"
    echo "Created: $CREATED"
    echo -e "\n${GRAY}Press Enter to continue...${NC}"
    read
}

# ===================================================================
#                         TAILSCALE MENU
# ===================================================================
tailscale_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - TAILSCALE MESH                       ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        # Check status
        if command -v tailscale &>/dev/null; then
            if systemctl is-active --quiet tailscaled; then
                echo -e "${GREEN}✓ Tailscale is RUNNING${NC}"
                echo -e "${WHITE}IP: ${CYAN}$(tailscale ip -4 2>/dev/null || echo "Not connected")${NC}"
            else
                echo -e "${RED}✗ Tailscale is STOPPED${NC}"
            fi
        else
            echo -e "${YELLOW}⚠ Tailscale is NOT INSTALLED${NC}"
        fi
        
        echo ""
        echo -e "${WHITE}Available Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Install Tailscale"
        echo -e "  ${GREEN}[2]${NC} Connect/Authenticate"
        echo -e "  ${GREEN}[3]${NC} Show Network Map"
        echo -e "  ${GREEN}[4]${NC} Disconnect"
        echo -e "  ${GREEN}[5]${NC} Uninstall"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r ts_choice
        
        case $ts_choice in
            1)
                echo -e "\n${BLUE}📥 Installing Tailscale...${NC}"
                curl -fsSL https://tailscale.com/install.sh | sh
                sudo systemctl enable --now tailscaled
                echo -e "${GREEN}✅ Tailscale installed!${NC}"
                sleep 2
                ;;
            2)
                echo -e "\n${BLUE}🔐 Connecting to Tailscale...${NC}"
                sudo tailscale up
                echo -e "${GREEN}✅ Connected!${NC}"
                sleep 2
                ;;
            3)
                echo -e "\n${BLUE}🌐 Tailscale Network Map:${NC}"
                tailscale status
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            4)
                echo -e "\n${BLUE}🔌 Disconnecting...${NC}"
                sudo tailscale down
                echo -e "${GREEN}✅ Disconnected!${NC}"
                sleep 2
                ;;
            5)
                echo -e "\n${RED}⚠ Uninstalling Tailscale...${NC}"
                sudo apt purge -y tailscale
                sudo rm -rf /var/lib/tailscale
                echo -e "${GREEN}✅ Tailscale removed!${NC}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         XRDP INSTALL MENU
# ===================================================================
xrdp_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - XRDP INSTALLER                       ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        # Check status
        if systemctl is-active --quiet xrdp; then
            echo -e "${GREEN}✓ XRDP is RUNNING${NC}"
        else
            echo -e "${RED}✗ XRDP is NOT INSTALLED/RUNNING${NC}"
        fi
        
        echo ""
        echo -e "${WHITE}Available Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Install XRDP with XFCE4"
        echo -e "  ${GREEN}[2]${NC} Start XRDP Service"
        echo -e "  ${GREEN}[3]${NC} Stop XRDP Service"
        echo -e "  ${GREEN}[4]${NC} Restart XRDP Service"
        echo -e "  ${GREEN}[5]${NC} View Status"
        echo -e "  ${GREEN}[6]${NC} Uninstall"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r xrdp_choice
        
        case $xrdp_choice in
            1)
                echo -e "\n${BLUE}🚀 Installing XRDP and XFCE4...${NC}"
                sudo apt update
                sudo apt install -y xrdp xfce4 xfce4-goodies dbus-x11
                sudo systemctl enable xrdp
                echo -e "root\nroot" | sudo passwd root
                sudo sed -i 's/^AllowRootLogin=false/AllowRootLogin=true/' /etc/xrdp/sesman.ini || true
                sudo sed -i 's/^auth required pam_succeed_if.so user != root quiet_success/#&/' /etc/pam.d/xrdp-sesman || true
                echo "startxfce4" > ~/.xsession
                chmod +x ~/.xsession
                sudo systemctl restart xrdp
                echo -e "${GREEN}✅ XRDP installed!${NC}"
                echo -e "${YELLOW}Login: root / root${NC}"
                sleep 3
                ;;
            2)
                echo -e "\n${BLUE}🚀 Starting XRDP...${NC}"
                sudo systemctl start xrdp
                echo -e "${GREEN}✅ XRDP started!${NC}"
                sleep 2
                ;;
            3)
                echo -e "\n${BLUE}🛑 Stopping XRDP...${NC}"
                sudo systemctl stop xrdp
                echo -e "${GREEN}✅ XRDP stopped!${NC}"
                sleep 2
                ;;
            4)
                echo -e "\n${BLUE}🔄 Restarting XRDP...${NC}"
                sudo systemctl restart xrdp
                echo -e "${GREEN}✅ XRDP restarted!${NC}"
                sleep 2
                ;;
            5)
                echo -e "\n${BLUE}📊 XRDP Status:${NC}"
                sudo systemctl status xrdp --no-pager
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            6)
                echo -e "\n${RED}⚠ Uninstalling XRDP...${NC}"
                sudo systemctl stop xrdp
                sudo apt purge -y xrdp xfce4 xfce4-goodies
                sudo rm -rf /etc/xrdp
                echo -e "${GREEN}✅ XRDP removed!${NC}"
                sleep 2
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         ROOT ACCESS MENU
# ===================================================================
root_access_menu() {
    while true; do
        clear
        echo -e "${CYAN}${BOLD}"
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║                    CODINGPRIME - ROOT ACCESS MANAGER                  ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        # Show current SSH config
        echo -e "${WHITE}Current SSH Configuration:${NC}"
        echo -e "  Root Login: $(sudo grep -E "^PermitRootLogin" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' || echo "not set")"
        echo -e "  Password Auth: $(sudo grep -E "^PasswordAuthentication" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' || echo "not set")"
        echo -e "  SSH Port: $(sudo grep -E "^Port" /etc/ssh/sshd_config | tail -1 | awk '{print $2}' || echo "22")"
        echo ""
        
        echo -e "${WHITE}Available Options:${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} Enable Root Login (Password)"
        echo -e "  ${GREEN}[2]${NC} Enable Root Login (Key Only)"
        echo -e "  ${RED}[3]${NC} Disable Root Login"
        echo -e "  ${GREEN}[4]${NC} Change Root Password"
        echo -e "  ${GREEN}[5]${NC} Change SSH Port"
        echo -e "  ${GREEN}[6]${NC} Restart SSH Service"
        echo -e "  ${GREEN}[7]${NC} View SSH Logs"
        echo -e "  ${GREEN}[b]${NC} Back to Main Menu"
        echo ""
        echo -ne "${YELLOW}Select option: ${NC}"
        read -r root_choice
        
        case $root_choice in
            1)
                echo -e "\n${BLUE}🔓 Enabling Root Login with Password...${NC}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
                echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
                echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${GREEN}✅ Root login enabled!${NC}"
                sleep 2
                ;;
            2)
                echo -e "\n${BLUE}🔑 Enabling Root Login (Key Only)...${NC}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
                echo "PermitRootLogin prohibit-password" | sudo tee -a /etc/ssh/sshd_config
                echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${GREEN}✅ Root login with keys only enabled!${NC}"
                sleep 2
                ;;
            3)
                echo -e "\n${RED}🔒 Disabling Root Login...${NC}"
                sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
                echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
                sudo systemctl restart sshd
                echo -e "${GREEN}✅ Root login disabled!${NC}"
                sleep 2
                ;;
            4)
                echo -e "\n${BLUE}🔐 Changing Root Password...${NC}"
                sudo passwd root
                echo -e "${GREEN}✅ Password changed!${NC}"
                sleep 2
                ;;
            5)
                echo -ne "\n${YELLOW}Enter new SSH port: ${NC}"
                read -r new_port
                if [[ "$new_port" =~ ^[0-9]+$ ]] && [ "$new_port" -ge 22 ] && [ "$new_port" -le 65535 ]; then
                    sudo sed -i '/^Port/d' /etc/ssh/sshd_config
                    echo "Port $new_port" | sudo tee -a /etc/ssh/sshd_config
                    sudo systemctl restart sshd
                    echo -e "${GREEN}✅ SSH port changed to $new_port${NC}"
                else
                    echo -e "${RED}❌ Invalid port number${NC}"
                fi
                sleep 2
                ;;
            6)
                echo -e "\n${BLUE}🔄 Restarting SSH service...${NC}"
                sudo systemctl restart sshd
                echo -e "${GREEN}✅ SSH restarted!${NC}"
                sleep 2
                ;;
            7)
                echo -e "\n${BLUE}📋 SSH Logs:${NC}"
                sudo journalctl -u sshd -n 30 --no-pager
                echo -e "\n${GRAY}Press Enter to continue...${NC}"
                read
                ;;
            b|B)
                break
                ;;
            *)
                echo -e "${RED}❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================
#                         MAIN LOOP
# ===================================================================
while true; do
    draw_header
    echo -ne "${WHITE}${BOLD}Select option (0-8): ${NC}"
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
            echo -e "\n${GREEN}Thank you for using CODINGPRIME System Control Center!${NC}"
            echo -e "${GRAY}Developed by CODING PRIME + Nobita${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option! Please enter 0-8${NC}"
            sleep 1
            ;;
    esac
done
