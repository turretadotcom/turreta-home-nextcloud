# Home Nextcloud

A small Docker Compose project for running Nextcloud at home.

This setup is intended to act as **temporary staging storage** for files uploaded from phones, tablets, and PCs before you manually archive them elsewhere.

## Versions

- Nextcloud: `32-apache`
- MariaDB: `11.4`

## Project layout

```text
home-nextcloud/
├── compose.yaml
├── .env.example
├── .gitignore
├── README.md
├── scripts/
│   ├── setup.sh
│   ├── start.sh
│   ├── stop.sh
│   ├── restart.sh
│   ├── status.sh
│   ├── logs.sh
│   └── update.sh
└── storage/                # created locally, ignored by Git
    ├── data/               # Nextcloud user data / staging area
    └── db/                 # MariaDB data
```

## Important storage design

The Nextcloud application itself is stored in a Docker-managed volume:

```text
nextcloud_app
```

User data is stored on the host at:

```text
./storage/data
```

MariaDB data is stored on the host at:

```text
./storage/db
```

The `storage/` directory is excluded from Git.

## Setup

```bash
chmod +x scripts/*.sh
./scripts/setup.sh
```

Then edit:

```bash
nano .env
```

Change all passwords.

## Start

```bash
./scripts/start.sh
```

## Access

On the server:

```text
http://localhost:8080
```

To find the LAN IP:

```bash
hostname -I
```

Then access from a phone or tablet using:

```text
http://SERVER_IP:8080
```

## Multiple users

Nextcloud supports multiple user accounts.

Create users from the Nextcloud administrator interface. Each user can log in from their phone, tablet, or browser.

## Where user files are stored

Nextcloud stores user data under:

```text
storage/data/
```

Typically:

```text
storage/data/<username>/files/
```

Do not manually delete or reorganize files inside this directory while Nextcloud is running, because Nextcloud also tracks file metadata in its database.

## Status

```bash
./scripts/status.sh
```

## Logs

```bash
./scripts/logs.sh
```

Press `Ctrl+C` to stop following logs.

## Restart

```bash
./scripts/restart.sh
```

## Stop

```bash
./scripts/stop.sh
```

## Update

```bash
./scripts/update.sh
```

This pulls updates matching the currently pinned image tags.

For major Nextcloud upgrades, change the Nextcloud image tag explicitly in `compose.yaml`.

## Recreate on another machine

Clone the repository:

```bash
git clone YOUR_REPOSITORY_URL
cd home-nextcloud
```

Then:

```bash
chmod +x scripts/*.sh
./scripts/setup.sh
nano .env
./scripts/start.sh
```

This creates a fresh empty Nextcloud installation.

## Git

The following are intentionally not committed:

```text
.env
storage/
```

Initialize a repository with:

```bash
git init
git add .
git commit -m "Initial home Nextcloud setup"
git branch -M main
```

Then add your GitHub remote and push.

## LAN and Android Access

This Nextcloud installation is intended primarily for use inside the home Wi-Fi/LAN.

The default host port for this project is:

```dotenv
NEXTCLOUD_PORT=8181
```

The Compose mapping is:

```yaml
ports:
  - "${NEXTCLOUD_PORT}:80"
```

This means port `8181` on the Lubuntu/Ubuntu host is forwarded to port `80` inside the Nextcloud container.

### Find the server's LAN IP address

On the Nextcloud server, run:

```bash
hostname -I
```

For example, if the server IP is:

```text
192.168.1.105
```

Nextcloud can be opened from another computer on the same Wi-Fi at:

```text
http://192.168.1.105:8181
```

Use the same address in the Nextcloud Android app.

### Android and HTTP

HTTPS/SSL is not required just to get Nextcloud working on a trusted home LAN. The Android app can connect using an HTTP address such as:

```text
http://192.168.1.105:8181
```

Android or the Nextcloud app may warn that the connection is not encrypted. This is expected when using HTTP.

HTTP traffic, including credentials and transferred files, is not encrypted over the Wi-Fi network. HTTPS is therefore a worthwhile future improvement even for local use, but it is not required for the initial home setup.

**Do not expose or port-forward port `8181` to the Internet while using this HTTP-only setup.** Keep it accessible only from the home LAN.

### Give the server a stable IP address

The router may assign a different IP address to the server after a reboot or DHCP lease change. If that happens, the saved address in the Android app will stop working.

The recommended solution is to configure a **DHCP reservation** in the home router for the T460/Nextcloud server. For example, reserve:

```text
192.168.1.105
```

The exact address should match the home network and an available address in the router's LAN configuration.

### Nextcloud "Untrusted Domain" error

If Nextcloud displays:

```text
Access through untrusted domain
```

add the server's LAN IP to Nextcloud's trusted domains.

For example:

```bash
docker compose exec --user www-data nextcloud \
  php occ config:system:set trusted_domains 1 \
  --value=192.168.1.105
```

Check the configured trusted domains with:

```bash
docker compose exec --user www-data nextcloud \
  php occ config:system:get trusted_domains
```

Replace `192.168.1.105` with the actual reserved LAN IP.

### Firewall

Check whether UFW is enabled:

```bash
sudo ufw status
```

If it is active and port `8181` is blocked, allow access from the home LAN only. For example, for a `192.168.1.0/24` network:

```bash
sudo ufw allow from 192.168.1.0/24 to any port 8181 proto tcp
```

Adjust the subnet to match the actual home network.

## Docker Compose on Ubuntu 24.04 Noble

On Ubuntu 24.04 Noble, Docker may be installed without the Compose v2 command.

A symptom is running:

```bash
./scripts/start.sh
```

and receiving an error similar to:

```text
unknown shorthand flag: 'd' in -d
```

Check Compose with:

```bash
docker compose version
```

For an Ubuntu repository installation, install Compose v2 with:

```bash
sudo apt update
sudo apt install docker-compose-v2
```

Then verify:

```bash
docker compose version
```

The project scripts intentionally use the modern Compose v2 syntax:

```bash
docker compose up -d
```

rather than the legacy:

```bash
docker-compose up -d
```

If `docker-compose-v2` cannot be found, ensure Ubuntu's Universe repository is enabled:

```bash
sudo add-apt-repository universe
sudo apt update
sudo apt install docker-compose-v2
```
