#!/bin/bash
# Ubuntu server log manager: show table -> confirm -> clean -> show table again
# Usage: sudo serverlogs.sh [days_to_keep]   (default 7)

DAYS=${1:-7}

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo."; exit 1
fi

# ---------- helpers ----------
human() { numfmt --to=iec --suffix=B "${1:-0}"; }

sum_find() {  # prints "bytes count" for a find expression
  find /var/log -type f "$@" -printf '%s\n' 2>/dev/null \
    | awk '{s+=$1; n++} END{printf "%d %d", s+0, n+0}'
}

row() { printf "| %-36s | %12s | %8s |\n" "$1" "$2" "$3"; }
line() { printf "+%s+%s+%s+\n" "$(printf '%38s' | tr ' ' '-')" "$(printf '%14s' | tr ' ' '-')" "$(printf '%10s' | tr ' ' '-')"; }

# ---------- display ----------
show_usage() {
  local title="$1"
  echo
  echo "=================== $title ==================="

  read -r rot_b rot_n < <(sum_find \( -name "*.gz" -o -name "*.[0-9]" -o -name "*.old" \))
  read -r old_b old_n < <(sum_find -name "*.log" -mtime +"$DAYS")

  act_b=0; act_n=0
  for f in /var/log/syslog /var/log/auth.log /var/log/kern.log /var/log/ufw.log; do
    if [ -f "$f" ]; then
      act_b=$(( act_b + $(stat -c %s "$f") )); act_n=$(( act_n + 1 ))
    fi
  done

  jr_b=$(du -sb /var/log/journal /run/log/journal 2>/dev/null | awk '{s+=$1} END{print s+0}')
  apt_b=$(du -sb /var/cache/apt/archives 2>/dev/null | awk '{print $1+0}')
  TOTAL_B=$(du -sb /var/log 2>/dev/null | awk '{print $1+0}')

  line
  row "CATEGORY" "SIZE" "FILES"
  line
  row "Rotated/compressed (.gz .1 .old)" "$(human "$rot_b")" "$rot_n"
  row "*.log older than ${DAYS} days"     "$(human "$old_b")" "$old_n"
  row "Active logs (syslog/auth/kern/ufw)" "$(human "$act_b")" "$act_n"
  row "systemd journal"                   "$(human "$jr_b")"  "-"
  row "apt package cache"                 "$(human "$apt_b")" "-"
  line
  row "TOTAL /var/log" "$(human "$TOTAL_B")" "-"
  line

  echo
  echo "Top 10 largest files in /var/log"
  line
  row "FILE" "SIZE" "AGE(days)"
  line
  find /var/log -type f -printf '%s\t%T@\t%p\n' 2>/dev/null | sort -rn | head -10 \
    | while IFS=$'\t' read -r sz mt path; do
        age=$(( ( $(date +%s) - ${mt%.*} ) / 86400 ))
        row "${path: -36}" "$(human "$sz")" "$age"
      done
  line

  echo
  echo "Disk usage (/):"
  df -h / | awk 'NR==1{printf "  %-10s %8s %8s %8s %6s\n",$1,$2,$3,$4,$5} NR==2{printf "  %-10s %8s %8s %8s %6s\n",$1,$2,$3,$4,$5}'
}

# ---------- clean ----------
clean_logs() {
  echo
  echo ">> Removing rotated/compressed logs..."
  find /var/log -type f \( -name "*.gz" -o -name "*.[0-9]" -o -name "*.old" \) -delete

  echo ">> Removing *.log files older than ${DAYS} days..."
  find /var/log -type f -name "*.log" -mtime +"$DAYS" -delete

  echo ">> Truncating active logs..."
  for f in /var/log/syslog /var/log/auth.log /var/log/kern.log /var/log/ufw.log; do
    [ -f "$f" ] && truncate -s 0 "$f"
  done

  echo ">> Trimming systemd journal to ${DAYS} days..."
  journalctl --vacuum-time="${DAYS}d" >/dev/null 2>&1

  echo ">> Cleaning apt cache..."
  apt-get clean

  echo ">> Cleanup completed."
}

# ---------- main ----------
show_usage "CURRENT LOG USAGE"
BEFORE=$TOTAL_B

echo
read -rp "Proceed with cleanup (keep last ${DAYS} days)? [y/N]: " ans
case "$ans" in
  y|Y|yes|YES) ;;
  *) echo "Cancelled. Nothing was changed."; exit 0 ;;
esac

clean_logs
show_usage "LOG USAGE AFTER CLEANUP"
AFTER=$TOTAL_B

echo
echo "Summary: before $(human "$BEFORE") -> after $(human "$AFTER") | freed $(human $(( BEFORE > AFTER ? BEFORE - AFTER : 0 )))"