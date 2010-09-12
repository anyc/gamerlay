# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit games cmake-utils subversion

DESCRIPTION="FreeOrion is a free and open source clone of Master Of Orion"
HOMEPAGE="http://www.freeorion.org"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	dev-games/gigi[ogre]
	<dev-lang/python-3
	dev-libs/boost:1.42
	media-gfx/graphviz
	media-libs/freealut
	>=media-libs/libogg-1.1.3
	>=media-libs/libsdl-1.2
	>=media-libs/libvorbis-1.1.2
	media-libs/openal
	sci-physics/bullet
	sys-devel/libtool
	sys-libs/zlib"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

CMAKE_USE_DIR="${S}/FreeOrion"

src_prepare() {
	epatch "${FILESDIR}/fix_graphviz.patch"
	epatch "${FILESDIR}/freeorion-cmake-zlib.patch"
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		-DCMAKE_DOC_DIR=/usr/share/doc/${PF}
		-DCMAKE_MAN_DIR=/usr/share/man
		-DCMAKE_DATA_DIR="${GAMES_DATADIR}"
		$(cmake-utils_use_build debug)
		-DBUILD_RELEASE=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
