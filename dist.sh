#!/bin/bash

set -euo pipefail

UPDATE_BINARY_URL="https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh"

mkdir -p ./module/META-INF/com/google/android
curl "${UPDATE_BINARY_URL}" > ./module/META-INF/com/google/android/update-binary
echo "#MAGISK" > ./module/META-INF/com/google/android/updater-script

VERSION=$(sed -ne "s/version=\(.*\)/\1/gp" ./module/module.prop)
NAME=$(sed -ne "s/id=\(.*\)/\1/gp" ./module/module.prop)

rm -f ${NAME}-${VERSION}.zip
(
  cd ./module
  sed -ne "s/AG_CERT_HASH=.*/AG_CERT_HASH=${CERT_HASH}/"
  zip ../${NAME}-${VERSION}.zip -r * -x ".*" "*/.*"
)
