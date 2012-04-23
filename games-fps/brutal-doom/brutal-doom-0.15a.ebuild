# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games
MY_PV=${PV/./}

DESCRIPTION="A mod that attempts to make Doom faster placed, harder, gorier and more violent."
HOMEPAGE="http://wadhost.fathax.com/download.php?view.20"
SRC_URI="http://wadhost.fathax.com/e107_files/downloads/BRUTALGZDOOMV${MY_PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO Add USEs for zdoom and skulltag
IUSE=""

RDEPEND="games-fps/zdoom"
DEPEND="app-arch/unzip"

src_install() {
	insinto "${GAMES_DATADIR}/doom-data"
	doins BRUTALGZDOOMV${MY_PV}.pk3
	dodoc *.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "In order to play this mod run zdoom with -file option:"
	elog "    zdoom -file ${GAMES_DATADIR}/doom-data/BRUTALGZDOOMV${MY_PV}.pk3"
	echo
}
