# Spark Docker Image

Dockerized Apache Spark 3.3.1 standalone cluster running on Oracle Linux 9.

## Quick Start

```bash
# Build the image
just build

# Run as master
just run master

# Run as worker
just run worker
```

## Manual Docker Commands

```bash
# Build
docker build -t kagaston/spark:latest .

# Run master
docker run --rm -e SPARK_WORKLOAD=master -p 7077:7077 -p 8080:8080 kagaston/spark:latest

# Run worker (connect to master)
docker run --rm -e SPARK_WORKLOAD=worker -e SPARK_MASTER=spark://spark-master:7077 kagaston/spark:latest
```

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SPARK_WORKLOAD` | `master` | Workload type: `master`, `worker`, or `submit` |
| `SPARK_MASTER` | `spark://spark-master:7077` | Master URL (used by workers) |
| `SPARK_MASTER_PORT` | `7077` | Master RPC port |
| `SPARK_MASTER_WEBUI_PORT` | `8080` | Master web UI port |
| `SPARK_WORKER_WEBUI_PORT` | `8080` | Worker web UI port |
| `SPARK_WORKER_PORT` | `7000` | Worker port |

## Exposed Ports

| Port | Purpose |
|---|---|
| `7077` | Spark master RPC |
| `8080` | Web UI (master or worker) |
| `7000` | Spark worker |

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for setup and workflow.

```bash
just lint          # Lint Dockerfile + shell scripts
just format-shell  # Format shell scripts
just preflight     # Run all checks
```

## Project Structure

```
spark/
├── Dockerfile                # Multi-stage image build
├── .dockerignore             # Build context exclusions
├── .hadolint.yaml            # Dockerfile linting config
├── justfile                  # Task runner recipes
├── structure-test.yaml       # Container structure tests
├── scripts/
│   ├── bootstrap.sh          # Container provisioning (packages, user)
│   ├── build.sh              # Download Spark, build, and push image
│   └── entrypoint.sh         # Runtime workload dispatcher
├── .github/
│   ├── workflows/ci.yml      # CI pipeline (lint → build → scan → push)
│   ├── pull_request_template.md
│   └── ISSUE_TEMPLATE/
├── CONTRIBUTING.md
└── README.md
```

## License

This project is licensed under the MIT License.
