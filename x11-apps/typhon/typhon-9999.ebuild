# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhontyphon-9999.ebuild,v 1.0 2011/01/18 09:21:06 by frostwork Exp $

EAPI="2"

CMAKE_MIN_VERSION=2.8

inherit cmake-utils eutils subversion

ESVN_REPO_URI="http://typhon-launcher.googlecode.com/svn/trunk/"

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/?p=1"
#SRC_URI="http://www.frostworx.de/typhon/${P/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug mmd opencv +xml"

S="${WORKDIR}/${P/_/-}"

RDEPEND="virtual/opengl
	media-libs/libpng
	>=media-libs/libsfml-2.0
	opencv? ( media-libs/opencv )
	sys-libs/zlib
	mmd? ( media-libs/libmmd )
	xml? ( dev-libs/tinyxml )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use xml xml)
		$(cmake-utils_use !mmd NOMMD)
		$(cmake-utils_use !opencv NOCV)		
	)

	cmake-utils_src_configure
}
