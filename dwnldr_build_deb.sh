#!/bin/sh

#  dwnldr_build_deb.sh
#  Dwnldr
#
#  Created by Stilldabomb
#  Copyright © 2015 Stilldabomb. All rights reserved.

rm -fr Builds/ || true
find . -iname ".DS_Store" | xargs rm -f
sudo rm dwnldr_staging/Library/MobileSubstrate/DynamicLibraries/Dwnldr.dylib || true
export EXTERNAL=1;xctool -sdk iphoneos -project Dwnldr.xcodeproj/ -scheme Dwnldr CODE_SIGNING_REQUIRED=NO owner=$1
sudo cp Builds/Dwnldr.dylib dwnldr_staging/Library/MobileSubstrate/DynamicLibraries/Dwnldr.dylib
sudo chown root:wheel dwnldr_staging/Library/MobileSubstrate/DynamicLibraries/Dwnldr.dylib
sudo ldid -S dwnldr_staging/Library/MobileSubstrate/DynamicLibraries/Dwnldr.dylib
dpkg-deb -b -Zgzip dwnldr_staging/ Dwnldr.deb
