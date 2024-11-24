#!/bin/bash

declare -A port_service_dict
declare -A port_version_dict
declare -A http_service_dict
declare -A site_map_dict

menu() {
    echo "Current Settings:"
    echo " "
    echo "Target IP:" "$targetIP"
    echo "Local IP:" "$localIP"
    echo "Listen on Port:" "$localPort"
    echo "Scan Port(s):" "$scanPorts"
    echo "HTTP/S Port(s):" "$httpPorts"
    echo "Enumeration WordList:" "$discoveryPath"
    echo "Password Wordlist:" "$crackPassPath" 
    echo " "
    echo "Pen Test Stages"
    echo " "
    echo "[0] Change Settings"
    echo "[1] Full Pen Test"
    echo "[2] Intelligence Gathering (Local)"
    echo "[3] Network Scanning (Local)" 
    echo "[4] Idenitfy Vulnerabilities (Local)"
    echo "[5] Exploit Vulnerabilities (Local)"
    echo "[6] Maintain Access (Local/Target)" 
    echo "[7] Escalate Privilages (Target)"
    echo "[8] Harvest Credentials (Target)"
    echo "[9] Crack Passwords (Local/Target)"
    echo " "
    read -p "Select Stage: " stage
    getTools
    navigator
}

navigator() {
    case "$stage" in
        0)
            stage0
            ;;
        1)
            stage1
            ;;
        2)
            stage2
            prompt_next_stage "stage3"
            ;;
        3)
            stage3
            prompt_next_stage "stage4"
            ;;
        4)
            stage4
            prompt_next_stage "stage5"
            ;;
        5)
            stage5
            prompt_next_stage "stage6"
            ;;
        6)
            stage6
            prompt_next_stage "stage7"
            ;;
        7)
            stage7
            prompt_next_stage "stage8"
            ;;
        8)
            stage8
            prompt_next_stage "stage9"
            ;;
        9)
            stage9
            prompt_next_stage
            ;;
        *)
            echo "Invalid stage: $stage"
            ;;
    esac
}

settings() {
    echo "-- Options --"
    echo " "
    echo "*********************************************"
    echo " "
    echo "Scan Port(s) "
    echo " "
    echo "<port> = Scan a Single Port"
    echo "<port>,<port> = Scan a List of Ports"
    echo "<port>-<port> = Scan Port Range"
    echo "<port>,<port>,<port>-<port> =  Scan a Combination of Ports and Port Ranges"
    echo " "
    echo "TOP = Scans Top 1,000 TCP Ports"
    echo "ALL = Scans All 65,5335 TCP Ports"
    echo " "
    echo "*********************************************"
    echo " "
    echo "HTTP/S Port(s) "
    echo " "
    echo "# Web Hacking will only be attempted on ports running HTTP service"
    echo "# You can include non http service ports in your port ranges as they will be filtered out and ignored"
    echo " "
    echo "<port> = Attempt Web Hacking on Specified HTTP Service Port"
    echo "<port>,<port> = Attempt Web Hacking on List of Ports"
    echo "<port>-<port> = Attempt Web Hacking on Range of Ports"
    echo "<port>,<port>,<port>-<port> = Attempt Web Hacking on Combination of Ports and Port Ranges"
    echo " "
    echo "LATER = Set HTTP Service Ports after Network Scan Results in Stage 3"
    echo "ALL = Attempt Web Hacking on All HTTP Service Ports"
    echo " "
    echo "*********************************************"
    echo " "
    echo "Set Parameters (Press Enter to Skip and Use Default)"
    echo " "

    read -p "Target IP: " temp_targetIP
    if [[ -z "$targetIP" ]]; then
        while [[ -z "$temp_targetIP" ]]; do
            echo "Target cannot be blank"
            read -p "Target IP: " temp_targetIP
        done
    fi
    read -p "Local IP: " temp_localIP
    read -p "Listener Port: " temp_localPort
    read -p "Scan Port(s): " temp_scanPorts
    read -p "HTTP/S Port(s): " temp_httpPorts
    read -p "Enumeration WordList (Full-Path): " temp_discoveryPath
    read -p "Password WordList (Full-Path): " temp_crackPassPath

    # Assign values only if not empty
    [[ -n "$temp_targetIP" ]] && targetIP="$temp_targetIP"
    [[ -n "$temp_localIP" ]] && localIP="$temp_localIP"
    [[ -n "$temp_localPort" ]] && localPort="$temp_localPort"
    [[ -n "$temp_scanPorts" ]] && scanPorts="$temp_scanPorts"
    [[ -n "$temp_httpPorts" ]] && httpPorts="$temp_httpPorts"
    [[ -n "$temp_discoveryPath" ]] && discoveryPath="$temp_discoveryPath"
    [[ -n "$temp_crackPassPath" ]] && crackPassPath="$temp_crackPassPath"

    # Update the .env file
    setEnv "TARGET_IP" "$targetIP"
    setEnv "LOCAL_IP" "$localIP"
    setEnv "LOCAL_PORT" "$localPort"
    setEnv "SCAN_PORTS" "$scanPorts"
    setEnv "HTTP_PORTS" "$httpPorts"
    setEnv "ENUM_LIST" "$discoveryPath"
    setEnv "WORD_LIST" "$crackPassPath"

    echo " "
    clear
    menu
}

loadEnv() {
    # Load the .env file
    if [[ -f .env ]]; then
        source .env
    else
        echo ".env file not found!"
        exit 1
    fi

    # Assign default values if not set
    targetIP="${TARGET_IP:-""}"
    localIP="${LOCAL_IP:-$(ip route get 1.1.1.1 | awk '{print $7; exit}')}"
    localPort="${LOCAL_PORT:-7654}"
    scanPorts="${SCAN_PORTS:-TOP}"
    httpPorts="${HTTP_PORTS:-80}"
    discoveryPath="${ENUM_LIST:-/usr/share/seclists/Discovery/Web-Content/common.txt}"
    crackPassPath="${WORD_LIST:-/usr/share/wordlists/rockyou.txt}"
}

setEnv()
{
    local key="$1"
    local value="$2"
    local env_file=".env"
    sed -i "/^${key}=/d" "$env_file"
    echo "${key}=\"$value\"" >> "$env_file"
}

resetEnv()
{
    setEnv "TARGET_IP" ""
    setEnv "LOCAL_IP" ""
    setEnv "LOCAL_PORT" ""
    setEnv "SCAN_PORTS" ""
    setEnv "HTTP_PORTS" ""
    setEnv "ENUM_LIST" ""
    setEnv "WORD_LIST" ""

}

stage0() {
    settings
}

stage1() { # Full Pen Test
    stage2
    stage3
    stage4
    stage5
    stage6
    stage7
    stage8
    stage9
}

stage2() { # Intelligence Gathering
    echo "hello"
}

stage3() { # Network Scanning
    nmapOpen
}

stage4() { # Idenitfy Vulnerabilities
    echo "hello"
}

stage5() {
    echo "hello"
}

stage6() {
    echo "hello"
}

stage7() {
    echo "hello"
}

stage8() {
    echo "hello"
}

stage9() {
    echo "hello"
}

prompt_next_stage() {
    local next_stage="$1"
    echo " "
    echo "Continue to next stage, go back to menu, print summary or quit"
    read -p "(next/menu/summary/quit): " choice
    case "$choice" in
        "next")
            $next_stage
            ;;
        "menu")
            menu
            ;;
        "summary")
            echo "place holder"
            ;;
        "quit")
            exit
            ;;
        *)
            echo "Not a valid option, Try again"
            prompt_next_stage
            ;;
    esac
    echo " "
}

getTools() {

    if test "$stage" = "1" || test "$stage" = "2"; then

        if ! command -v python3 >/dev/null 2>&1; then
            echo "Installing Dependencies.."
            sudo apt install -y python3
        fi
    fi
    if test "$stage" = "3"; then
        if ! command -v nmap >/dev/null 2>&1; then
            echo "Installing Dependencies.."
            sudo apt install -y nmap
        fi
        if ! command -v gobuster >/dev/null 2>&1; then
            echo "Installing Dependencies.."
            sudo apt install -y gobuster
        fi
    fi
    echo " "
}

nmapOpen() {
    echo "Identifying Open Ports..."
    echo " "
    if [[ "$scanPorts" == "ALL" ]]; then
        output=$(nmap "$targetIP" -p- --open)
    elif [[ "$scanPorts" == "TOP" ]]; then
        output=$(nmap "$targetIP" --open)
    else
        output=$(nmap "$targetIP" -p "$scanPorts" --open)
    fi

    # Extract open ports and build a comma-separated list
    ports=$(echo "$output" | awk '/^[0-9]+\/[a-z]+/ {print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
    nmapVersions
}

nmapVersions() {
    # Ensure `nmapOpen` was called to populate the ports variable
    if [[ -z "$ports" ]]; then
        echo "No Open Ports We're found"
        return 1
    else

        output=$(nmap "$targetIP" -sV -p "$ports")

        # Populate dictionaries
        while IFS= read -r line; do
            if [[ "$line" =~ ^([0-9]+)/[a-z]+[[:space:]]+open[[:space:]]+([a-zA-Z0-9-]+)[[:space:]]+(.+) ]]; then
                port="${BASH_REMATCH[1]}"
                service="${BASH_REMATCH[2]}"
                version="${BASH_REMATCH[3]}"
                port_service_dict["$port"]="$service"
                port_version_dict["$port"]="$version"
            elif [[ "$line" =~ ^([0-9]+)/[a-z]+[[:space:]]+open[[:space:]]+([a-zA-Z0-9-]+) ]]; then
                # Handle cases where version information is missing
                port="${BASH_REMATCH[1]}"
                service="${BASH_REMATCH[2]}"
                port_service_dict["$port"]="$service"
                port_version_dict["$port"]="unknown"
            fi
        done <<< "$output"

        # Print the header
        printf "%-10s | %-15s | %-50s\n" "Port" "Service" "Version"
        printf "%-10s-+-%-15s-+-%-50s\n" "----------" "---------------" "--------------------------------------------------"

        # Print the dictionaries
        local portCount=0
        local idCount=0
        for key in $(printf "%s\n" "${!port_service_dict[@]}" | sort -n); do
            ((portCount++))
            if [[ "${port_service_dict[$key]}" != "unknown" && "${port_version_dict[$key]}" != "unknown" ]]; then
                printf "%-10s | %-15s | %-50s\n" "$key" "${port_service_dict[$key]}" "${port_version_dict[$key]}"
                ((idCount++))
                if [[ "${port_service_dict[$key]}" == "http" ]]; then
                    http_service_dict["$key"]="${port_service_dict[$key]}"
                fi
            else
            {
                unset ${port_service_dict[$key]}
                unset ${port_version_dict[$key]}
            }
            fi
        done

        if ((portCount > 0)); then
        percentage=$(awk "BEGIN {printf \"%.2f\", ($idCount/$portCount)*100}")
        else
            percentage=0
        fi

        echo " "
        echo "Open Ports: $portCount"
        echo "Identified Ports: $idCount"
        echo "$percentage%" 
        enumerateSite
    fi
        
}

getPortList() {
    # Input string with port numbers and ranges
    local port_input=$1

    # Reference the array passed as the second argument
    local -n cleanPorts=$2

    # Initialize the array
    cleanPorts=()

    # Split the input string by commas
    IFS=',' read -r -a port_parts <<< "$port_input"

    # Process each part (individual port or range)
    for part in "${port_parts[@]}"; do
        if [[ "$part" == *"-"* ]]; then
            # If the part contains a dash, it's a range
            IFS='-' read -r start end <<< "$part"
            for ((port=start; port<=end; port++)); do
                cleanPorts+=("$port")
            done
        else
            # Otherwise, it's a single port
            cleanPorts+=("$part")
        fi
    done
}

enumerateSite()
{
    echo " "
    echo "Getting HTTP Services..."
    echo " "
    # Print the header
    printf "%-10s | %-15s | %-50s\n" "Port" "Service" "Version"
    printf "%-10s-+-%-15s-+-%-50s\n" "----------" "---------------" "--------------------------------------------------"

    for key in $(printf "%s\n" "${!http_service_dict[@]}" | sort -n); do
        printf "%-10s | %-15s | %-50s\n" "$key" "${port_service_dict[$key]}" "${port_version_dict[$key]}"
    done
    
    echo " "

    if [[ "$httpPorts" == "ALL" ]]; then
        for key in $(printf "%s\n" "${!http_service_dict[@]}" | sort -n); do
            echo "Fuzzing for Site Pages on port: $key"
            echo " "
            output=$(gobuster -u "http://$targetIP:$key" -w "$discoveryPath")
            paths=($(echo "$output" | awk '/\(Status: 200\)/ {gsub(/\(Status: 200\)/, "", $1); print $1}'))
            if [[ ${#paths[@]} -gt 0 ]]; then
                echo " "
                echo "Accessible Paths Discovered:"
                printf "%s\n" "${paths[@]}"
                echo " "
                site_map_dict[$key]="${paths[@]}"
            else
                echo " "
                echo "No paths accessible on port $key"
                echo " "
            fi
        done
    else
        cleanHTTP=()
        while true; do
            # Prompt user for HTTP/S ports
            if [[ "$httpPorts" == "LATER" ]]; then
                read -p "Select HTTP/S Port(s): " temp_httpPorts
            else
                temp_httpPorts="$httpPorts"
            fi

            getPortList "$temp_httpPorts" cleanHTTP 
            # Initialize valid and invalid port arrays
            valid_ports=()
            invalid_ports=()

            # Validate each port
            for key in "${cleanHTTP[@]}"; do
                if [[ -v http_service_dict["$key"] ]]; then
                    valid_ports+=("$key")
                fi
            done

            # Check if there are any valid ports to proceed
            if [[ ${#valid_ports[@]} -gt 0 ]]; then
                echo "Valid HTTP ports: ${valid_ports[*]}"
                echo " "
                httpPorts=$(IFS=,; echo "${valid_ports[*]}")  # Rebuild as a comma-separated string
                setEnv "HTTP_PORTS" "$httpPorts"

                # Perform gobuster for each valid port
                for port in "${valid_ports[@]}"; do
                    echo "Fuzzing for Site Pages on port: ${valid_ports[*]}"
                    echo " "
                    output=$(gobuster -u "http://$targetIP:$port" -w "$discoveryPath")
                    paths=($(echo "$output" | awk '/\(Status: 200\)/ {gsub(/\(Status: 200\)/, "", $1); print $1}'))
                    if [[ ${#paths[@]} -gt 0 ]]; then
                        echo " "
                        echo "Accessible Paths Discovered:"
                        printf "%s\n" "${paths[@]}"
                        echo " "
                        site_map_dict[$port]="${paths[@]}"
                    else
                        echo " "
                        echo "No paths accessible on port $key"
                        echo " "
                    fi
                done
                break
            else
                if [[ ${#http_service_dict[@]} -gt 0 ]]; then 
                    echo "No valid ports provided. Please enter new ports."
                    read -p "Select HTTP/S Port(s): " temp_httpPorts
                else
                    echo "No HTTP Ports Found"
                    echo "skipping fuzzing for site enumeration"
                    break
                fi
            fi
        done
    fi

    exploreSite
    
}

exploreSite()

{

    for key in "${!site_map_dict[@]}"; do # Loops throught each http port's site pages
        pages=(${site_map_dict[$key]})
        i=0
        while [[ $i -lt ${#pages[@]} ]]; do # Crawls all avaliable pages
            page="${pages[$i]}"
            #echo $page
            output=$(curl -s "$targetIP:$key$page")
            hrefs=($(echo "$output" | sed -n 's/.*href="\(\(\/[^"]*\)\).*/\1/p'))

            # add support for scripts later

            for new_page in "${hrefs[@]}"; do
                
                top_level="/$(echo "$new_page" | cut -d'/' -f2)"
                #echo "Top: $top_level"
                #echo "Checking list for $new_page"
                if [[ ! " ${pages[@]} " =~ " $new_page " ]]; then
                #echo "Adding: $new_page"
                pages+=("$new_page")
                fi

                if [[ ! " ${pages[@]} " =~ " $new_page " ]]; then
                pages+=("$top_level")
                fi
            done
            ((i++))
        done
        site_map_dict[$key]="${pages[@]}"

        echo "siteMap"
        printf "%s\n" "${site_map_dict[$key]}"

    done

}

echo " "
echo "Lightning Thief"
echo " "
echo "Updating Packages.."
#sudo apt update -y
echo " "
echo "Loading Configuration.."
echo " "
loadEnv
#sudo apt upgrade
menu