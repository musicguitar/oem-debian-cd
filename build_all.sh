#!/bin/sh

# Script to build everything possible : sources and binaries for all archs

. CONF.sh

for ARCH in "i386 m68k alpha sparc powerpc"
do
	export ARCH
	echo "Now we're going to build CD for $ARCH !"
	echo " ... cleaning"
	make distclean
	make ${CODENAME}_status
	echo " ... checking your mirror"
	make mirrorcheck
	if [ $? -gt 0 ]; then
		echo "ERROR: Your mirror has a problem, please correct it." >&2
		exit 1
	fi
	echo " ... selecting packages to include"
	make list COMPLETE=1 SIZELIMIT1=576716800
	echo " ... building the images"
	if [ "$ARCH" = "i386" ]; then
		make official_images
	else
		make bin-official_images
		if [ $? -gt 0 ]; then
			echo "ERROR WHILE BUILDING OFFICIAL IMAGES !!" >&2
			echo "I'll try to build a simple (non-bootable) CD" >&2
			make clean
			make installtools
			make bin-images
		fi
	fi
	echo "--------------- `date` ---------------"
done

make imagesums
