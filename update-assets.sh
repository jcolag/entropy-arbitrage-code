#!/usr/bin/bash

from=_eassets
to=assets
tsfile=.assets-latest
last=$(date --date=@0)

if [ -f .assets-latest ]
then
  old=$(cat "${tsfile}")
  last=$(date --date=@"${old}")
fi

find "${to}" -newermt "${last}" -type f -print | while read -r file
do
  case "${file}" in *.avif)
    true;;
  *)
    mv "${file}" "${from}"
  esac
done

find "${from}" -newermt "${last}" -not -path "${from}/.git/*" -type f -print | while read -r file
do
  base=$(basename "${file}")
  dest="${to}/${base}.avif"

  avifenc --min 30 --max 63 --speed 0 --yuv 420 -d 8 --codec aom "${file}" "${dest}"
  if [ $? == 1 ]
  then
    cp "${from}/${base}" "${to}"
  fi
done

date +%s > "${tsfile}"

