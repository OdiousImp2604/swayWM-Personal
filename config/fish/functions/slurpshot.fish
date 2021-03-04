function slurpshot
  makoctl reload
  switch $argv
    case -f
      grim - | swappy -f -
    case -g
      if pgrep sway
        set geometry (swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
      else
        set geometry (slurp)
      end

      if string match -r $geometry "[0-9]+.*" $geometry
        grim -g $geometry - | swappy -f -
      else
        grim -o (printf "HDMI-A-1\nDP-2" | wofi --dmenu) - | swappy -f -
      end
    case -wf
      if pgrep sway
        set geometry (swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
      else
        set geometry (slurp)
      end

      if string match -r $geometry "[0-9]+.*" $geometry
        wf-recorder -f ~/Videos/(date +recording_%Y-%m-%d-%H%M%S.mp4) -g $geometry
        notify-send "Recording saved" ~/Videos/(date +recording_%Y-%m-%d-%H%M%S.mp4) -i video
      else
        set -l monitor (printf "HDMI-A-1\nDP-2" | wofi --dmenu)

        if test $monitor!=""
          wf-recorder -f ~/Videos/(date +recording_%Y-%m-%d-%H%M%S.mp4) -o $monitor
          notify-send "Recording saved" ~/Videos/(date +recording_%Y-%m-%d-%H%M%S.mp4) -i video
        end
      end

    end
end
