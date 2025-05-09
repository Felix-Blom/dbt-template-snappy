# {{ cookiecutter.__project_slug }}

![Python](https://img.shields.io/badge/python-≥3.12-blue?logo=python&logoColor=white)
![DBT Core](https://img.shields.io/badge/dbt--core-≥1.9.4-orange?logo=dbt&logoColor=white)
![Databricks](https://img.shields.io/badge/dbt--databricks-≥1.10.1-red?logo=databricks&logoColor=white)
![SQLFluff](https://img.shields.io/badge/sqlfluff-≥3.4.0-ff69b4?logo=databricks&logoColor=white)
![Ruff](https://img.shields.io/badge/ruff-≥0.11.8-success?logo=ruff&logoColor=white)
![Pre-commit](https://img.shields.io/badge/pre--commit-≥4.2.0-lightgrey?logo=pre-commit&logoColor=white)

dbt core instance for the Data Platform Transformations for {{ cookiecutter.__project_slug }}

## Setup

### Install uv

[uv](https://github.com/astral-sh/uv) is a fast Python package installer and resolver (pip & venv replacement).
uv is used to manage the dependencies shown in the `pyproject.toml`

Install it using:

```bash
pip install uv
```

Then synchronize python dependencies:

```bash
uv sync
```

## Setup

> [!NOTE]
> For a more complete overview of the tools and their documentation, refer to the Tools & Setup section of this `README.md`

### Setup dbt locally

First a `.dbt` directory should be created in your home directory.
You can navigate to your user profile in the Windows Explorer by typing `%userprofile%` in the address bar and creating a `.dbt` folder there.

Or use the following command:

```bash
mdkir $home\.dbt
```

> [!CAUTION]
> This folder will be used to host the `profiles.yml` files.
> These control personal access the the Databricks instance.
> It contains database access & user credentials.
> DO NOT SHARE WITH ANYONE

In that folder create a `profiles.yml` file . It contains the information to connect to a certain Warehouse within a Databricks instance.
It should have the following structure. Explanation below.

It can be found under the `SQL Warehouses > {Warehouse Name} > Connection details` section, by clicking on the `dbt` logo.

```yaml
{{ cookiecutter.__project_slug }}:
  outputs:
    dev:
      catalog: <unity_catalog_name>
      host: <HOSTNUMBER>.azuredatabricks.net
      http_path: /sql/1.0/warehouses/{warehouse_id}
      schema: <default_schema>
      threads: 1
      token: <PERSONAL ACCESS TOKEN>
      type: databricks
  target: dev
```

If for some strange reason you can't generate `dbt profile` at the warehouse level. Here's a manual approach:

| **Name**    | **What It Is**                                                            | **Where to Find or Set It**                                                 |
| ----------- | ------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `catalog`   | Unity Catalog name used for data governance and access control            | Databricks workspace → Data Explorer → Catalogs                             |
| `host`      | Databricks workspace URL including workspace ID                           | Databricks workspace → Copy from browser address bar when logged in         |
| `http_path` | Path to the SQL warehouse (formerly cluster) used for dbt execution       | Databricks → SQL Warehouses → Select warehouse → Copy JDBC/ODBC `http_path` |
| `schema`    | Default schema (within the catalog) where dbt models will be materialized | User-defined; often your username or project-specific schema                |
| `threads`   | Number of concurrent threads dbt uses when executing                      | User-defined; typically set to 1–4 for development, higher for production   |
| `token`     | Personal Access Token used to authenticate with Databricks                | Databricks → User Settings → Access Tokens → Generate new token             |
| `type`      | Specifies the type of connection (`databricks` in this case)              | Always set to `databricks` for this type of profile                         |
| `target`    | Default environment target dbt will use (refers to a key in `outputs`)    | User-defined; should match one of the keys under `outputs` (like `dev`)     |

## Tools & Setup

### dbt

[dbt-core](https://github.com/dbt-labs/dbt-core) is a free Open source python package.
It is installed when running `uv sync`.
Engineers using dbt can transform their data by simply writing select statements, while dbt handles turning these statements into tables and views in a data warehouse.
Get started with [interactive learning videos](https://www.getdbt.com/dbt-learn) and the [documentation](https://docs.getdbt.com/docs/build/documentation)

#### dbt commands

Refer to the `justfile` for an overview of the commands.

Execution

- build: Run models, tests, and snapshots in DAG order
- run: Execute and materialize models
- test: Run data tests

Documentation

- docs-generate: Create HTML docs
- docs-serve: View docs in browser

Data Loading

- seed: Load CSV files into database
- snapshot: Track historical data changes

Utility

- list: Show project resources
- clean: Remove generated artifacts
- compile: Generate SQL without execution
- debug: Test connectivity and config

**Notable dbt features:**

- Lineage: [link](https://www.getdbt.com/blog/getting-started-with-data-lineage)
- Auto-documentation: [link](https://docs.getdbt.com/reference/commands/cmd-docs)
- Built-in & custom tests: [link](https://docs.getdbt.com/docs/build/data-tests)
- Data-sources / source freshness: [link](https://docs.getdbt.com/docs/build/sources)
- Seeds (simple csv -> table): [link](https://docs.getdbt.com/docs/build/seeds)
- Exposures (which users/dashboard uses which table): [link](https://docs.getdbt.com/reference/exposure-properties)

**Databricks dbt features**

- Databricks-specific dbt-configurations: [link](https://docs.getdbt.com/reference/resource-configs/databricks-configs)
- Support for Unity Catalog: [link](https://docs.getdbt.com/best-practices/dbt-unity-catalog-best-practices)

### dbt Power user

We recommend using the `VSCode` plugin [dt-power-user](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)
This helps with development of models within vscode. Make sure to set the Python interpreter to the one generated by `uv`

- `CTRL + SHIFT + P` > `Python: Select Interpreter` > Select `.venv\Scripts\python.exe`

### Just

Install [Just] (command runner) from the [github](https://github.com/casey/just):
It allows us to run (multiple) long commands using simple aliases, for example:
we can type `just lint-dbt` to run the entire `uv run dbt-score lint` command.

```bash
lint-dbt:
  - uv run dbt-score lint
```

These commands can then be combined, so it runs multiple commands:

```bash
lint:
  - lint-python
  - lint-sql
  - lint-dbt
```

These aliases are shown in the `justfile`

Example installation for Windows

```bash
winget install --id Casey.Just --exact
```

Example installation for mac

```bash
brew install just
```

### Install Pre-commit

To maintain high code quality by automatically enforcing consistent coding standards, and catching potential issues before code is committed, pre-commits are used.
Before code is committed, code-quality checks are run on the code to make sure it adheres to the standards. These can be found in `.pre-commit-config.yaml`

We recommend installing pre-commit outside of a virtual environment (global installation).

Install [pre-commit](https://pre-commit.com/):

```bash
pip install pre-commit
pre-commit install
pre-commit run
```

> [!CAUTION]
> dbt-score has no pre-commit
> At the moment dbt-score has no pre-commit hook available.
> We recommend running the `just lint` command to also run the dbt-score linter.

### Gitmoji

To maintain consistent and meaningful commit messages, we use [gitmoji](https://gitmoji.dev/).
This helps to easily identify the purpose or type of a commit through emojis. It can be installed as a cli or vscode plugin.

#### VS Code Extension

Install the [Gitmoji](https://marketplace.visualstudio.com/items?itemName=seatonjiang.gitmoji-vscode) extension for VS Code to easily add gitmoji to your commit messages:

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "Gitmoji"
4. Install the extension by Seaton Jiang

You can then use the extension when writing commit messages to quickly insert the appropriate gitmoji.

It can also be installed as a cli:

```bash
npm i -g gitmoji-cli
```

or

```bash
brew install gitmoji
```

For reference, visit the [gitmoji website](https://gitmoji.dev/) to see all available emojis and their meanings.
