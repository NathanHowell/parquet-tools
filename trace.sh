#!/usr/bin/env bash

set -ex

# shellcheck disable=SC2037
PARQUET=(java \
  -agentlib:native-image-agent=config-merge-dir=/config-dir/ \
  --illegal-access=warn \
  -jar /parquet-tools.jar)

"${PARQUET[@]}" --help || exit 0

# trace a few common commands to capture any straggling reflection calls
for COMMAND in cat schema meta; do
    "${PARQUET[@]}" ${COMMAND} /tmp/users.parquet
done
