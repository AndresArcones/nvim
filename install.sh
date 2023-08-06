#!/bin/bash

# Define a function to check and install a package if needed
check_install() {
  if ! command -v $1 &> /dev/null
  then
    sudo apt-get -y install $1
  fi
}

# Check and install Neovim
check_install "nvim"

# Check and install Ruby
check_install "ruby"

# Check and install Node.js
if ! command -v node &> /dev/null
then
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get -y install nodejs
fi

# Check and install Python 3.10
check_install "python3.10"

# Check and upgrade pip
if command -v pip3 &> /dev/null
then
    PIP_VERSION=$(pip3 --version)
    if ! echo "$PIP_VERSION" | grep -q "pip 22"
    then
        sudo -H pip3 install --upgrade pip
    fi
else
    check_install "python3-pip"
fi

# Check and install Composer
check_install "composer"

# Check and install Go
check_install "golang-go"

# Check and install Rust
check_install "rustc"

# Check and install LuaRocks
check_install "luarocks"

# Check and install Java
check_install "default-jdk"

# Check and install Julia
check_install "julia"

# Check and install PowerShell
check_install "powershell"

# Check GitHub API rate limit
API_LIMIT=$(curl -s -H "Authorization: token YOUR_GITHUB_API_TOKEN" https://api.github.com/rate_limit | grep -oP '(?<="remaining":)[^,]*')
if [[ "$API_LIMIT" -lt 10 ]]
then
    echo "GitHub API rate limit is low. Used: $((60-$API_LIMIT)). Remaining: $API_LIMIT."
fi
