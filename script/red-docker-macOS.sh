function red-docker {
	cmd=$1

	if [ "$cmd" = "" ];then
		cmd="run" 
	fi

	shift

	distrib=""
	if [ "$1" = "" ];then
		distrib="ubuntu"
	else
		distrib="$1"
		case $distrib in
		# aliases
		archlinux)
			distrib="arch"
			;;
		cent)
			distrib="centos"
			;;
		esac
		shift
	fi

	container="rcqls/red-gtk-${distrib}"

	case $cmd in
	run)
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

		echo "red-docker container $container connected to DISPLAY ${ifaddr}:0"

		docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=${ifaddr}:0 ${container}

		;;
	build)

		url="https://github.com/rcqls/docker-red-gtk.git#:Distribs"

		case $distrib in
		ubuntu)
			url="${url}/Ubuntu"
			;;
		arch)
			url="${url}/Archlinux"
			distrib="arch"
			;;
		centos)
			url="${url}/Centos"
			distrib="centos"
			;;
		esac
		docker build -t $container $url
		;;
	start)
		 open -a Xquartz
		 socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
		;;
	stop)
		pkill socat
		;;
	esac

}