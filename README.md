# OVERVIEW

Original work by [Stephan Raabe](https://gitlab.com/stephan-raabe) on `https://gitlab.com/stephan-raabe/dotfiles/`.

Many background images sourced from [Gh0stzk dotfiles](https://github.com/gh0stzk/dotfiles).

# DEPENDENCIES

Modified to work on my `Ubuntu 23.10` laptop running:
- https://github.com/hyprwm/Hyprland (compiled from source)
- https://github.com/Alexays/Waybar (compiled from source)
- https://github.com/jirutka/swaylock-effects (compiled from source)
- https://github.com/LGFae/swww (compiled from source)
- https://github.com/dylanaraps/pywal (compiled from source)
- https://github.com/swaywm/swayidle (compiled from source)
- libwayland 1.22.0-2.1 (apt
- xwayland 2.23 (apt)
- wayland-protocols 1.32 (apt)
- qtwayland5 5.15.10-2 (apt)
- qt6-wayland 6.4.2-3 (apt)

# INSTALLATION

First, install all the dependencies (some of which require building).

Now `stow` the files:

```
git clone https://github.com/amplexus/hyprdots.git
stow --target=~/ hyprdots
```

Finally, logout and when logging in, choose the `Hyprland` window manager in the `sddm` dropdown.

# NVIDIA

`sudo ubuntu-drivers install`

