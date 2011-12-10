# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games

DESCRIPTION="Dune Legacy is an open source clone of Dune 2."
HOMEPAGE="http://dunelegacy.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

src_install() {
	dogamesbin src/${PN} || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/* || die "doins failed"

	domenu ${PN}.desktop
	doicon ${PN}.png

	prepgamesdirs
}

pkg_postinst() {
	elog "You will need to copy all Dune 2 *.PAK files to ${GAMES_DATADIR}/${PN}"
	elog "For playing in german or french you need additionally GERMAN.PAK"
	elog "or FRENCH.PAK."
}
