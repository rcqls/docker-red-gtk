## red/gtk for (macOS) docker

THis si a quick try to launch `red/gtk` in  

### install

Please, before installing, check that these tools are not yet installed

```{bash}
brew cask install docker # updates are then automatically managed 
brew cask install xquartz
brew install socat
```
### setup

This setup allows any x-application provided by docker containers to launch 

```{bash}
open -a Xquartz
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
```

If you want to stop socat: 

```{bash}
pkill socat
```

### use

```{bash}
docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=$(ipconfig getifaddr en0):0 rcqls/red-gtk
```

### test

Inside the container,`console-gtk` is the binary to test the `red` console with `Needs: 'View` option activated. You could then try:

```{bash}
console-gtk /home/user/red/red/tests/react-test.red
```

or 

```{bash}
console
```

or if `~/titi/toto.red` is a regular `red` file in the host systemfile

```{bash}
console titi/toto.red
``` 

