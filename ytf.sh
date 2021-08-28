#!/bin/bash

# usage: yt (video|playlist|channel)

Color_Off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;97m'  # White

# YTDL
# codes: https://voussoir.net/writing/youtubedl_formats
# -i > ignore errors
# -o > output name template
# -w > no file overwrites
# -c > continue
# --write-sub OR --write-auto-sub

function ffmpegCheck() {
  if dpkg -l ffmpeg >/dev/null; then
    return
  else
    echo -e "${Red} [!] ffmpeg not found, installing... ${Color_Off}"
    sudo apt-get install ffmpeg -y
  fi
}

function selectQuality(media, mediaType) {
  case $mediaType in
    video)
    ;;
    playlist)
    ;;
    channel)
  esac
}

function getMedia() {
  echo -e "${Cyan} Enter dir for media: ${Color_Off}"
  read dir
  mkdir $dir
  echo -e "${Cyan} Entering '$dir' ${Color_Off}"
  cd "$dir" && pwd
  echo -e "${Green} ############################## ${Color_Off}"

  if [[ ${1} == "video" ]]; then
    echo -e "${Cyan} Enter video URL to save: ${Color_Off}"
    read -r c
    echo -e "${Green} Starting YTDL Service... ${Color_Off}"
    youtube-dl -f 'bestvideo,bestaudio' -ciw -o "%(title)s.%(ext)s" -i ${c}

  elif [[ ${1} == "playlist" ]]; then
    echo -e "${Cyan} Enter Playlist URL to save: ${Color_Off}"
    read -r c
    selectQuality(${c},${1}) # OKAYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY

    echo -e "${Green} ##############################"
    echo -e "${Cyan} Select quality for entire playlist:"
    echo -e "${Cyan} [1] Low-res (360p)" # 18
    echo -e "${Cyan} [2] High-res (720p)" # 22
    echo -e "${Cyan} [3] Audio-only" # 140
    echo -e "${Cyan} [4] Best possible quality ${Color_Off}"
    read -r q

    case ${q} in
      1)
      youtube-dl -f 18 -ciw -o "%(title)s.%(ext)s" -i ${c}
      ;;
      2)
      youtube-dl -f 22 -ciw -o "%(title)s.%(ext)s" -i ${c}
      ;;
      3)
      youtube-dl -f 140 -ciw -o "%(title)s.%(ext)s" -i ${c}
      ;;
      4)
      youtube-dl -f 'bestvideo,bestaudio' -ciw -o "%(title)s.%(ext)s" -i ${c}
    esac

  elif [[ ${1} == "channel" ]]; then
    echo -e "${Cyan} Enter Channel URL to save: ${Color_Off}"
    read -r c
    echo -e "${Green} Starting YTDL Service... ${Color_Off}"
    youtube-dl -f 'bestvideo,bestaudio' -ciw -o "%(title)s.%(ext)s" -v ${c}
  fi
}

ffmpegCheck
getMedia
