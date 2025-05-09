##### DBT Execution Commands #####
# These commands handle the building, running, and testing of dbt models.

build:
    uv run dbt build

run:
    uv run dbt run

test:
    uv run dbt test


##### DBT Documentation Commands #####
# Commands to generate and serve dbt documentation.

docs-generate:
    uv run dbt docs generate

docs-serve:
    uv run dbt docs serve 

docs:
    just docs-generate
    just docs-serve


##### DBT Seeding and Snapshots #####
# Load seed data and run snapshots.

seed:
    uv run dbt seed

snapshot:
    uv run dbt snapshot


##### DBT Utility Commands #####
# Miscellaneous utilities for maintenance and troubleshooting.

list:
    uv run dbt list

clean:
    uv run dbt clean

compile:
    uv run dbt compile

debug:
    uv run dbt debug


##### Code Linting Commands #####
# Run linters for Python, SQL, and dbt project files.

lint-python:
    uv run ruff check --fix

lint-sql:
    uv run sqlfluff fix

lint-dbt:
    uv run dbt-score lint


##### Run All Linters #####
# Shortcut to run all linting steps.
lint:
    lint-python
    lint-sql
    lint-dbt
