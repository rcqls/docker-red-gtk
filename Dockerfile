FROM ubuntu

MAINTAINER "Cqls Team"

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y wget && apt-get install -y git

RUN apt-get install -y libc6:i386 libcurl4:i386 

RUN apt-get install -y libgtk-3-bin:i386 librsvg2-common:i386 libcanberra-gtk-module:i386 libcanberra-gtk3-module:i386 at-spi2-core:i386

RUN apt-get install -y dbus-x11:i386 strace

#RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/libg/libgksu/libgksu2-0_2.0.13/home/userpre1-9ubuntu2_amd64.deb
#RUN apt install -y ./libgksu2-0_2.0.13/home/userpre1-9ubuntu2_amd64.deb

#RUN wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gksu/gksu_2.0.2-9ubuntu1_amd64.deb
#RUN apt install -y  ./gksu_2.0.2-9ubuntu1_amd64.deb

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
RUN git clone -b GTK https://github.com/rcqls/red.git
WORKDIR /home/user/red/red
ADD console-gtk.red /home/user/red/red/environment/console/CLI/console-gtk.red
#USELESS: RUN echo 'Rebol[] do/args %red.r "-r %environment/console/CLI/console.red"' | rebol +q -s
#DOES NOT WORK: RUN echo 'Rebol[] do/args %red.r "-r %environment/console/CLI/console-gtk.red"' | rebol +q -s
## DO NOT PUT IN THE REPO: ADD console-gtk console-gtk
####################################################

RUN wget https://toltex.u-ga.fr/users/RCqls/Red/console-gtk

USER root

RUN chmod u+x console-gtk && chown user:user console-gtk

USER user

ENV PATH /home/user/red/red:$PATH

RUN mkdir /home/user/work

WORKDIR /home/user/work

CMD ["/bin/bash"]
