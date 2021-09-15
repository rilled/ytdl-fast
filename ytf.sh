#!/usr/bin/env bash

# usage: yt (video|playlist|channel)
Reset='\e[0m'
Green='\e[32m'
Red='\e[31m'
Cyan='\e[36m'
White='\e[97m'

# YTDL
# codes: https://voussoir.net/writing/youtubedl_formats
# -i > ignore errors
# -o > output name template
# -w > no file overwrites
# -c > continue
# --write-sub OR --write-auto-sub

DIR=""

function stripImport {
  read -p ${Cyan}"Enter desired file to import:"${Reset} file
  sed -i -r 's/(.{11}).*/\1/' ${file} # remove all fluf after video code, YT videos are always 11chars
  sed -i -e 's#^#https://youtube.com/watch?v=#' ${file} # append url prefix
  echo -e ${Green}"Import complete!"
}

function ytdlCheck {
  if dpkg -l youtube-dl >/dev/null; then
    return
  else
    echo -e "${Red} [!] youtube-dl not found, installing... ${Reset}"
    sudo apt-get install youtube-dl -y
}

function ffmpegCheck {
  if dpkg -l ffmpeg >/dev/null; then
    return
  else
    echo -e "${Red} [!] ffmpeg not found, installing... ${Reset}"
    sudo apt-get install ffmpeg -y
  fi
}

function selectQuality(media, mediaType) {
  case ${mediaType} in
    video | playlist | channel)
      echo -ne "${Green} ##############################
      ${Cyan} Select quality for download:
      ${White} [1] Low-res (360p) # 18
      ${White} [2] High-res (720p) # 22
      ${White} [3] Audio-only # 140
      ${White} [4] Best possible quality"
      read -p "${Green} ############################## ${Reset}" quality
      download(${media},${quality}) ;;
    *)
      echo ${Red}"Invalid input ${MediaType}"${Reset}
      exit 1 ;;
  esac
}

function download(media, quality, extras) { # todo: add support for thumbnails, desc and subs
  case ${quality} in
    1)
      youtube-dl -f 18 -ciw -o "%(title)s.%(ext)s" -i ${c} ;;
    2)
      youtube-dl -f 22 -ciw -o "%(title)s.%(ext)s" -i ${c} ;;
    3)
      youtube-dl -f 140 -ciw -o "%(title)s.%(ext)s" -i ${c} ;;
    4)
      youtube-dl -f 'bestvideo,bestaudio' -ciw -o "%(title)s.%(ext)s" -i ${c} ;;
  esac
}

function start() {
  ffmpegCheck
  ytdlCheck

  if [ ${2} == "-d" ] then
    read -p ${Cyan}"Enter dir for media:"${Reset} dir
    mkdir $dir
    echo -e ${Cyan}"Entering '$dir'"${Reset} && cd "$dir"
    DIR="${dir}"
  else
    echo -e ${Cyan}"Using current directory ${White} (use '-d' to specify directory)"${Reset}
    DIR=$(pwd)
  fi

  if [[ ${1} == "video" | "playlist" | "channel" ]]; then
    read -p ${Cyan}"Enter URL to save:"${Reset} c
    selectQuality(${c},${1})
  else
    echo ${Red}"Invalid selection."${Reset}
  fi
}

start
