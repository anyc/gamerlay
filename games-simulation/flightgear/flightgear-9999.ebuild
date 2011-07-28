# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_BRANCH="next"

inherit games cmake-utils git-2

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/flightgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="subversion"

RDEPEND=">=dev-games/openscenegraph-2.9[png]
	>=dev-games/simgear-9999
	media-libs/plib
	x11-libs/libXmu
	x11-libs/libXi
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
	-DENABLE_FGADMIN=OFF
	-DWITH_FGPANEL=OFF
	$(cmake-utils_use subversion ENABLE_LIBSVN)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon icons/fg-16.png ${PN}.png
	make_desktop_entry fgfs "FlightGear"
	prepgamesdirs
}

pkg_postinst() {
	elog "FlightGear is now installed, but to run the game you will have to"
	elog "download fgdata as well."
	elog "To do this use:"
	elog "\"git clone git://gitorious.org/fg/fgdata.git\"."
	elog "You can save fgdata anywhere, but need to set FG_ROOT to that directory or"
	elog "create an --fg-root= entry in ~/.fgfsrc"
	elog
	elog "Don't forget that before updating FlightGear you will most likely"
	elog "have to update Simgear, too"
}
