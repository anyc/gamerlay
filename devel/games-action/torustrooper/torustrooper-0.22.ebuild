# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=tt
MY_PV=${PV//./_}

DESCRIPTION="Speed! More speed! Speeding ship sailing through barrage, 'Torus Trooper'"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/tt_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/bulletss"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/tt/barrage.d \
	-e 's:"\(tt.prf[^"]*\)":"'${GAMES_STATEDIR}'/'${PN}'/\1":g' -i src/abagames/tt/prefmanager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	dodir "${GAMES_STATEDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/replay"
	local statedir="${GAMES_STATEDIR}"/${PN}

	if [ ! -e ${D}"${GAMES_STATEDIR}"/${PN}/tt.prf ]; then
		touch ${D}"${GAMES_STATEDIR}"/${PN}/tt.prf
		chmod ug+rw ${D}"${GAMES_STATEDIR}"/${PN}/tt.prf
	        fperms 660 ${D}"${GAMES_STATEDIR}"/${PN}/tt.prf
	fi

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r barrage images sounds || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
