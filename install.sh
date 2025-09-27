#!/usr/bin/env bash
set -uo pipefail

# Robust interactive input: prefer /dev/tty (FD 3) when available
TTY_FD=0
if [ -e /dev/tty ] && [ -r /dev/tty ]; then
  exec 3</dev/tty || true
  TTY_FD=3
fi
echo "XTT Installer (interactive)"

# XTT installer and DB helper (interactive)
# - Installs PostgreSQL on Debian/Ubuntu if missing (with prompt)
# - Creates database/user automatically or lets you enter credentials manually
# - Imports base schema from ./xtt_schema.sql (if present)
# - Applies optional migrations from ./migrations/xtt_migrations.sql
# - Generates ./.env containing only DATABASE_URL
# - Supports Backup/Restore/Migrate actions

BASE_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Defaults (can be overridden by flags for non-interactive usage)
DB_NAME="xtt"
DB_USER=""
DB_PASS=""
SCHEMA_FILE=""
MIGRATIONS_FILE=""
HOST="localhost"
PORT="5432"
NO_INSTALL="0"
DROP_IF_EXISTS="0"
BACKUP_BEFORE_DROP="0"
BACK_DIR="${BASE_DIR}/backup"
ENV_OUT="${BASE_DIR}/.env"

rand_str() {
  # Alnum, excluding ambiguous
  LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "${1:-16}"
}

# Helpers for privilege handling
is_root() { [ "$(id -u)" = "0" ]; }
have_sudo() { command -v sudo >/dev/null 2>&1; }
run_root() {
  if have_sudo && ! is_root; then sudo "$@"; else "$@"; fi
}
as_postgres_psql() {
  # Usage: as_postgres_psql <psql args...>
  if have_sudo && ! is_root; then
    sudo -u postgres psql "$@"
  elif command -v runuser >/dev/null 2>&1; then
    runuser -u postgres -- psql "$@"
  else
    # shell fallback; mind quoting
    su - postgres -c "psql $*"
  fi
}

# Wrapper to ensure we don't inherit a root-only CWD (e.g., /root/*) which causes noisy warnings.
as_postgres_psql_cd() {
  (
    cd / || true
    as_postgres_psql "$@"
  )
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --db-name) DB_NAME="$2"; shift 2;;
    --db-user) DB_USER="$2"; shift 2;;
    --db-pass) DB_PASS="$2"; shift 2;;
    --schema) SCHEMA_FILE="$2"; shift 2;;
    --migrations) MIGRATIONS_FILE="$2"; shift 2;;
    --host) HOST="$2"; shift 2;;
    --port) PORT="$2"; shift 2;;
    --no-install) NO_INSTALL="1"; shift;;
    --drop-if-exists) DROP_IF_EXISTS="1"; shift;;
    --backup-before-drop) BACKUP_BEFORE_DROP="1"; shift;;
    --backup-dir|--back-dir) BACK_DIR="$2"; shift 2;;
    --env-out) ENV_OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

if [[ -z "$DB_USER" ]]; then DB_USER="xtt_$(rand_str 8)"; fi
if [[ -z "$DB_PASS" ]]; then DB_PASS="$(rand_str 24)"; fi

prompt_yes_no() {
  local msg="$1" ans=""
  while true; do
    printf "%s [Y/N]: " "$msg" >&2
    if ! IFS= read -r -u "$TTY_FD" ans; then ans=""; fi
    case "${ans^^}" in
      Y|YES) return 0;;
      N|NO)  return 1;;
      *) echo "Please answer Y or N.";;
    esac
  done
}

prompt_choice() {
  local msg="$1" ans=""
  while true; do
    printf "%s " "$msg" >&2
    if ! IFS= read -r -u "$TTY_FD" ans; then ans=""; fi
    ans="${ans^^}"
    case "$ans" in
      A|B) echo "$ans"; return 0;;
      *) echo "Please choose A or B.";;
    esac
  done
}

prompt_value() {
  # Usage: prompt_value "Prompt [default]: " default outvar
  local prompt="$1" def="$2" outvar="$3" val=""
  printf "%s" "$prompt" >&2
  if ! IFS= read -r -u "$TTY_FD" val; then val=""; fi
  if [ -z "$val" ]; then val="$def"; fi
  printf -v "$outvar" "%s" "$val"
}

ensure_psql() {
  if command -v psql >/dev/null 2>&1; then return 0; fi
  echo "PostgreSQL is not installed; XTT requires PostgreSQL."
  if [[ "$NO_INSTALL" == "1" ]]; then
    echo "Auto-install suppressed via --no-install. Exiting."; exit 1
  fi
  if prompt_yes_no "Do you wish to install PostgreSQL now?"; then
    if command -v apt-get >/dev/null 2>&1; then
      run_root apt-get update -y
      run_root env DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-contrib
      return 0
    else
      echo "Automatic install only supported on apt-based systems. Please install PostgreSQL and rerun."; exit 1
    fi
  else
    echo "Installation declined. Exiting."; exit 1
  fi
}

# Decide schema and migrations files (local directory)
if [[ -z "$SCHEMA_FILE" ]]; then
  if [[ -f "$BASE_DIR/xtt_schema.sql" ]]; then
    SCHEMA_FILE="$BASE_DIR/xtt_schema.sql"
  else
    SCHEMA_FILE=""
  fi
fi
if [[ -z "$MIGRATIONS_FILE" ]]; then
  if [[ -f "$BASE_DIR/migrations/xtt_migrations.sql" ]]; then
    MIGRATIONS_FILE="$BASE_DIR/migrations/xtt_migrations.sql"
  else
    MIGRATIONS_FILE=""
  fi
fi

ensure_psql

# If PostgreSQL is already installed or after install, offer automatic vs manual DB configuration
echo
echo "Do you wish to generate the database automatically or enter credentials manually?"
echo "  A = Automatic (Generate it automatically)"
echo "  B = Manual (Enter Host, Port, DB name, User, Pass)"
CHOICE=$(prompt_choice "Choose A or B:")
if [[ "$CHOICE" == "A" ]]; then
  # Keep defaults; generate user/pass if empty
  if [[ -z "$DB_USER" ]]; then DB_USER="xtt_$(rand_str 8)"; fi
  if [[ -z "$DB_PASS" ]]; then DB_PASS="$(rand_str 24)"; fi
  [[ -z "$DB_NAME" ]] && DB_NAME="xtt"
  [[ -z "$HOST" ]] && HOST="localhost"
  [[ -z "$PORT" ]] && PORT="5432"
else
  # Manual entry
  prompt_value "Host [localhost]: " "localhost" IN_HOST; HOST=${IN_HOST:-localhost}
  prompt_value "Port [5432]: " "5432" IN_PORT; PORT=${IN_PORT:-5432}
  prompt_value "Database name [xtt]: " "xtt" IN_DB; DB_NAME=${IN_DB:-xtt}
  prompt_value "Username [xtt_$(rand_str 4)]: " "xtt_$(rand_str 8)" IN_USER; DB_USER=${IN_USER}
  prompt_value "Password (leave blank to auto-generate): " "" IN_PASS; DB_PASS=${IN_PASS:-$(rand_str 24)}
fi

# Ensure service is running (best-effort)
if command -v systemctl >/dev/null 2>&1; then
  run_root systemctl enable postgresql || true
  run_root systemctl start postgresql || true
fi

# Sanity: can we run as postgres?
if ! as_postgres_psql_cd -tAc "SELECT 1" >/dev/null 2>&1; then
  echo "Cannot run psql as 'postgres'. Ensure you have sudo privileges and PostgreSQL is running." >&2
  exit 1
fi

echo "Creating role and database (if missing)..."
# Create user
EXISTS_USER=$(as_postgres_psql_cd -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'")
if [[ "$EXISTS_USER" != "1" ]]; then
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "CREATE USER \"${DB_USER}\" WITH PASSWORD '${DB_PASS}';"
else
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "ALTER USER \"${DB_USER}\" WITH PASSWORD '${DB_PASS}';"
fi

# Create or recreate DB
EXISTS_DB=$(as_postgres_psql_cd -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'")
if [[ "$EXISTS_DB" == "1" && "$DROP_IF_EXISTS" == "1" ]]; then
  # Optional backup
  if [[ "$BACKUP_BEFORE_DROP" == "1" ]]; then
    TS=$(date +%Y%m%d_%H%M%S)
    run_root mkdir -p "$BACK_DIR"
    BACKUP_FILE="$BACK_DIR/xtt_${DB_NAME}_${TS}.sql"
    echo "Backing up existing database '${DB_NAME}' to $BACKUP_FILE ..."
    if have_sudo && ! is_root; then
      sudo -u postgres pg_dump -d "$DB_NAME" > "$BACKUP_FILE"
    elif command -v runuser >/dev/null 2>&1; then
      runuser -u postgres -- pg_dump -d "$DB_NAME" > "$BACKUP_FILE"
    else
      su - postgres -c "pg_dump -d \"$DB_NAME\"" > "$BACKUP_FILE"
    fi
    run_root chmod 0644 "$BACKUP_FILE"
  fi
  echo "Terminating connections and dropping existing database '${DB_NAME}' ..."
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='${DB_NAME}' AND pid <> pg_backend_pid();"
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS \"${DB_NAME}\";"
  EXISTS_DB="0"
fi

if [[ "$EXISTS_DB" != "1" ]]; then
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "CREATE DATABASE \"${DB_NAME}\" OWNER \"${DB_USER}\";"
else
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -c "ALTER DATABASE \"${DB_NAME}\" OWNER TO \"${DB_USER}\";"
fi

# Pre-clean common conflicting objects when not doing a full drop
if [[ "$DROP_IF_EXISTS" != "1" ]]; then
  # Drop helper function if present to avoid duplicate errors
  as_postgres_psql_cd -v ON_ERROR_STOP=0 -d "$DB_NAME" -c "DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;"
  as_postgres_psql_cd -v ON_ERROR_STOP=0 -d "$DB_NAME" -c "DROP FUNCTION IF EXISTS refactored.update_updated_at_column() CASCADE;" || true
fi

if [[ -n "${SCHEMA_FILE}" && -f "${SCHEMA_FILE}" ]]; then
  echo "Importing schema into database '${DB_NAME}' from ${SCHEMA_FILE} ..."
  TMP_SCHEMA=$(mktemp /tmp/xtt_schema.XXXXXX.sql)
  TMP_CLEAN=$(mktemp /tmp/xtt_schema.clean.XXXXXX.sql)
  run_root cp "$SCHEMA_FILE" "$TMP_SCHEMA"
  run_root chmod 0644 "$TMP_SCHEMA"
  awk 'BEGIN{IGNORECASE=1} !/ OWNER TO / {print}' "$TMP_SCHEMA" > "$TMP_CLEAN"
  run_root chmod 0644 "$TMP_CLEAN"
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$TMP_CLEAN"
  run_root rm -f "$TMP_SCHEMA" "$TMP_CLEAN"
else
  echo "Schema file not found at ${SCHEMA_FILE:-<none>}. Skipping initial import."
fi

# Grant privileges
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "GRANT ALL PRIVILEGES ON DATABASE \"${DB_NAME}\" TO \"${DB_USER}\";"
# Ensure the app user can access the public schema
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "GRANT USAGE ON SCHEMA public TO \"${DB_USER}\";"
# Grant table privileges for all existing tables (fixes permission denied on streams)
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"${DB_USER}\";"
# Ensure sequence privileges for application user (needed for nextval on sequences like user_logs_id_seq)
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO \"${DB_USER}\";"
# Default privileges for future objects
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO \"${DB_USER}\";"
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO \"${DB_USER}\";"

# Reassign ownership of objects in this database to the target user (robust across dump owners)
as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "ALTER SCHEMA public OWNER TO \"${DB_USER}\";"

# Generate ALTER OWNER statements for non-extension objects not owned by the app user, then execute them
OWN_SQL=$(mktemp /tmp/xtt_reassign_own.XXXXXX.sql)
as_postgres_psql_cd -At -d "$DB_NAME" -c "
SELECT CASE c.relkind
  WHEN 'S' THEN 'ALTER SEQUENCE '
  WHEN 'v' THEN 'ALTER VIEW '
  WHEN 'm' THEN 'ALTER MATERIALIZED VIEW '
  WHEN 'f' THEN 'ALTER FOREIGN TABLE '
  ELSE 'ALTER TABLE ' END
  || format('%I.%I OWNER TO %I;', n.nspname, c.relname, '${DB_USER}')
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname='public' AND c.relkind IN ('r','p','v','m','f')
  AND c.relowner <> (SELECT oid FROM pg_roles WHERE rolname='${DB_USER}')
  AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid=c.oid AND d.deptype='e')
UNION ALL
SELECT 'ALTER FUNCTION ' || format('%I.%I(%s)', n.nspname, p.proname, pg_get_function_identity_arguments(p.oid)) || format(' OWNER TO %I;', '${DB_USER}')
FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
WHERE n.nspname='public' AND p.proowner <> (SELECT oid FROM pg_roles WHERE rolname='${DB_USER}')
  AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid=p.oid AND d.deptype='e')
UNION ALL
SELECT 'ALTER TYPE ' || format('%I.%I', n.nspname, t.typname) || format(' OWNER TO %I;', '${DB_USER}')
FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
WHERE n.nspname='public' AND t.typtype IN ('e','c','d')
  AND t.typrelid = 0  -- exclude composite row types tied to tables; table owner change covers those
  AND t.typowner <> (SELECT oid FROM pg_roles WHERE rolname='${DB_USER}')
  AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid=t.oid AND d.deptype='e');
" > "$OWN_SQL"
run_root chmod 0644 "$OWN_SQL"
if [[ -s "$OWN_SQL" ]]; then
  as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$OWN_SQL"
fi
run_root rm -f "$OWN_SQL"

echo
echo "Provisioning complete. Credentials:"
echo "  HOST    = $HOST"
echo "  PORT    = $PORT"
echo "  DB_NAME = $DB_NAME"
echo "  DB_USER = $DB_USER"
echo "  DB_PASS = $DB_PASS"
echo

# Generate minimal .env in current working directory
echo "Writing .env to: $ENV_OUT"
run_root mkdir -p "$(dirname "$ENV_OUT")"
echo "DATABASE_URL=postgres://${DB_USER}:${DB_PASS}@${HOST}:${PORT}/${DB_NAME}?sslmode=disable" > "$ENV_OUT"
run_root chmod 0600 "$ENV_OUT" || true

# Also place a copy of .env next to any built binaries so runtime picks it up.
# The server loads .env from the executable directory first, then CWD.
if [[ -d "${BASE_DIR}/bins" ]]; then
  while IFS= read -r -d '' dir; do
    # Only copy if a server binary is present in this dir (xtt_*)
    if ls "$dir"/xtt_* >/dev/null 2>&1; then
      run_root cp "$ENV_OUT" "$dir/.env"
      run_root chmod 0600 "$dir/.env" || true
      echo "Copied .env to binary directory: $dir/.env"
    fi
  done < <(find "${BASE_DIR}/bins" -mindepth 1 -maxdepth 1 -type d -print0)
fi

# Export credentials to db_credentials.txt
CREDS_OUT="${BASE_DIR}/db_credentials.txt"
{
  echo "HOST=$HOST"
  echo "PORT=$PORT"
  echo "DB_NAME=$DB_NAME"
  echo "DB_USER=$DB_USER"
  echo "DB_PASS=$DB_PASS"
  echo "DATABASE_URL=postgres://${DB_USER}:${DB_PASS}@${HOST}:${PORT}/${DB_NAME}?sslmode=disable"
} > "$CREDS_OUT"
run_root chmod 0600 "$CREDS_OUT" || true

# Offer post-actions
echo
echo "Select next action:"
echo "  1) Backup database"
echo "  2) Restore from backup"
echo "  3) Apply migrations"
echo "  4) Finish"
printf "Enter choice [1-4]: " >&2
if ! IFS= read -r -u "$TTY_FD" NEXT; then NEXT=""; fi
case "$NEXT" in
  1)
    run_root mkdir -p "$BACK_DIR"
    TS=$(date +%Y%m%d_%H%M%S)
    OUTF="$BACK_DIR/xtt_${DB_NAME}_${TS}.sql"
    echo "Backing up to $OUTF ..."
    if have_sudo && ! is_root; then
      sudo -u postgres pg_dump -d "$DB_NAME" > "$OUTF"
    elif command -v runuser >/dev/null 2>&1; then
      runuser -u postgres -- pg_dump -d "$DB_NAME" > "$OUTF"
    else
      su - postgres -c "pg_dump -d \"$DB_NAME\"" > "$OUTF"
    fi
    run_root chmod 0644 "$OUTF" || true
    echo "Backup complete: $OUTF";;
  2)
    read -r -p "Path to backup .sql file: " INFILE
    if [[ -f "$INFILE" ]]; then
      echo "Restoring $INFILE into database '$DB_NAME' ..."
      as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$INFILE"
      echo "Restore complete."
    else
      echo "File not found: $INFILE" >&2
    fi;;
  3)
    if [[ -z "$MIGRATIONS_FILE" ]]; then
      if [[ -f "$BASE_DIR/migrations/xtt_migrations.sql" ]]; then
        MIGRATIONS_FILE="$BASE_DIR/migrations/xtt_migrations.sql"
      fi
    fi
    if [[ -n "$MIGRATIONS_FILE" && -f "$MIGRATIONS_FILE" ]]; then
      echo "Applying migrations from $MIGRATIONS_FILE ..."
      as_postgres_psql_cd -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$MIGRATIONS_FILE"
      echo "Migrations applied."
    else
      echo "No migrations file found at ./migrations/xtt_migrations.sql"
    fi;;
  *) ;;
esac

echo "Done."
