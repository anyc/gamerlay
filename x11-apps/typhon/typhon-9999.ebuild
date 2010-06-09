# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhontyphon-0.90.ebuild,v 1.0 2010/05/19 12:51:12 by frostwork Exp $

EAPI="2"

inherit cmake-utils eutils subversion

ESVN_REPO_URI="http://typhon-launcher.googlecode.com/svn/trunk/"

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/?p=1"
#SRC_URI="http://www.frostworx.de/typhon/${P/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug glut +sound +sysinfo +themes"

S="${WORKDIR}/${P/_/-}"

RDEPEND="media-libs/ftgl
	virtual/opengl
	media-libs/devil
	x11-libs/libXrender
	x11-libs/libXrandr
	glut? ( media-libs/freeglut )
	sound? ( media-libs/sdl-mixer )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0"

src_configure() {
	local mycmakeargs+=(
		$(cmake-utils_use !sound NOSOUND)
		$(cmake-utils_use !glut NOGLUT)
		$(cmake-utils_use !themes NOP3T)
		$(cmake-utils_use !sysinfo NOSYSINFO)
		$(cmake-utils_use debug DEBUG)
	)

	mycmakeargs+=(
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DCMAKE_INSTALL_ICONDIR=/usr/share/pixmaps/"
		"-DCMAKE_INSTALL_DESKTOPDIR=/usr/share/applications/"
		"-DCMAKE_DATA_PATH=/usr/share/"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
