#!/usr/bin/env bash

set -euo pipefail

main() {
  env
  /usr/bin/docker run \
    --name ghcriowhilpbuildifierlatestsha256c9801dbfb119bbbbfedaa43314b9d4cd27dfde7b0c9a5b93fe958e9d8e46d88c_fb3f3f \
    --label e5ae59 \
    --workdir /github/workspace \
    --rm \
    -e HOME \
    -e GITHUB_JOB \
    -e GITHUB_REF \
    -e GITHUB_SHA \
    -e GITHUB_REPOSITORY \
    -e GITHUB_REPOSITORY_OWNER \
    -e GITHUB_RUN_ID \
    -e GITHUB_RUN_NUMBER \
    -e GITHUB_ACTOR \
    -e GITHUB_WORKFLOW \
    -e GITHUB_HEAD_REF \
    -e GITHUB_BASE_REF \
    -e GITHUB_EVENT_NAME \
    -e GITHUB_SERVER_URL \
    -e GITHUB_API_URL \
    -e GITHUB_GRAPHQL_URL \
    -e GITHUB_WORKSPACE \
    -e GITHUB_ACTION \
    -e GITHUB_EVENT_PATH \
    -e GITHUB_PATH \
    -e GITHUB_ENV \
    -e RUNNER_OS \
    -e RUNNER_TOOL_CACHE \
    -e RUNNER_TEMP \
    -e RUNNER_WORKSPACE \
    -e ACTIONS_RUNTIME_URL \
    -e ACTIONS_RUNTIME_TOKEN \
    -e ACTIONS_CACHE_URL \
    -e GITHUB_ACTIONS=true \
    -e CI=true \
    -v "/var/run/docker.sock":"/var/run/docker.sock" \
    -v "/home/runner/work/_temp/_github_home":"/github/home" \
    -v "/home/runner/work/_temp/_github_workflow":"/github/workflow" \
    -v "/home/runner/work/_temp/_runner_file_commands":"/github/file_commands" \
    -v "/home/runner/work/world/world":"/github/workspace"
}

main "$@"
exit $?
