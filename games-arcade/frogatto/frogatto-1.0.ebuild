# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-arcade/frogatto/frogatto-1.0.ebuild frostwork Exp $

inherit eutils games flag-o-matic 

EAPI="2"

DESCRIPTION="a frog, and a platform game"
HOMEPAGE="http://frogatto.com/"
SRC_URI="http://www.frogatto.com/files/${P}.tar.bz2"

LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="media-libs/sdl-image
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/glew
	dev-libs/boost
	virtual/opengl
	virtual/glu"

src_prepare(){
	sed -i -e "s/-O2 -fno-inline-functions/${CFLAGS}/" Makefile || die
	sed -i -e "s/-fno-inline-functions//" Makefile || die
	sed -i -e "s/-Wnon-virtual-dtor//" Makefile || die
	sed -i -e "s/-Wreturn-type//" Makefile || die
	sed -i -e "s/-fthreadsafe-statics//" Makefile || die
	sed -i -e "s/ccache//" Makefile || die
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:.\/images/:"${GAMES_DATADIR}"/"${PN}"/images/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:data/:"${GAMES_DATADIR}"/"${PN}"/data/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:music/:"${GAMES_DATADIR}"/"${PN}"/music/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:music_aac/:"${GAMES_DATADIR}"/"${PN}"/music_aac/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:sounds/:"${GAMES_DATADIR}"/"${PN}"/sounds/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:sounds_wav/:"${GAMES_DATADIR}"/"${PN}"/sounds_wav/:g"; done
	for i in `find src -name *.cpp`; do sed -i "$i" -e "s:FreeMono.ttf:"${GAMES_DATADIR}"/"${PN}"/FreeMono.ttf:g"; done
}

src_install() {
	newgamesbin game ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data images music music_aac sounds sounds_wav FreeMono.ttf || die
	newicon images/window-icon.png ${PN}.png
	make_desktop_entry ${PN} 
	prepgamesdirs
}
