# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

EAPI="5"
inherit udev
DESCRIPTION="drivers, config files for Raspberry Pi 4"
HOMEPAGE="https://fydeos.io"

LICENSE="BSD-Fyde"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
    chromeos-base/device-appid
    chromeos-base/bluetooth-input-fix
    chromeos-base/raspberry-bootloader-update
"

DEPEND="${RDEPEND}"
S=${WORKDIR}

src_install() {
  udev_dorules "${FILESDIR}/udev/10-vchiq-permissions.rules"
  udev_dorules "${FILESDIR}/udev/50-media.rules"
  #insinto /etc/init
  #doins "${FILESDIR}/bt/bluetooth_uart.conf"
  #doins "${FILESDIR}/bt/console-ttyAMA0.override"
  insinto /firmware/rpi
  doins "${FILESDIR}/kernel-config"/*
  exeinto /usr/share/cros/init
  insinto /etc/chromium/policies/managed
  doins ${FILESDIR}/power_policy/power.json
  insinto /etc
  doins ${FILESDIR}/etc/hardware_features.xml
  insinto /etc/swap
  doins ${FILESDIR}/swap/swap_size_mb
  dosym /lib/firmware /etc/firmware
}
