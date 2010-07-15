# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

EGIT_HAS_SUBMODULES=true
inherit games git autotools

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/flightgear.git"
EGIT_BRANCH="next"
EGIT_MASTER="${EGIT_BRANCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-games/openscenegraph
	=dev-games/simgear-9999
	virtual/glut
	x11-libs/libXmu"

DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--enable-osgviewer \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newicon icons/fg-16.png ${PN}.png
	make_desktop_entry fgfs FlightGear /usr/share/pixmaps/${PN}.png
	dodoc AUTHORS ChangeLog NEWS README Thanks
	prepgamesdirs
}
