# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_BRANCH="next"

inherit games git autotools

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/flightgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-games/openscenegraph-2.9[png]
	=dev-games/simgear-9999
	dev-vcs/subversion
	media-libs/plib
	x11-libs/libXmu
	x11-libs/libXi"
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

pkg_postinst() {
	elog "FlightGear is now installed, but to run the game you will have to"
	elog "download fgdata as well."
	elog "To do this use \"git clone git://mapserver.flightgear.org/fgdata\"."
	elog "You can save fgdata anywhere, but need to set FG_ROOT to that directory or"
	elog "create an --fg-root= entry in ~/.fgfsrc"
}
