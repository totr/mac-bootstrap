# Mac mini or Mac Studio as an AI server

Use `SERVER_HOSTNAME = ai-server-01` throughout this guide.

## Server name settings

Open **System Settings → General → About** on the server Mac.

- **Name:** `SERVER_HOSTNAME` (`ai-server-01`).

## Network settings

Run on the server Mac:

```sh
sudo /opt/homebrew/bin/tailscale up --ssh
```

Open the login URL shown in the terminal.

- **Account:** Same personal account as on the MacBook.
- **Key expiry:** Disabled (Tailscale admin console → Machines → server Mac → ⋯ → Disable key expiry).


## Screen sharing settings

Open **System Settings → General → Sharing** on the server Mac.

- **Screen Sharing:** On.
- **Allow access for:** Your user account (click ⓘ next to Screen Sharing).

On the MacBook, open Finder, press **⌘K**, and connect to `vnc://SERVER_HOSTNAME`.
Select **High Performance** as the connection type on the MacBook. 

## Power settings

Open **System Settings → Energy** on the server Mac.

- **Prevent automatic sleeping when the display is off:** On.
- **Wake for network access:** On.
- **Start up automatically after a power failure:** On, if available.

## Wallpaper settings

Open **System Settings → Wallpaper** on the server Mac.

- **Wallpaper:** Choose a static picture or solid color.
- **Show as screen saver:** Off, if available.

## Lock screen settings

Open **System Settings → Lock Screen** on the server Mac.

- **Turn display off on power adapter when inactive:** 5 minutes.

## Security settings

Open **System Settings → Privacy & Security → FileVault** on the server Mac.

- **FileVault:** Off.

## Siri settings

Open **System Settings → Siri** on the server Mac.

- **Siri:** Off (click **Turn Off Siri**).

## iCloud settings

Open **System Settings → Apple Account → iCloud → See All** on the server Mac.

- **iCloud Drive → Sync this Mac:** Off.
- **Photos → Sync this Mac:** Off.
- **Notes, Contacts, Calendars, Reminders, Safari:** Off on this Mac.
