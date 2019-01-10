function red-docker {
	cmd=$1

	if [ "$cmd" = "" ];then
		cmd="run" 
	fi

	shift
	cmd=$1

	distrib="ubuntu"
	if [ "$cmd" != "" ];then
		distrib="$cmd"
		case $distrib
		# aliases
		archlinux)
			distrib="arch"
			;;
		esac
		shift
		cmd=$1
	fi

	container="rcqls/red-gtk-${distrib}"

	case $cmd
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

		echo "red-docker connected to ${ifaddr}:0"

		docker run --rm  -ti -v ~/:/home/user/work  -e DISPLAY=${ifaddr}:0 ${container}

		;;
	build)
		
		url="https://github.com/rcqls/docker-red-gtk.git#:Distribs"

		case $distrib
		ubuntu)
			url="${url}/Ubuntu"
			;;
		arch)
			url="${url}/Archlinux"
			distrib="arch"
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