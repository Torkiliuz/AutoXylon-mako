#!/bin/bash

# Auto compiling script for Xylon custom ROM
# Made by Torkiliuz
# Android™ • 2013


# Get colored text…
cya=$(tput setaf 6)                   #  Cyan
bldcya=${txtbld}$(tput setaf 6) #  Bold cyan
txtrst=$(tput sgr0)                    #  Reset colors

# Start-time of script
res1=$(date +%s.%N)

# Shameless self-plug
echo -e "${bldcya}You are running a script made by Torkiliuz. Enjoy! ${txtrst}";

# Check for Java…
echo -e "${bldcya}Checking to see if Java is installed, and prompting to install if not ${txtrst}";
java

# Download Homebrew…
echo -e "${bldcya}Downloading and installing Homebrew, so we can run Linux-code ${txtrst}";
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

# Create bash_profile…
echo -e "${bldcya}Creating bash_profile ${txtrst}";
touch ~/.bash_profile

# Add Homebrew to bash_profile…
echo -e "${bldcya}Adding Homebrew-paths to bash_profile ${txtrst}";
echo "PATH=/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/android-sdk/tools:/usr/local/android-sdk/platform-tools" >> ~/.bash_profile
echo -e "${bldcya}Adding Mac SDK parts to bash_profile ${txtrst}";
echo export BUILD_MAC_SDK_EXPERIMENTAL=1 >> ~/.bash_profile

# Prepare system for Homebrew…
echo -e "${bldcya}Making everything ready for Homebrew ${txtrst}";
brew doctor
brew update
brew install git coreutils findutils gnu-sed gnupg pngcrush repo
brew outdated
brew upgrade

# Create necessary symbolic links for Homebrew…
echo -e "${bldcya}Creating symbolic links for some Homebrew-tools ${txtrst}";
ln -s /usr/local/bin/gfind /usr/local/bin/find
ln -s /usr/local/bin/gsed /usr/local/bin/sed

# Create sparse image for code…
echo -e "${bldcya}Creating a 60 GB sparse image partition were we will save the code and compilers etc. ${txtrst}";
hdiutil create -type SPARSE -fs "Case-sensitive Journaled HFS+" -size 60g -volname "android" -attach ~/Desktop/Android

# Enter directory and create folder for code…
echo -e "${bldcya}Entering sparse image partition and creating folder for code ${txtrst}";
cd /Volumes/Android
mkdir aosp

# Enter code folder…
echo -e "${bldcya}Entering code folder ${txtrst}";
cd aosp

# Initialize repo, and synchronize it…
echo -e "${bldcya}Initializing and synchronizing code repository ${txtrst}";
repo init -u git://github.com/XYAOSP/platform_manifest.git -b jb4.2
repo sync -j4

# Fix permissions for build-script…
echo -e "${bldcya}Fixing the permissions for the build-script ${txtrst}";
chmod 775 build-xy.sh

# Run build-script…
echo -e "${bldcya}Running build script ${txtrst}";
./build-xy.sh mako

#Time spent
res2=$(date +%s.%N)
echo "${bldcya}Time spent: ${txtrst}${cya}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
