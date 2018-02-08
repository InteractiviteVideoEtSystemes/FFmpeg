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
--prefix=$PREFIX \
--disable-debug \
--disable-programs \
--enable-pic"

# avresample
#CONFIGURE_FLAGS="$CONFIGURE_FLAGS --enable-avresample"

./configure \
--arch=$ARCH \
--cc="$CC" \
$CONFIGURE_FLAGS \
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

