#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v java >/dev/null 2>&1; then
    echo "Error: Java is not installed or not on PATH." >&2
    exit 1
fi

JAVA_VERSION_OUTPUT="$(java -version 2>&1 | head -n 1)"
if [[ "$JAVA_VERSION_OUTPUT" != *\"17* ]]; then
    echo "Warning: This project targets Java 17." >&2
    echo "Detected: $JAVA_VERSION_OUTPUT" >&2
fi

if [[ -f "./mvnw" ]]; then
    chmod +x ./mvnw
    MVN_CMD="./mvnw"
elif command -v mvn >/dev/null 2>&1; then
    MVN_CMD="mvn"
else
    echo "Error: Maven is not installed and ./mvnw is missing." >&2
    exit 1
fi

echo "Building WAR with $MVN_CMD ..."
"$MVN_CMD" clean package

echo
echo "Build complete."
echo "Artifact: $ROOT_DIR/target/demo-1.0-SNAPSHOT.war"
