# Odoo 16 Docker Compose Deployment

Production-ready, declarative Docker deployment for **Odoo 16.0** with **PostgreSQL 17** and Traefik reverse proxy support.

## Architecture

- **Application**: Odoo 16.0 (`odoo:16.0`)
- **Database**: PostgreSQL 17 (`postgres:17`)
- **Configuration**: Direct database & service options via `etc/odoo.conf`
- **Reverse Proxy**: Traefik-ready (`proxy_mode = True`, commented route labels provided)

## Project Structure

```
.
├── docker-compose.yml     # Compose stack specification
├── etc/
│   ├── odoo.conf          # Active Odoo server configuration
│   ├── odoo.conf.template # Full reference configuration template
│   └── requirements.txt   # Optional Python requirements
├── addons/                # Custom Odoo addons
├── enterprise-addons/     # Enterprise addons directory
├── postgresql/            # PostgreSQL cluster data directory (runtime)
├── exports/               # Database dumps and backups
└── run.sh                 # Instance deployment automation script
```

## Getting Started

### 1. Configuration
Review database credentials and parameters in `etc/odoo.conf` and `docker-compose.yml`.

### 2. Start Services
```bash
docker compose up -d
```

### 3. Check Logs
```bash
docker compose logs -f odoo16
```

### 4. Access Odoo
Open your browser at `http://localhost:10019` (or via configured Traefik host).
