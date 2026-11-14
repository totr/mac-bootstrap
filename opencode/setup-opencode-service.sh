#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: sudo $0 <macOS-user>" >&2
  exit 1
fi

service_user=$1
if ! user_id=$(/usr/bin/id -u "$service_user") || [[ "$user_id" -eq 0 ]]; then
  echo "Choose an existing, non-root macOS user." >&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Run this script with sudo." >&2
  exit 1
fi

home_dir=$(/usr/bin/dscl . -read "/Users/$service_user" NFSHomeDirectory)
home_dir=${home_dir#NFSHomeDirectory: }
if [[ ! -d "$home_dir" ]]; then
  echo "User home directory does not exist: $home_dir" >&2
  exit 1
fi
if [[ ! -x /opt/homebrew/bin/opencode ]]; then
  echo "Install OpenCode with the project's bootstrap first." >&2
  exit 1
fi

launcher=/Library/PrivilegedHelperTools/start-opencode
plist=/Library/LaunchDaemons/local.opencode.plist

/bin/mkdir -p /Library/PrivilegedHelperTools
umask 077
{
  printf '#!/bin/bash\nset -euo pipefail\n'
  printf 'service_user=%q\n' "$service_user"
  cat <<'SH'
OPENCODE_PASSWORD=$(/usr/bin/security find-generic-password \
  -a opencode -s ai-server-opencode -w /Library/Keychains/System.keychain)
test -n "$OPENCODE_PASSWORD"
export OPENCODE_PASSWORD
exec /usr/bin/sudo -n -H -u "$service_user" --preserve-env=OPENCODE_PASSWORD /bin/sh -c '
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  cd "$HOME"
  exec /opt/homebrew/bin/opencode serve --hostname 127.0.0.1 --port 4096
'
SH
} > "$launcher"
/usr/sbin/chown root:wheel "$launcher"
/bin/chmod 700 "$launcher"

cat > "$plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>local.opencode</string>
  <key>ProgramArguments</key><array>
    <string>/Library/PrivilegedHelperTools/start-opencode</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ThrottleInterval</key><integer>10</integer>
  <key>StandardOutPath</key><string>/dev/null</string>
  <key>StandardErrorPath</key><string>/var/log/opencode-server.err.log</string>
</dict></plist>
PLIST
/usr/sbin/chown root:wheel "$plist"
/bin/chmod 644 "$plist"
/usr/bin/plutil -lint "$plist"

if /bin/launchctl print system/local.opencode >/dev/null 2>&1; then
  /bin/launchctl bootout system/local.opencode
fi
/bin/launchctl bootstrap system "$plist"
echo "Installed OpenCode boot service for $service_user (home: $home_dir)."
echo "Check status: sudo launchctl print system/local.opencode"
