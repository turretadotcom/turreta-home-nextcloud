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
