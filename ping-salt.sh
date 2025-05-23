#!/bin/bash
CONF_DIR="$(pwd)/salt-conf"
KEYFILE="$CONF_DIR/pki/ssh/salt-ssh.rsa"
ROSTER_FILE="./roster"

mkdir -p "$CONF_DIR/pki/ssh" "$CONF_DIR/cache" "$CONF_DIR/log"
chmod -R u+rwX "$CONF_DIR"

if [ ! -f "$KEYFILE" ]; then
  ssh-keygen -t rsa -b 4096 -f "$KEYFILE" -N ''
fi

cat > "$CONF_DIR/master" <<EOF
pki_dir: $CONF_DIR/pki
cachedir: $CONF_DIR/cache
log_file: $CONF_DIR/log/salt.log
EOF

# Explicit env vars and options override all defaults
SALT_CONFIG_DIR="$CONF_DIR" \
PYTHONWARNINGS="ignore::DeprecationWarning" \
salt-ssh \
  --config-dir="$CONF_DIR" \
  --roster-file="$ROSTER_FILE" \
  --log-file="$CONF_DIR/log/salt.log" \
  --priv="$KEYFILE" \
  --wipe \
  --static \
  '*' test.ping
