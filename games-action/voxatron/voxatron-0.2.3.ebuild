# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="A voxelicious action adventure"
HOMEPAGE="http://www.lexaloffle.com/voxatron.php"
SRC_URI="${PN}_${PV}_i386.tar.gz"
RESTRICT="fetch"

LICENSE="Voxatron"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x86? ( media-libs/libsdl[opengl] )
	amd64? ( app-emulation/emul-linux-x86-sdl )"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto ${dir}
	doins vox.dat
	exeinto ${dir}
	doexe vox
	newicon lexaloffle-vox.png ${PN}.png
	make_desktop_entry ${PN} Voxatron ${PN}
	games_make_wrapper ${PN} ./vox ${dir} ${dir}
	dodoc ${PN}.txt
	prepgamesdirs
}
