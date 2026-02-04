#!/bin/bash

# Rəng Kodları
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m' 

# Ekranı təmizlə
clear

# Nmap yoxlanışı
if ! command -v nmap &> /dev/null; then
    echo -e "${RED}[!] Nmap sistemi üzərində tapılmadı.${NC}"
    echo -e "${YELLOW}[*] Quraşdırmaq üçün: sudo apt update && sudo apt install nmap${NC}"
    exit 1
fi

# Log qovluğu
mkdir -p hack_logs
LOG_FILE="hack_logs/nmap_res_$(date +'%Y%m%d_%H%M%S').txt"

ana_menu() {
    clear
    echo -e "${RED}"
    echo "  ██╗  ██╗ █████╗  ██████╗██╗  ██╗"
    echo "  ██║  ██║██╔══██╗██╔════╝██║ ██╔╝"
    echo "  ███████║███████║██║     █████╔╝ "
    echo "  ██╔══██║██╔══██║██║     ██╔═██╗ "
    echo "  ██║  ██║██║  ██║╚██████╗██║  ██╗"
    echo "  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    
    echo -e "${WHITE}"
    echo "              ______"
    echo "           .-'      '-."
    echo "          /            \\"
    echo "         |              |"
    echo "         |,  .-.  .-.  ,|"
    echo "         | )(__/  \\__)( |"
    echo "         |/     /\\     \\|"
    echo "         (_     ^^     _)"
    echo "          \\__|IIIIII|__/"
    echo "           | \\IIIIII/ |"
    echo "           \\          /"
    echo "            '--------'"
    
    echo -e "${GREEN}"
    echo "        [-- HACK NMAP INTERFACE --]"
    echo -e "${NC}"
    echo -e "${RED}⚡ HACK NMAP Ana Menyu - Bir kategoriya seçin (1-10)${NC}"
    echo -e "${YELLOW}Bütün funksiyalar işləkdir. Loglar hack_logs daxilinə yazılır.${NC}"
    echo -e "${GREEN}"
    echo "1) Port Skanerləri"
    echo "2) Servis & Versiya Analizi"
    echo "3) Əməliyyat Sistemi (OS) Tespiti"
    echo "4) Firewall & Filter Bypass"
    echo "5) NSE Script (Zəiflik) Taramaları"
    echo "6) Şəbəkə Kəşfi & Topologiya"
    echo "7) Sürət & Zamanlama Ayarları"
    echo "8) Hədəf Təyini Texnikaları"
    echo "9) Spoofing / Fragmentation (Gizlilik)"
    echo "10) Full Kombinasiya (Aqressiv)"
    echo "0) Çıxış"
    echo -e "${NC}"
    read -p "Seçiminiz (1-10 | 0): " secim

    case $secim in
        1) kategori1 ;;
        2) kategori2 ;;
        3) kategori3 ;;
        4) kategori4 ;;
        5) kategori5 ;;
        6) kategori6 ;;
        7) kategori7 ;;
        8) kategori8 ;;
        9) kategori9 ;;
        10) kategori10 ;;
        0) echo -e "${RED}Sistemdən çıxılır...${NC}" && exit 0 ;;
        *) echo -e "${RED}Yanlış seçim!${NC}"; sleep 1; ana_menu ;;
    esac
}

kategori1() {
    clear
    echo -e "${RED}--- Port Skanerləri ---${NC}"
    echo "1) Sürətli skan (-F)"
    echo "2) Spesifik portlar (-p)"
    echo "3) Bütün portlar (-p-)"
    echo "4) TCP SYN (Stealth)"
    echo "5) TCP Connect"
    echo "6) UDP Skan"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf IP/Domain: " hedef
    case $secim in
        1) nmap -F "$hedef" | tee -a "$LOG_FILE" ;;
        2) read -p "Port(lar): " p; nmap -p "$p" "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -p- "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -sS "$hedef" | tee -a "$LOG_FILE" ;;
        5) nmap -sT "$hedef" | tee -a "$LOG_FILE" ;;
        6) nmap -sU "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori1
}

kategori2() {
    clear
    echo -e "${RED}--- Servis & Versiya Analizi ---${NC}"
    echo "1) Versiya tespiti (-sV)"
    echo "2) Aqressiv versiya analizi"
    echo "3) Banner Grab taraması"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) nmap -sV "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -sV --version-intensity 5 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap --script=banner "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori2
}

kategori3() {
    clear
    echo -e "${RED}--- OS Tespiti ---${NC}"
    echo "1) Standart OS tespiti (-O)"
    echo "2) Təxmini OS analizi (--osscan-guess)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) nmap -O "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -O --osscan-guess "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori3
}

kategori4() {
    clear
    echo -e "${RED}--- Firewall & Filter Bypass ---${NC}"
    echo "1) ACK Skan (Filter yoxla)"
    echo "2) Fragmented paketlər (-f)"
    echo "3) Bad Checksum göndər"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) nmap -sA "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -f "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap --badsum "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori4
}

kategori5() {
    clear
    echo -e "${RED}--- NSE Script (Zəiflik) Taramaları ---${NC}"
    echo "1) Zəiflik taraması (--script vuln)"
    echo "2) Brute Force scriptləri"
    echo "3) Təhlükəsizlik yoxlanışı (default)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) nmap --script vuln "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap --script brute "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -sC "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori5
}

kategori6() {
    clear
    echo -e "${RED}--- Şəbəkə Kəşfi & Topologiya ---${NC}"
    echo "1) Ping Skan (Hostları tap)"
    echo "2) Traceroute (Yol analizi)"
    echo "3) DNS Discovery"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf (məs: 192.168.1.0/24): " hedef
    case $secim in
        1) nmap -sn "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap --traceroute "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap --script dns-brute "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori6
}

kategori7() {
    clear
    echo -e "${RED}--- Sürət & Zamanlama Ayarları ---${NC}"
    echo "1) T1 (Çox yavaş - Stealth)"
    echo "2) T3 (Normal)"
    echo "3) T4 (Sürətli)"
    echo "4) T5 (Aqressiv)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) nmap -T1 "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -T3 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -T4 "$hedef" | tee -a "$LOG_FILE" ;;
        4) nmap -T5 "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori7
}

kategori8() {
    clear
    echo -e "${RED}--- Hədəf Təyini Texnikaları ---${NC}"
    echo "1) Random IP taraması (-iR)"
    echo "2) Fayldan hədəf oxu (-iL)"
    echo "3) Müəyyən IP-ləri xaric et (--exclude)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    case $secim in
        1) read -p "Sayı: " n; nmap -iR "$n" | tee -a "$LOG_FILE" ;;
        2) read -p "Fayl yolu: " f; nmap -iL "$f" | tee -a "$LOG_FILE" ;;
        3) read -p "Hədəf: " h; read -p "Xaric edilən: " e; nmap "$h" --exclude "$e" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori8
}

kategori9() {
    clear
    echo -e "${RED}--- Spoofing / Fragmentation ---${NC}"
    echo "1) IP Spoofing (-S)"
    echo "2) MAC Spoofing"
    echo "3) Decoy Scan (Kamuflyaj)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf: " hedef
    case $secim in
        1) read -p "Sahte IP: " s; nmap -S "$s" "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        3) read -p "Decoy IP-lər (vergüllə): " d; nmap -D "$d" "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori9
}

kategori10() {
    clear
    echo -e "${RED}--- HACK COMBOS ---${NC}"
    echo "1) Full Port + Service + Script (Deep Scan)"
    echo "2) Stealth + Fragmented + MAC Spoof"
    echo "3) Canavar Modu (Hər şey daxil)"
    echo "0) Geri"
    read -p "Seçim: " secim
    [[ "$secim" == "0" ]] && ana_menu
    read -p "Hədəf IP: " hedef
    case $secim in
        1) nmap -p- -sV -sC -T4 "$hedef" | tee -a "$LOG_FILE" ;;
        2) nmap -sS -f --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
        3) nmap -A -T5 -f -sS -D RND:5 --spoof-mac 0 "$hedef" | tee -a "$LOG_FILE" ;;
    esac
    read -p "Davam etmək üçün Enter..." _; kategori10
}

ana_menu
