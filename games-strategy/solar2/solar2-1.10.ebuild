# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/spaz/spaz-1.605.ebuild,v 1.1 2012/09/27 08:17:05 pinkbyte Exp $

EAPI=5

inherit games

DESCRIPTION="Open-world, sandbox game set in an infinite abstract universe."
HOMEPAGE="http://murudai.com/solar/"
SRC_URI="${PN}-linux-${PV}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="multilib"
RESTRICT="fetch strip"

DEPEND=""
RDEPEND="sys-libs/glibc"

REQUIRED_USE="amd64? ( multilib )"

S="${WORKDIR}"/Solar2

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	rm solar2.sh
	doins -r .
	doexe Solar2.bin.x86
	doicon "${FILESDIR}/${PN}.png"

	games_make_wrapper "${PN}" "./Solar2.bin.x86" "${dir}" "./lib"
	make_desktop_entry "${PN}" "Solar 2" "${PN}"

	prepgamesdirs
}
