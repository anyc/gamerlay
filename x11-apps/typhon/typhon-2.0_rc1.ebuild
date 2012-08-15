# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhon-2.0-rc1.ebuild,v 1.1 2012/08/15 17:48:23 by frostwork Exp $

EAPI="4"

CMAKE_MIN_VERSION=2.8

inherit cmake-utils eutils

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/?p=1"
SRC_URI="http://www.frostworx.de/typhon/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mmd sfe +p3t"

RDEPEND="virtual/opengl
	dev-libs/tinyxml
	media-libs/libpng
	>=media-libs/libsfml-1.99
	sfe? ( media-libs/sfemovie )
	sys-libs/zlib
	mmd? ( media-libs/libmmd )
	p3t? ( media-libs/libp3t )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use !mmd NOMMD)
	)

	cmake-utils_src_configure
}
