# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=mcd
MY_PV=${PV//./_}

DESCRIPTION="The Physics Centipede Invasion. Smashup waggly shmup, 'Mu-cade'."
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/mcd_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	<dev-games/ode-10.1
	dev-libs/bulletss"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/mcd/barrage.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(mcd.prf[^"]*\)":"'${GAMES_STATEDIR}'/'${PN}'/\1":g' -i src/abagames/mcd/prefmanager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	dodir "${GAMES_STATEDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/replay"

	if [ ! -e ${D}"${GAMES_STATEDIR}"/${PN}/mcd.prf ]; then
		touch ${D}"${GAMES_STATEDIR}"/${PN}/mcd.prf
		chmod ug+rw ${D}"${GAMES_STATEDIR}"/${PN}/mcd.prf
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
