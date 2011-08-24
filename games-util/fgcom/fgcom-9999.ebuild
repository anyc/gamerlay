# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit subversion

DESCRIPTION="A VoIP client for FlightGear"
HOMEPAGE="http://fgcom.sourceforge.net/"
ESVN_REPO_URI="http://fgcom.svn.sourceforge.net/svnroot/fgcom/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-games/simgear
	media-libs/openal
	media-libs/plib"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-makefile.patch
}

src_compile() {
	cd src
	emake -j1
}

src_install() {
	cd src
	dobin ${PN}
	insinto /usr/share/"${PN}"
	doins ../data/positions.txt
	doins ../data/phonebook.txt
	doins ../data/special_frequencies.txt
}
