#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/investigaite"
REPO_URL="https://github.com/huijujhan/demo-investigAIte.git"

sudo mkdir -p "$APP_DIR"

if [ ! -d "$APP_DIR/.git" ]; then
  sudo git clone "$REPO_URL" "$APP_DIR"
fi

sudo git -C "$APP_DIR" fetch --all --tags --prune
sudo git -C "$APP_DIR" checkout main
sudo git -C "$APP_DIR" pull --ff-only origin main

sudo chown -R ec2-user:ec2-user "$APP_DIR"

sudo -u ec2-user bash -lc 'cd /opt/investigaite && python3 -m venv .venv || true && . .venv/bin/activate && python -m pip install --upgrade pip && python -m pip install -r requirements.txt'

sudo cp /opt/investigaite/scripts/investigaite.service /etc/systemd/system/investigaite.service
sudo systemctl daemon-reload
sudo systemctl enable --now investigAIte
sudo systemctl restart investigAIte
sudo systemctl status investigAIte --no-pager --lines 20
