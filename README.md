# <span style="color: #2E86C1;">🚀 Linux Playbook</span>

This repository provides a collection of scripts to set up Docker, Zsh with plugins, and manage your terminal setup. Follow the steps below to get started.

# <span style="color: #D35400;"> 1. 🐳 Docker Setup</span>

### <span style="color: #D35400;"> 1.1 Docker Installation</span>

To install Docker using the provided script, run the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/Docker-Setup/docker.sh
chmod 755 docker.sh
./docker.sh
```

### <span style="color: #D35400;"> 1.2 Alternatively (one-liner):</span>

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/Docker-Setup/docker.sh && chmod 755 docker.sh && ./docker.sh
```

# <span style="color: #D35400;"> 2. 🦄 Zsh Setup</span>

### 2.1 Install <span style="color: #E67E22;font-style: italic">Oh My Zsh</span> and Set as Default Shell

To install **Oh My Zsh** and set it as your default shell, run the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/zsh-font.sh && chmod 755 zsh-font.sh && ./zsh-font.sh
```

### 2.2 Install <span style="color: #E67E22;font-style: italic">Oh My Zsh</span> Plugins 🛠️

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/plugins.sh && chmod 755 plugins.sh && ./plugins.sh
```

### 2.3 <span style="color: #D35400;"> ❌ Uninstall Zsh and Plugins</span>

If you want to uninstall **Oh-My-Zsh** and all installed plugins, use the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/terminal/uninstall.sh && chmod 755
uninstall.sh && ./uninstall.sh
```

### 3. <span style="color: #D35400;"> 🐳Portainer and Watchtower container Setup</span>

Installing Portainer, Watchtower, and Docker network, use the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/portainer-watchtower/setup_portainer_watchtower.sh && chmod 755 setup_portainer_watchtower.sh && ./setup_portainer_watchtower.sh
```

## 4. <span style="color: #27AE60;">Proxmox Setup</span>

### 4.1 Install <span style="color: #E67E22;font-style: italic">To fix network issues - Name server </span> 🛠️

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/proxmox/prox_network.sh && chmod 755 prox_network.sh && ./prox_network.sh
```

### 4.2 Install <span style="color: #E67E22;font-style: italic">To merge Storage - LVM </span> 🛠️

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/proxmox/prox_config.sh && chmod 755 prox_config.sh && ./prox_config.sh
```

## 5. <span style="color: #27AE60;">🌈 Conclusion</span>

### Enhancements Made

- Make sure you have the necessary permissions before running the scripts.
- These scripts will modify your shell setup, so it’s recommended to back up your `.zshrc` or other configuration files if needed.

You now have a powerful terminal setup with Docker and Zsh configured! For any issues or contributions, please open an issue or a pull request. Enjoy coding! 🎉
