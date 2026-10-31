#!/usr/bin/env bash
#
# storage_bars.sh - Show storage usage as ASCII progress bars.
# Tested for Ubuntu 24.04 (works on any modern Linux with GNU coreutils)
#
# Usage:
#   chmod 755 storage_bars.sh
#   ./storage_bars.sh          # physical disks only (excludes tmpfs, squashfs, etc.)
#   ./storage_bars.sh -a       # include all filesystems (--all also works)
#
# Colors are enabled only when stdout is a terminal and NO_COLOR is unset.
# Bar length is used / (used + available), the same basis as df Use%.

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

echo "$DF_OUT" | awk -v color="$USE_COLOR" -v bar_width=20 '
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

function make_bar(p,   filled, i, full, rest, code) {
    if (p < 0) p = 0
    if (p > 100) p = 100
    filled = int(p * bar_width / 100 + 0.5)
    full = ""; rest = ""
    for (i = 1; i <= bar_width; i++) {
        if (i <= filled) full = full "#"
        else rest = rest "-"
    }
    code = pct_color(p)
    return paint("[", code) paint(full, code) paint(rest, "2") paint("]", code)
}

function empty_bar(   i, rest) {
    rest = ""
    for (i = 1; i <= bar_width; i++) rest = rest "-"
    return paint("[" rest "]", "2")
}

BEGIN {
    sep = ""
    for (i = 0; i < 102; i++) sep = sep "="
    head = sprintf("%-26s %-20s %-26s %s", "Filesystem", "Mounted on", "Used / Total", "Usage")
    print paint(sep, "2;36")
    print paint("Storage usage (GB)", "1;36")
    print paint(head, "1;36")
    print paint(sep, "2;36")
}

NR > 1 {
    total = $2; used = $3; avail = $4; mount = $6
    # Handle mount points containing spaces
    for (i = 7; i <= NF; i++) mount = mount " " $i

    base = used + avail
    if (base > 0) {
        p = used * 100 / base
        bar_s = make_bar(p)
        use_s = paint(sprintf("%4s", sprintf("%.0f%%", p)), pct_color(p))
    } else {
        bar_s = empty_bar()
        use_s = paint(sprintf("%4s", "-"), "2")
    }

    printf "%-26.26s %-20.20s %10.2f / %10.2f GB %s %s\n", \
           $1, mount, gb(used), gb(total), bar_s, use_s

    sum_total += total
    sum_used  += used
    sum_avail += avail
}

END {
    base = sum_used + sum_avail
    if (base > 0) {
        p = sum_used * 100 / base
        bar_s = make_bar(p)
        use_s = paint(sprintf("%4s", sprintf("%.0f%%", p)), pct_color(p))
    } else {
        bar_s = empty_bar()
        use_s = paint(sprintf("%4s", "-"), "2")
    }

    label = paint(sprintf("%-26s", "TOTAL"), "1;36")
    print paint(sep, "2;36")
    printf "%s %-20s %10.2f / %10.2f GB %s %s\n", \
           label, "-", gb(sum_used), gb(sum_total), bar_s, use_s
    print paint(sep, "2;36")
}
'
