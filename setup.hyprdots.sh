#!/usr/bin/env bash

BASEDIR=~/Work/hypr

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
		libzip-dev librsvg2-dev librust-epoll-dev libpugixml-dev libxcb-util-dev libxcb-util0-dev libfftw3-dev xutils-dev xcb-proto libspdlog-dev \
		qt6-wayland-dev qt6-wayland-dev-tools qt6-tools-dev qt6-base-dev cmake libtomlplusplus-dev libiniparser-dev libpipewire-0.3-dev libgbm-dev libspa-0.2-dev \
		libseat-dev libdisplay-info-dev libxcb-errors-dev libxcb-icccm4-dev libxcb-res0-dev libxcb-xfixes0-dev libxcb-composite0-dev libre2-dev
		qt6-quick3d-dev qt6-quick3dphysics-dev qt6-quicktimeline-dev libqt63dquick6 qt6-declarative-dev qt6-declarative-private-dev  libqca-qt6-dev \
		libqaccessibilityclient-qt6-dev  qt6-base-private-dev  qt6-tools-private-dev qt6-wayland-private-dev \
		libmagic-dev flex bison foot

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
	[ -d $BASEDIR/Catch2 ] || git clone https://github.com/catchorg/Catch2 --recurse-submodules $BASEDIR/Catch2
	cd $BASEDIR/Catch2 || exit 2
	git pull origin devel --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
	sudo cp src/catch2/internal/catch_config_prefix_messages.hpp /usr/local/include/catch2/internal/
}

# SWAYLOCK WITH EFFECTS
function install_swaylock() {
	[ -d $BASEDIR/swaylock-effects ] || git clone https://github.com/jirutka/swaylock-effects --recurse-submodules $BASEDIR/swaylock-effects/
	cd $BASEDIR/swaylock-effects || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
	sudo chmod +s /usr/local/bin/swaylock
}

# SWWW
function install_swww() {
	[ -d $BASEDIR/swww ] || git clone https://github.com/LGFae/swww $BASEDIR/swww
	cd $BASEDIR/swww || exit 2
	git pull origin main --recurse-submodules
	git checkout tags/v0.9.4 # 0.9.5 and HEAD don't work
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
	[ -d $BASEDIR/pywal ] || git clone https://github.com/dylanaraps/pywal $BASEDIR/pywal
	cd $BASEDIR/pywal || exit 2
	git pull origin master --recurse-submodules
	~/.venv/bin/pip3 install .
}

function install_libxcberrors() {
	[ -d $BASEDIR/libxcb-errors ] || git clone https://gitlab.freedesktop.org/xorg/lib/libxcb-errors.git $BASEDIR/libxcb-errors
	cd $BASEDIR/libxcb-errors || exit 2
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
	[ -d $BASEDIR/drm ] || git clone https://gitlab.freedesktop.org/mesa/drm.git $BASEDIR/drm
	cd $BASEDIR/drm || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPRLANG
function install_hyprlang() {
	[ -d $BASEDIR/hyprlang ] || git clone --recursive https://github.com/hyprwm/hyprlang $BASEDIR/hyprlang
	cd $BASEDIR/hyprlang/
	rm -rf ./build
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/local/lib -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build build
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# HYPRCURSOR
function install_hyprcursor() {
	[ -d $BASEDIR/hyprcursor ] || git clone --recursive https://github.com/hyprwm/hyprcursor $BASEDIR/hyprcursor
	cd $BASEDIR/hyprcursor/ || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
	cmake --build ./build --config Release --target all -j"$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)"
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

function install_hyprqtutils() {
	[ -d $BASEDIR/hyprqtutils ] || git clone --recursive https://github.com/hyprwm/hyprland-qtutils $BASEDIR/hyprqtutils
	cd $BASEDIR/hyprqtutils/ || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
}

# WAYLAND UTILS
function install_wayland_utils() {
	[ -d $BASEDIR/wayland-utils ] || git clone https://gitlab.freedesktop.org/wayland/wayland-utils.git $BASEDIR/wayland-utils
	cd $BASEDIR/wayland-utils || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# WAYLAND PROTOCOLS
function install_wayland_protocols() {
	[ -d $BASEDIR/wayland-protocols ] || git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git $BASEDIR/wayland-protocols
	cd $BASEDIR/wayland-protocols || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPERLAND  UTILS
function install_hyprutils() {
	[ -d $BASEDIR/hyprutils ] || git clone https://github.com/hyprwm/hyprutils.git $BASEDIR/hyprutils
	cd $BASEDIR/hyprutils || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
	cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
	sudo cmake --install build
}

# HYPRLAND PROTOCOLS
function install_hyprland_protocols() {
	[ -d $BASEDIR/hyprland-protocols ] || git clone https://github.com/hyprwm/hyprland-protocols.git $BASEDIR/hyprland-protocols
	cd $BASEDIR/hyprland-protocols || exit 2
	rm -rf ./build
	git pull origin main --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# HYPRLAND
function install_hyprland() {
	[ -d $BASEDIR/hyprland ] || git clone https://github.com/hyprwm/Hyprland --recurse-submodules $BASEDIR/hyprland/
	cd $BASEDIR/hyprland || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build -Dbuildtype=debug
	ninja -C build
	sudo ninja -C build install --quiet
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# SWAY IDLE
function install_swayidle() {
	[ -d $BASEDIR/swayidle ] || git clone https://github.com/swaywm/swayidle $BASEDIR/swayidle
	cd $BASEDIR/swayidle || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# WLOGOUT
function install_wlogout() {
	# [ -d $BASEDIR/wlogout ] || git clone https://github.com/swaywm/wlogout $BASEDIR/wlogout
	[ -d $BASEDIR/wlogout ] || git clone https://github.com/ArtsyMacaw/wlogout $BASEDIR/wlogout
	cd $BASEDIR/wlogout || exit 2
	git pull origin master --recurse-submodules
	git checkout . # for some reason the build modifies version managed files...
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# ROFI WAYLAND
function install_rofi_wayland() {
	[ -d $BASEDIR/rofi ] || git clone https://github.com/lbonn/rofi $BASEDIR/rofi
	cd $BASEDIR/rofi || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local -Dxcb=disabled build
	ninja -C build
	ninja -C build install --quiet
}

# WAYBAR
function install_waybar() {
	[ -d $BASEDIR/Waybar ] || git clone https://github.com/Alexays/Waybar $BASEDIR/Waybar
	cd $BASEDIR/Waybar || exit 2
	git pull origin master --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
	rm -f /tmp/hypr && ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr
}

# Sway Notifications
function install_swaync() {
	[ -d $BASEDIR/SwayNotificationCenter ] || git clone https://github.com/ErikReider/SwayNotificationCenter $BASEDIR/SwayNotificationCenter
	cd $BASEDIR/SwayNotificationCenter || exit 2
	git pull origin main --recurse-submodules
	rm -rf ./build
	meson setup --reconfigure --prefix=/usr/local build
	ninja -C build
	ninja -C build install --quiet
}

# XDG DESKTOP PORTAL HYPRLAND
function install_xdg_portal() {
	export QT_DIR=/usr/lib/qt6
	[ -d $BASEDIR/xdg-desktop-portal-hyprland ] || git clone --recursive https://github.com/hyprwm/xdg-desktop-portal-hyprland $BASEDIR/xdg-desktop-portal-hyprland
	cd $BASEDIR/xdg-desktop-portal-hyprland/ || exit 2
	rm -rf ./build
	git pull origin master --recurse-submodules
	cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/local/lib -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build build
	sudo cmake --install build
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build # for neovim
}

# NWG LOOK
function install_nwglook() {
	[ -d $BASEDIR/nwg-look ] || git clone https://github.com/nwg-piotr/nwg-look $BASEDIR/nwg-look
	cd $BASEDIR/nwg-look || exit 2
	git pull origin main --recurse-submodules
	make build && sudo make install
}

# WPGTK
function install_wpgtk() {
	[ -d $BASEDIR/wpgtk ] || git clone https://github.com/deviantfero/wpgtk $BASEDIR/wpgtk
	cd $BASEDIR/wpgtk || exit 2
	git pull origin master --recurse-submodules
	~/.venv/bin/pip3 install .
	~/.venv/lib/python3.12/site-packages/wpgtk/misc/wpg-install.sh -gi
}

# hyprwayland_scanner
function install_hypr_scanner() {
	[ -d $BASEDIR/hyprwayland-scanner ] || git clone https://github.com/hyprwm/hyprwayland-scanner $BASEDIR/hyprwayland-scanner
	cd $BASEDIR/hyprwayland-scanner || exit 2
	rm -rf ./build
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build ./build -j $(nproc)
	sudo cmake --install ./build
}

function install_hyprgraphics() {
	[ -d $BASEDIR/hyprgraphics ] || git clone https://github.com/hyprwm/hyprgraphics $BASEDIR/hyprgraphics
	cd $BASEDIR/hyprgraphics || exit 2
	rm -rf ./build
	git pull origin main --recurse-submodules

	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
}

# aquamarine
function install_aquamarine() {
	[ -d $BASEDIR/aquamarine ] || git clone https://github.com/hyprwm/aquamarine $BASEDIR/aquamarine
	cd $BASEDIR/aquamarine || exit 2
	rm -rf ./build
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build ./build -j $(nproc)
	sudo cmake --install ./build
}

function install_glaze() {
	[ -d $BASEDIR/glaze ] || git clone https://github.com/stephenberry/glaze $BASEDIR/glaze
	cd $BASEDIR/glaze || exit 2
	rm -rf ./build
	git pull origin main --recurse-submodules
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local -B build
	cmake --build ./build -j $(nproc)
	sudo cmake --install ./build
}

# EPOLL SHIM
function install_epoll_shim() {
	[ -d $BASEDIR/epoll-shim ] || git clone https://github.com/jiixyj/epoll-shim $BASEDIR/epoll-shim
	cd $BASEDIR/epoll-shim || exit 2
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
	[ -d $BASEDIR/youtube-music ] || git clone https://github.com/th-ch/youtube-music $BASEDIR/youtube-music
	cd $BASEDIR/youtube-music || exit 2
	git pull origin master --recurse-submodules
	npm i --legacy-peer-deps && npm run build
	~/.local/share/pnpm/pnpm dist:linux
	sudo cp pack/*.AppImage /usr/local/bin/youtube-music
}

set -e # exit on error

mkdir -p $BASEDIR # We will checkout source code for various projects here

install_packages
install_go # Ubuntu version is too old for nwg-look
install_rust

install_catch2
install_rofi_wayland
install_libdrm
install_libxcberrors # not needed
install_swaylock
install_swww
install_pywal
install_hypr_scanner

# install_wayland_protocols # Ubuntu 24.10 version is adequate
# install_wayland_utils # Ubuntu 24.10 version is adequate - must keep in sync with wayland-protocols

install_rofi_wayland
install_hyprutils
install_hyprlang
install_hyprcursor
install_hyprqtutils
install_swayidle
install_wlogout
install_waybar
install_xdg_portal
install_swaync

install_nwglook
install_wpgtk
install_hyprland_protocols
install_hyprgraphics
install_aquamarine
install_glaze
install_hyprland
# # install_yt_music # optional...

echo
echo "Four more important steps for you to do:"
echo "1. run nwg-look and select FlatColor theme and icons"
echo "2. enable the rice by running 'stow' - e.g. 'cd $BASEDIR && stow --target=~/ hyprdots'"
echo "3. if you DO NOT have a 4k monitor, edit ~/.config/hypr/hyprland.conf file and modify the monitor line to change ',highres,auto,2' to ',highres,auto,1' because you probably don't want to scale to double size like me - otherwise everything will be scaled to double size"
echo "4. logout and log back in, but make sure you choose the hyprland window manager in the sddm login screen"
echo "5. If you find hyprland isn't starting up it could be because of max open files errors, so you might want to set the following in /etc/sysctl.conf:"
echo "   fs.inotify.max_user_instances=512"
echo "   fs.inotify.max_user_watches=256000"
