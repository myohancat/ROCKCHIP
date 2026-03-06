DESCRIPTION = "helloworld"
LICENSE = "CLOSED"

TARGET   = "HelloWorld"
DEST_DIR = "/home/root"

DEPENDS = "weston gstreamer1.0 gstreamer1.0-plugins-base"

FILESEXTRAPATHS:prepend := "${THISDIR}:${THISDIR}/..:"

INSANE_SKIP:${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

SRC_URI = "file://${BPN} \
           "

inherit pkgconfig

do_compile() {
   export TOPDIR=${TOPDIR}
   cd ${WORKDIR}/${BPN}
   make
}

do_install() {
    mkdir -p ${D}${DEST_DIR}
    install ${WORKDIR}/${BPN}/out/${TARGET} ${D}${DEST_DIR}
}

FILES:${PN} += "${DEST_DIR}"
