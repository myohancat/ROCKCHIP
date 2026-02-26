SUMMARY = "Image for test image"

IMAGE_FEATURES += "splash package-management ssh-server-dropbear hwcodecs weston"

LICENSE = "MIT"

inherit core-image

QB_MEM = "-m 512"

# Enable Debug feature
#EXTRA_IMAGE_FEATURES:append = " dbg-pkgs tools-debug"
IMAGE_INSTALL:append = " gdb"

IMAGE_INSTALL:append = " wpa-supplicant"
IMAGE_INSTALL:append = " bluez5"

IMAGE_INSTALL:append = " less procps"
IMAGE_INSTALL:append = " util-linux"

IMAGE_INSTALL:append = " file"
IMAGE_INSTALL:append = " ldd"
IMAGE_INSTALL:append = " dtc"
IMAGE_INSTALL:append = " iw"
IMAGE_INSTALL:append = " i2c-tools"
IMAGE_INSTALL:append = " pciutils"
IMAGE_INSTALL:append = " usbutils"
IMAGE_INSTALL:append = " v4l-utils media-ctl"
IMAGE_INSTALL:append = " tcpdump"
IMAGE_INSTALL:append = " libusb1"
IMAGE_INSTALL:append = " dbus"
IMAGE_INSTALL:append = " lrzsz"
IMAGE_INSTALL:append = " tar xz"
IMAGE_INSTALL:append = " libdrm"

IMAGE_INSTALL:append = " gstreamer1.0"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-base"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-good"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-bad"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-bad-kms"
IMAGE_INSTALL:append = " gstreamer1.0-rockchip"
IMAGE_INSTALL:append = " rockchip-librga"
IMAGE_INSTALL:append = " v4l-rkmpp"
IMAGE_INSTALL:append = "${@' rockchip-rkisp-server rockchip-rkisp-iqfiles' if d.getVar('RK_ISP_VERSION') == '1' else ''}"
IMAGE_INSTALL:append = "${@oe.utils.version_less_or_equal('RK_ISP_VERSION', '1', '', ' rockchip-rkaiq-server rockchip-rkaiq-iqfiles', d)}"
