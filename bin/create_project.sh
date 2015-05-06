#!/usr/bin/env bash
#
#

PROJECTS_DIR=${HOME}"/projects"


##------------------------------------------------------------------------------
## Color print management
##------------------------------------------------------------------------------
COLOR_ERROR='\e[1;41;37m'
COLOR_SUCCESS='\e[1;32m'
COLOR_PROMPT='\e[1;36m'
COLOR_NORMAL='\e[1;1m'
COLOR_RESET='\e[0m' # No Color

m_error () {
    echo -e "${COLOR_ERROR} ${1} ${COLOR_RESET}"
}
m_success () {
    echo -e "${COLOR_SUCCESS} ${1} ${COLOR_RESET}"
}
m_prompt () {
    echo -e "${COLOR_PROMPT}?? ${1}${COLOR_RESET}"
}
m_normal () {
    echo -e "${COLOR_NORMAL}>> ${1}${COLOR_RESET}"
}
## aliases
##------------------------------------------------------------------------------

if [ -z "$1" ]; then 
    m_error "please set new project name. exit."
    exit 1;
fi
PROJECT_NAME=$1
NEW_PROJECT_DIR="${PROJECTS_DIR}/${PROJECT_NAME}"

m_normal "Entering to ${PROJECTS_DIR}"
if [ ! -d "${PROJECTS_DIR}" ]; then
    m_error "${PROJECTS_DIR} does not exist or its not a directory. exit."
    exit 1
fi

# Creating folder
while true; do
    if [ -e "${NEW_PROJECT_DIR}" ]; then 
        while true; do
            m_prompt "${NEW_PROJECT_DIR} already exist. Overwrite? (Yy/Nn/Ss) "
            read yn
            case $yn in
                [Ss]* ) ls -Alh "${NEW_PROJECT_DIR}";;
                [Yy]* ) rm -rvf "${NEW_PROJECT_DIR}"
                    break;;
                [Nn]* ) break 2;;
                * ) m_prompt "Please answer (Yy/Nn/Ss) ";;
            esac
        done
    fi

    m_normal "Creating project in ${PROJECTS_DIR}"
    mkdir "${NEW_PROJECT_DIR}" 
    cd "${NEW_PROJECT_DIR}"
    mkdir -vp backup docs files git sshfs tmp  
    m_success "\nProject \"${PROJECT_NAME}\" created at ${NEW_PROJECT_DIR}"
    break
done

exit 0
