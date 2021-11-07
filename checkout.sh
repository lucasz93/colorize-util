#!/bin/bash
buildDir=`pwd`/..
cd $buildDir

checkout_branch()
{
	url=$1
	out_dir=$2
	branch=$3

	if [ ! -d $2 ]; then
		git clone $url
		pushd $out_dir
			git checkout $branch
			git submodule update --init --recursive
		popd
	fi
}

checkout_branch "https://github.com/lucasz93/interactive-deep-colorization.git" "interactive-deep-colorization" "master"
checkout_branch "https://github.com/lucasz93/libinteractivedeepcolorization.git" "libinteractivedeepcolorization" "master"
checkout_branch "https://github.com/lucasz93/colorization-pytorch.git" "colorization-pytorch" "master"

