#!/bin/bash
which gas-preprocessor.pl > /dev/null
if [ $? -ne 0 ]
then
	echo "Please install gas-preprocessor.pl"
	exit 10
fi

export PREFIX=$HOME/Documents/doubango/doubango/thirdparties/mac

if [ ! -d $PREFIX ]
then 
    echo "No doubqngo stack found. Expected to find it in:"
    echo $PREFIX
    exit 20
fi

export LOG=build.log

export  CONFIGURE_FLAGS="  \
--enable-static \
--enable-gpl \
--disable-shared \
--disable-devices \
--disable-ffplay \
--disable-ffserver \
--disable-zlib \
--enable-encoder=h263 \
--enable-decoder=h263 \
--enable-encoder=vp8 \
--enable-decoder=vp8 \
--enable-decoder=h264 \
--enable-filter=hqdn3d \
--enable-filter=removegrain \
--disable-filter=coreimage \
--disable-doc \
--prefix=$PREFIX \
--libdir=$PREFIX/lib/x86_64 \
--disable-debug \
--disable-programs \
--enable-pic"

# avresample
#CONFIGURE_FLAGS="$CONFIGURE_FLAGS --enable-avresample"

export XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
export CC="cc"

./configure \
$CONFIGURE_FLAGS \
--extra-cflags='-mmacosx-version-min=10.9' \
--extra-cxxflags='-mmacosx-version-min=10.9' \
--extra-ldflags='-mmacosx-version-min=10.9' \
--cc="$CC" \
--prefix="$PREFIX" # >> $LOG

if [ $? -ne 0 ]
then
   echo "Failed to configure for arch " $ARCH
   echo "Check build.log"

   exit 20
fi
make clean # >> $LOG 2>&1
make  # >> $LOG 2>&1
make install # >> $LOG 2>&1


done

if [ -d $DOUBANGO/thirdparties/iphone/include ]
then
	cp -rp $PREFIX/include/* $DOUBANGO/thirdparties/iphone/include/
	echo "Installed headers in thirdparties"
fi

