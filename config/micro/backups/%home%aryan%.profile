export MOZ_ENABLE_WAYLAND=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
#export WLR_NO_HARDWARE_CURSORS=1
source "$HOME/.cargo/env"
export GDK_BACKEND=x11 yad    
