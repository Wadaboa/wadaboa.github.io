#!/bin/bash

set -ex -o pipefail

REPO=$(pwd)
BRANCH="master"
BRANCH_FROM="release"

if [ ! -e _site ]; then
  echo -e "\nJekyll didn't generate anything in _site!"
  exit 1
fi

echo -e "\nCopying '_site' folder:"
TEMP=$(mktemp -d -t jgd-XXX)
trap 'rm -rf ${TEMP}' EXIT
cp -R "${REPO}/_site" "${TEMP}"

echo -e "\nDeploying into ${BRANCH} branch:"
git checkout "${BRANCH}"
rm -rf ./**
cp -R "${TEMP}/_site"/* .
rm -f README.md
git add .
git commit -am "new version $(date)" --allow-empty
git push origin "${BRANCH}"

echo -e "\nCleaning up:"
rm -rf "${TEMP}"
