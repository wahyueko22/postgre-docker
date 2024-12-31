project-directory/
├── docker-compose.yml
├── data/                    # PostgreSQL data files stored here
│   └── pgdata/             # Actual database files
└── init-scripts/           # Initialization scripts
    ├── 01-create-db.sql
    ├── 02-create-tables.sql
    └── 03-insert-data.sql



# Create data directory if it doesn't exist
sudo mkdir -p ~/project-directory/data

# Set ownership and permissions
sudo chown -R 999:999 ~/project-directory/data
sudo chmod 700 ~/project-directory/data


# Navigate to postgres directory
cd ~/postgres-docker

# Start PostgreSQL container
docker compose up -d

# Verify container is running
docker ps

# Check logs
docker logs postgres_db


Any .sql, .sql.gz, or .sh files placed in this directory will be automatically executed in alphabetical order when the container is first initialized

# Start containers
docker compose --env-file .env up -d

# Stop containers
docker compose --env-file .env down

# View logs
docker compose --env-file .env logs

# Connect to PostgreSQL
docker exec -it postgres_db psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}


# Postgre three common partitioning strategies:

# Range Partitioning (sales table)

    Partitions data by date ranges (quarterly)
    Useful for time-series data
    Enables efficient querying of specific date ranges


# List Partitioning (customers table)

    Partitions data by discrete values (regions)
    Good for categorical data
    Allows efficient filtering by region


# Hash Partitioning (orders table)

    Evenly distributes data across partitions
    Uses hash of order_id
    Good for data without natural partitioning key