# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
  chromeos-base/baseboard-bsp
  app-editors/nano
  chromeos-base/edit-pi-config
  chromeos-base/auto-expand-partition
  chromeos-base/chromeos-bsp-rpi4-openfyde-base
"

DEPEND="${RDEPEND}"
