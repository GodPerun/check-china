#!/bin/sh

print_help() {
	echo "Usage:"
	echo "	-f|--file-list	- input file list"
	echo "	-o|--output	- output file"
	echo "	-h|--help"
}

download() {

	input_list="$1" #input file list
	log_name="$2" #output log name
	mod_limit="$3" #number of parallel downloads
	start_time=`date +%s`
	IFS=$'\n'

	[ ! -d tmp ] && mkdir tmp
	[ ! -f $log_name ] && echo "url;Beijing;Shenzhen;Inner Mongolia;Heilongjiang Province;Yunnan Province">$log_name

	for line in $(cat $input_list)
	do
		i=$((i+1))
		num=$(($i % $mod_limit))
		web=www.$(echo $line|awk '{print $3}')
		$(curl -s http://www.greatfirewallofchina.org/index.php?siteurl=$web>tmp/web_$num.txt && ./extract.py "tmp/web_$num.txt" "$web">>$log_name )&

		if [ "$num" -eq 0 ]; then
			echo "Wait for $mod_limit downloads."
		wait
		fi
	done
	end_time=`date +%s`
	runtime=$((end_time-start_time))
	echo "Runtime=$runtime s"
}

if [[ "$#" -eq 0 ]]; then
	print_help
	exit
fi

while [[ "$#" -ge 1 ]]
do
	key="$1"

	case $key in
	-p|--parallel-downloads)
	NUMDOWNLOADS="$2"
	shift
	;;
	-f|--file-list)
	FILELIST="$2"
	shift
	;;
	-o|--output)
	OUTPUT="$2"
	shift
	;;
	-h|--help|*)
	echo "aaaaaaa"
	print_help
	exit
	;;
	esac
	shift
done

[ -z "$OUTPUT" ] && OUTPUT=china_censor_$(date +"%y-%m-%d_%H-%M").cvs
[ -z "$FILELIST" ] || [ ! -f "$FILELIST" ]  && echo "Error ! Filelist is required parametr !" && exit
[ -z "$NUMDOWNLOADS" ] && NUMDOWNLOADS=100

echo "output=$OUTPUT"
echo "numbdownloads=$NUMDOWNLOADS"

download $FILELIST $OUTPUT $NUMDOWNLOADS
