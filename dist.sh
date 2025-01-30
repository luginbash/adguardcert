#!/bin/bash

UPDATE_BINARY_URL="https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh"

mkdir -p ./module/META-INF/com/google/android
curl "${UPDATE_BINARY_URL}" > ./module/META-INF/com/google/android/update-binary
echo "#MAGISK" > ./module/META-INF/com/google/android/updater-script

VERSION=$(sed -ne "s/version=\(.*\)/\1/gp" ./module/module.prop)
NAME=$(sed -ne "s/id=\(.*\)/\1/gp" ./module/module.prop)

rm -f ${NAME}-${VERSION}.zip
(
  cd ./module
  if [[ -z $CERT_HASH ]]; then echo "CERT_HASH is not defined, exiting.."; exit -1; fi
  sed -ine "s/AG_CERT_HASH=.*/AG_CERT_HASH=${CERT_HASH}/" module/post-fs-data.sh
  sed -ine "s/version=.*/version=${VERSION}/" module.prop
  sed -ine "s/CA_CERT_HASH/${CERT_HASH}/" module.prop
  zip ../${NAME}-${VERSION}-${CERT_HASH}.zip -r * -x ".*" "*/.*"
)
