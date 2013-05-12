# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
SRC_URI="https://github.com/SupSuper/OpenXcom/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~dev-cpp/yaml-cpp-0.3.0
	media-libs/libsdl:0
	media-libs/sdl-gfx
	media-libs/sdl-image:0
	media-libs/sdl-mixer
	media-sound/timidity++"
RDEPEND="${DEPEND}"

S="${WORKDIR}/OpenXcom-${PV}"

DOCS=( README.txt )
src_prepare() {
	epatch "${FILESDIR}/${P}_data-install-dir.patch"
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATADIR=${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

#src_install() {
#	cmake-utils_src_install
#	prepgamesdirs
#}

pkg_postinst() {
	games_pkg_postinst
	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, SOUND, TERRAIN"
	elog "UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "${GAMES_DATADIR}/${PN}/data"
}
