#!/usr/bin/env bash

APP_DIR=$( dirname "${BASH_SOURCE[0]}" )
LOG_FILE="${APP_DIR}/public/autopull.log"
ERROR_LOG_FILE="${APP_DIR}/public/autopull.log"

REMOTE="origin"
BRANCH="master"

LOCK="${APP_DIR}/autopull.running"

if [[ -f "${LOCK}" ]]; then
    exit 1
fi

# Create file for one instance only
touch "${LOCK}"

# Update remote history
cd "${APP_DIR}"
git fetch "${REMOTE}"

# Update only current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Chek if current branch is master
if [[ "${CURRENT_BRANCH}" != "${BRANCH}" ]]; then
    rm -f "${LOCK}"
    exit 1
fi

# Get last local and remote commit hash
LAST_COMMIT_ID=$(git rev-parse HEAD)
LAST_REMOTE_COMMIT_ID=$(git rev-parse "${REMOTE}"/"${BRANCH}")

# If all is ok - update our application
if [[ "${LAST_REMOTE_COMMIT_ID}" != "${LAST_COMMIT_ID}" ]]; then
    ERRORS="$(git merge -q "${REMOTE}" "${BRANCH}" 2>&1 > /dev/null)"

    if [[ ! -z "${ERRORS}" ]]; then
        LAST_COMMIT_AUTHOR_EMAIL=$(git --no-pager log -1 --pretty=format:"%ae" HEAD)
        MESSAGE="### DATETIME: $(date +"%Y-%m-%d %H:%M:%S") ###

### CURRENT LOCAL COMMIT ###
$(git --no-pager log -1 --pretty=format:"commit %H %an <%ae> %n  %s%n" HEAD)


### NEW REMOTE COMMITS ### 
$(git --no-pager log --pretty=format:"commit %H %an <%ae> %n  %s%n" ${LAST_COMMIT_ID}..${LAST_REMOTE_COMMIT_ID})


### ERROR MESSAGE ### 
${ERRORS}


### GIT STATUS ### 
$(git status --short)
"
        echo "${MESSAGE}" > "${ERROR_LOG_FILE}"
        echo "${MESSAGE}" | mail -s "Failed autopull from $(git config --get remote.${BRANCH}.url) at $(hostname)" "${LAST_COMMIT_AUTHOR_EMAIL}"
    fi
    # composer dump-autoload >> "${LOG_FILE}"
    # composer install >> "${LOG_FILE}"
    # composer update >> "${LOG_FILE}"
fi

rm -f "${LOCK}"

exit 0
