#!/usr/bin/env bash

[ -d ~/.venv ] || python3 -m venv ~/.venv && ~/.venv/bin/python3 -m ensurepip --default-pip

export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/.venv/bin

function abort() {
	echo "ERROR: $*"
	exit 2
}
function install_packages() {
	sudo apt install qttools5-dev-tools libsdbus-c++-dev git curl slurp grim lxappearance pulseaudio-utils udiskie wl-clipboard \
		clang-tidy gobject-introspection libdbusmenu-gtk3-dev libevdev-dev libfmt-dev libgirepository1.0-dev libgtk-3-dev nodejs stow \
		libgtkmm-3.0-dev libinput-dev libjsoncpp-dev libmpdclient-dev libnl-3-dev libnl-genl-3-dev libpulse-dev libsigc++-2.0-dev ninja-build meson \
		libspdlog-dev libwayland-dev scdoc upower libxkbregistry-dev valac sassc libjson-glib-dev libhandy-1-dev libgranite-dev libnotify-bin libpciaccess-dev liblz4-dev \
		libzip-dev librsvg2-dev librust-epoll-dev libpugixml-dev libxcb-util-dev libxcb-util0-dev libfftw3-dev xutils-dev xcb-proto
	sudo apt remove catch2
}
function install_pnpm() {
	which pnpm || curl -fsSL https://get.pnpm.io/install.sh | sh -
}
#
function install_rust() {
	apt list --installed | grep rustup && abort "Rust installed via apt didn't work for me, so uninstall it using 'apt remove' and try again"
	which rustup || curl https://sh.rustup.rs -sSf | sh
	rustup default stable
}

# CATCH2
function install_catch2() {
	[ -d ~/Work/Catch2 ] || git clone https://github.com/catchorg/Catch2 --recurse-submodules ~/Work/Catch2
	cd ~/Work/Catch2 || exit 2
	git pull origin devel --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
	sudo cp src/catch2/internal/catch_config_prefix_messages.hpp /usr/local/include/catch2/internal/
}

# SWAYLOCK WITH EFFECTS
function install_swaylock() {
	[ -d ~/Work/swaylock-effects ] || git clone https://github.com/jirutka/swaylock-effects --recurse-submodules ~/Work/swaylock-effects/
	cd ~/Work/swaylock-effects || exit 2
	git pull origin master --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
	sudo chmod +s /usr/local/bin/swaylock
}

# SWWW
function install_swww() {
	[ -d ~/Work/swww ] || git clone https://github.com/LGFae/swww ~/Work/swww
	cd ~/Work/swww || exit 2
	git pull origin main --recurse-submodules
	cargo build --release
	[ -f /usr/local/bin/swww-daemon ] && sudo mv /usr/local/bin/swww-daemon /usr/local/bin/swww-daemon.old
	sudo cp target/release/swww-daemon /usr/local/bin/
	sudo cp target/release/swww /usr/local/bin/
}

# INSTALL GO
function install_go() {
	curl -L https://go.dev/dl/go1.22.2.linux-amd64.tar.gz --output /tmp/go1.22.2.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.22.2.linux-amd64.tar.gz
	export PATH=/usr/local/go/bin:$PATH
}

function install_pywal() {
	# GTK PYWAL dependencies
	~/.venv/bin/pip3 install gobject pygobject

	# PYWAL
	[ -d ~/Work/pywal ] || git clone https://github.com/dylanaraps/pywal ~/Work/pywal
	cd ~/Work/pywal || exit 2
	git pull origin master --recurse-submodules
	~/.venv/bin/pip3 install .
}


function install_libxcberrors() {
	[ -d ~/Work/libxcb-errors ] || git clone https://gitlab.freedesktop.org/xorg/lib/libxcb-errors.git ~/Work/libxcb-errors
	cd ~/Work/libxcb-errors || exit 2
	git submodule update --init    
	git pull origin master --recurse-submodules
	autoreconf --install
	mkdir -p build
	cd build
	../configure
	make
	sudo make install
}
#
# LIBDRM > 2.4.119
function install_libdrm() {
	[ -d ~/Work/drm ] || git clone https://gitlab.freedesktop.org/mesa/drm.git ~/Work/drm
	cd ~/Work/drm || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPRLANG
function install_hyprlang() {
	[ -d ~/Work/hyprlang ] || git clone --recursive https://github.com/hyprwm/hyprlang ~/Work/hyprlang
	cd ~/Work/hyprlang/ 
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/local/lib -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build build
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build  # for neovim 
}

# HYPRCURSOR
function install_hyprcursor() {
	[ -d ~/Work/hyprcursor ] || git clone --recursive https://github.com/hyprwm/hyprcursor ~/Work/hyprcursor
	cd ~/Work/hyprcursor/ || exit 2
	git pull origin main --recurse-submodules
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# WAYLAND UTILS
function install_wayland_utils() {
	[ -d ~/Work/wayland-utils ] || git clone https://gitlab.freedesktop.org/wayland/wayland-utils.git ~/Work/wayland-utils
	cd ~/Work/wayland-utils || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# WAYLAND PROTOCOLS
function install_wayland_protocols() {
	[ -d ~/Work/wayland-protocols ] || git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git ~/Work/wayland-protocols
	cd ~/Work/wayland-protocols || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPERLAND  UTILS
function install_hyprutils() {
	[ -d ~/Work/hyprutils ] || git clone https://github.com/hyprwm/hyprutils.git ~/Work/hyprutils
	cd ~/Work/hyprutils || exit 2
	git pull origin main --recurse-submodules
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
	sudo cmake --install build
}

# HYPRLAND PROTOCOLS
function install_hyprland_protocols() {
	[ -d ~/Work/hyprland-protocols ] || git clone https://github.com/hyprwm/hyprland-protocols.git ~/Work/hyprland-protocols
	cd ~/Work/hyprland-protocols || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPRLAND
function install_hyprland() {
	[ -d ~/Work/hyprland ] || git clone https://github.com/hyprwm/Hyprland --recurse-submodules ~/Work/hyprland/
	cd ~/Work/hyprland || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build -Dbuildtype=debug
	ninja -C build
	sudo ninja -C build install --quiet
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# SWAY IDLE
function install_swayidle() {
	[ -d ~/Work/swayidle ] || git clone https://github.com/swaywm/swayidle ~/Work/swayidle
	cd ~/Work/swayidle || exit 2
	git pull origin master --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# WLOGOUT
function install_wlogout() {
	[ -d ~/Work/wlogout ] || git clone https://github.com/swaywm/wlogout ~/Work/wlogout
	cd ~/Work/wlogout || exit 2
	git pull origin master --recurse-submodules
	git checkout . # for some reason the build modifies version managed files...
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# WAYBAR
function install_waybar() {
	[ -d ~/Work/Waybar ] || git clone https://github.com/Alexays/Waybar ~/Work/Waybar
	cd ~/Work/Waybar || exit 2
	git pull origin master --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# Sway Notifications
function install_swaync() {
	[ -d ~/Work/SwayNotificationCenter ] || git clone https://github.com/ErikReider/SwayNotificationCenter ~/Work/SwayNotificationCenter
	cd ~/Work/SwayNotificationCenter || exit 2
	git pull origin main --recurse-submodules
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# XDG DESKTOP PORTAL HYPRLAND
function install_xdg_portal() {
	[ -d ~/Work/xdg-desktop-portal-hyprland ] || git clone --recursive https://github.com/hyprwm/xdg-desktop-portal-hyprland ~/Work/xdg-desktop-portal-hyprland
	cd ~/Work/xdg-desktop-portal-hyprland/ || exit 2
	git pull origin master --recurse-submodules
	cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/local/lib -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build build
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# NWG LOOK
function install_nwglook() {
	[ -d ~/Work/nwg-look ] || git clone https://github.com/nwg-piotr/nwg-look ~/Work/nwg-look
	cd ~/Work/nwg-look || exit 2
	git pull origin main --recurse-submodules
	make build && sudo make install
}

# WPGTK
function install_wpgtk() {
	[ -d ~/Work/wpgtk ] || git clone https://github.com/deviantfero/wpgtk ~/Work/wpgtk
	cd ~/Work/wpgtk || exit 2
	git pull origin master --recurse-submodules
	~/.venv/bin/pip3 install .
	~/.venv/lib/python3.11/site-packages/wpgtk/misc/wpg-install.sh -gi
}

# hyprwayland_scanner
function install_hypr_scanner() {
	[ -d ~/Work/hyprwayland-scanner ] || git clone https://github.com/hyprwm/hyprwayland-scanner ~/Work/hyprwayland-scanner
	cd ~/Work/hyprwayland-scanner || exit 2
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local -B build
  cmake --build ./build -j `nproc`
  sudo cmake --install ./build
}

# EPOLL SHIM
function install_epoll_shim() {
	[ -d ~/Work/epoll-shim ] || git clone https://github.com/jiixyj/epoll-shim ~/Work/epoll-shim
	cd ~/Work/epoll-shim || exit 2
	rm -rf build
	mkdir build
	cd build/
	git pull origin master --recurse-submodules
	cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
  cmake --build .
  cmake --build . --target install
}

# YOUTUBE MUSIC
function install_yt_music() {
	[ -d ~/Work/youtube-music ] || git clone https://github.com/th-ch/youtube-music ~/Work/youtube-music
	cd ~/Work/youtube-music || exit 2
	git pull origin master --recurse-submodules
	npm i --legacy-peer-deps && npm run build
	~/.local/share/pnpm/pnpm dist:linux
	sudo cp pack/*.AppImage /usr/local/bin/youtube-music
}

set -e # exit on error

mkdir -p ~/Work # We will checkout source code for various projects here

install_packages
install_go # Ubuntu version is too old for nwg-look
install_rust
install_catch2

install_libdrm
install_libxcberrors
install_swaylock
install_swww
install_pywal
install_wayland_protocols # need newer version not available in apt
install_wayland_utils     # keep in sync with wayland-protocols
install_hyprutils
install_hyprlang
install_hyprcursor
install_swayidle

# install_wlogout # FIXME!

install_waybar
install_swaync
install_nwglook # nwg needs go 1.22... and takes a long time to build...
install_wpgtk
install_epoll_shim # NOT NEEDED AT ALL EVER
install_hypr_scanner
install_hyprland_protocols
install_hyprland
# install_yt_music

echo
echo "Four more important steps for you to do:"
echo "1. run nwg-look and select FlatColor theme and icons"
echo "2. enable the rice by running 'stow' - e.g. 'cd ~/Work && stow --target=~/ hyprdots'"
echo "3. if you DO NOT have a 4k monitor, edit ~/.config/hypr/hyprland.conf file and modify the monitor line to change ',highres,auto,2' to ',highres,auto,1' because you probably don't want to scale to double size like me - otherwise everything will be scaled to double size"
echo "4. logout and log back in, but make sure you choose the hyprland window manager in the sddm login screen"
