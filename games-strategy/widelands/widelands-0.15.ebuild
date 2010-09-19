# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils versionator cmake-utils games

MY_PV=build$(get_version_component_range 2)
MY_P=${PN}-${MY_PV}-src
DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="http://www.widelands.org/"
SRC_URI="http://launchpad.net/${PN}/${MY_PV}/${MY_PV}/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="dev-games/ggz-client-libs
	dev-lang/lua
	media-libs/jpeg
	media-libs/libpng:0
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/tiff"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost"
RDEPEND="${COMMON_DEPEND}
	media-libs/libsdl[video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch

	sed -i \
		-e 's:__ppc__:__PPC__:' src/s2map.cc \
		|| die "sed s2map.cc failed"
}

src_configure() {
	mycmakeargs+=(
		'-DWL_VERSION_STANDARD=true'
		"-DCMAKE_INSTALL_PREFIX=${GAMES_DATADIR}/${PN}"
		"-DWL_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DWL_INSTALL_DATADIR=${GAMES_DATADIR}/${PN}"
		"-DWL_INSTALL_LOCALEDIR=locale"
		"-DWL_INSTALL_BINDIR=${GAMES_BINDIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	newicon pics/wl-ico-128.png ${PN}.png || die
	make_desktop_entry ${PN} Widelands

	dodoc ChangeLog CREDITS || die
	prepgamesdirs
}
