# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils games
DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="http://unknown-horizons.org/"

SRC_URI="http://sourceforge.net/projects/unknownhorizons/files/Unknown%20Horizons/2011.1/unknown-horizons-2011.1a.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND="
>=dev-lang/python-2.5[sqlite]
<dev-lang/python-3
dev-python/pyyaml
=games-engines/fife-0.3.1_p3607
dev-python/python-distutils-extra
"

RDEPEND="$DEPEND"

src_compile() {
	cd "unknown-horizons"
	distutils_src_compile
}
src_install() {
	cd "unknown-horizons"
	distutils_src_install
}
