# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games

DESCRIPTION="A spaceship simulation real-time rogue-like"
HOMEPAGE="http://www.ftlgame.com/"
SRC_URI="${PN}-linux-${PV}-1350405106.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64 -*"
IUSE=""
RESTRICT="fetch mirror strip"

RDEPEND="media-libs/freetype:2
	media-libs/devil
	media-libs/libpng:0
	media-libs/libsdl
	sys-devel/gcc[cxx]
	sys-libs/zlib"

S=${WORKDIR}/FTL

pkg_nofetch() {
	ewarn "Please download"
	ewarn "	${SRC_URI}"
	ewarn "from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	doins -r data/resources
	doins data/exe_icon.bmp
	exeinto "${GAMES_PREFIX_OPT}/${PN}"
	doexe data/${ARCH}/bin/FTL
	dogameslib data/${ARCH}/lib/libbass{.so,mix.so}

	games_make_wrapper ${PN} ./FTL "${GAMES_PREFIX_OPT}/${PN}"
	make_desktop_entry ${PN} FTL

	dodoc FTL_README.html

	prepgamesdirs
}
