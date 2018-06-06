Name:      ffmpeg
Version:   %_version
#Ne pas enlever le .ives a la fin de la release !
#Cela est utilise par les scripts de recherche de package.
Release:   1.ives%{?dist}
Summary:   [IVeS] Utilities and libraries to record, convert and stream audio and video
Vendor:    FFMPEG
Group:     Applications/Multimedia
License: GPL
URL:       http://www.ffmpeg.org
BuildArchitectures: x86_64 i686 i386 i586
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
%define distribution        %(/usr/lib/rpm/redhat/dist.sh --distnum)
%if %{distribution} == 5
BuildRequires: opencore-amr-devel, x264-devel >= 0.7.0, gsm-devel
%else
BuildRequires: opencore-amr-devel, x264-devel >= 0.7.0, gsm-devel
%endif
Requires:  ivespkg, x264 >= 0.7.0

%description
FFmpeg is a very fast video and audio converter. It can also grab from a
live audio/video source.
The command line interface is designed to be intuitive, in the sense that
ffmpeg tries to figure out all the parameters, when possible. You have
usually to give only the target bitrate you want. FFmpeg can also convert
from any sample rate to any other, and resize video on the fly with a high
quality polyphase filter. This version is rempackaged by IVeS and contains
some in house patches and correction

%package devel
Summary: Libraries, includes to develop applications with %{name}.
Group: Development/Libraries
Requires: %{name} = %{version}

%description devel
The %{name}-devel package contains the header files and static libraries for
building apps and func which use %{name}.
  
%clean
echo "############################# Clean"
echo Clean du repertoire $RPM_BUILD_ROOT
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%build
echo "Build"
echo "############################# Build"
echo $PWD
cd %_topdir
cd ..
./configure --prefix=/usr --libdir=%{_libdir} --shlibdir=%{_libdir} --enable-pthreads --enable-libgsm --enable-shared --disable-ffplay --disable-ffserver --enable-libx264 --enable-gpl --enable-nonfree --disable-devices --enable-swscale --enable-pic --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvpx --enable-version3 --extra-ldflags="-L/home/ebuu/mediaserver/staticdeps/lib" --extra-cflags="-I/home/ebuu/mediaserver/staticdeps/include"
make

%install
echo "Install" $PWD
cd %_topdir
cd ..
make DESTDIR=$RPM_BUILD_ROOT install

%files
%defattr(-,root,root,-)
%{_libdir}/*.so
%{_libdir}/*.so.*
/usr/bin/*
%{_libdir}/pkgconfig/
/usr/share/ffmpeg/*.ffpreset
/usr/share/man/man1/
/usr/share/man/man3/libavcodec.3.gz
/usr/share/man/man3/libavdevice.3.gz
/usr/share/man/man3/libavfilter.3.gz
/usr/share/man/man3/libavformat.3.gz
/usr/share/man/man3/libavutil.3.gz
/usr/share/man/man3/libswresample.3.gz
/usr/share/man/man3/libswscale.3.gz
/usr/share/ffmpeg/ffprobe.xsd

%files devel
%defattr(-,root,root)
%attr(0755,root,root) /usr/include/*/*.h
%{_libdir}/*.a
/usr/share/ffmpeg/examples/

%changelog
* Mon Mar 17 2015 Emmanuel BUU <emmanuel.buu@ives.fr>
- integration ffmpeg 2.2.14

