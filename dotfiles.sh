#!/bin/bash


PROFILE_BASE_DIR=$HOME/.dotfiles/profiles

# Link files of a single profile
link_profile() {
    profile=$1
    profile_dir=${PROFILE_BASE_DIR}/$profile
    
    
    if [ ! -d $profile_dir ]; then
    	echo "$profile does not exist"
		exit 1
	else
		echo "Linking files from profile $profile"
	fi

	cd $profile_dir
    OIFS="$IFS"
    IFS=$'\n'
	# Find all files to link
    for file in `find . -type f | cut -c 3- | grep -v "^$"`; do
   		dir=$(dirname "${file}")
		src=`pwd`/$file
		dst_dir=$HOME/$dir
		dst=$HOME/$file
		
		# create folder if not exist
		if [ ! -d "$dst_dir" ]; then
			echo "Creating destination direcory $dst_dir"
			mkdir -p $dst_dir
		fi

		# link file
		echo "Linking $src to $dst"
		if [ -f "${dst}" ] || [ -L "${dst}" ]; then
			difference="$(diff -y $src $dst)"
			if [ "$?" -ne 0 ]; then
				echo "$difference"
				echo "$(basename $dst) already exists (and differs). Override? [y/N]"
				read response
				if [ "$response" == 'y' ] || [ "$response" == 'Y' ] \
					|| [ "$response" == 'yes' ] || [ "$response" == 'Yes' ]; then
					ln -sf $src $dst
				else
					echo "Skipping $file"
				fi
			else
				echo "Skipping $file (no diff)"
			fi
		else
			ln -s $src $dst	
		fi
	done
}

# link profiles
if [ "$1" == "link" ]; then
	shift
	while [ "$1" != "" ]; do
		link_profile $1
		shift
	done
fi 
