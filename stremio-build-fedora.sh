#!/bin/sh
set -e
git clone --recurse-submodules https://github.com/Stremio/stremio-shell.git
cd stremio-shell
sed -i 's/qmake/qmake-qt5/g' release.makefile
qmake-qt5
make -f release.makefile
./dist-utils/common/postinstall
cd ..
rm -rf stremio-shell
