# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhontyphon-9999.ebuild,v 1.0 2011/01/18 09:21:06 by frostwork Exp $

EAPI="2"

CMAKE_MIN_VERSION=2.8

inherit cmake-utils eutils

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/?p=1"
SRC_URI="http://www.frostworx.de/typhon/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ffmpeg glut +sound +xml"

S="${WORKDIR}/${P/_/-}"

RDEPEND="media-libs/ftgl
	virtual/opengl
	media-libs/devil[jpeg,opengl,png]
	x11-libs/libXrender
	x11-libs/libXrandr
	xml? ( dev-libs/tinyxml )
	glut? ( media-libs/freeglut )
	ffmpeg? ( >=virtual/ffmpeg-0.6 )
	sound? ( media-libs/sdl-mixer )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use !sound NOSOUND)
		$(cmake-utils_use !glut NOGLUT)
		$(cmake-utils_use !ffmpeg NOVIDEOPLAYER)
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use xml xml)
	)

	cmake-utils_src_configure
}
