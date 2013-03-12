# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/spaz/spaz-1.605.ebuild,v 1.1 2012/09/27 08:17:05 pinkbyte Exp $

EAPI=5

inherit games

DESCRIPTION="Beat Hazard Ultra"
HOMEPAGE="http://www.coldbeamgames.com/"
SRC_URI="${PN}-installer-022613"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"/data

src_unpack() {
	unzip -q "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}/all"
	doins -r all
	doexe all/BeatHazard_Linux2
	newicon SmileLogo.png "${PN}".png
	dodoc Linux.README

	games_make_wrapper "${PN}" "./all/BeatHazard_Linux2" "${dir}" "./all/hge_lib/"
	make_desktop_entry "${PN}" "BeatHazard" "${PN}"

	prepgamesdirs
}
