#!/usr/bin/env bash

src_dir="/nightingale-hacking"
local_src="/tmp/nightingale-hacking"
output_dir="/vagrant/dist"

mkdir -p $local_src
mkdir -p $output_dir

# Install build dependencies
apt-get update
apt-get install -qq -y autoconf g++ libgtk2.0-dev libdbus-glib-1-dev libtag1-dev libgstreamer-plugins-base0.10-dev zip unzip libidl-dev libasound2-dev

# Copy the Nightingale source into a non-shared folder
cp -rf $src_dir/* $local_src/

# Add system-specific build config settings
echo 'ac_add_options --with-taglib-source=packaged' >> $local_src/nightingale.config

# BUILD
cd $local_src && $local_src/build.sh

# Sync the build to the host machine
cp -rf $local_src/compiled/dist/* $output_dir/
