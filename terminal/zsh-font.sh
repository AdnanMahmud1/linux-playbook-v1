#!/bin/bash

# Step 1: Update package list and install Zsh
echo "Updating package list and installing Zsh..."
sudo apt update
sudo apt install -y zsh

# Step 2: Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# Step 3: Install Oh My Zsh (to manage Zsh configuration)
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Step 4: Install zsh-history-substring-search plugin
echo "Installing zsh-history-substring-search plugin..."
git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Step 5: Configure Zsh to use the plugin
echo "Configuring Zsh to use the history search plugin..."
sed -i 's/plugins=(git)/plugins=(git zsh-history-substring-search)/' ~/.zshrc

# Step 6: Install Hack font
echo "Installing Hack font..."
sudo apt install -y fonts-hack-ttf

# Step 7: Apply changes
echo "Applying changes by restarting the shell..."
source ~/.zshrc

# Step 8: Restarting the terminal message
echo "Zsh is installed and configured with Hack font. Please restart your terminal or run 'exec zsh' to start using Zsh."

# Optional: If you want to automatically restart to Zsh, you can uncomment the following line.
# exec zsh
