# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils
DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="http://unknown-horizons.org/"

SRC_URI="https://downloads.sourceforge.net/project/unknownhorizons/Unknown%20Horizons/2010.1/unknown_horizons_2010_1_source.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND="
>=dev-lang/python-2.5[sqlite]
<dev-lang/python-3
dev-python/pyyaml
=games-engines/fife-0.3.1_p3431
dev-python/python-distutils-extra
"

RDEPEND="$DEPEND"

src_compile() {
	cd "UnknownHorizons-2010.1"
	distutils_src_compile
}
src_install() {
	cd "UnknownHorizons-2010.1"
	distutils_src_install
}
