# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

EAPI=2
inherit flag-o-matic toolchain-funcs

DESCRIPTION="a renderlib for mikumiku dance pmd model and vmd motion files"
HOMEPAGE="http://frostworx.de/"
SRC_URI="http://frostworx.de/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="sci-physics/bullet"
DEPEND="${RDEPEND}"

src_install() {
	dolib.so *.so* || die "dolib.so failed"

	insinto /usr/include/mmd
	doins *.h || die "doins failed"
	dodoc README
}
