#!/usr/bin/env bash
linux_acpi() {
    arg=$1
    BAT=$(ls -d /sys/class/power_supply/BAT* | head -1)
    if [ ! -x "$(which acpi 2> /dev/null)" ];then
        case "$arg" in
            status)
                cat $BAT/status
            ;;

            percent)
                cat $BAT/capacity
            ;;

            *)
            ;;
        esac
    else
        case "$arg" in
            status)
                acpi | cut -d: -f2- | cut -d, -f1 | tr -d ' '
            ;;
            percent)
                acpi | cut -d: -f2- | cut -d, -f2 | tr -d '% '
            ;;
            *)
            ;;
        esac
    fi
}
battery_percent()
{
	# Check OS
	case $(uname -s) in
		Linux)
            linux_acpi percent
		;;

		Darwin)
			echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac
}

battery_status()
{
	# Check OS
	case $(uname -s) in
		Linux)
            status=$(linux_acpi status)
		;;

		Darwin)
			status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac

	if [[ "$status" = 'discharging' ]] || [[ "$status" = 'Discharging' ]]; then
		echo ''
	else
	 	echo 'AC '
	fi
}

main()
{
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)
	echo "♥ $bat_stat$bat_perc"
}

#run main driver program
main

