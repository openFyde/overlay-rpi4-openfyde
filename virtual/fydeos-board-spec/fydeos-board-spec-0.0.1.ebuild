# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

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
  virtual/fydemina
  chromeos-base/auto-expand-partition
  chromeos-base/chromeos-bsp-rpi4-openfyde
"

DEPEND="${RDEPEND}"
