FROM i386/centos

MAINTAINER "Cqls Team"

RUN yum install -y glibc libcurl gtk3 wget git

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

USER root

#DEVEL# RUN chmod u+x console && chown user:user console

RUN chmod u+x console-gtk && chown user:user console-gtk

RUN chmod u+x red-compile && chown user:user red-compile

USER user

ENV PATH /home/user/red/red:$PATH

RUN mkdir /home/user/work

WORKDIR /home/user/work

CMD ["/bin/bash"]
