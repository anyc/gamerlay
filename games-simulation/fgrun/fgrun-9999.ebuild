# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games cmake-utils git

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
EGIT_REPO_URI="git://mapserver.flightgear.org/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls"

DEPEND="dev-games/openscenegraph
	>=dev-games/simgear-9999
	x11-libs/fltk:1.1[opengl,threads]
	x11-libs/libXi
	x11-libs/libXmu
	nls? ( virtual/libintl )"

RDEPEND="${DEPEND}
	>=games-simulation/flightgear-9999"

DOCS=(AUTHORS NEWS)

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.5.1-fltk.patch"
}

src_configure() {
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
	$(cmake-utils_use nls ENABLE_NLS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	make_desktop_entry ${PN} "${PN}" flightgear
	prepgamesdirs
}
