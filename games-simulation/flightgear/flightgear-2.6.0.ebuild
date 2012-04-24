# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games cmake-utils

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="http://mirrors.ibiblio.org/pub/mirrors/flightgear/ftp/Source/${P}.tar.bz2
	ftp://mirrors.ibiblio.org/pub/mirrors/flightgear/ftp/Shared/FlightGear-data-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+jsbsim larcsim subversion uiuc +yasim"

RDEPEND=">=dev-games/openscenegraph-3.0[png]
	>=dev-games/simgear-2.6[subversion=,X]
	media-libs/plib
	sys-fs/udev
	x11-libs/libXmu
	x11-libs/libXi
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
	-DFG_DATA_DIR="${GAMES_DATADIR}"/${PN}
	-DENABLE_FGADMIN=OFF
	-DWITH_FGPANEL=OFF
	$(cmake-utils_use_enable jsbsim)
	$(cmake-utils_use_enable larcsim)
	$(cmake-utils_use subversion ENABLE_LIBSVN)
	$(cmake-utils_use_enable uiuc)
	$(cmake-utils_use_enable yasim)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ../data/*
	newicon icons/fg-16.png ${PN}.png
	make_desktop_entry fgfs "FlightGear"
	prepgamesdirs
}
