# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_BRANCH="next"
EGIT_PROJECT="flightgear.git"

inherit games cmake-utils git-2

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/flightgear.git
		git://mapserver.flightgear.org/flightgear/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug fgpanel +jsbsim oldfdm +subversion test +yasim"

COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.0[png]
	>=dev-games/simgear-9999[subversion?,X]
	sys-libs/zlib
	sys-fs/udev
	virtual/opengl
"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.37
	media-libs/openal
	>=media-libs/plib-1.8.5
	fgpanel? (
		media-libs/freeglut
		media-libs/libpng
	)
	subversion? (
		dev-libs/apr
		dev-vcs/subversion
	)
"

RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DFG_DATA_DIR="${GAMES_DATADIR}"/${PN}-live
		-DENABLE_FGADMIN=OFF
		-DENABLE_PROFILE=OFF
		-DENABLE_RTI=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_SQLITE=ON
		$(cmake-utils_use_with fgpanel)
		$(cmake-utils_use_enable jsbsim)
		$(cmake-utils_use_enable oldfdm LARCSIM)
		$(cmake-utils_use_enable oldfdm UIUC_MODEL)
		$(cmake-utils_use_enable subversion LIBSVN)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use_enable yasim)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon package/${PN}.ico ${PN}.ico
	newmenu package/${PN}.desktop ${PN}.desktop
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
	elog "Don't forget that before updating FlightGear you will most likely"
	elog "have to update Simgear, too"
	elog
	elog
	elog "It is recommended that you install one of the available launchers,"
	elog "as they provide easy access to startup options:"
	elog "* games-simulation/fgx"
	elog "* games-simulation/fgrun"
}
