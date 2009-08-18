# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=vr
MY_PV=${PV//./_}

DESCRIPTION="Guns, Guns, Guns! Inofficial and secret 1st version of gunroar"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/"
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
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/vr/barrage.d \
	-e 's:"\(vr.prf[^"]*\)":"'${GAMES_STATEDIR}'/\1":g' -i src/abagames/vr/prefmanager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r barrage images sounds || die

	if [ ! -e "${GAMES_STATEDIR}"/vr.prf ]
	then
		dodir "${GAMES_STATEDIR}"
		touch ${D}/"${GAMES_STATEDIR}"/vr.prf
	fi
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	chmod ug+rw "${GAMES_STATEDIR}"/vr.prf
}
