# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_BRANCH="next"

inherit games cmake-utils git-2

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/flightgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+jsbsim larcsim subversion uiuc +yasim"

RDEPEND=">=dev-games/openscenegraph-3.0[png]
	>=dev-games/simgear-9999[subversion=,X]
	media-libs/plib
	sys-fs/udev
	x11-libs/libXmu
	x11-libs/libXi
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	if use uiuc || use larcsim; then
		mycmakeargs=(-DENABLE_LARCSIM=ON -DENABLE_UIUC_MODEL=ON)
	else
		mycmakeargs=(-DENABLE_LARCSIM=OFF -DENABLE_UIUC_MODEL=OFF)
	fi

	mycmakeargs+=(
	-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
	-DFG_DATA_DIR="${GAMES_DATADIR}"/${PN}-live
	-DENABLE_FGADMIN=OFF
	-DWITH_FGPANEL=OFF
	$(cmake-utils_use_enable jsbsim)
	$(cmake-utils_use subversion ENABLE_LIBSVN)
	$(cmake-utils_use_enable yasim)
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
	elog "FlightGear is now installed, but to run it you"
	elog "have to download fgdata as well, which is expected under"
	elog "${GAMES_DATADIR}/${PN}-live"
	elog
	elog "You can save it anywhere else but then you have to set"
	elog "FG_ROOT to that directory or create an \"--fg-root=\" entry in ~/.fgfsrc"
	elog
	elog "To download fgdata, use"
	elog "\"git clone git://mapserver.flightgear.org/fgdata/ SOMEPATH\"."
	elog
	elog
	elog "Don't forget that before updating FlightGear you will most likely"
	elog "have to update Simgear, too"
}
