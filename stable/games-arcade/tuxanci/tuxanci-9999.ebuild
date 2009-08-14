# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

[[ ${PV} = 9999* ]] && GIT="git"
EGIT_REPO_URI="git://repo.or.cz/tuxanci.git"

inherit games cmake-utils ${GIT}

DESCRIPTION="Tuxanci is first tux shooter inspired by game Bulanci."
HOMEPAGE="http://www.tuxanci.org/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="http://download.${PN}.org/${P}.tar.bz2"
fi
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated +ipv6 nls opengl +sound"
# alsa is used only when building client

RDEPEND="
	!dedicated? (
		media-libs/fontconfig
		media-libs/libsdl[X,opengl?]
		media-libs/sdl-ttf[X]
		media-libs/sdl-image[png]
		x11-libs/cairo[X,svg]
		sound? (
			media-libs/sdl-mixer[vorbis]
		)
	)
	>=dev-libs/libzip-0.9"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with sound AUDIO)
		$(cmake-utils_use_enable debug)
		$(cmake-utils_use_build dedicated SERVER)
		$(cmake-utils_use_with nls)
		$(cmake-utils_use_with opengl)
		$(cmake-utils_use_enable ipv6)
		$(cmake-utils_use_enable debug)"

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DCMAKE_INSTALL_ICONDIR=${GAMES_DATADIR_BASE}/pixmaps/
		-DCMAKE_INSTALL_DESKTOPDIR=${GAMES_DATADIR_BASE}/applications/
		-DCMAKE_DATA_PATH=${GAMES_DATADIR}
		-DCMAKE_LOCALE_PATH=${GAMES_DATADIR_BASE}/locale/
		-DCMAKE_DOC_PATH=${GAMES_DATADIR_BASE}/doc/${PF}
		-DCMAKE_CONF_PATH=${GAMES_SYSCONFDIR}"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	prepgamesdirs
}
