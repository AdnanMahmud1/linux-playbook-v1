#!/bin/bash

# Step 1: Restore default shell to Bash
echo "Restoring default shell to Bash..."
chsh -s /bin/bash

# Step 2: Remove Oh My Zsh if it exists
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Removing Oh My Zsh..."
    rm -rf ~/.oh-my-zsh
else
    echo "Oh My Zsh is not installed."
fi

# Step 3: Remove Zsh configuration files if they exist
echo "Removing Zsh configuration files..."
[ -f ~/.zshrc ] && rm -f ~/.zshrc
[ -f ~/.zprofile ] && rm -f ~/.zprofile
[ -f ~/.zlogin ] && rm -f ~/.zlogin
[ -f ~/.zlogout ] && rm -f ~/.zlogout
[ -f ~/.zshenv ] && rm -f ~/.zshenv

# Step 4: Uninstall Zsh if it's installed
if dpkg -l | grep -q zsh; then
    echo "Uninstalling Zsh..."
    sudo apt remove -y zsh
else
    echo "Zsh is not installed."
fi

# Step 5: Remove plugins if they exist
echo "Removing Zsh plugins..."

# Remove zsh-autosuggestions
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions plugin is not installed."
fi

# Remove zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting plugin is not installed."
fi

# Remove zsh-history-substring-search
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
else
    echo "zsh-history-substring-search plugin is not installed."
fi

# Remove zsh-z
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z" ]; then
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
else
    echo "zsh-z plugin is not installed."
fi

# Step 6: Uninstall Hack font if it's installed
if dpkg -l | grep -q fonts-hack-ttf; then
    echo "Uninstalling Hack font..."
    sudo apt remove -y fonts-hack-ttf
else
    echo "Hack font is not installed."
fi

# Step 7: Clean up any remaining unused packages
echo "Cleaning up..."
sudo apt autoremove -y

# Step 8: Notify user to restart shell
echo "Uninstallation complete. Please restart your terminal or run 'exec bash' to start using Bash."
