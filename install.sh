#!/usr/bin/env bash
# Quick Notes installer — run from your Mac with the tablet plugged in by USB.
#   ./install.sh            install / update the mod
#   ./install.sh --remove   remove the mod (your pins are kept)
#   ./install.sh --logs     show the mod's log lines from the tablet
set -euo pipefail

HOST="${RM_HOST:-root@10.11.99.1}"
# Reuse one SSH login for every step, so you type the tablet password once.
SSH_OPTS=(-o ControlMaster=auto -o ControlPath=/tmp/rm-quicknotes-%r@%h -o ControlPersist=10m -o StrictHostKeyChecking=accept-new)
ssh() { command ssh "${SSH_OPTS[@]}" "$@"; }
scp() { command scp "${SSH_OPTS[@]}" "$@"; }
QMD_DIR="/home/root/xovi/exthome/qt-resource-rebuilder"
HERE="$(cd "$(dirname "$0")" && pwd)"

case "${1:-}" in
  --remove)
    ssh "$HOST" "rm -f $QMD_DIR/quickNotes.qmd && systemctl reset-failed xochitl; /home/root/xovi/start"
    echo "Removed. Pins stay in /home/root/.local/share/quicknotes/slots.json"
    exit 0 ;;
  --logs)
    ssh "$HOST" 'journalctl -u xochitl --since "-10min" --no-pager | grep -E "quicknotes|Error while|qmldiff" || true'
    exit 0 ;;
esac

echo "Checking tablet…"
ssh "$HOST" 'test -x /home/root/xovi/start' \
  || { echo "xovi not found. Install it first (see README step 1)."; exit 1; }

ssh "$HOST" "ls /home/root/xovi/extensions.d/ | grep -q qt-command-executor" \
  || { echo "qt-command-executor missing. Run on the tablet: vellum add qt-command-executor"; exit 1; }

echo "Copying patch…"
scp -q "$HERE/quickNotes.qmd" "$HOST:$QMD_DIR/quickNotes.qmd"

echo "Restarting the reMarkable UI with xovi…"
ssh "$HOST" "systemctl reset-failed xochitl; /home/root/xovi/start" >/dev/null 2>&1 || true

sleep 12
echo "Log check:"
ssh "$HOST" 'journalctl -u xochitl --since "-1min" --no-pager | grep -E "quicknotes|Error while" || echo "(no quicknotes lines yet — tap the corner, then run ./install.sh --logs)"'
