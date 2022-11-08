#! /usr/bin/env bash

rm ./*.png

logoFilename='logo64.png'

for directory in ../../../kernels/available/*; do
  dirName=$(basename $directory)
  #echo "$directory/$logoFilename"
  #echo  "$dirName-$logoFilename"
  ln -s "$directory/$logoFilename" "$dirName-$logoFilename"
done
