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

### Managing image (for macOS and linux user)

#### build image

```{bash}
docker build -t rcqls/red-gtk https://github.com/rcqls/docker-red-gtk.git
```

#### use image

```{bash}
## for macOS user
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(ipconfig getifaddr en0)$(ipconfig getifaddr en2):0 rcqls/red-gtk

## NOT TESTED: for linux user (change interface 'eno0' if necessary by checking `ifconfig`)
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(/sbin/ip -o -4 addr list eno0 | awk '{print $4}' | cut -d/ -f1):0 rcqls/red-gtk
```

**Rmk**: you can add this in your `.bash_profile`

```{bash}
## for masOS user
alias red-docker="docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(ipconfig getifaddr en0)$(ipconfig getifaddr en2):0 rcqls/red-gtk"
```

and then launch `red-docker` instead.

#### test container

Inside the container,`console-gtk` is the binary to test the `red` console with `Needs: 'View` option activated. You could then try:

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

### Note for linux user

`console-gtk` binary can be downloaded directly [here](https://toltex.u-ga.fr/users/RCqls/Red/console-gtk)
