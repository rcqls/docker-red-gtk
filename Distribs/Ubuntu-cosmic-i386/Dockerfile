FROM i386/ubuntu:cosmic

MAINTAINER "Cqls Team"


RUN apt-get update && apt-get install -y wget && apt-get install -y git

RUN apt-get install -y libc6 libcurl4 

RUN apt-get install -y libgtk-3-bin librsvg2-common libcanberra-gtk-module  libcanberra-gtk3-module  at-spi2-core 

RUN apt-get install -y dbus-x11 strace

RUN apt-get install -y \
	git autoconf automake meson ninja-build pkg-config parallel ruby-sass sassc optipng \
	inkscape \
	libgtk-3-dev libgdk-pixbuf2.0-dev libglib2.0-dev libglib2.0-bin \
	libxml2-utils librsvg2-dev \
	gnome-themes-standard gtk2-engines-murrine gtk2-engines-pixbuf libcanberra-gtk3-module \
	fonts-roboto-hinted fonts-noto-hinted


RUN apt-get remove -y numix-gtk-theme

RUN apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN useradd -m user

RUN mkdir -p /var/run/dbus

USER user

RUN mkdir -p /home/user/rebol

WORKDIR /home/user/rebol

RUN wget http://www.rebol.com/downloads/v278/rebol-core-278-4-3.tar.gz

RUN tar xzvf rebol-core-278-4-3.tar.gz

ENV PATH /home/user/rebol/releases/rebol-core:$PATH

RUN chmod u+x /home/user/rebol/releases/rebol-core/rebol

RUN mkdir -p /home/user/red

WORKDIR /home/user/red

######################################################
### The following lines are still here only for kind reminder (since console-gtk even if it compiles does not work properly)
RUN git clone -b GTK https://github.com/red/red.git
WORKDIR /home/user/red/red
ADD console-gtk.red /home/user/red/red/environment/console/CLI/console.red
#DEVEL# RUN echo 'Rebol[] do/args %red.r "-r %environment/console/CLI/console.red"' | rebol +q -s
####################################################

RUN wget https://toltex.u-ga.fr/users/RCqls/Red/console-gtk

ADD red-compile /home/user/red/red/red-compile

RUN git clone https://github.com/tliron/install-gnome-themes /home/user/install-gnome-themes

USER root

#DEVEL# RUN chmod u+x console && chown user:user console

RUN chmod u+x console-gtk && chown user:user console-gtk

RUN chmod u+x red-compile && chown user:user red-compile

## cleanup package manager

RUN apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


USER user

ENV PATH /home/user/red/red:$PATH

RUN mkdir /home/user/work

WORKDIR /home/user/work

CMD ["/bin/bash"]
