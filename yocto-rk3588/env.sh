ENV_REV="1.00"
ENV_CONF=".env.conf"

ENV_Help ()
{
    clear
    echo ""
    echo "##########################################################################################"
    echo "#"
    echo "#  . ./Env.sh [help|reset]"
    echo "#"
    echo "##########################################################################################"
    echo ""
}

SELECT_Project ()
{
    clear
    echo ""
    echo "    1) rock-5b-plus        core-image-test"
    echo "    2) rock-5b-plus        core-image-qt6"
    echo ""
    echo ""
    echo ""
    printf "choice target board : "

    read BOARD_NAME
	case $BOARD_NAME in
        1)  echo "MACHINE=rock-5b-plus" > $ENV_CONF
            echo "IMAGE=core-image-test" >> $ENV_CONF
            echo "DISTRO=poky" >> $ENV_CONF
            ;;
        2)  echo "MACHINE=rock-5b-plus" > $ENV_CONF
            echo "IMAGE=core-image-qt6" >> $ENV_CONF
            echo "DISTRO=poky" >> $ENV_CONF
            ;;
	    *)  echo ""
			echo "!!! Env configuraion failed. please check the model. !!!"
			echo ""
			return 1
			;;
	esac
	echo "REVISION=$ENV_REV" >> $ENV_CONF

    ENV_Apply
}

ENV_Reset ()
{
    unset MACHINE
    unset IMAGE
    unset DISTRO
    unset YOCTO_DIR
    unset KSRC_DIR
    unset KBUILD_DIR

    unalias cdh    > /dev/null 2>&1
    unalias cdb    > /dev/null 2>&1
    unalias cdi    > /dev/null 2>&1
    unalias cdk    > /dev/null 2>&1
    unalias cdkb   > /dev/null 2>&1
    unalias buildi > /dev/null 2>&1
    unalias buildk > /dev/null 2>&1
    unalias flashi > /dev/null 2>&1
    unalias cdm    > /dev/null 2>&1
}

ENV_Apply ()
{
    . ./$ENV_CONF

    export MACHINE=$MACHINE
    export IMAGE=$IMAGE
    export DISTRO=$DISTRO
    _MACHINE=${MACHINE//"-"/"_"}
    export YOCTO_DIR=`pwd`
    export KSRC_DIR=$YOCTO_DIR/build/tmp/work-shared/$MACHINE/kernel-source

    alias  cdh='cd $YOCTO_DIR'
    alias  cdb='cd $YOCTO_DIR/build'
    alias  cdi='cd $YOCTO_DIR/build/tmp/deploy/images/$MACHINE'
    alias  cdk='cd $KSRC_DIR'
    alias  buildi='cd $YOCTO_DIR/build; bitbake $IMAGE; cd -'
    alias  flashi='$YOCTO_DIR/flash.sh'

    if [ -e $YOCTO_DIR/build/tmp/work/$_MACHINE-$DISTRO-linux/linux-rockchip ]; then
        export KBUILD_DIR=$(cd $YOCTO_DIR/build/tmp/work/$_MACHINE-$DISTRO-linux/linux-rockchip/*; pwd)
        alias  cdkb='cd $KBUILD_DIR'
        alias  buildk='$KBUILD_DIR/temp/run.do_compile'
    else
        alias  cdu='echo "Please build the system first. and source env.sh again"'
    fi

    if [ -e $YOCTO_DIR/build/tmp/work/$_MACHINE-$DISTRO-linux/u-boot-rockchip ]; then
        export UBOOT_DIR=$(cd $YOCTO_DIR/build/tmp/work/$_MACHINE-$DISTRO-linux/u-boot-rockchip/*; pwd)
        alias  cdu='cd $UBOOT_DIR'
    else
        alias  cdu='echo "Please build the system first. and source env.sh again"'
    fi
}

YOCTO_MAKE_LOCAL_CONF ()
{
cat << EOF > conf/local.conf
MACHINE = '$MACHINE'
DISTRO = '$DISTRO'
PACKAGE_CLASSES ?= 'package_rpm'
EXTRA_IMAGE_FEATURES ?= "debug-tweaks"
USER_CLASSES ?= "buildstats"
PATCHRESOLVE = "noop"
BB_DISKMON_DIRS ??= "\\
    STOPTASKS,\${TMPDIR},1G,100K \\
    STOPTASKS,\${DL_DIR},1G,100K \\
    STOPTASKS,\${SSTATE_DIR},1G,100K \\
    STOPTASKS,/tmp,100M,100K \\
    HALT,\${TMPDIR},100M,1K \\
    HALT,\${DL_DIR},100M,1K \\
    HALT,\${SSTATE_DIR},100M,1K \\
    HALT,/tmp,10M,1K"
PACKAGECONFIG:append:pn-qemu-system-native = " sdl"
CONF_VERSION = "2"

INHERIT:append = " rockchip-image"

DISTRO_FEATURES:remove = "vulkan"
DISTRO_FEATURES:remove = "x11"
DISTRO_FEATURES:append = " egl"

#BB_NUMBER_THREADS="10"
#PARALLEL_MAKE = "-j 8"

DL_DIR ?= "\${TOPDIR}/../downloads/"
EOF
}

YOCTO_MAKE_BBLAYER_CONF ()
{
cat << EOF > conf/bblayers.conf
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "\${TOPDIR}"
#BBFILES ?= ""
BSPDIR := "\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}"

BBLAYERS ?= " \\
  \${BSPDIR}/meta-rockchip \\
  \${BSPDIR}/poky/meta \\
  \${BSPDIR}/poky/meta-poky \\
  \${BSPDIR}/poky/meta-yocto-bsp \\
  \${BSPDIR}/meta-openembedded/meta-oe \\
  \${BSPDIR}/meta-openembedded/meta-python \\
  \${BSPDIR}/meta-openembedded/meta-networking \\
  \${BSPDIR}/meta-qt6 \\
"

# My Custom Layer
BBLAYERS += "\${BSPDIR}/meta-my"
EOF
}

# reset
ENV_Reset

# Argument check
if [ $# -eq 0 ]; then
    if [ -f "$ENV_CONF" ]; then
        ENV_Apply
		if [ "x$REVISION" = "x" -o "$REVISION" != "$ENV_REV" ]; then
			SELECT_Project
			if [ $? -eq 1 ]; then
				return
			fi
		fi
    else
        SELECT_Project
		if [ $? -eq 1 ]; then
			return
		fi
    fi
elif [ $# -eq 1 -a "$1" = "reset" ]; then
    echo "$ENV_CONF deleted"
    rm -rf $ENV_CONF
    rm -rf build/conf
    SELECT_Project
	if [ $? -eq 1 ]; then
		return
	fi
else
    ENV_Help
    return
fi

OEROOT=$PWD/poky
. $OEROOT/oe-init-build-env build > /dev/null

grep "$MACHINE" conf/local.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
    YOCTO_MAKE_LOCAL_CONF
fi

grep "meta-medithinq" conf/bblayers.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
    YOCTO_MAKE_BBLAYER_CONF
fi

cat <<EOF

[[[ METASCOPE3D Build ]]]

MACHINE=$MACHINE
IMAGE=$IMAGE
DISTRO=$DISTRO

You can build image
    # bitbake $IMAGE

You can find the image to burn.
    PATH : $YOCTO_DIR/build/tmp/deploy/images/$MACHINE
    FILE : [[ TODO ]]

command:
    cdh    : cd home
    cdb    : cd build
    cdi    : cd image folder
    flashi : flash image
    buildi : build image
EOF
