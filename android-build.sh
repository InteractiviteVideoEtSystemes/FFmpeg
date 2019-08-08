#!/bin/sh
export BUILD_ARCHS="x86_64 arm64 x86 armv5te armv7-a armv7-a-neon" 
#export BUILD_ARCHS="x86"
export SAV_PATH=$PATH
export LOG=build.log
export PREFIX=android

date >$LOG

#rm -rf $PREFIX

for arch in $BUILD_ARCHS
do
  echo "x264 path: $PATH_X264"
	
	export CPPFLAGS=""
  export ASFLAGS=""
  export SYSROOT=""
	export CC=""
	export AR=""
	export CXX=""
  export AS=""
	export RANLIB=""
	export STRIP=""
  export CFLAGS=""
  export LDFLAGS=""
  export ANDROID_PREFIX=""
  export ANDROID_TOOLCHAIN=""

	case "$arch" in
		x86)
      echo -e "x86 config"export HOST=$NDK/toolchains/x86-$GCC_VERSION/prebuilt/linux-x86_64/bin/i686-linux-androideabi
      export ANDROID_VERSION=9
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/x86-$GCC_VERSION/prebuilt/linux-x86_64/bin/i686-linux-android
     	export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-x86
      export ANDROID_PREFIX=i686-linux-android
      export ANDROID_TOOLCHAIN=$NDK/toolchains/x86-$GCC_VERSION/prebuilt/linux-x86_64/
      export CFLAGS="-march=x86 -mtune=intel -mssse3 -mfpmath=sse -m32 -fPIC -I/$PATH_X264/android/x86/include"
      export LDFLAGS='-L/$PATH_X264/android/x86/lib'
		;;
		armv7-a)
      echo -e "armv7-a config"
      export ANDROID_VERSION=9
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/bin/arm-linux-androideabi
			export ANDROID_PREFIX=arm-linux-androideabi
			export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-arm
			export ANDROID_TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/
      export CFLAGS="-march=armv7-a -mfloat-abi=softfp -Os -O3 -fPIC -I/$PATH_X264/android/armv7-a/include"
      export LDFLAGS="-L/$PATH_X264/android/armv7-a/lib"
		;;
		armv7-a-neon)
      echo -e "armv7-a-neon config"
      export ANDROID_VERSION=21
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/bin/arm-linux-androideabi
			export ANDROID_PREFIX=arm-linux-androideabi
			export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-arm
      export ANDROID_TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/
			export CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -I/$PATH_X264/android/armv7-a-neon/include"
      export LDFLAGS="-Wl,--fix-cortex-a8 -L/$PATH_X264/android/armv7-a-neon/lib"
		;;
    arm64)
      echo -e "arm64 config"
      export ANDROID_VERSION=21
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/aarch64-linux-android-$GCC_VERSION/prebuilt/linux-x86_64/bin/aarch64-linux-android
      export ANDROID_PREFIX=aarch64-linux-android
      export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-arm64
      export ANDROID_TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-$GCC_VERSION/prebuilt/linux-x86_64/
      export CFLAGS="-march=armv8-a -Os -O3 -fPIC -I/$PATH_X264/android/arm64/include"
      export LDFLAGS="-L/$PATH_X264/android/arm64/lib"
    ;;
    x86_64)
      echo -e "x86_64 config"   
      export ANDROID_VERSION=21
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/bin/x86_64-linux-android
      export ANDROID_PREFIX=x86_64-linux-android
      export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-x86_64
      export ANDROID_TOOLCHAIN=$NDK/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/
      export CFLAGS="-msse4.2 -mpopcnt -m64 -mtune=intel -fomit-frame-pointer -O3 -fPIC -I/$PATH_X264/android/x86_64/include"
      export LDFLAGS="-L/$PATH_X264/android/x86_64/lib"
    ;;
		*)
      echo -e "Generic config"   
			export ANDROID_PREFIX=arm-linux-androideabi
      export ANDROID_VERSION=9
      export GCC_VERSION=4.9
      export HOST=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/bin/arm-linux-androideabi
			export SYSROOT=$NDK/platforms/android-$ANDROID_VERSION/arch-arm
			export ANDROID_TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/
      export CFLAGS="-I/$PATH_X264/android/armv5te/include"
      export LDFLAGS="-L/$PATH_X264/android/armv5te/lib"
		;;
	esac

	if [ $arch = "x86" ]
  then 
      export CC='ccache $ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-gcc' 
      export LD=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-ld
      export AR=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-ar
  else 
      export CC='$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-gcc'
      export LD=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-ld
      export AR=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-ar
      export CXX=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-g++
      export AS=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-as
      export RANLIB=$ANDROID_TOOLCHAIN/bin/$ANDROID_PREFIX-ranlib
      export STRIP=""
  fi 

	if [ $arch = "x86" ]; then \
	   export CFG_OPT="--disable-everything \
      --enable-pic  \
      --enable-static \
      --disable-shared \
      --disable-network \
      --disable-protocols \
      --disable-devices \
      --disable-filters \
      --disable-bsfs \
      --disable-muxers \
      --disable-demuxers \
      --disable-parsers \
      --disable-ffmpeg \
      --disable-ffplay \
      --disable-ffserver \
      --disable-encoders \
      --disable-decoders \
      --disable-zlib \
      --disable-debug \
      --enable-libvpx \
      --enable-encoder=h263 \
      --enable-encoder=h263p \
      --enable-decoder=h263 \
      --enable-decoder=h264 \
      --enable-encoder=mpeg4 \
      --enable-decoder=mpeg4 \
      --enable-parser=h264 \
      --enable-parser=vp8 \
      --enable-filter=hqdn3d \
      --enable-filter=removegrain \
      --enable-gpl \
      --disable-doc \
      --enable-cross-compile \
      --arch=$arch \
      --target-os=linux \
      --cross-prefix=${HOST}- \
      --cpu=i686 \
      --sysroot=${SYSROOT} \
      --disable-inline-asm \
      --disable-asm \
      --disable-devices \
      --disable-amd3dnow \
      --disable-amd3dnowext \
      --disable-yasm"
      else \
	    export CFG_OPT="--disable-everything \
      --enable-pic  \
      --enable-static \
      --disable-shared \
      --disable-network \
      --disable-protocols \
      --disable-devices \
      --disable-filters \
      --disable-bsfs \
      --disable-muxers \
      --disable-demuxers \
      --disable-parsers \
      --disable-ffmpeg \
      --disable-ffplay \
      --disable-ffserver \
      --disable-encoders \
      --disable-decoders \
      --disable-zlib \
      --disable-debug \
      --enable-libvpx \
      --enable-encoder=h263 \
      --enable-encoder=h263p \
      --enable-decoder=h263 \
      --enable-encoder=mpeg4 \
      --enable-decoder=mpeg4 \
      --enable-decoder=h264 \
      --enable-parser=h264 \
      --enable-parser=vp8 \
      --enable-filter=hqdn3d \
      --enable-filter=removegrain \
      --enable-gpl \
      --enable-asm \
      --enable-yasm \
      --disable-doc \
      --enable-cross-compile \
      --arch=$arch \
      --target-os=linux \
      --cross-prefix=${HOST}- \
      --sysroot=${SYSROOT}";
	fi

  make distclean >>$LOG

  echo -e  "building for ARCH="$arch" configure with" $CFG_OPT " " $PATH_X264 " LDFlags: " $LDFLAGS
  ./configure $CFG_OPT --prefix=$PREFIX/$arch --extra-cflags="$CFLAGS" --extra-ldflags="$LDFLAGS" >>$LOG

  export PATH=$SAV_PATH

	make clean >>$LOG
	make uninstall >>$LOG
	#make all >>$LOG
  make -j2 >>$LOG
  make install; >>$LOG
done
