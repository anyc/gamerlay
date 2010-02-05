# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/egoboo/egoboo-2.22-r1.ebuild,v 1.3 2007/10/30 06:33:57 mr_bones_ Exp $

inherit eutils flag-o-matic toolchain-funcs games

MY_SRC="${PN}-source-${PV}"
MY_DATA="${PN}-data-${PV}"
DESCRIPTION="A 3d dungeon crawling adventure in the spirit of NetHack"
HOMEPAGE="http://egoboo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz
	mirror://sourceforge/${PN}/${PN}-data-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl"

S="${WORKDIR}"/${MY_SRC}/game/

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp Makefile.unix Makefile
}

src_compile() {
	emake clean || die "emake clean failed"
	emake || die "emake failed"
}

src_install () {
	games_make_wrapper ${PN} ./${PN} "${GAMES_DATADIR}/${PN}"
	insinto "${GAMES_DATADIR}/${PN}"
	doins egoboo
	cd "${WORKDIR}"/"${MY_DATA}"
	dodoc Changelog.txt Readme.txt
	doins -r basicdat/ modules/ players/ setup.txt controls.txt \
		|| die "doins failed"
	# FIXME: this is stupid.  should be patched to run out of GAMES_BINDIR
	fperms 750 "${GAMES_DATADIR}/${PN}/${PN}"
	newicon basicdat/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Egoboo /usr/share/pixmaps/${PN}.bmp

	prepgamesdirs
	# ugly, but the game needs write here.
	cd "${D}${GAMES_DATADIR}/${PN}"
	chmod -R g+w setup.txt controls.txt basicdat players modules
}
