# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit games multilib

#TIMESTAMP="1347958759"

DESCRIPTION="A side-scrolling platformer packed with action, gravity-bending puzzles, space bandits and absurdly powerful astro-mining tools."
HOMEPAGE="http://rochardthegame.com/"

SLOT="0"
LICENSE="Rochard-EULA"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE=""

SRC_URI="x86? ( rochard-linux-20120927_131RC1_Linux32bit-1348771540.tar.gz )
	amd64? ( rochard-linux-20120927_131RC1_Linux64bit-1348771540.tar.gz )"
# They're crazy on new distfiles name, so, I just mask old one
#	amd64? ( rochard-linux-${TIMESTAMP}-${PV//[._-]}-64bit.tar.gz )"

RDEPEND="virtual/opengl
	app-arch/gzip
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
MY_PN=Rochard

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}";
	local bit;

	use x86 && bit=32;
	use amd64 && bit=64;

	S="${WORKDIR}/ROCHARD_LINUX_${bit}_DRMFREE"
	cd "${S}"

	insinto "${dir}"
	doins -r "Rochard_Data"
	exeinto "${dir}"
	doexe "${MY_PN}"

	games_make_wrapper "${PN}" "./${MY_PN}" "${dir}" "${dir}"
	newicon "${FILESDIR}/${MY_PN}.png" "${PN}.png" || die
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"

	dodoc README changelog.txt
	prepgamesdirs
}
