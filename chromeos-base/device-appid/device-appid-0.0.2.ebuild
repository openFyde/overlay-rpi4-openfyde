# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

EAPI="5"

inherit appid
DESCRIPTION="empty project"
HOMEPAGE="https://fydeos.io"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	doappid "{2FE3DCB3-AF27-4215-A724-3523BB4C0565}" "CHROMEBOX"
}
