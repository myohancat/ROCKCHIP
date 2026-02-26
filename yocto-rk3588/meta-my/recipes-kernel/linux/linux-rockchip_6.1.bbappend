FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}_${PV}:"

SRC_URI:append = " \
    file://9000-config-kernel-drivers.cfg \
    file://9001-add-rock-5b-plus-dts.patch \
    file://9999-remove-dwhdmi-tmds-log.patch \
"
