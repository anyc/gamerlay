# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games git-2

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
EGIT_COMMIT=3558366d159029149b83945916420531b8e670f1

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl:0
	media-libs/sdl-gfx
	media-libs/sdl-image:0
	media-libs/sdl-mixer
	media-sound/timidity++"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/OpenXcom"

DOCS=( README.txt )

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATADIR=${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/docs/html/*

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND,"
	elog "TERRAIN, UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "${GAMES_DATADIR}/${PN}/data"
}
