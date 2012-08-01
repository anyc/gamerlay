# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

MY_PV="${PV/_/-}"
DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://www.sfml-dev.org/"
SRC_URI="https://github.com/LaurentGomila/SFML/zipball/db1f1b8fa1006ea440b9cbe4a2d61b632109ebb2 -> SFML-${MY_PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/freetype:2
	media-libs/glew
	>=media-libs/libpng-1.4
	media-libs/libsndfile
	media-libs/mesa
	media-libs/openal
	sys-libs/zlib
	virtual/jpeg
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/LaurentGomila-SFML-db1f1b8
