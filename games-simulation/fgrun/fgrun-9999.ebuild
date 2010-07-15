# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit games git autotools flag-o-matic

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
EGIT_REPO_URI="git://mapserver.flightgear.org/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

DEPEND="dev-games/simgear
	|| (
		<x11-libs/fltk-1.1.9:1.1[opengl]
		>=x11-libs/fltk-1.1.9:1.1[opengl,threads]
	)
	x11-libs/libXi
	x11-libs/libXmu
	nls? ( virtual/libintl )"

RDEPEND="${DEPEND}
	>=games-simulation/flightgear-1.9.0"

pkg_setup() {
	append-ldflags -Wl,--no-as-needed
}

src_prepare() {
	epatch "${FILESDIR}/${PN}"-1.5.1-fltk.patch
	AT_M4DIR=. eautoreconf
}

src_configure() {
	egamesconf \
	$(use_enable nls) \
	|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS
	prepgamesdirs
}
