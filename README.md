Here's the clean README.md without any HTML template names:

```markdown
# HURT v1.0 – Phishing Framework

Advanced phishing tool for **authorized security testing only**. Captures GPS, camera photos, device info, and form data.

## ⚠️ Legal Warning
Use only with explicit permission. Unauthorized use is illegal.

## Features
- 📍 GPS coordinates
- 📸 10 camera photos
- 📱 Device info (battery, network, screen)
- 🌐 IP & geolocation
- 📝 Form data (phone, email, etc.)
- 🔗 Cloudflared tunnel (HTTPS)
- 🎨 Multiple templates

## Installation
```bash
sudo apt install php wget   # Debian/Ubuntu
pkg install php wget         # Termux

git clone https://github.com/DawoodKhan5218/hurt.git
cd hurt
chmod +x hurt.sh
./hurt.sh
```

Usage

```bash
./hurt.sh
```

1. Select template
2. Enter victim username
3. Enter redirect URL (optional)
4. Send phishing link

Data Captured

· data.txt – all form data, GPS, device info
· captures/*.jpg – camera photos
· ip.txt – victim IPs

Requirements

· PHP
· Bash
· wget

Credits

DawoodKhan5218 | GitHub

License

Educational purposes only. Use responsibly!
