#!/bin/sh
set -e
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root..." >&2
    exit 1
fi
apk update
apk upgrade
echo "Note that qt5-qtwebengine-dev and some packages wants testing and edge binaries and libraries. I tried to built it with normal release repos but I encountered with dependency hell. So I just used testing and edge repos."
apk add make pkgconf gcc g++ git nodejs mpv mpv-libs mpv-dev qt5-qtbase-dev qt5-qtdeclarative-dev qt5-qtwebengine-dev qt5-qtwebchannel-dev qt5-qtquickcontrols qt5-qtquickcontrols2 cmake wget
git clone --recurse-submodules https://github.com/stremio/stremio-shell
cd stremio-shell
wget $(cat server-url.txt) -O server.js
qmake-qt5
cmake -B build -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=""
cmake --build build --parallel $(nproc)
mkdir -p /opt/stremio
cp -R build/* /opt/stremio
cp server.js /opt/stremio
ln -sf /usr/bin/node /opt/stremio/node
mkdir -p ~/.local/share/applications
fetch -o /opt/stremio/stremio-logo.svg https://raw.githubusercontent.com/Stremio/stremio-brand/master/logos/SVG/stremio-logo-icon-only-fullcolor.svg
cat << 'EOF' > /usr/share/applications/Stremio.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Stremio
GenericName=Media Center
Comment=Watch instantly all the video content you enjoy in one place.
Icon=/opt/stremio/stremio-logo.svg
Exec=/opt/stremio/stremio
Terminal=false
Categories=AudioVideo;Video;Player;
EOF
