#!/bin/sh

# Install dependencies for script
function install_dependencies() {
    apk update
    apk add git curl
    wget https://github.com/mikefarah/yq/releases/download/v4.12.1/yq_linux_amd64 -O /usr/bin/yq
    chmod +x /usr/bin/yq
}

# Get repository content
function get_repo() {
    local GIT_USER_NAME="${1}"
    local GIT_USER_EMAIL="${2}"
    local GIT_REPO_PATH="${3}"
    local GIT_MAIN_BRANCH="${4}"
    local GITLAB_ACCESS_TOKEN_NAME="${5}"
    local GITLAB_ACCESS_TOKEN_VALUE="${6}"

    git config --global user.email "${GIT_USER_EMAIL}" && git config --global user.name "${GIT_USER_NAME}"
    git remote set-url origin "https://${GITLAB_ACCESS_TOKEN_NAME}:${GITLAB_ACCESS_TOKEN_VALUE}@${GIT_REPO_PATH}"
    git pull origin "${GIT_MAIN_BRANCH}"
    git checkout "${GIT_MAIN_BRANCH}"
}

# Update files that have app_name inside
function update_app_file() {
    local PATH_TO_FILES="${1}"
    local APP_NAME="${2}"
    local APP_IMAGE_VERSION="${3}"
    local CONTAINER_NAME="${4}"

    # For yq, "env" function
    export APP_IMAGE_VERSION
    export CONTAINER_NAME

    # Change file (yaml) content
    if [ -d "${PATH_TO_FILES}" ]; then
        for FILE in $(grep -re "name: \(${APP_NAME}\)$" "./${PATH_TO_FILES}" | awk -F ":" '{print $1}'); do
            if [ -z "${CONTAINER_NAME}" ]; then
                yq -i eval 'select(.kind == "HelmRelease").spec.values.tag |= env(APP_IMAGE_VERSION)' "${FILE}";
            else
                yq -i eval '(.spec.values.deployment.images[] | select(. | has("tag")) | select(.name == env(CONTAINER_NAME)) | .tag) |= env(APP_IMAGE_VERSION)' "${FILE}"
            fi
        done
    else
        echo "ERROR! There is no such path to files in the repository! Make sure that path is correct: ${PATH_TO_FILES}"
        exit 1
    fi
}

# If prod environment - create merge-request with custom branch, else commit to main branch
function commit_changes() {
    local APP_NAME="${1}"
    local APP_IMAGE_VERSION="${2}"
    local ENV_NAME="${3}"
    local GIT_MAIN_BRANCH="${4}"
    local GIT_UNIQ_BRANCH_NAME="${5}"
    local CONTAINER_NAME="${6}"

    # Check for changed files
    if [ -z "$(git status --porcelain)" ]; then
        echo "WARNING: Nothing to commit. Make sure that passed variables are correct!"
    else
        git add -u
        if [ -z "${CONTAINER_NAME}" ]; then
            git commit -m "${APP_NAME} version was upgraded to ${APP_IMAGE_VERSION}"
        else
            git commit -m "${APP_NAME}(${CONTAINER_NAME}) version was upgraded to ${APP_IMAGE_VERSION}"
        fi
        # Prod
        if [ "${ENV_NAME}" == "prod" ]; then
            git checkout -b "${GIT_UNIQ_BRANCH_NAME}"
            git push origin "${GIT_UNIQ_BRANCH_NAME}" -o merge_request.create
        # Non-prod
        else
            git push origin "${GIT_MAIN_BRANCH}"
        fi
    fi
}

# Main
function main() {
    GIT_USER_NAME="aws-company-deploy-user"
    GIT_USER_EMAIL="aws-company-deploy-user@corp.com"
    GIT_REPO_PATH="git.corp.com/${CI_PROJECT_PATH}.git"
    GIT_MAIN_BRANCH="main"
    GIT_UNIQ_BRANCH_NAME="${APP}-${CI_COMMIT_SHORT_SHA}"

    GITLAB_ACCESS_TOKEN_NAME="aws-platform-stage-token"
    GITLAB_ACCESS_TOKEN_VALUE="${DEPLOY_TOKEN}"

    ENV_NAME="${ENV}"
    APP_NAME="${APP}"
    CONTAINER_NAME="${CONTAINER_NAME}"
    APP_IMAGE_VERSION="${IMAGE_VERSION}"
    PATH_TO_FILES="apps/${ENV}/${PRODUCT}"

    install_dependencies
    get_repo "${GIT_USER_NAME}" "${GIT_USER_EMAIL}" "${GIT_REPO_PATH}" "${GIT_MAIN_BRANCH}" "${GITLAB_ACCESS_TOKEN_NAME}" "${GITLAB_ACCESS_TOKEN_VALUE}"
    update_app_file "${PATH_TO_FILES}" "${APP_NAME}" "${APP_IMAGE_VERSION}" "${CONTAINER_NAME}"
    commit_changes "${APP_NAME}" "${APP_IMAGE_VERSION}" "${ENV_NAME}" "${GIT_MAIN_BRANCH}" "${GIT_UNIQ_BRANCH_NAME}" "${CONTAINER_NAME}"
}

main
