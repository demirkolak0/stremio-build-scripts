#!/bin/sh
set -e
zypper install -y nodejs wget librsvg-devel rsvg-convert mpv-devel libqt5-qtbase-devel libqt5-qtwebengine-devel libqt5-qtquickcontrols libqt5-qtquickcontrols2 libopenssl-devel gcc gcc-c++ make glibc-devel kernel-devel binutils
git clone --recurse-submodules https://github.com/Stremio/stremio-shell.git
cd stremio-shell
sed -i 's/qmake/qmake-qt5/g' release.makefile
qmake-qt5
make -f release.makefile
./dist-utils/common/postinstall
cd ..
echo "DONE!!"
