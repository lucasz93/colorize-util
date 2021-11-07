#!/bin/bash

sudo apt install ninja-build

#
# Install miniconda.
#
if [ ! -d "$HOME/miniconda3" ]; then
	pushd ~/Downloads
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b
	eval "$(/home/mechsoft/miniconda3/bin/conda shell.bash hook)"
	conda init
	popd
else
	source $HOME/miniconda3/etc/profile.d/conda.sh
fi

#
# Checkout all source code.
#
bash checkout.sh

#
# Setup environment.
#
conda env create -n colorize_deps -f ../libideepcolor/environment.yml --quiet

#
# Build OpenCV with CUDA support.
#
bash install_opencv4.5.0_Jetson.sh

#
# This may break one day. Will need to update environment.yml to keep in sync.
#
pushd ..
wget https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-1.9.1%2Bcu111.zip
gunzip libtorch-cxx11-abi-shared-with-deps-1.9.1%2Bcu111.zip
popd

