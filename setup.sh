#!/usr/bin/env bash

export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/.venv/bin
which git || sudo apt install git
which curl || sudo apt install curl
which lxappearance || sudo apt install lxappearance

export PATH=$HOME/.local/bin:$HOME/.venv/bin:$PATH
[ -d ~/.venv ] || python3 -m venv ~/.venv

# RUST
curl https://sh.rustup.rs -sSf| sh
rustup default stable

mkdir -p ~/Work

# SWAYLOCK WITH EFFECTS
cd ~/Work
git clone https://github.com/jirutka/swaylock-effects --recurse-submodules
cd swaylock-effects
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# SWWW
cd ~/Work
git clone https://github.com/LGFae/swww
cd swww
cargo build --release
sudo cp target/release/swww-daemon /usr/local/bin/
sudo cp target/release/swww /usr/local/bin/

# PYWAL
cd ~/Work
git clone https://github.com/dylanaraps/pywal
cd pywal
~/.venv/bin/pip3 install pywal

# LIBDRM > 2.4.119
cd ~/Work
git clone https://gitlab.freedesktop.org/mesa/drm.git
cd drm
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install  


# HYPRLAND
cd ~/Work
git clone https://github.com/hyprwm/Hyprland --recurse-submodules
cd Hyprland
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# SWAY IDLE
cd ~/Work
git clone https://github.com/swaywm/swayidle
cd swayidle
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# WAYBAR
sudo apt install clang-tidy gobject-introspection libdbusmenu-gtk3-dev libevdev-dev libfmt-dev libgirepository1.0-dev libgtk-3-dev libgtkmm-3.0-dev libinput-dev libjsoncpp-dev libmpdclient-dev libnl-3-dev libnl-genl-3-dev libpulse-dev libsigc++-2.0-dev libspdlog-dev libwayland-dev scdoc upower libxkbregistry-dev

cd ~/Work
git clone https://github.com/Alexays/Waybar
cd Waybar
meson setup --reconfigure --prefix=/usr/local build
ninja -C build
ninja -C build install

# YOUTUBE MUSIC
cd ~Work
git clone https://github.com/th-ch/youtube-music
cd youtube-music
npm i --legacy-peer-deps
sudo cp dist/*.AppImage /usr/local/bin/youtube-music
