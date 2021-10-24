#!/bin/bash
set -e

#===============================================================================
#===============================================================================
rootDir=`pwd`/..
installDir=$MECHSRC_INSTALL

installMessage=NEVER

build_type=$1
shift

case $build_type in
	"Debug" ) ;&
	"MinSizeRel" ) ;&
	"RelWithDebInfo" ) ;&
	"Release" )
		buildType="-DCMAKE_BUILD_TYPE=$build_type"
		;;
	* )
		buildType=""
		;;
esac

debug_info_level="-ggdb3"
#debug_info_level="-pg"

#===============================================================================
#===============================================================================
configure_libidc()
{
	pushd $rootDir/libideepcolor
	mkdir -p build
	cd build

	$HOME/miniconda3/envs/colorize_deps/bin/cmake .. -GNinja   \
	  -DCMAKE_INSTALL_MESSAGE=$installMessage                  \
	  -DCMAKE_INSTALL_PREFIX=$installDir                       \
	  -DCMAKE_PREFIX_PATH="/mechsrc/colorize/libtorch"         \
	  -DCUDA_TOOLKIT_ROOT_DIR="$HOME/miniconda3/envs/colorize_deps/pkgs/cuda-toolkit" \
	  -DDEBUG_INFO_LEVEL="$debug_info_level"                   \
	  -DCMAKE_C_COMPILER_LAUNCHER="/usr/bin/ccache"            \
	  -DCMAKE_CXX_COMPILER_LAUNCHER="/usr/bin/ccache"          \
	  -DCMAKE_CXX_FLAGS="-fuse-ld=lld"                         \
	  $buildType

	popd
}

#===============================================================================
#===============================================================================
for target in "$@"
	do
	case "$target" in
		"libidc" ) configure_libidc "$build_type" ;;
		"all" )
			configure_libidc "$build_type"
			;;
		* ) 
			echo "configure: Unknown target '$build_type'"
			echo "./configure.sh [libidc|all]"
			exit 1
			;;
	esac
done
