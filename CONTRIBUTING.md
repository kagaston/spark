# Contributing to Spark

## Prerequisites

- Docker
- [just](https://github.com/casey/just) (task runner)
- [shellcheck](https://www.shellcheck.net/) (shell linting)
- [shfmt](https://github.com/mvdan/sh) (shell formatting)
- [hadolint](https://github.com/hadolint/hadolint) (Dockerfile linting)

## Development Commands

| Command | Purpose |
|---|---|
| `just lint` | Lint Dockerfile and shell scripts |
| `just lint-docker` | Lint Dockerfile only |
| `just lint-shell` | Lint shell scripts only |
| `just format-shell` | Format shell scripts |
| `just build` | Build the Docker image |
| `just run` | Run the container (master mode) |
| `just run worker` | Run the container (worker mode) |
| `just test-structure` | Run container structure tests |
| `just clean` | Remove build artifacts |
| `just preflight` | Run all checks before pushing |

## Workflow

1. Create a branch: `git checkout -b feat/description`
2. Make changes with conventional commits
3. Run `just preflight` before pushing
4. Open a PR using the project template
5. Address review feedback
6. Squash-merge after approval

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(docker): add health check to Dockerfile
fix(entrypoint): handle invalid workload type
docs: update contributing guide
chore(build): upgrade Spark version
```
