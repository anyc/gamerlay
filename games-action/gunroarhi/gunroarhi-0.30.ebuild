# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=gr_hi
MY_PV=${PV//./_}

DESCRIPTION="Guns, Guns, Guns! 360-degree gunboat shooter, fork of ABAs 'Gunroar'"
HOMEPAGE="http://www.edit.ne.jp/~otoyan/soft/gr_hi.html"
SRC_URI="http://www.edit.ne.jp/~otoyan/soft/gr_hi/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_prepare(){
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i src/abagames/util/sdl/sound.d \
	-e 's:"\(gr.prf[^"]*\)":"'${GAMES_STATEDIR}'/'${PN}'/\1":g' -i src/abagames/gr/prefmanager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	dodir "${GAMES_STATEDIR}/${PN}" "${GAMES_STATEDIR}/${PN}/replay"
	local statedir="${GAMES_STATEDIR}"/${PN}

	if [ ! -e ${D}"${GAMES_STATEDIR}"/${PN}/gr.prf ]; then
		touch ${D}"${GAMES_STATEDIR}"/${PN}/gr.prf
		chmod ug+rw ${D}"${GAMES_STATEDIR}"/${PN}/gr.prf
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
