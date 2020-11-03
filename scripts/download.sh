#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

wget "https://www.robots.ox.ac.uk/~vgg/data/flowers/102/README.txt" -O README.txt

files_url=(
	"https://www.robots.ox.ac.uk/~vgg/data/flowers/102/102flowers.tgz 102flowers.tgz" \
	"https://www.robots.ox.ac.uk/~vgg/data/flowers/102/102segmentations.tgz 102segmentations.tgz" \
	"https://www.robots.ox.ac.uk/~vgg/data/flowers/102/distancematrices102.mat distancematrices102.mat" \
	"https://www.robots.ox.ac.uk/~vgg/data/flowers/102/imagelabels.mat imagelabels.mat" \
	"https://www.robots.ox.ac.uk/~vgg/data/flowers/102/setid.mat setid.mat")

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8
git-annex migrate --fast -c annex.largefiles=anything *

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(git-annex list --fast | grep -o " .*") > md5sums
