#!/bin/bash
#
# Copyright (c) 2020, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#

version="4.5.3"
folder="workspace"

set -e

echo "** Remove other OpenCV first"
sudo sudo apt-get purge *libopencv*


echo "** Install requirement"
sudo apt-get update
sudo apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2
sudo apt-get install -y curl


echo "** Download opencv-"${version}
rm -rf ${folder}
mkdir $folder
cd ${folder}
curl -L https://github.com/opencv/opencv/archive/${version}.zip -o opencv-${version}.zip
curl -L https://github.com/opencv/opencv_contrib/archive/${version}.zip -o opencv_contrib-${version}.zip
unzip opencv-${version}.zip
unzip opencv_contrib-${version}.zip
cd opencv-${version}/

source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate colorize_deps

echo "** Building..."
mkdir release
cd release/
cmake -GNinja                                                             \
    -DWITH_CUDA=ON                                                        \
    -DWITH_CUDNN=ON                                                       \
    -DCUDA_ARCH_BIN="6.1,7.5"                                             \
    -DCUDA_ARCH_PTX=""                                                    \
    -DOPENCV_GENERATE_PKGCONFIG=ON                                        \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${version}/modules   \
    -DWITH_GSTREAMER=ON                                                   \
    -DWITH_LIBV4L=ON                                                      \
    -DBUILD_opencv_python2=ON                                             \
    -DBUILD_opencv_python3=ON                                             \
    -DWITH_PROTOBUF=0                                                     \
    -DBUILD_PROTOBUF=1                                                    \
    -DPROTOBUF_UPDATE_FILES=1                                             \
    -DBUILD_TIFF=ON                                                       \
    -DBUILD_TESTS=OFF                                                     \
    -DBUILD_PERF_TESTS=OFF                                                \
    -DBUILD_EXAMPLES=OFF                                                  \
    -DCMAKE_BUILD_TYPE=RELEASE                                            \
    -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX                                  \
    -DWITH_OPENMP=1                                                       \
    -DCXX_STANDARD=17                                                     \
  ..
ninja -j$(nproc)
sudo ninja install

conda deactivate

echo "** Install opencv-"${version}" successfully"
echo "** Bye :)"
