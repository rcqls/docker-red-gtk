## red/gtk for macOS and linux docker

This project aims at executing commands related to `red/red:GTK` inside a linux docker container (running `red:GTK`with  Ubuntu, Archlinux or Centos distribution) from your host (macOS or linux).

### Quick start

### Requirement (for macOS user only)

Please, before installing, check that these tools are not yet installed

```{bash}
brew cask install docker # updates are then automatically managed 
brew cask install xquartz
brew install socat
```

### Main use (for macOS and linux user)

1. Download [docker-red-init.sh](https://raw.githubusercontent.com/rcqls/docker-red-gtk/master/script/docker-red-init.sh)
(TODO since not tested on linux: see [docker GUI for linux](https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110) to fix DISPLAY on host since maybe `docker run` comment needs `--net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw"` options)
1. Add it to `.bash_profile` (or similar)
```
if [ -f "<path-docker-red-init-sh>/docker-red-init.sh" ];then . <path-docker-red-init-sh>/docker-red-init.sh; fi
```
1. **macOS user only**: 
	* start socat: `docker-red service start`
	* stop socat: `docker-red service stop`
1. Build docker image(s): `docker-red [--dist ubuntu|arch|centos] build ` (default image built is ubuntu)
1. Tasks:
	* Run the container: `docker-red [--dist ubuntu|arch|centos] [repl]`
	* Compile: `docker-red [--dist ubuntu|arch|centos] [-c -u -r] [--root <red-relative-path> or <red-absolue-path-inside-container>] red-script`
	* Execute: `docker-red [--dist ubuntu|arch|centos] binary`

### Tutorial

TO COMPLETE SOON


### Alternative use (by hand)

This section is mainly provided to describe how the `docker-red` command works.

#### setup service

This setup allows any x-application provided by docker containers to launch 

```{bash}
open -a Xquartz
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
```

If you want to stop socat: 

```{bash}
pkill socat
```

#### managing image (for macOS and linux user)

1. build image
```{bash}
docker build -t rcqls/red-gtk https://github.com/rcqls/docker-red-gtk.git#:/Distribs/Ubuntu
```
1. use image
```{bash}
## for macOS user (replace interface 'en0' below if necessary with the active one by checking `ifconfig`)
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(ipconfig getifaddr en0):0 rcqls/red-gtk

## NOT TESTED: for linux user (replace interface 'eno0' with the active one if necessary by checking `ifconfig`)
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(/sbin/ip -o -4 addr list eno0 | awk '{print $4}' | cut -d/ -f1):0 rcqls/red-gtk
```
1. test container
Inside the container,`console` is the compiled binary (when `console-gtk` is the downloaded binary) to test the `red` console with `Needs: 'View` option activated. You could then try:
```{bash}
console-gtk /home/user/red/red/tests/react-test.red
```
or 
```{bash}
console-gtk
```
or if `~/titi/toto.red` is a regular `red` file in the host systemfile
```{bash}
console-gtk titi/toto.red
```
1.  compile red file

	* host file
If `~/titi/toto.red` is a regular `red` file in the host systemfile, you can compile it:
```{bash}
## cd ~/work (if you change of working directory)
red-compile titi/toto.red
```
	* guest file

In the example above, the host systemfile  `~/titi/toto.red` is named in the container (guest systemfile)  `/home/user/work/titi/toto.red` and then be compiled to create `toto` binary
```{bash}
red-compile /home/user/work/titi/toto.red
```
One can also compile with a relative path
```{bash}
## to create the binary inside this folder
cd /home/user/red/red/tests
## compile the red file
red-compile react-view.red
## to execute the binary file
react-view
```
In fact, `red-compile` is just a bash script containing 
```{bash}
redfile="$1"
echo "Rebol[] do/args %/home/user/red/red/red.r \"-r %${redfile}\"" | rebol +q -s
```
This script can be  extended to provide some similar usage provided by the `red` binary provided in the `red` website.

### Note for linux user

`console-gtk` binary can be downloaded directly [here](https://toltex.u-ga.fr/users/RCqls/Red/console-gtk)

### For Windows user

#### docker

To test `red-gtk` with docker, you could try to adapt this using [x11docker](https://github.com/mviereck/x11docker) 

#### Windows Subsystem for Linux (WSL)

However, the best solution is maybe to consider [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

After installation, you have just to follow step by step the installation inside the `Dockerfile`.

#### Vagrant

It is also possible to adapt of this previous docker installation by using [Vagrant](https://www.vagrantup.com) (VagrantFile to automate installation) with Virtual machine (like Virtualbox).