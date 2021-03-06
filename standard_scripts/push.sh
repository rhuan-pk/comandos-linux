#!/usr/bin/env bash

# It does the entire push process automatically and if no parameter is passed, it commits with a standard message

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "\
		\rTo the default commit (message: \"refresh\"), run:\n\
			\r\t$(basename ${0})\n\n\
		\r\
		\rFor commit with a specific message, run:\n\
			\r\t$(basename ${0}) \"commit message\"\
		\r"
}

verify_privileges

[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

[ -z "${1}" ] && MSG=refresh || MSG="${1}"
[ -z "${2}" ] && BRANCH=$(git branch --show-current) || BRANCH="${2}"

git add .
git commit -m "${MSG}"
git push origin "${BRANCH}"
