[private]
default:
    @just --list --unsorted

build version="latest":
    bash scripts/build.sh
    docker build -t kagaston/spark:{{version}} -t kagaston/spark:latest .

push:
    docker push --all-tags kagaston/spark

run workload="master":
    docker run --rm -e SPARK_WORKLOAD={{workload}} kagaston/spark:latest

lint: lint-docker lint-shell lint-yaml

lint-docker:
    hadolint Dockerfile

lint-shell:
    shellcheck scripts/*.sh

lint-yaml:
    yamllint -d relaxed .github/ structure-test.yaml

format-shell:
    shfmt -i 2 -ci -w scripts/

test-structure:
    container-structure-test test --image kagaston/spark:latest --config structure-test.yaml

clean:
    rm -rf tmp/ deploy/ bin/ jars/
    docker image prune -f

preflight: lint-shell format-shell lint-docker lint-yaml build test-structure
