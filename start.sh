#!/bin/bash

REPOSITORY=$REPO
ACCESS_TOKEN=$TOKEN

echo "REPO ${REPOSITORY}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"
echo "REG_TOKEN ${REG_TOKEN}"
echo "REPOOWNER ${REPO_OWNER}"
echo "LABELS ${RUNNER_LABELS}"
#REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

echo "./config.sh --url https://github.com/${REPO_OWNER}/${REPOSITORY} --token ${REG_TOKEN}"
./config.sh --url https://github.com/${REPO_OWNER}/${REPOSITORY} --token ${REG_TOKEN} --unattended --name "gha-runner-docker-test1" --work "_workdir" --disableupdate --labels "$(RUNNER_LABELS)"

# --unattended           Disable interactive prompts for missing arguments. Defaults will be used for missing options
# --url string           Repository to add the runner to. Required if unattended
# --token string         Registration token. Required if unattended
# --name string          Name of the runner to configure (default alexeym-lnx2-gh-runner)
# --runnergroup string   Name of the runner group to add this runner to (defaults to the default runner group)
# --labels string        Custom labels that will be added to the runner. This option is mandatory if --no-default-labels is used.
# --no-default-labels    Disables adding the default labels: 'self-hosted,Linux,X64'
# --local                Removes the runner config files from your local machine. Used as an option to the remove command
# --work string          Relative runner work directory (default _work)
# --replace              Replace any existing runner with the same name (default false)
# --pat                  GitHub personal access token with repo scope. Used for checking network connectivity when executing `./run.sh --check`
# --disableupdate        Disable self-hosted runner automatic update to the latest released version`
# --ephemeral            Configure the runner to only take one job and then let the service un-configure the runner after the job finishes (default false)

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
