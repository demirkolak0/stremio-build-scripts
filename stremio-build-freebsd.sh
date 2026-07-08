#!/bin/sh
set -e
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root..." >&2
    exit 1
fi
pkg install -y gmake pkgconf gcc git node mpv qt5-qmake qt5-buildtools qt5-declarative qt5-webengine qt5-webchannel qt5-opengl qt5-quickcontrols qt5-quickcontrols2 cmake wget
git clone --recurse-submodules https://github.com/stremio/stremio-shell
cd stremio-shell
wget $(cat server-url.txt) -O server.js
qmake-qt5
cmake -B build -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=""
cmake --build build --parallel $(sysctl -n hw.ncpu)
mkdir -p /usr/local/share/stremio
cp -R build/* /usr/local/share/stremio/
cp server.js /usr/local/share/stremio/
ln -sf /usr/local/bin/node /usr/local/share/stremio/node
cat << 'EOF' > /usr/local/bin/stremio
#!/bin/sh
cd /usr/local/share/stremio
exec ./stremio "$@"
EOF
chmod +x /usr/local/bin/stremio
mkdir -p ~/.local/share/applications
fetch -o /usr/local/share/stremio/stremio-logo.svg https://raw.githubusercontent.com/Stremio/stremio-brand/master/logos/SVG/stremio-logo-icon-only-fullcolor.svg
cat << 'EOF' > ~/.local/share/applications/stremio.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Stremio
GenericName=Media Center
Comment=Watch instantly all the video content you enjoy in one place.
Icon=/usr/local/share/stremio/stremio-logo.svg
Exec=/usr/local/bin/stremio
Terminal=false
Categories=AudioVideo;Video;Player;
EOF
