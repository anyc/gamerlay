# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="A voxelicious action adventure"
HOMEPAGE="http://www.lexaloffle.com/voxatron.php"
SRC_URI="${PN}_${PV}_i386.tar.gz"
RESTRICT="fetch"

LICENSE="Voxatron"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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

src_configure() { :; }

src_compile() { :; }

src_test() { :; }

dir="${GAMES_PREFIX_OPT}/${PN}"

src_install() {
	cd ${PN}
	insinto ${dir}
	doins vox.dat vox.txt
	exeinto ${dir}
	doexe vox
	games_make_wrapper ${PN} ./vox ${dir} ${dir}

	prepgamesdirs
}
