# <span style="color: #2E86C1;">Linux Playbook</span>

This repository provides a collection of scripts to set up Docker, Zsh with plugins, and manage your terminal setup. Follow the steps below to get started.

## <span style="color: #D35400;">Docker Setup</span>

To install Docker using the provided script, run the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/Docker-Setup/docker.sh
chmod 755 docker.sh
./docker.sh
```

# Alternatively (one-liner):

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/Docker-Setup/docker.sh && chmod 755 docker.sh && ./docker.sh
```

## <span style="color: #D35400;">Zsh Setup</span>

### Install <span style="color: #E67E22;font-style: italic">Oh My Zsh</span> and Set as Default Shell

To install **Oh My Zsh** and set it as your default shell, run the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/zsh-font.sh && chmod 755 zsh-font.sh && ./zsh-font.sh
```

### Install <span style="color: #E67E22;font-style: italic">Oh My Zsh</span> Plugins

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/plugins.sh && chmod 755 plugins.sh && ./plugins.sh
```

## <span style="color: #D35400;">Uninstall Zsh and Oh My Zsh</span>

If you want to uninstall **Oh-My-Zsh** and all installed plugins, use the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/uninstall.sh && chmod 755 uninstall.sh && ./uninstall.sh
```

## <span style="color: #27AE60;">Additional Notes</span>

- Make sure you have the necessary permissions before running the scripts.
- These scripts will modify your shell setup, so it’s recommended to back up your `.zshrc` or other configuration files if needed.
