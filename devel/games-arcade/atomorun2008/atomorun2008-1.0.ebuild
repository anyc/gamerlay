# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

DESCRIPTION="Matthias Thurau's great OpenGL 3D platform-game Atomorun2008"
HOMEPAGE="http://atomorun2008.whosme.de/"
SRC_URI="http://atomorun2008.whosme.de/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_unpack(){
	unpack ${A}
}

src_prepare(){
	cd "${S}/${PN}-${PV}"
	epatch ${FILESDIR}/"${P}.diff"
	sed -i -e "s:resources/:"${GAMES_DATADIR}"/"${PN}"/resources/:" -i src/sound.d

}

src_compile() {
	cd "${S}/${PN}-${PV}"
	emake || die
}

src_install() {
	cd "${S}/${PN}-${PV}"
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r resources || die

	insinto "${GAMES_SYSCONFDIR}"/"${PN}"
	doins resources/config.cfg || die "doins config.cfg failed"

	newicon "${FILESDIR}"/"${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"
	dodoc README*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
