#!/bin/sh
set -e
apt update
apt install -y nodejs wget git librsvg2-dev librsvg2-bin libmpv-dev qtbase5-dev qtwebengine5-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libssl-dev build-essential linux-headers-amd64 binutils cmake qml-module-qtquick-dialogs qml-module-qtwebchannel qml-module-qtwebengine
git clone --recurse-submodules https://github.com/Stremio/stremio-shell.git
cd stremio-shell
qmake
make -f release.makefile
./dist-utils/common/postinstall
cd ..
echo "DONE!!"
