#!/bin/bash
sudo mdutil -i off -a
sudo rm -rf /Applications/Xcode_11* &
hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 300g ~/android.dmg.sparseimage
mkdir -p ~/aosp
hdiutil attach -mountroot ~/aosp ~/android.dmg.sparseimage &
mkdir ~/bin
PATH=~/bin:$PATH
ulimit -S -n 20480
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
git config --global user.name "Apon77"
git config --global user.email "khalakuzzamanapon5@gmail.com"
git config --global color.ui true

brew install ccache &
mkdir -p ~/aosp/untitled/aex
cd ~/aosp/untitled/aex
repo init --depth=1 -u git://github.com/AospExtended/manifest.git -b 11.x -g default,-notdefault,-device,-mips
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j 30 device/xiaomi/mido


cd build/soong/
git fetch https://github.com/LineageOS/android_build_soong
git cherry-pick 7e5cbc10ec376269c29ef6c30ed60db592af7985
cd -


. build/envsetup.sh
lunch aosp_mido-user
export CCACHE_DIR=~/aosp/untitled/aex/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
ccache -M 20G
ccache -o compression=true
make aex -j 24
curl --upload-file out/target/product/mido/*.zip https://free.keep.sh || echo failed to upload
