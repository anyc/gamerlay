# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games

DESCRIPTION="Squirrel Physics (codename JAMP)"
HOMEPAGE="http://perre.noud.ch/jamp/"
SRC_URI="http://perre.noud.ch/jamp/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-image
	dev-libs/box2d
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

src_prepare(){
	epatch ${FILESDIR}/"${P}-ownbox2d.patch"
	sed -e "s:/usr/games:${GAMES_BINDIR}:g" -i Makefile || die "sed failed"
}

src_install() {
	dogamesbin ${PN}
	local datadir="${GAMES_DATADIR}"/"${PN}"
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r images shapes sounds || die
	newicon images/"${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
