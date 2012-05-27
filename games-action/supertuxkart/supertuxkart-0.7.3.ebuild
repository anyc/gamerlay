# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils games

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="http://supertuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/supertuxkart/SuperTuxKart/${PV}/${P}-src.tar.bz2"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-2.0 CCPL-Sampling-Plus-1.0 public-domain as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug unicode"

RDEPEND=">=dev-games/irrlicht-1.8
	virtual/opengl
	net-libs/enet:1.3
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-irrlicht-fix.patch
	epatch "${FILESDIR}"/${P}-fribidi-cmake.patch
	epatch "${FILESDIR}"/${P}-install-rules-cmake.patch
	# Remove bundled enet library
	sed -i	-e '/add_subdirectory("${STK_SOURCE_DIR}\/enet")/d' \
			-e '/include_directories("${STK_SOURCE_DIR}\/enet\/include")/d' \
			-e '\/src\/enet\/include\/enet/d' \
		CMakeLists.txt || die
	sed -i	-e "s:PREFIX/games/supertuxkart:${GAMES_BINDIR}/${PN}:" \
		data/supertuxkart_desktop.template || die
	# Remove bundled bullet library - still no works
#	sed -i	-e '/add_subdirectory("${STK_SOURCE_DIR}\/bullet")/d' \
#			-e '/include_directories("${STK_SOURCE_DIR}\/bullet\/src")/d' \
#		CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		-DSUPERTUXKART_BINDIR="${GAMES_BINDIR}"
		-DSUPERTUXKART_DATADIR="${GAMES_DATADIR}/${PN}"
		$(cmake-utils_use_use unicode FRIBIDI)
	)
	cmake-utils_src_configure
}

src_install() {
	DOCS="README"
	cmake-utils_src_install
	prepgamesdirs
}
