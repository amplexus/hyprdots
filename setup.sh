#!/usr/bin/env bash

[ -d ~/.venv ] || python3 -m venv ~/.venv

export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/.venv/bin

sudo apt install qttools5-dev-tools libsdbus-c++-dev git curl slurp grim wl_clipboard lxappearance pulseaudio-utils \
	clang-tidy gobject-introspection libdbusmenu-gtk3-dev libevdev-dev libfmt-dev libgirepository1.0-dev libgtk-3-dev \
	libgtkmm-3.0-dev libinput-dev libjsoncpp-dev libmpdclient-dev libnl-3-dev libnl-genl-3-dev libpulse-dev libsigc++-2.0-dev \
	libspdlog-dev libwayland-dev scdoc upower libxkbregistry-dev valac sassc libjson-glib-dev libhandy-1-dev libgranite-dev libnotify-bin libpciaccess-dev

# RUST
which rustup || curl https://sh.rustup.rs -sSf | sh

rustup default stable

mkdir -p ~/Work

# CATCH2
git clone https://github.com/catchorg/Catch2 --recurse-submodules ~/Work/Catch2
cd ~/Work/Catch22 || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# SWAYLOCK WITH EFFECTS
git clone https://github.com/jirutka/swaylock-effects --recurse-submodules ~/Work/swaylock-effects/
cd ~/Work/swaylock-effects || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install
sudo chmod +s /usr/local/bin/swaylock

# SWWW
git clone https://github.com/LGFae/swww ~/Work/swww
cd ~/Work/swww || exit 2
cargo build --release
sudo cp target/release/swww-daemon /usr/local/bin/
sudo cp target/release/swww /usr/local/bin/

# PYWAL
git clone https://github.com/dylanaraps/pywal ~/Work/pywal
cd ~/Work/pywal || exit 2
~/.venv/bin/pip3 install pywal

# GTK PYWAL
~/.venv/bin/pip3 install gobject pygobject

# LIBDRM > 2.4.119
git clone https://gitlab.freedesktop.org/mesa/drm.git ~/Work/drm
cd ~/Work/drm || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# HYPRLAND
git clone https://github.com/hyprwm/Hyprland --recurse-submodules ~/Work/hyprland/
cd ~/Work/Hyprland || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# SWAY IDLE
git clone https://github.com/swaywm/swayidle ~/Work/swayidle
cd ~/Work/swayidle || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# WLOGOUT
git clone https://github.com/swaywm/wlogout ~/Work/wlogout
cd ~/Work/wlogout || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# WAYBAR
git clone https://github.com/Alexays/Waybar ~/Work/Waybar
cd ~/Work/Waybar || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# Sway Notifications
git clone https://github.com/ErikReider/SwayNotificationCenter ~/Work/SwayNotificationCenter
cd ~/Work/SwayNotificationCenter || exit 2
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# XDG DESKTOP PORTAL HYPRLAND
git clone --recursive https://github.com/hyprwm/xdg-desktop-portal-hyprland ~/Work/xdg-desktop-portal-hyprland
cd ~/Work/xdg-desktop-portal-hyprland/ || exit 2
cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/local/lib -DCMAKE_INSTALL_PREFIX=/usr/local -B build
cmake --build build
sudo cmake --install build

# WPGTK
git clone https://github.com/deviantfero/wpgtk ~/Work/wpgtk
cd ~/Work/wpgtk || exit 2
~/.venv/bin/pip3 install .

# NWG LOOK
git clone https://github.com/nwg-piotr/nwg-look ~/Work/nwg-look
cd ~/Work/nwg-look || exit 2
make build && sudo make install

# YOUTUBE MUSIC
git clone https://github.com/th-ch/youtube-music ~/Work/youtube-music
cd ~/Work/youtube-music || exit 2
npm i --legacy-peer-deps
sudo cp dist/*.AppImage /usr/local/bin/youtube-music
