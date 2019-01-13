function docker-red {
	compile_args=""		# --args for red-compile
	compile_root=""		# --root for red-compile
	distrib="ubuntu"	# linux distrib of container
	container=""		# container name (default is rcqls/red-gtk-$distrib)
	ifs=""				# to specifiy specific network interface(s)
	debug="false"		# to echo output
	build_folder=""		# build folder containing Dockerfile
	# cmd declaration
	cmd=""	
	
	# get options 
	while true 
	do 
		cmd=$1
		case $cmd in
			-h|--help)
				docker-red-help
				return
			;;
			--echo)
				debug="true"
				shift
				;;
			--root) # --root for red-compile 
				shift
				compile_root="$1"
				shift
			;;
			--dist|--distr|--distrib) # distrib container
				shift
				distrib="$1"
				case $distrib in
					# aliases
					ub)
						distrib="ubuntu"
						;;
					ar|archlinux)
						distrib="arch"
						;;
					ce|cent)
						distrib="centos"
						;;
					al|alp)
						distrib="alpine"
						;;
				esac
				shift
				;;
			--build-dir|--build-folder)
				shift
				build_folder=$1
				if [ "$build_folder" = "local" ]; then build_folder="$HOME/Github/docker-red-gtk/Distribs"; fi
				shift
				;;
			--cont|--container) # or directly the name of the container
				shift
				container=$1
				shift
				;;
			--ifs) # to choose the address to connect DISPLAY
				shift
				ifs="$1"
				shift
				;;
			-*) # argument for red-compile
				compile_args="$compile_args $1"
				case $2 in
					-*) # Nothing to do
					;;
					*)
						shift
						if [ "$1" != "" ];then compile_args="$compile_args $1"; fi
					;;
				esac
				shift
			;;
			*) # cmd is then a command
				if [ "$cmd" = "" ];then cmd="bash"; fi
				break
			;;
		esac
	done

	if [ "$debug" = "true" ]; then 
		echo "<cmd=$cmd|root=$compile_root|args=$compile_args|build_folder=$build_folder>"
	fi

	if [ "$container" = "" ]; then container="rcqls/red-gtk-${distrib}"; fi

	case $cmd in
	bash|repl|exec|run|compile|ls)
		ifaddr=""

		if [ "$ifs" = "" ]; then
			ifs="en0 en1 en2 eno0 eno1 eno2 eth0 eth1 eth2"
		fi

		for if in $ifs;do
			case $OSTYPE in
				darwin*)
					ifaddr=$(ipconfig getifaddr ${if})
				;;
				linux*)
					ifaddr=$(/sbin/ip -o -4 addr list ${if} > /dev/null 2>&1 | awk '{print $4}' | cut -d/ -f1)
				;;
			esac

			if [ "$ifaddr" != "" ];then 
				break
			fi
		done

		if [ $ifaddr = "" ];then
			echo "Error in red-docker: no IP address!"
			return
		fi

		# if compile_args non-empty bash becomes compile
		if [ "$compile_root$compile_args" != "" ];then cmd="compile"; fi

		echo "docker-red $cmd inside container $container connected to DISPLAY ${ifaddr}:0"
		docker_run="docker run --rm  -ti -v ~/:/home/user/work  -v /tmp:/tmp -e DISPLAY=${ifaddr}:0 ${container}"
		if [ "$debug" = "true" ];then echo "run command: ${docker_run}"; fi
		
		redbin_host="${HOME}/.RedGTK"
		redbin_guest="/home/user/work/.RedGTK"

		case $cmd in 
			bash) 
				eval $docker_run
				;;
			repl)
				docker_repl="console-gtk"
				if [ -f "$redbin_host/console-view" ]; then docker_repl="$redbin_guest/console-view"; fi
				eval "$docker_run $docker_repl"
				;;
			ls)
				eval "$docker_run ls $redbin_guest"
				;;
			exec|run)
				shift
				if [ -f "${redbin_host}/$1" ];then 
					eval "$docker_run  ${redbin_guest}/$*"
				else 
					if [ -f "${HOME}/$1" ];then
						eval "$docker_run  $*"
					else 
						echo "Binary file ${HOME}/$1 does not exist..."
					fi
				fi
				;;
			compile)
				shift
				if [ "$compile_args" = "" ]; then compile_args="-r"; fi
				if [ "$compile_root" = "" ]; then compile_root="/home/user/red/red"; fi 
				eval "$docker_run /bin/bash -e /home/user/red/red/red-compile --root $compile_root --args \"$compile_args\" --mv $*" 
				;;
		esac
		;;
	
	build)

		if [ "$build_folder" = "" ]; then build_folder="https://github.com/rcqls/docker-red-gtk.git#:Distribs"; fi

		case $distrib in
		ubuntu)
			build_folder="${build_folder}/Ubuntu"
			;;
		arch)
			build_folder="${build_folder}/Archlinux"
			distrib="arch"
			;;
		centos)
			build_folder="${build_folder}/Centos"
			distrib="centos"
			;;
		alpine)
			build_folder="${build_folder}/Alpine"
			distrib="alpine"
			;;
		esac
		
		echo "Docker red: building image $container from $build_folder..."

		docker build -t $container $build_folder
		;;
	service|services)
		shift
		cmd=$1
		case $cmd in
			start)
				case $OSTYPE in
				darwin*)
					echo "Docker-red: starting socat service"
					open -a Xquartz
					socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" > /dev/null 2>&1 &
					;;
				esac
				;;
			stop)
				case $OSTYPE in
				darwin*)
					echo "Docker-red: trying to stop socat service"
					pkill socat
					;;
				esac
				;;
		esac
		;;
	esac

}

docker-red-help() {
	cat <<- EOF
	usage: docker-red [--root <>] [--dist ubuntu|arch|centos] [-c] [-r] [-u] [exec|run|repl|compile]
	EOF
}