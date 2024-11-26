#!/bin/bash
# Author: Haitham Aouati
# GitHub: github.com/haithamaouati
# A Bash tool to fetch and display GitHub user information in JSON format using the GitHub API.

clear
# Text formats
normal="\e[0m"
bold="\e[1m"
faint="\e[2m"
italics="\e[3m"
underlined="\e[4m"

# ASCII Art
figlet -f standard "Copilot"
echo -e "\nA Bash tool to fetch and display GitHub user information in JSON format using the GitHub API.${normal}\n"
echo -e "Author: Haitham Aouati"
echo -e "GitHub: ${underlined}github.com/haithamaouati${normal}\n"

# Function to display help
show_help() {
    echo -e "Usage: $0 [-u <username>] [-t <token>] [-f <filename>] [-h]"
    echo
    echo "Options:"
    echo "  -u, --username    GitHub username to fetch information for"
    echo "  -t, --token       GitHub personal access token for authenticated requests (optional)"
    echo "  -f, --file        File to save the JSON response to (optional)"
    echo -e "  -h, --help        Display this help message\n"
    exit 0
}

# Function to check if required tools are installed
check_requirements() {
    for cmd in figlet curl jq; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "Error: '$cmd' is required but not installed.\n"
            exit 1
        fi
    done
}

# Preload token from the 'token' file, if it exists
PRELOADED_TOKEN=""
if [ -f "token" ]; then
    PRELOADED_TOKEN=$(<token)
fi

# Check for arguments
if [ $# -eq 0 ]; then
    echo -e "Error: No arguments provided. Use -h or --help for usage information.\n"
    exit 1
fi

# Parse arguments
TOKEN=""
FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -t|--token)
            # If no token is provided after -t, use the preloaded token
            if [[ -z "$2" || "$2" == -* ]]; then
                echo -e "Using token from 'token' file.\n"
                TOKEN="$PRELOADED_TOKEN"
                shift 1
            else
                TOKEN="$2"
                shift 2
            fi
            ;;
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo -e "Error: Invalid argument '$1'. Use -h or --help for usage information.\n"
            exit 1
            ;;
    esac
done

# If no token is explicitly provided, use the preloaded token
if [ -z "$TOKEN" ]; then
    TOKEN="$PRELOADED_TOKEN"
    if [ -n "$TOKEN" ]; then
        echo -e "Using token from 'token' file.\n"
    else
        echo -e "No token provided. Using unauthenticated requests with rate limits.\n"
    fi
fi

# Check for required tools
check_requirements

# API URL
API_URL="https://api.github.com/users/$USERNAME"

# Fetch user information
if [ -n "$TOKEN" ]; then
    response=$(curl -s -H "Authorization: token $TOKEN" -w "\n%{http_code}" "$API_URL")
else
    response=$(curl -s -w "\n%{http_code}" "$API_URL")
fi

body=$(echo "$response" | head -n -1)
http_code=$(echo "$response" | tail -n 1)

# Check HTTP status code
if [ "$http_code" -eq 200 ]; then
    echo -e "GitHub User Info for '${USERNAME}':\n"
    echo "$body" | jq || echo "$body"  # Format with jq if available

    # If the user has provided a file option, save the response
    if [ -n "$FILE" ]; then
        echo "$body" > "$FILE"
        echo -e "\nResponse saved to '$FILE'.\n"
    fi
elif [ "$http_code" -eq 403 ]; then
    echo -e "Rate limit exceeded.\n"
    echo -e "Use a GitHub personal access token with -t or --token to increase rate limits."
    echo -e "Learn more at: ${underlined}https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting${normal}\n"
elif [ "$http_code" -eq 404 ]; then
    echo -e "User '${USERNAME}' not found.\n"
else
    echo -e "An unexpected error occurred: HTTP $http_code.\n"
fi
