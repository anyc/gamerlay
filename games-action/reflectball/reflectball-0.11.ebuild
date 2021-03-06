# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=RefLectBall
MY_PV=${PV//./_}

DESCRIPTION="jumpei isshiki's HelloWorldProject (2006/09/09) "
HOMEPAGE="http://homepage2.nifty.com/isshiki/prog_win_d.html"
SRC_URI="http://isshiki.la.coocan.jp/game/${MY_PN}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/libbulletml"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	epatch "${FILESDIR}"/${P}-fixes.diff
	epatch "${FILESDIR}"/${P}-homedir.diff
	epatch "${FILESDIR}"/${P}-import.diff
	epatch "${FILESDIR}"/${P}-makefile.diff
	mv src/reflection.d src/reflection.d-OFF
	sed -i \
	-e 's:"\(title.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(next.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(gameover.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(edificio.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/main.d \
	-e 's:"\(ref-ball[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(voice_[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(zlock[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
	-e 's:"\(bullets[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/init.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r bullets *.bmp *.ogg *.wav || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
