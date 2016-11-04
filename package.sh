#!/bin/bash
VERSION=`git describe --exact-match --tags $(git log -n1 --pretty='%h')|tr -d v`
if [ $? -gt 0 ]; then
  echo 'The current commit hash has no tag'
  exit 1
fi
OSARCH="linux/amd64"
DIST_NAME=mackerel-plugin-nvidia-smi-${VERSION}.tar.gz

go get -d -v ./...
go get -v github.com/mitchellh/gox
gox -verbose -ldflags='-s -w' \
  -osarch=$OSARCH -output build/mackerel-plugin-nvidia-smi \
  github.com/ksauzz/mackerel-plugin-nvidia-smi

cd build
tar zcfv $DIST_NAME mackerel-plugin-nvidia-smi
shasum -a 256 $DIST_NAME > $DIST_NAME.sha
cd ../
