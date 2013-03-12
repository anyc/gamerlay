# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/spaz/spaz-1.605.ebuild,v 1.1 2012/09/27 08:17:05 pinkbyte Exp $

EAPI=5

inherit games

DESCRIPTION="Bomberman inspired stealth arcade game"
HOMEPAGE="http://www.galcon.com/dynamitejack/"
SRC_URI="${P}.tgz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/"${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}/bin"
	doins -r data bin
	doexe bin/main
	doicon "${FILESDIR}/${PN}".png
	dodoc LINUX.txt

	games_make_wrapper "${PN}" "./main" "${dir}/bin" "${dir}/bin"
	make_desktop_entry "${PN}" "Dinamite Jack" "${PN}"

	prepgamesdirs
}
