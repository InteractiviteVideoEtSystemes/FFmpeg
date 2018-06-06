#!/bin/bash
which gas-preprocessor.pl > /dev/null
if [ $? -ne 0 ]
then
	echo "Please install gas-preprocessor.pl"
	exit 10
fi

# --disable-filters

export  CONFIGURE_FLAGS="  \
--enable-static \
--enable-gpl \
--disable-filters \
--disable-parsers \
--disable-shared \
--disable-network \
--disable-protocols \
--disable-devices \
--disable-bsfs \
--disable-muxers \
--disable-demuxers \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffserver \
--disable-encoders \
--disable-decoders \
--disable-zlib \
--disable-debug \
--enable-encoder=h263 \
--enable-encoder=h263p \
--enable-decoder=h263 \
--enable-encoder=mpeg4 \
--enable-decoder=mpeg4 \
--enable-decoder=h264 \
--enable-parser=h264 \
--enable-parser=h263 \
--enable-parser=vp8 \
--enable-filter=hqdn3d \
--enable-filter=removegrain \
--disable-doc \
--enable-cross-compile \
--prefix=$PREFIX \
--disable-debug \
--disable-programs \
--enable-pic"

# avresample
#CONFIGURE_FLAGS="$CONFIGURE_FLAGS --enable-avresample"

#export ARCHS="arm64 armv7s armv7 armv6"
export ARCHS="arm64 armv7s armv7"
export DEPLOYMENT_TARGET="7.0"
export LOG=build.log

for ARCH in $ARCHS
do
echo "start build $ARCH" > $LOG
echo "building $ARCH..."
export PREFIX=$PWD/ios/$ARCH
CFLAGS="-arch $ARCH"
case "$ARCH" in
i386)
export PLATFORM="iPhoneSimulator"
export CFLAGS="$CFLAGS -mios-simulator-version-min=$DEPLOYMENT_TARGET"
;;
x86_64)
export PLATFORM="iPhoneSimulator"
export CFLAGS="$CFLAGS -mios-simulator-version-min=$DEPLOYMENT_TARGET"
;;
arm64)
PLATFORM="iPhoneOS"
export EXPORT="GASPP_FIX_XCODE5=1"
export CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET"
;;
armv7)
export PLATFORM="iPhoneOS"
#export CFLAGS='-march=armv7-a -mfloat-abi=softfp  '
#export LDFLAGS='-Wl,--fix-cortex-a8'
export CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET"
;;
armv7s)
export PLATFORM="iPhoneOS"
export CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET"
#export LDFLAGS=" -Wl,--fix-cortex-a8 -L$ARM_LIB -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker  -lc -lm -ldl -lgcc"
#export CFLAGS=" -march=armv7-a -mtune=cortex-a8 -mfpu=neon -msoft-float -D__ARM_ARCH_7__ -mfloat-abi=softfp"
;;
*)
;;
esac

export XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
export CC="xcrun -sdk $XCRUN_SDK clang"
export LDFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS"

./configure \
--target-os=darwin \
--arch=$ARCH \
--cc="$CC" \
$CONFIGURE_FLAGS \
--extra-cflags="$CFLAGS" \
--extra-cxxflags="$CXXFLAGS" \
--extra-ldflags="$LDFLAGS" \
--prefix="$PREFIX" >> $LOG
if [ $? -ne 0 ]
then
   echo "Failed to configure for arch " $ARCH
   echo "Check build.log"

   exit 20
fi
make clean  >> $LOG 2>&1
make  >> $LOG 2>&1
make install >> $LOG 2>&1

if [ -d $DOUBANGO/thirdparties/iphone/lib/$ARCH ]
then
	cp $PREFIX/lib/*.a $DOUBANGO/thirdparties/iphone/lib/$ARCH
	echo "Installed libs for arch " $ARCH " in doubango thirdparties."
fi

done

if [ -d $DOUBANGO/thirdparties/iphone/include ]
then
	cp -rp $PREFIX/include/* $DOUBANGO/thirdparties/iphone/include/
	echo "Installed headers in thirdparties"
fi

