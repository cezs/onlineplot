#!/bin/sh

automake_dir=/usr/share/automake-1.15

# download benchmark https://github.com/vetter/shoc.git
git clone https://github.com/vetter/shoc.git

# remove following error
# configure: error: cannot guess build type; you must specify one
cd shoc/build_aux
cp config.guess config.guess.backup
cp ${automake_dir}/config.guess .
cd ..
./configure
make
