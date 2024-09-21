search_text=$(wofi --show dmenu)

wl-copy "$(trans -b $1 "$search_text" | wofi --show dmenu)"