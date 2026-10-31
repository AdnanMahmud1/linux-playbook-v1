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

## 3. <span style="color: #D35400;"> 🐳Portainer and Watchtower container Setup</span>

Installing Portainer, Watchtower, and Docker network, use the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/portainer-watchtower/setup_portainer_watchtower.sh && chmod 755 setup_portainer_watchtower.sh && ./setup_portainer_watchtower.sh
```
### 3.1 <span style="color: #D35400;"> 🐳Watchtower container Setup</span>

Installing P Watchtower use the following command:

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/portainer-watchtower/watchtower.sh && chmod 755 watchtower.sh && ./watchtower.sh
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
### 4.3 Disable valid subscription nagging (will auto restart the web UI)

```
sed -Ezi.bak "s/(Ext\.Msg\.show\(\{\s*title: gettext\('No valid sub)/void({ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

## 5. <span style="color: #2E86C1;"> 💾 Storage Info</span>

### 5.1 Show storage usage (table)

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/storage_info/storage.sh && chmod 755 storage.sh && ./storage.sh
```

### 5.2 Show storage usage as progress bars

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/storage_info/storage_bars.sh && chmod 755 storage_bars.sh && ./storage_bars.sh
```

### 5.3 <span style="color: #E67E22;font-style: italic"> Notes</span>

- Both scripts accept `-a` / `--all` to include every filesystem (for example: `./storage.sh -a`).
- Usage is color-coded: green below 70%, yellow from 70% to 89%, red at 90% and above.
- Colors turn off automatically when output is piped or redirected, or when `NO_COLOR` is set.
- By default, `tmpfs`, `devtmpfs`, `squashfs`, `overlay`, and `efivarfs` are excluded.

## 6. <span style="color: #27AE60;"> 🧹 Docker Logs</span>

### 6.1 Show log usage and clean container logs

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/docker-show-clean-logs/docker-show-clean-logs.sh && chmod 755 docker-show-clean-logs.sh && sudo ./docker-show-clean-logs.sh
```

### 6.2 Clean logs and prune unused Docker data

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/docker-show-clean-logs/docker-show-clean-logs.sh && chmod 755 docker-show-clean-logs.sh && sudo ./docker-show-clean-logs.sh --prune
```

### 6.3 <span style="color: #E67E22;font-style: italic"> Notes</span>

- Requires root and Docker.
- Shows per-container log sizes, `docker system df`, and `/var/lib/docker` usage.
- Truncates all container logs after a `[y/N]` confirmation.
- With `--prune`, also removes stopped containers, dangling images, unused networks, and build cache.

## 7. <span style="color: #27AE60;"> 🧹 Server Logs</span>

### 7.1 Show log usage and clean system logs

```
wget https://raw.githubusercontent.com/AdnanMahmud1/linux-playbook-v1/main/server-show-clean-logs/server-show-clean-logs.sh && chmod 755 server-show-clean-logs.sh && sudo ./server-show-clean-logs.sh
```

### 7.2 Change retention (default 7 days)

```
sudo ./server-show-clean-logs.sh 14
```

### 7.3 <span style="color: #E67E22;font-style: italic"> Notes</span>

- Requires root.
- Deletes rotated/compressed logs (`.gz`, `.1`, `.old`) and `*.log` files older than the retention period (default 7 days).
- Truncates active syslog, auth, kern, and ufw logs, vacuums the systemd journal, and clears the apt package cache.
- Asks for a `[y/N]` confirmation before making any changes.

## 8. <span style="color: #27AE60;">🌈 Conclusion</span>

### Enhancements Made

- Make sure you have the necessary permissions before running the scripts.
- These scripts will modify your shell setup, so it’s recommended to back up your `.zshrc` or other configuration files if needed.

You now have a powerful terminal setup with Docker and Zsh configured! For any issues or contributions, please open an issue or a pull request. Enjoy coding! 🎉
