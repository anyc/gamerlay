# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit toolchain-funcs

MY_PV=${PV/_rc/-RC}
DESCRIPTION="A tool checking NFO code for errors"
HOMEPAGE="http://dev.openttdcoop.org/projects/nforenum"
SRC_URI="http://binaries.openttd.org/extra/${PN}/${MY_PV}/${PN}-${MY_PV}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}-source

DEPEND="dev-libs/boost
	dev-lang/perl"
RDEPEND=""

src_prepare() {
# workaround upstream workflow by setting CC to the C++ compiler and CFLAGS to ${CXXFLAGS}
# This is actually what they do in Makefile now, we set CC = $(tc-getCC) previously.
	cat > Makefile.local <<-__EOF__
		CC = $(tc-getCXX)
		CXX = $(tc-getCXX)
		CFLAGS = ${CXXFLAGS}
		CXXFLAGS = ${CXXFLAGS}
		LDOPT = ${LDFLAGS}
		STRIP = :
		UPX =
		V = 1
	__EOF__
}

src_install() {
	dobin ${PN} || die
	doman docs/nforenum.1 || die
	dodoc changelog.txt docs/*.en.txt || die
}
