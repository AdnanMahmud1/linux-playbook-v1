#!/bin/bash

# Step 1: Update package list and install Zsh
echo "Updating package list and installing Zsh..."
sudo apt update
sudo apt install -y zsh

# Step 2: Set Zsh as the default shell (non-interactively)
echo "Setting Zsh as the default shell..."
sudo usermod --shell $(which zsh) $USER

# Step 3: Install Oh My Zsh (without asking for confirmation to switch shell)
echo "Installing Oh My Zsh without changing shell prompt..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Step 4: Install popular plugins
echo "Installing popular Zsh plugins..."

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-history-substring-search
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
fi

# Install zsh-z
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z" ]; then
    git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
fi

# Step 5: Configure Zsh to use the plugins
echo "Configuring Zsh to use the plugins..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-z)/' ~/.zshrc

# Step 6: Install Hack font
echo "Installing Hack font..."
sudo apt install -y fonts-hack-ttf

# Step 7: Apply changes
echo "Zsh is installed and configured with popular plugins and Hack font."

# Step 8: Prompt to start Zsh
echo "Please start Zsh by running 'exec zsh' or restart your terminal."

