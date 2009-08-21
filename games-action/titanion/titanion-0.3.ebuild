# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=ttn
MY_PV=${PV//./_}

DESCRIPTION="Strike down super high-velocity swooping insects. Fixed shooter in the good old days, 'Titanion'. "
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/ttn_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

src_unpack(){
	unpack ${A}
}

src_prepare(){
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(ttn.prf[^"]*\)":"'${GAMES_STATEDIR}'/'${PN}'/\1":g' -i src/abagames/ttn/preference.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	dodir "${GAMES_STATEDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/replay"
	local statedir="${GAMES_STATEDIR}"/${PN}

	if [ ! -e ${D}"${GAMES_STATEDIR}"/${PN}/ttn.prf ]; then
		touch ${D}"${GAMES_STATEDIR}"/${PN}/ttn.prf
		chmod ug+rw ${D}$"{GAMES_STATEDIR}"/${PN}/ttn.prf
	        fperms 660 ${D}"${GAMES_STATEDIR}"/${PN}/ttn.prf
	fi

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images sounds || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
