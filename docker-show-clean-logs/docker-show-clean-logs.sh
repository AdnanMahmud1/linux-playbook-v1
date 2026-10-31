#!/bin/bash
# Docker log manager: show table -> confirm -> clean -> show table again
# Usage: sudo dockerlogs.sh            (truncate container logs only)
#        sudo dockerlogs.sh --prune    (also prune stopped containers, dangling images, unused networks, build cache)

PRUNE=0
[ "${1:-}" = "--prune" ] && PRUNE=1

if [ "$EUID" -ne 0 ]; then echo "Please run with sudo."; exit 1; fi
if ! command -v docker >/dev/null; then echo "Docker not found."; exit 1; fi

# ---------- helpers ----------
human() { numfmt --to=iec --suffix=B "${1:-0}"; }
row()  { printf "| %-28s | %-10s | %-10s | %12s |\n" "$1" "$2" "$3" "$4"; }
line() { printf "+%s+%s+%s+%s+\n" "$(printf '%30s' | tr ' ' '-')" "$(printf '%12s' | tr ' ' '-')" "$(printf '%12s' | tr ' ' '-')" "$(printf '%14s' | tr ' ' '-')"; }

# ---------- display ----------
show_usage() {
  local title="$1" data="" id name state drv log size
  echo
  echo "=================== $title ==================="

  TOTAL_B=0
  for id in $(docker ps -aq); do
    name=$(docker inspect --format '{{.Name}}' "$id"); name=${name#/}
    state=$(docker inspect --format '{{.State.Status}}' "$id")
    drv=$(docker inspect --format '{{.HostConfig.LogConfig.Type}}' "$id")
    log=$(docker inspect --format '{{.LogPath}}' "$id")
    size=0
    [ -n "$log" ] && [ -f "$log" ] && size=$(stat -c %s "$log")
    TOTAL_B=$(( TOTAL_B + size ))
    data+="${size}"$'\t'"${name}"$'\t'"${state}"$'\t'"${drv}"$'\n'
  done

  echo
  echo "Container logs (largest first)"
  line
  row "CONTAINER" "STATE" "DRIVER" "LOG SIZE"
  line
  if [ -z "$data" ]; then
    row "(no containers)" "-" "-" "-"
  else
    printf '%s' "$data" | sort -rn | while IFS=$'\t' read -r sz nm st dv; do
      row "${nm:0:28}" "$st" "$dv" "$(human "$sz")"
    done
  fi
  line
  row "TOTAL" "" "" "$(human "$TOTAL_B")"
  line

  echo
  echo "Docker disk usage (docker system df)"
  printf "  %-16s %12s %22s\n" "TYPE" "SIZE" "RECLAIMABLE"
  docker system df --format '{{.Type}}|{{.Size}}|{{.Reclaimable}}' \
    | while IFS='|' read -r t s r; do printf "  %-16s %12s %22s\n" "$t" "$s" "$r"; done

  echo
  echo "Disk usage (/var/lib/docker):"
  df -h /var/lib/docker | awk 'NR==1||NR==2{printf "  %-20s %8s %8s %8s %6s\n",$1,$2,$3,$4,$5}'
}

# ---------- clean ----------
clean_docker() {
  local id name log
  echo
  echo ">> Truncating container logs..."
  for id in $(docker ps -aq); do
    log=$(docker inspect --format '{{.LogPath}}' "$id")
    name=$(docker inspect --format '{{.Name}}' "$id"); name=${name#/}
    if [ -n "$log" ] && [ -f "$log" ]; then
      truncate -s 0 "$log" && echo "   cleared: $name"
    else
      echo "   skipped: $name (no json-file log)"
    fi
  done

  if [ "$PRUNE" -eq 1 ]; then
    echo ">> Pruning stopped containers, dangling images, unused networks..."
    docker system prune -f
    echo ">> Pruning build cache..."
    docker builder prune -f
  fi

  echo ">> Cleanup completed."
}

# ---------- main ----------
show_usage "CURRENT DOCKER LOG USAGE"
BEFORE=$TOTAL_B

echo
if [ "$PRUNE" -eq 1 ]; then
  MSG="Truncate ALL container logs AND prune unused Docker data?"
else
  MSG="Truncate ALL container logs shown above?"
fi
read -rp "$MSG [y/N]: " ans
case "$ans" in
  y|Y|yes|YES) ;;
  *) echo "Cancelled. Nothing was changed."; exit 0 ;;
esac

clean_docker
show_usage "DOCKER LOG USAGE AFTER CLEANUP"
AFTER=$TOTAL_B

echo
echo "Summary: container logs before $(human "$BEFORE") -> after $(human "$AFTER") | freed $(human $(( BEFORE > AFTER ? BEFORE - AFTER : 0 )))"