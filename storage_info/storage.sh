#!/usr/bin/env bash
#
# storage.sh - Show total, used, and available storage in GB (colorized table)
# with Use% and Free% columns.
# Tested for Ubuntu 24.04 (works on any modern Linux with GNU coreutils)
#
# Usage:
#   chmod 755 storage.sh
#   ./storage.sh          # physical disks only (excludes tmpfs, squashfs, etc.)
#   ./storage.sh -a       # include all filesystems (--all also works)
#
# Colors are enabled only when stdout is a terminal and NO_COLOR is unset.

set -euo pipefail

SHOW_ALL=false
if [[ "${1:-}" == "-a" || "${1:-}" == "--all" ]]; then
    SHOW_ALL=true
fi

USE_COLOR=1
if [[ ! -t 1 || -n "${NO_COLOR:-}" ]]; then
    USE_COLOR=0
fi

# Collect df output in 1K blocks (POSIX mode) so we can convert to GB accurately.
# Columns: Filesystem, 1K-blocks, Used, Available, Use%, Mounted on
if $SHOW_ALL; then
    DF_OUT=$(df -P -k)
else
    DF_OUT=$(df -P -k -x tmpfs -x devtmpfs -x squashfs -x overlay -x efivarfs)
fi

echo "$DF_OUT" | awk -v color="$USE_COLOR" '
function gb(kb) { return kb / 1024 / 1024 }

function paint(s, code,   c) {
    if (color != 1) return s
    c = sprintf("%c", 27)
    return c "[" code "m" s c "[0m"
}

function pct_color(p) {
    if (p >= 90) return "31"
    if (p >= 70) return "33"
    return "32"
}

BEGIN {
    line = "+----------------------------+----------------------+------------+------------+------------+--------+--------+"
    head = sprintf("| %-26s | %-20s | %10s | %10s | %10s | %6s | %6s |", \
           "Filesystem", "Mounted on", "Total (GB)", "Used (GB)", "Avail (GB)", "Use%", "Free%")
    print paint(line, "2;36")
    print paint(head, "1;36")
    print paint(line, "2;36")
}

NR > 1 {
    total = $2; used = $3; avail = $4; pct = $5; mount = $6
    # Handle mount points containing spaces
    for (i = 7; i <= NF; i++) mount = mount " " $i

    # Free% = 100 - Use% (same basis as df: used / (used + avail))
    use_n = pct; gsub(/%/, "", use_n)
    if (use_n ~ /^[0-9]+$/) {
        free_s = sprintf("%d%%", 100 - use_n)
        use_col = paint(sprintf("%6s", pct), pct_color(use_n))
        free_col = paint(sprintf("%6s", free_s), pct_color(100 - use_n))
    } else {
        use_col = sprintf("%6s", pct)
        free_col = sprintf("%6s", "-")
    }

    printf "| %-26.26s | %-20.20s | %10.2f | %10.2f | %10.2f | %s | %s |\n", \
           $1, mount, gb(total), gb(used), gb(avail), use_col, free_col

    sum_total += total
    sum_used  += used
    sum_avail += avail
}

END {
    base = sum_used + sum_avail
    if (base > 0) {
        use_n   = sum_used * 100 / base
        use_s   = sprintf("%.0f%%", use_n)
        free_s  = sprintf("%.0f%%", 100 - use_n)
        use_col  = paint(sprintf("%6s", use_s), pct_color(use_n))
        free_col = paint(sprintf("%6s", free_s), pct_color(100 - use_n))
    } else {
        use_col = sprintf("%6s", "-")
        free_col = sprintf("%6s", "-")
    }

    label = paint(sprintf("%-26s", "TOTAL"), "1;36")
    printf "| %s | %-20s | %10.2f | %10.2f | %10.2f | %s | %s |\n", \
           label, "-", gb(sum_total), gb(sum_used), gb(sum_avail), use_col, free_col
    print paint(line, "2;36")
}
'
