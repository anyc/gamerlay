# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games java-pkg-2 versionator

MY_PN=revengeofthetitans
MY_PV=$(delete_all_version_separators)

DESCRIPTION="Defeat the returning Titan horde in a series of epic ground
battles."
HOMEPAGE="http://www.puppygames.net/revenge-of-the-titans/"
SRC_URI="amd64? ( RevengeOfTheTitans-HIB-${MY_PV}-amd64.tar.gz )
	x86? ( RevengeOfTheTitans-HIB-${MY_PV}-i386.tar.gz )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6
	virtual/opengl"
DEPEND=""

RESTRICT="mirror strip"

dir="${GAMES_PREFIX_OPT}/${MY_PN}"
S="${WORKDIR}/${MY_PN}"

src_install() {
	insinto "${dir}"
	doins *.jar || die "doins jar"

	exeinto "${dir}"
	doexe *.so revenge.sh || die "doexe"

	games_make_wrapper ${PN} ./revenge.sh "${dir}" "${dir}"
	doicon revenge.png
	make_desktop_entry ${PN} "Revenge of the Titans" revenge

	prepgamesdirs
}
