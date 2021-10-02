#!/bin/bash

mode=$1

if [ "$mode" != "backup" ] && [ "$mode" != "restore" ]; then
	echo "./config.sh [backup|restore]"
	exit 1
fi

do_proj()
{
	src=$1
	dst=$2

	# Swap src and dst if restoring.
	if [ "$mode" == "restore" ]; then
		tmp=$src
		src=$dst
		dst=$tmp
	fi

	# Clear old backups.
	rm -rf $dst/.vscode
	mkdir -p $dst/.vscode
	
	# Copy VSCode config.
	cp $src/.vscode/* $dst/.vscode
}

do_proj "../../colorize-satellite-imagery/" "colorize-satellite-imagery"
do_proj "../../libideepcolor" "libideepcolor"

