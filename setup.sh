#!/usr/bin/env bash

which git || sudo apt install git
which curl || sudo apt install curl
which lxappearance || sudo apt install lxappearance

# RUST
curl https://sh.rustup.rs -sSf| sudo sh
rustup default stable

mkdir -p ~/Work

# SWAYLOCK WITH EFFECTS
cd ~/Work
git clone https://github.com/jirutka/swaylock-effects
cd swaylock-effects
cargo build --release
sudo cp target/release/swaylock-effects /usr/local/bin

# SWWW
cd ~/Work
git clone https://github.com/LGFae/swww
cd swww
cargo build --release
sudo cp target/release/swww-daemon /usr/local/bin/

# PYWAL
cd ~/Work
git clone https://github.com/dylanaraps/pywal
cd pywal
python3 -m venv ~/.venv
~/.venv/bin/pip3 install pywal

# HYPRLAND
cd ~/Work
git clone https://github.com/hyprwm/Hyprland
cd Hyprland
meson setup --reconfigure --prefix=/usr build
ninja -C build
ninja -C build install

# WAYBAR
cd ~/Work
git clone https://github.com/Alexays/Waybar

# SWAY IDLE
cd ~/Work
git clone https://github.com/swaywm/swayidle

# YOUTUBE MUSIC
cd ~Work
git clone https://github.com/th-ch/youtube-music
cd youtube-music
npm i --legacy-peer-deps
sudo cp dist/*.AppImage /usr/local/bin/youtube-music
