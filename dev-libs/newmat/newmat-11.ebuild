# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="A C++ matrix library"
HOMEPAGE="http://www.robertnz.net/nm_intro.htm"
SRC_URI="http://www.robertnz.net/ftp/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake -f nm_gnu.mak || die "emake failed"
}

src_install() {
	dolib libnewmat.a
	dodir /usr/include/newmat
	insinto /usr/include/newmat
	doins *.h
}
