# Copilot
A Bash tool to fetch and display GitHub user information in JSON format using the GitHub API.

# Screenshot

![screenshot](https://raw.githubusercontent.com/haithamaouati/Copilot/refs/heads/main/screenshot.jpg)

## Usage

To use the Copilot script, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/haithamaouati/Copilot.git
    ```

2. Change to the Copilot directory:

    ```bash
    cd Copilot
    ```
    
3. Change the file modes
    ```bash
    chmod +x copilot.sh
    ```
    
5. Run the script:

    ```bash
    ./copilot.sh
    ```
##### Syntax:

```
./copilot.sh [options]
```

##### Options:

Examples:

1. Fetch user information without authentication:
```
./copilot.sh -u octocat
```

2. Fetch user information with a personal access token:
```
./copilot.sh -u octocat -t ghp_12345abcdef
```

3. Save the response to a file:

```
./copilot.sh -u octocat -f user_data.json
```

## Dependencies

The script requires the following dependencies:

- [figlet](http://www.figlet.org/): Program for making large letters out of ordinary text
- [curl](https://curl.se/): Command line tool for transferring data with URL syntax
- [jq](https://stedolan.github.io/jq/): Command-line JSON processor

Make sure to install these dependencies before running the script.

## Configuration

If you frequently use a personal access token, you can preload it by creating a token file in the script's directory. The script will automatically detect and use it:
```bash
echo "ghp_12345abcdef" > token
```

## Notes

> [!NOTE]
> Rate Limits: Unauthenticated requests are limited to 60 requests per hour. Use a personal access token to increase the limit to 5,000 requests per hour.

##### Error Handling:

> [!WARNING]
> 403: Rate limit exceeded. Use a token to continue.

> [!WARNING]
> 404: User not found.

> [!WARNING]
> Other HTTP codes: Displayed with details.

## Author

Made with :coffee: by **Haitham Aouati**
  - GitHub: [github.com/haithamaouati](https://github.com/haithamaouati)

## License

Loki is licensed under [Unlicense license](LICENSE).
