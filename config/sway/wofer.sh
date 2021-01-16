#!/bin/bash

# Unopiniated script that let's you emulate a file manager

FOLDER=~/.config/wofer

SHOW_HIDDEN=false # Hidden files toggle

if [[ "$@" =~ -c ]]; then
  source $(echo $@ | grep -o '\-c .*' | sed 's/\-c //')
elif [ ! -f $FOLDER/config ]; then # Checks if config file is there
  if [ ! -d "$FOLDER" ]; then
      mkdir $FOLDER
  fi
  curl -o "$FOLDER/config" 'https://gitlab.com/snakedye/wofer/-/raw/master/config?inline=false'  # Curls from the repo if it isn't
  source $FOLDER/config  # Source config file
else
  source $FOLDER/config  # Source config file
fi

if [[ -n "$@" && $EXEC!="$@" ]]; then
  export EXEC=$@
else
  export EXEC
fi


# Checking arguments
if [ -z "$EXEC" ]; then
  echo You need a runner, example ./wofer wofi --dmenu
  exit
elif [[ $1 == '--help' ]]; then
  if [ -f README.md ]; then
    cat README.md
  else
    xdg-open https://gitlab.com/snakedye/wofer
  fi
  exit
elif [[ $@ =~ --uwu ]]; then
  UWU=true
  EXEC=${EXEC//--uwu}
fi

lsi () {  # ls with icons
  if [[ $UWU == "true" ]]; then
    echo "🙉 Who's my little pog champ! 🐱"
  fi
  echo "   .."
  if [[ "$1" != "" ]]; then
    echo "$1 here"
  fi
  all=''
  if $SHOW_HIDDEN; then
    all='-A'
  fi
  ls $all | while read entry; do
    if [[ $UWU == 'true' ]]; then # changes icons if uwu mode enabled
      echo "   $entry"
    elif [ -d "$entry" ]; then  # special icons for directories
      case $entry in
        Document)
          echo "   $entry"
          ;;
        Pictures)
          echo "   $entry"
          ;;
        Videos)
          echo "   $entry"
          ;;
        Music)
          echo "   $entry"
          ;;
        *)
          echo "   $entry"
          ;;
      esac
    elif [[ $entry =~ \.(sh|c)$ ]]; then  # icons for filetype
      echo "   $entry"
    elif [[ $entry =~ \.(txt|log)$|rc$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.(jpg|png|svg|webp)$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.fish$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.md$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.py$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.js$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.css$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.html$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.mp4|mkv$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.(mp3|m4a)$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.(pdf)$ ]]; then
      echo "   $entry"
    elif [[ $entry =~ \.(tar|zip) ]]; then
      echo "   $entry"
    else
      echo "   $entry"
    fi
  done
}

# Displays options for files and directories
prompt () {
  if [ -z "$1" ]; then # options for directories
    echo "   Open directory in $FM"
    echo "   Copy $PWD"
    echo "   Link $PWD"
    echo "   Move $PWD"
    echo "   Delete $PWD"
  else  # options for files
    echo "   Launch $1"
    case $( echo "$1" | sed 's/.*\.//' ) in
      png | jpeg | jpg | gif | mp4 | webp | svg)
        echo "   Upload $1 to imgur"
        echo "   Set $1 as wallpaper"
        ;;
      zip | tar.gz)
        echo "   Extract $1"
        ;;
    esac
    echo "   Edit $1 in $EDITOR"
    echo "   Send $1 with KDE Connect"
    # echo "﯂   Run whatever $1"
	  echo "   Execute $1"
    echo "   Make $1 executable"
    echo "   Copy $1"
    echo "   Move $1"
    echo "   Link $1"
    echo "   Upload $1 to gofile.io"
    echo "   Rename $1"
    echo "   Move to trash $1"
    echo "   Delete $1"
  fi
}

extension () {
  $EXTENSIONS/$@
}
 
# Backend of the prompt function
menu () {
  LOC=""
  if [[ -f "$@" ]]; then
    OPTION=$( prompt "$1"  | $EXEC | tail -1 );
    LOC="$1"
  elif [[ -n "$@" ]]; then
    OPTION=$1
    LOC="$2"
  else
    LOC=$PWD
    OPTION=$( prompt ""  | $EXEC );
    d="-r"
  fi
  case $(echo $OPTION | grep -o '[a-zA-Z]*') in
    Execute* |'./'* )
      if [ -r "$LOC" ]; then
        ./$LOC
      fi
      exit
      ;;
    Run* )
      $(echo "Run a command" | $EXEC) "$LOC"
      ;;
    Edit* )
      if [[ $EXEC =~ fzf ]]; then
        $EDITOR "$LOC"
      else
        $TERM $EDITOR $LOC &
        # $TERM ~/wofer/extensions/nvim "$LOC" & # Edit this based on you terminal
        exit
      fi
      ;;
    Launch* )
      launcher "$LOC"
      ;;
    Open* )
      if [[ $EXEC =~ fzf ]]; then
        $FM $LOC
      else
        $FM "$LOC" &
        exit
      fi
      ;;
    Send* )
      extension kdeconnect "$LOC"
      ;;
    Copy* |cp* )
      DESTINATION=$(runner "Copy")
      if [[ "$DESTINATION"!="$PWD" ]]; then
        cp $d "$LOC" "$DESTINATION" 
        cd "$DESTINATION"
      fi
      ;;
    Link* |ln* )
      DESTINATION=$(runner "Link")
      ln -s "$LOC" "$DESTINATION"
      ;;
    Make* |exe* )
      chmod +x "$LOC"
      ;;
    Set* )
      extension wallpaper "$LOC"
      ;;
    'Move to trash'* )
      mv "$LOC" ~/.local/share/Trash/files/
      ;;
    Move* |mv* )
      DESTINATION=$(runner "Move")
      if [[ "$DESTINATION"!="$PWD" ]]; then
        mv "$LOC" "$DESTINATION" 
        cd "$DESTINATION"
      fi
      ;;
    Rename* |rn* )
      mv "$LOC" "$($EXEC)"
      ;;
    Upload* |up* )
      if [[ $OPTION =~ imgur ]]; then
        extension imgur "$LOC"
        notify-send 'Uploaded to imgur' $(wl-paste) -i "$PWD/$LOC"
      else
        fish -c "gofile $LOC"
      fi
      exit
      ;;
    Extract* )
      DESTINATION=$( runner "Extract" )
      if unzip -q "$LOC" -d "$DESTINATION" ; then
        :
      else
        tar xzf "$LOC" -C "$DESTINATION"
      fi
      ;;
    Delete* |rm* )
      rm $d -f "$LOC"
      ;;
  esac
}

# Choose the app launcher basically, it will default to xdg-open
launcher () {
  case $( echo "$1" | sed 's/.*\.//' ) in
    jpg | jpeg | png | webp | svg | gif)
      imv "$1" &
      ;;
    mp4 | mkv)
      mpv "$1" &
      ;;
    pdf)
      zathura "$1" &
      ;;
    *)
      xdg-open "$1" 2> /dev/null
      ;;
  esac
}

# I think the name is quite explicit
shortcuts () {
  case $1 in
    '?' | ':') # launch menu for directories
      menu ''
      ;;
    :help) # sends you to the repo readme
      xdg-open https://gitlab.com/snakedye/wofer
      exit
      ;;
    :h | :hidden) # show/hide hidden files/directories
      if $SHOW_HIDDEN; then
        SHOW_HIDDEN=false
      else
        SHOW_HIDDEN=true
      fi
      ;;
    :m) # launches the manga extension
      extension manga
      ;;
    ZZ)
      fish # usefull for fzf
      ;;
    !delete) # delete the current directory
      rm -r "$PWD"
      ;;
    "🙉 Who's my little pog champ! 🐱")
      xdg-open https://static2.thegamerimages.com/wordpress/wp-content/uploads/2019/12/poggers-e-pogchamp-cke.jpg
      ;;
    *)
      if [[ "$1" =~ ^~/ ]]; then  # brings you to the home menu
        str='~/'
        cd "${1/$str/"$HOME/"}"
      elif [[ "$1" =~ ^[?] ]]; then  # fd integration
        query="${1/?/}"
        finder=$( fd "$query" | $EXEC )
        if [ -d $finder ]; then
          cd $finder
        else
          menu $finder
        fi
      else
        menu $@
      fi
      ;;
  esac
}

# You shouldn't have to touch this function
runner () {
  while :
  do
    stdout=$( lsi "$1" | $EXEC | tail -1 )
    ENTRY=${stdout:4} # ik it's lazy but it works
    if [ -z "$stdout" ]; then
      break
    elif [ -f "$stdout" ]; then
      menu "$stdout"
    elif [ -f "$ENTRY" ]; then
      menu "$ENTRY"
    elif [ -d "$ENTRY" ]; then
      cd "$ENTRY"
    elif [ -d "$stdout" ]; then
      cd "$stdout"
    elif [[ "$stdout" =~ "$1 here" ]]; then
      echo $PWD
      break
    elif [[ $ENTRY =~ \.\. ]]; then
      cd ..
    else
      shortcuts "$stdout"
    fi
  done
}

runner

