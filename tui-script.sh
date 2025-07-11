#!/bin/ash

COLOR_RED="\033[31m"
COLOR_GOLD="\033[33m"
COLOR_CYAN="\033[38;2;36;255;255m" # #24ffff
COLOR_RESET="\033[0m"
MAX_CMD_LEN=2048

print_banner() {
    echo -e "$COLOR_GOLD"
    echo "░█████╗░██╗░░░░░░█████╗░██╗░░░██╗██████╗░███████╗███╗░░░███╗░█████╗░██████╗░░██████╗"
    echo "██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝"
    echo "██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░"
    echo "██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗"
    echo "╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝"
    echo "░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚════╝░╚════╝░"
    echo -e "$COLOR_RESET"
    echo -e "$COLOR_CYAN claudemods Alpine Sysutil v1.0\n\n$COLOR_RESET"
}

execute_command() {
    local command="$1"
    echo -ne "$COLOR_CYAN [EXECUTING] $COLOR_RESET"
    
    eval "$command"
    local status=$?
    
    if [ $status -ne 0 ]; then
        echo -e "$COLOR_RED\n[ERROR] Command failed with status $status$COLOR_RESET"
    else
        echo -e "$COLOR_CYAN\n[SUCCESS] Command completed$COLOR_RESET"
    fi
    
    echo -e "\nPress Enter to continue..."
    read -r
}

get_key() {
    local c
    read -rsn1 c
    if [ "$c" = $'\033' ]; then
        read -rsn2 c
    fi
    echo "$c"
}

main() {
    local root_password
    local selected=0
    local commands=(
        "Fix 'failed to synchronize all databases' for apk"
        "Fix 'unable to lock database' for apk"
        "Fix clock time"
        "Fix connectivity issues"
        "Fix corrupted packages"
        "Fix login issues"
        "See system logs"
        "Update system"
        "Quit"
    )
    local num_commands=${#commands[@]}

    # Save terminal settings
    local oldt
    oldt=$(stty -g)
    stty -icanon -echo

    print_banner

    # Get root password
    echo -ne "$COLOR_CYAN Password: $COLOR_RESET"
    stty -echo
    read -r root_password
    stty echo
    echo -e "\n"

    while true; do
        clear
        print_banner

        echo -e "$COLOR_CYAN  Fix Alpine Linux"
        echo -e "  --------------$COLOR_RESET"

        for ((i=0; i<num_commands; i++)); do
            if [ $i -eq $selected ]; then
                echo -e "$COLOR_GOLD\033[1m➤ ${commands[$i]}\033[0m\n$COLOR_RESET"
            else
                echo -e "$COLOR_CYAN  ${commands[$i]}\n$COLOR_RESET"
            fi
        done

        local c=$(get_key)

        case $c in
            'A') # Up arrow
                if [ $selected -gt 0 ]; then
                    ((selected--))
                fi
                ;;
            'B') # Down arrow
                if [ $selected -lt $((num_commands - 1)) ]; then
                    ((selected++))
                fi
                ;;
            $'\n')
                local command="echo '$root_password' | su -c '"

                case "${commands[$selected]}" in
                    "Quit")
                        stty "$oldt"
                        exit 0
                        ;;
                    "Fix 'failed to synchronize all databases' for apk")
                        command+="rm -rf /var/cache/apk/* && apk update'"
                        ;;
                    "Fix 'unable to lock database' for apk")
                        command+="rm -f /var/lib/apk/db/lock'"
                        ;;
                    "Fix clock time")
                        command+="time_str=\$(curl -sI \"http://google.com\" | grep -i \"^date:\" | cut -d\" \" -f2-) && date -s \"\$time_str\" &>/dev/null && hwclock --systohc &>/dev/null'"
                        ;;
                    "Fix connectivity issues")
                        command+="apk del networkmanager --force-broken-world && rm -rf /etc/NetworkManager && apk add networkmanager && rc-service networkmanager restart'"
                        ;;
                    "Fix corrupted packages")
                        command+="apk fix'"
                        ;;
                    "Fix login issues")
                        command+="apk add --force linux-firmware linux-firmware-none'"
                        ;;
                    "See system logs")
                        command+="dmesg'"
                        ;;
                    "Update system")
                        command+="apk update && apk upgrade'"
                        ;;
                esac

                execute_command "$command"
                ;;
        esac
    done

    stty "$oldt"
}

main
