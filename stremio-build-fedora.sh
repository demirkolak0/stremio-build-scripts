#!/bin/sh
set -e
sudo dnf install nodejs wget librsvg2-devel librsvg2-tools mpv-libs-devel qt5-qtbase-devel qt5-qtwebengine-devel qt5-qtquickcontrols qt5-qtquickcontrols2 openssl-devel gcc g++ make glibc-devel kernel-headers binutils -y
git clone --recurse-submodules https://github.com/Stremio/stremio-shell.git
cd stremio-shell
sed -i 's/qmake/qmake-qt5/g' release.makefile
qmake-qt5
make -f release.makefile
./dist-utils/common/postinstall
cd ..
rm -rf stremio-shell
