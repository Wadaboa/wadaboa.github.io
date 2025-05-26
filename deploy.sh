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

echo -e "\nPreparing ${BRANCH} branch:"
if git branch -a | grep -q "origin/${BRANCH}"; then
  git checkout --orphan "${BRANCH}"
else
  git checkout "${BRANCH}"
fi

echo -e "\nDeploying into ${BRANCH} branch:"
rm -rf ./**
cp -R "${TEMP}"/* .
rm -f README.md
git add .
git commit -am "new version $(date)" --allow-empty
git push origin "${BRANCH}"

echo -e "\nCleaning up:"
rm -rf "${TEMP}"
