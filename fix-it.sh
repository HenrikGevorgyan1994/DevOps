#!/usr/bin/env bash

set -euo pipefail

TARGET="${1:-$HOME/genesis-fixit}"
SERVICE="cron"


log() {
    echo "[$(date +%H:%M:%S)] $1"
}


log "Starting fix-it script"


# -------------------------
# 1. Fix permissions
# -------------------------

log "Fixing permissions"

chmod 600 "$TARGET/secrets.env"

chmod 755 "$TARGET/deploy.sh"

log "Permissions fixed"


# -------------------------
# 2. Check service
# -------------------------

log "Checking service"

if systemctl is-active --quiet "$SERVICE"
then
    log "$SERVICE is running"
else
    log "$SERVICE is stopped"

    sudo systemctl restart "$SERVICE" || true

    log "$SERVICE restarted"
fi


# -------------------------
# 3. Archive old logs
# -------------------------

log "Archiving old logs"

mkdir -p "$TARGET/archive"


find "$TARGET/logs" -name "*.log" -type f -mtime +7 | while read logfile
do
    log "Compressing $logfile"

    gzip "$logfile"

    mv "$logfile.gz" "$TARGET/archive/"
done


# -------------------------
# 4. Verify
# -------------------------

log "Checking result"

fails=0


if [ "$(stat -c %a "$TARGET/secrets.env")" != "600" ]
then
    log "secrets.env permission wrong"
    fails=$((fails+1))
fi


if [ "$(stat -c %a "$TARGET/deploy.sh")" != "755" ]
then
    log "deploy.sh permission wrong"
    fails=$((fails+1))
fi


if find "$TARGET/logs" -name "*.log" -mtime +7 | grep -q .
then
    log "Old logs still exist"
    fails=$((fails+1))
fi


log "Verification finished"

if [ "$fails" -eq 0 ]
then
    log "Everything is OK"
else
    log "$fails problem(s) found"
fi


exit "$fails"
