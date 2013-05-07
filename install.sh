#!/usr/bin/env bash

#create necessary outide this repo so that main repo can use this subrepo

set -u # error on undefined variable
set -e # stop execution if one command returns != 0

BNAME="$( basename "$( pwd )" )"
cd ..

LNOUTS=( makefile .gitignore install-plugin.sh )

for F in "${LNOUTS[@]}" plugins; do
    if [ -e "$F" ]; then
        echo "FILE ALREADY EXISTS. INSTALLATION ABORTED: $F"
        exit 1
    fi
done

for F in "${LNOUTS[@]}"; do
    ln -s "$BNAME"/"$F" "$F"
done

mkdir plugins

echo 'INSTALLATION FINISHED. CONSIDER ADDING GENERATED FILES TO PROJECT WITH: `git add`'
exit 0
