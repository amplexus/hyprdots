# OVERVIEW

Original awesome work by [Stephan Raabe](https://gitlab.com/stephan-raabe) on `https://gitlab.com/stephan-raabe/dotfiles/`. 

I simply tweaked Stephen's work a bit to use `stow` for installation, as well as other minor tweaks to suit my workflow. 

Many background images sourced from [Gh0stzk dotfiles](https://github.com/gh0stzk/dotfiles), whose `bspwm` rice setup I previously tweaked to work on my Ubuntu system.

Sway notification config from [lvntcnylmz](https://github.com/lvntcnylmz/dotfiles/).

# DEPENDENCIES

Modified to work on my `Ubuntu 23.10` laptop running:
- https://github.com/hyprwm/Hyprland (compiled from source)
- https://github.com/Alexays/Waybar (compiled from source)
- https://github.com/jirutka/swaylock-effects (compiled from source)
- https://github.com/LGFae/swww (compiled from source)
- https://github.com/dylanaraps/pywal (compiled from source)
- https://github.com/swaywm/swayidle (compiled from source)
- https://github.com/ErikReider/SwayNotificationCenter (compiled from source)
- https://github.com/hyprwm/xdg-desktop-portal-hyprland (compiled from source)
- libwayland 1.22.0-2.1 (apt)
- xwayland 2.23 (apt)
- wayland-protocols 1.32 (apt)
- qtwayland5 5.15.10-2 (apt)
- qt6-wayland 6.4.2-3 (apt)

# INSTALLATION

First, install all the dependencies (some of which require building). The provided setup script should get you going.

Now `stow` the files:

```
git clone https://github.com/amplexus/hyprdots.git ~/hyprdots
cd ~/hyprdots
./setup.hyprdots.sh
cd ~/
stow --target=~/ hyprdots
```

Finally, logout and when logging in, choose the `Hyprland` window manager in the `sddm` dropdown.

# NVIDIA

`sudo ubuntu-drivers install`

