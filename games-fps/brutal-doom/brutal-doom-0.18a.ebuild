# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games
MY_PV=${PV/./}

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://www.moddb.com/mods/brutal-doom/"
SRC_URI="http://www.moddb.com/downloads/mirror/51150/98/09811e55e4b436312ae8a92d83c286de -> brutalv${MY_PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND="=games-fps/zdoom-9999"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto "${GAMES_DATADIR}/doom-data"
	doins brutalv${MY_PV}.pk3
	dodoc "brutalv${MY_PV} changelog.txt"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "In order to play this mod run zdoom with -file option:"
	elog "    zdoom -file ${GAMES_DATADIR}/doom-data/brutalv${MY_PV}.pk3"
	echo
}
