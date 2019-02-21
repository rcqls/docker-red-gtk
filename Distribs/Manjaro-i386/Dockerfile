FROM jonathonf/manjaro-32-build

MAINTAINER "Cqls Team"

#RUN pacman --noconfirm -Syyu
RUN sed -i '/# Branch = /c\Branch = x32-stable' /etc/pacman-mirrors.conf
#RUN  pacman-mirrors -c all
RUN pacman --noconfirm -Sy archlinux32-keyring-transition
RUN pacman --noconfirm -S archlinux32-keyring
RUN pacman --noconfirm -Syu

RUN pacman --noconfirm -S lib-curl lib-gtk3 git wget

RUN pacman --noconfirm  -S libcurl-compat

RUN useradd -m user

RUN mkdir -p /var/run/dbus

USER user

RUN mkdir -p /home/user/rebol

WORKDIR /home/user/rebol

RUN wget http://www.rebol.com/downloads/v278/rebol-core-278-4-3.tar.gz

RUN tar xzvf rebol-core-278-4-3.tar.gz

ENV PATH /home/user/rebol/releases/rebol-core:$PATH

RUN chmod u+x /home/user/rebol/releases/rebol-core/rebol

ADD red-compile /home/user/red/red/red-compile

USER root

RUN chmod u+x red-compile && chown user:user red-compile

USER user

ENV PATH /home/user/work/.RedGTK:$PATH

RUN mkdir /home/user/work

WORKDIR /home/user/work

CMD ["/bin/bash"]
