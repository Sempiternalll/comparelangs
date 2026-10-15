#!/bin/bash
# setup_db.sh - Create SQLite database with 10000 test users

rm -f bench.db bench.db-wal bench.db-shm

sqlite3 bench.db <<'EOF'
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;

CREATE TABLE users (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name     TEXT NOT NULL,
    email    TEXT NOT NULL
);

WITH RECURSIVE cnt(x) AS (
    SELECT 1 UNION ALL SELECT x+1 FROM cnt WHERE x < 10000
)
INSERT INTO users (name, email)
SELECT 'User_' || x, 'user_' || x || '@example.com' FROM cnt;

CREATE INDEX idx_users_id ON users(id);
EOF

echo "Database created:"
sqlite3 bench.db "SELECT COUNT(*) || ' users' FROM users;"
