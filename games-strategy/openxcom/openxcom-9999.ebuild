# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games subversion

DESCRIPTION="Open-source reimplementation of the original X-Com"
HOMEPAGE="http://openxcom.ninex.info/"
ESVN_REPO_URI="https://openxcom.svn.sourceforge.net/svnroot/openxcom/trunk/"
#SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S="${WORKDIR}/trunk"

src_prepare() {
	sed -i \
		-e "s:\(CXXFLAGS = -Wall \)-O2:\1${CXXFLAGS}:" \
		-e "s:\(LDFLAGS = \):\1${LDFLAGS} :" \
		"${S}"/src/Makefile || die "sed failed"
	sed -i -e "s:\(#define DATA_FOLDER \)\"./DATA/\":\1\"${GAMES_DATADIR}/${PN}/DATA/\":" \
		"${S}"/src/Menu/StartState.cpp || die "sed failed"
}

src_compile() {
	cd src
	emake || die "make failed"
}

src_install() {
	dogamesbin bin/openxcom
	dodir "${GAMES_DATADIR}"/${PN}/DATA
	dodoc README.txt
	elog "Copy the data files from X-COM: Enemy Unknown to"
	elog "${GAMES_DATADIR}/${PN}/DATA/"
	prepgamesdirs
}
