#!/bin/sh

COLOR_RED="\033[31m"
COLOR_GOLD="\033[33m"
COLOR_CYAN="\033[36m"
COLOR_RESET="\033[0m"

print_banner() {
    printf "${COLOR_GOLD}"
    printf "░█████╗░██╗░░░░░░█████╗░██╗░░░██╗██████╗░███████╗███╗░░░███╗░█████╗░██████╗░░██████╗\n"
    printf "██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝\n"
    printf "██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░\n"
    printf "██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗\n"
    printf "╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝\n"
    printf "░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚════╝░╚════╝░\n"
    printf "${COLOR_RESET}"
    printf "${COLOR_CYAN}claudemods Alpine Sysutil v1.0\n\n${COLOR_RESET}"
}

execute_command() {
    printf "${COLOR_CYAN}[EXECUTING] ${COLOR_RESET}"
    
    eval "$1"
    status=$?
    
    if [ $status -ne 0 ]; then
        printf "${COLOR_RED}\n[ERROR] Command failed with status $status${COLOR_RESET}\n"
    else
        printf "${COLOR_CYAN}\n[SUCCESS] Command completed${COLOR_RESET}\n"
    fi
    
    printf "\nPress Enter to continue..."
    read -r dummy
}

get_key() {
    old_settings=$(stty -g)
    stty -icanon -echo min 1 time 0
    key=$(dd bs=1 count=1 2>/dev/null)
    stty "$old_settings"
    
    if [ "$key" = "$(printf "\033")" ]; then
        old_settings=$(stty -g)
        stty -icanon -echo min 1 time 0
        key=$(dd bs=1 count=1 2>/dev/null)
        stty "$old_settings"
        if [ "$key" = "[" ]; then
            old_settings=$(stty -g)
            stty -icanon -echo min 1 time 0
            key=$(dd bs=1 count=1 2>/dev/null)
            stty "$old_settings"
        fi
    fi
    printf "$key"
}

main() {
    # Define menu items as separate variables
    cmd1="Fix 'failed to synchronize all databases' for apk"
    cmd2="Fix 'unable to lock database' for apk"
    cmd3="Fix clock time"
    cmd4="Fix connectivity issues"
    cmd5="Fix corrupted packages"
    cmd6="Fix login issues"
    cmd7="See system logs"
    cmd8="Update system"
    cmd9="Quit"
    
    selected=1
    
    print_banner
    
    printf "${COLOR_CYAN}Password: ${COLOR_RESET}"
    old_settings=$(stty -g)
    stty -echo
    read -r root_password
    stty "$old_settings"
    printf "\n"
    
    while true; do
        clear
        print_banner
        
        printf "${COLOR_CYAN}  Fix Alpine Linux\n"
        printf "  --------------\n${COLOR_RESET}"
        
        # Display menu items
        i=1
        while [ $i -le 9 ]; do
            eval "cmd=\"\$cmd$i\""
            if [ $i -eq $selected ]; then
                printf "${COLOR_GOLD}\033[1m➤ %s\033[0m\n\n${COLOR_RESET}" "$cmd"
            else
                printf "${COLOR_CYAN}  %s\n\n${COLOR_RESET}" "$cmd"
            fi
            i=$((i+1))
        done
        
        key=$(get_key)
        
        case $key in
            A)  # Up arrow
                if [ $selected -gt 1 ]; then
                    selected=$((selected-1))
                fi
                ;;
            B)  # Down arrow
                if [ $selected -lt 9 ]; then
                    selected=$((selected+1))
                fi
                ;;
            "")  # Enter key
                eval "cmd=\"\$cmd$selected\""
                
                case "$cmd" in
                    "Quit")
                        exit 0
                        ;;
                    "Fix 'failed to synchronize all databases' for apk")
                        command="echo '$root_password' | su -c 'rm -rf /var/cache/apk/* && apk update'"
                        ;;
                    "Fix 'unable to lock database' for apk")
                        command="echo '$root_password' | su -c 'rm -f /var/lib/apk/db/lock'"
                        ;;
                    "Fix clock time")
                        command="echo '$root_password' | su -c 'time_str=\$(curl -sI \"http://google.com\" | grep -i \"^date:\" | cut -d\" \" -f2-) && date -s \"\$time_str\" &>/dev/null && hwclock --systohc &>/dev/null'"
                        ;;
                    "Fix connectivity issues")
                        command="echo '$root_password' | su -c 'apk del networkmanager --force-broken-world && rm -rf /etc/NetworkManager && apk add networkmanager && rc-service networkmanager restart'"
                        ;;
                    "Fix corrupted packages")
                        command="echo '$root_password' | su -c 'apk fix'"
                        ;;
                    "Fix login issues")
                        command="echo '$root_password' | su -c 'apk add --force linux-firmware linux-firmware-none'"
                        ;;
                    "See system logs")
                        command="echo '$root_password' | su -c 'dmesg'"
                        ;;
                    "Update system")
                        command="echo '$root_password' | su -c 'apk update && apk upgrade'"
                        ;;
                esac
                
                execute_command "$command"
                ;;
        esac
    done
}

main
