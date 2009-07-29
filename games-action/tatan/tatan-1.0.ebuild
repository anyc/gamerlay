# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN=tatan
MY_PV=${PV//./_}

DESCRIPTION="pointing STG by HIZ "
HOMEPAGE="http://http://hizuoka.web.fc2.com/game/tatan/index_en.html"
SRC_URI="http://hizuoka.web.fc2.com/game/tatan/${MY_PN}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/bulletss"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

pkg_setup() {
	games_pkg_setup

	# gcc must be built with "d" USE-FLAG
	if ! built_with_use sys-devel/gcc:4.1 d; then
		ewarn "sys-devel/gcc must be built with d for this package"
		ewarn "to function."
		die "recompile gcc with USE=\"d\""
	fi
	if [ "$(gcc-major-version)" == "4" ] && [ "$(gcc-minor-version)" == "2" ] ; then
		die "gdc doesn't work with sys-devel/gcc-4.2 currently - use 4.1 instead"
	fi
}

src_unpack(){
	unpack ${A}
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(resource/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/import/hell2.d \
	-e 's:"\(image/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/src/br/gamemanager.d \
	-e 's:"\(image/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/src/br/screen.d \
	-e 's:"\(se/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/src/br/sound.d \
	-e 's:"\(voice/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/src/br/sound.d \
	-e 's:"\(music/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tatan/src/br/sound.d \
	-e 's:"\(screenshot.bmp[^"]*\)":"'${GAMES_STATEDIR}'/\1":g' -i tatan/src/br/screen.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r image music voice resource se || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}

