#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $DIR
rm -rf ./project/
rm -rf ./.Xil/
rm vivado*
cd ./ip/
find . ! -name *.xci -delete
