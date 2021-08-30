#!/bin/bash
Env_setup () {
	mkdir $HOME/surces
	export J=$(/usr/bin/nproc)
	export PREFIX=/usr
	export APP_PATH=$HOME/surces/
}

Wget () {
	cd $APP_PATH
	wget https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz
        tar xf wget-1.20.1.tar.gz
	cd wget-1.20.1
	./configure --prefix=/usr
 		    --sysconfdir=/etc
	            --with-ssl=openssl &&

	make -j$J 
	make -j$J install 

	cd $APP_PATH
	rm -rf wget-1.20.1
}

Pango () {
	cd $APP_PATH
	wget https://download.gnome.org/sources/pango/1.48/pango-1.48.9.tar.xz
	tar xf pango-1.48.9.tar.xz
	cd pango-1.48.9
        mkdir build
	cd build
	meson --prefix=/usr .. &&
        ninja
        sudo ninja install
        rm -rf pango-1.48.9
}

Oxugen-icon () {
        cd $APP_PATH
        wget https://download.kde.org/stable/frameworks/5.85/oxygen-icons5-5.85.0.tar.xz
        tar xf oxygen-icons5-5.85.0.tar.xz
        cd oxygen-icons5-5.85.0
	sed -i '/( oxygen/ s/)/scalable )/' CMakeLists.txt

	mkdir build &&

		cd    build &&


		cmake -DCMAKE_INSTALL_PREFIX=/usr -Wno-dev ..
        
	make -j$J
        sudo make -j$J install
        rm -rf oxygen-icons5-5.85.0
        
}
Env_setup
Wget
Pango
Oxugen-icon
