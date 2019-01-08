## red/gtk for macOS and linux docker

THis si a quick try to launch `red/gtk` inside a  

### requirement (for macOS user only)

#### install

Please, before installing, check that these tools are not yet installed

```{bash}
brew cask install docker # updates are then automatically managed 
brew cask install xquartz
brew install socat
```
#### setup

This setup allows any x-application provided by docker containers to launch 

```{bash}
open -a Xquartz
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
```

If you want to stop socat: 

```{bash}
pkill socat
```

**NOTE:** to simplify these tasks, 

* add this to your `~/.bash_profile`
```{bash}
alias socat-start="open -a Xquartz;socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\\\"$DISPLAY\\\" &"
alias socat-stop="pkill socat"
```
* and start socat with `socat-start` and stop it with `socat-stop` 

### Managing image (for macOS and linux user)

#### build image

```{bash}
docker build -t rcqls/red-gtk https://github.com/rcqls/docker-red-gtk.git
```

#### use image

```{bash}
## for macOS user (replace interface 'en0' below if necessary with the active one by checking `ifconfig`)
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(ipconfig getifaddr en0):0 rcqls/red-gtk

## NOT TESTED: for linux user (replace interface 'eno0' with the active one if necessary by checking `ifconfig`)
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(/sbin/ip -o -4 addr list eno0 | awk '{print $4}' | cut -d/ -f1):0 rcqls/red-gtk
```

**NOTE:**: you can add this bash function in your `.bash_profile`

```{bash}
## for masOS user
function red-docker {
	ifs=$1
	ifaddr=""

	if [ "$ifs" = "" ]; then
		ifs="en0 en1 en2 eno0 eno1 eno2 eth0 eth1 eth2"
	fi

	for if in $ifs;do
		ifaddr=$(ipconfig getifaddr ${if})
		if [ "$ifaddr" != "" ];then 
			break
		fi
	done

	if [ $ifaddr = "" ];then
		echo "Error in red-docker: no IP address!"
		exit
	fi

	echo "red-docker connected to ${ifaddr}:0"

	docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=${ifaddr}:0 rcqls/red-gtk
}
```

and then launch `red-docker` (or `red-docker en2` if you know the active interface) instead.

#### test container

Inside the container,`console` is the compiled binary (when `console-gtk` is the downloaded binary) to test the `red` console with `Needs: 'View` option activated. You could then try:

```{bash}
console /home/user/red/red/tests/react-test.red
```

or 

```{bash}
console
```

or if `~/titi/toto.red` is a regular `red` file in the host systemfile

```{bash}
console titi/toto.red
```

## compile red file

### host file

If `~/titi/toto.red` is a regular `red` file in the host systemfile, you can compile it:

```{bash}
## cd ~/work (if you change of working directory)
red-compile titi/toto.red
```

### guest file

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

### comment on `red-compile`

In fact, `red-compile` is just a bash script containing 

```{bash}
redfile="$1"
echo "Rebol[] do/args %/home/user/red/red/red.r \"-r %${redfile}\"" | rebol +q -s
```

This script can be  extended to provide some similar usage provided by the `red` binary provided in the `red` website.

### Note for linux user

`console-gtk` binary can be downloaded directly [here](https://toltex.u-ga.fr/users/RCqls/Red/console-gtk)

## For Windows user

### docker

To test `red-gtk` with docker, you could try to adapt this using [x11docker](https://github.com/mviereck/x11docker) 

### Windows Subsystem for Linux (WSL)

However, the best solution is maybe to consider [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

After installation, you have just to follow step by step the installation inside the `Dockerfile`.

## Vagrant

It is also possible to adapt of this previous docker installation by using [Vagrant](https://www.vagrantup.com) (VagrantFile to automate installation) with Virtual machine (like Virtualbox).