# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN=projectL
MY_PV=${PV//./}

DESCRIPTION="Sword action STG inspired by projectN developed by D.K"
HOMEPAGE="http://www.mb.ccnw.ne.jp/hiz/game/projectL/index_en.html"
SRC_URI="http://www.mb.ccnw.ne.jp/hiz/game/projectL/${MY_PN}_${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/bulletss"
RDEPEND=""

S=${WORKDIR}/${MY_PN}_${MY_PV}

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
	-e 's:"\(se/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i projectL_1001/src/br/gamemanager.d \
	-e 's:"\(music/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i projectL_1001/src/br/gamemanager.d \
	-e 's:"\(se/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i projectL_1001/src/br/sound.d \
	-e 's:"\(voice/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i projectL_1001/src/br/sound.d \
	-e 's:"\(music/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i projectL_1001/src/br/sound.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin projectL

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r music se voice || die

	if [ ! -e "${GAMES_STATEDIR}"/${PN}.prf ]
	then
		dodir "${GAMES_STATEDIR}"
		touch ${D}/"${GAMES_STATEDIR}"/${PN}.prf
	fi
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry projectL ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	chmod ug+rw "${GAMES_STATEDIR}"/${PN}.prf
}
