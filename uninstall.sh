#!/bin/zsh
set -eu

rm -f "$HOME/.local/bin/macos-clean-zip"
rm -f "$HOME/.local/bin/macos-clean-copy-usb"
rm -rf "$HOME/Library/Services/干净压缩.workflow"
rm -rf "$HOME/Library/Services/干净复制到U盘.workflow"

/System/Library/CoreServices/pbs -flush zh_CN en >/dev/null 2>&1 || true
/System/Library/CoreServices/pbs -update zh_CN en >/dev/null 2>&1 || true

echo "Removed macos-clean-export Quick Actions and scripts."
