#!/bin/bash

#
# Install miniconda.
#
if [ ! -d "$HOME/miniconda3" ]; then
	cd ~/Downloads
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b
	eval "$(/home/mechsoft/miniconda3/bin/conda shell.bash hook)"
	conda init
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
conda env create -n colorize_deps -f ../libinteractivedeepcolorization/environment.yml --quiet

