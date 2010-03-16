# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

MY_PV=${PV/0_pre/r}

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files."
HOMEPAGE="http://binaries.openttd.org/extra/grfcodec/"
SRC_URI="http://binaries.openttd.org/extra/${PN}/${MY_PV}/${PN}-${MY_PV}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND="app-arch/upx"
RDEPEND="${DEPEND}"

src_prepare() {

	cat > Makefile.local <<-__EOF__
		CC = $(tc-getCC)
		CXX = $(tc-getCXX)
		CFLAGS = ${CFLAGS}
		CXXFLAGS = ${CXXFLAGS}
		LDOPTS = ${LDFLAGS}
		STRIP = :
	__EOF__

	sed -e '/^CFLAGS = /{s:-g::; s:-O[13]::g; s:\$(CFLAGAPP)::; s:=:+=:; p; s:CFLAGS:CXXFLAGS:}' \
		-e '/^CFLAGS += /{p; s:CFLAGS:CXXFLAGS:}' \
		-e '/^CXXFLAGS = /d' \
		-i Makefile || die "sed failed on Makefile"
}

src_compile() {
	emake || die
}

src_install() {
	dobin ${PN} grf{diff,merge} || die "dobin failed"
	dodoc *.txt || die "dodoc failed"
	dodoc Changelog || die "dodoc failed on Changelog"
}