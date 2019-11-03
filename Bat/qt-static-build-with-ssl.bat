configure -opensource -confirm-license -static -static-runtime -mp -no-shared -debug-and-release -force-debug-info ^
	-platform win32-msvc2019 ^
	-prefix D:\Documents\Git\qt-everywhere-src-5.13.2\qt-5.13.2 ^
	-ssl -openssl-linked -ID:\Documents\Git\openssl-1.0.2k-vs2015\include -LD:\Documents\Git\openssl-1.0.2k-vs2015\lib ^
	OPENSSL_LIBS="-lGdi32 -lUser32 -lAdvapi32 -lWs2_32" ^
	OPENSSL_LIBS_DEBUG="-llibeay32MTd -lssleay32MTd" ^
	OPENSSL_LIBS_RELEASE="-llibeay32MT -lssleay32MT" ^
	-nomake examples -nomake tests -opengl desktop -no-direct2d -no-compile-examples -qt-zlib -qt-libpng -qt-libjpeg ^
	-skip qt3d -skip qtandroidextras -skip qtdatavis3d -skip qtcharts -skip qtconnectivity -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation -skip qtlottie -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtsvg -skip qttools -skip qttranslations -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebglplugin -skip qtwebsockets -skip qtwebview -skip qtx11extras -skip qtxmlpatterns
