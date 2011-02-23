# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils games git

DESCRIPTION="Open-source reimplementation of the original X-Com"
HOMEPAGE="http://openxcom.ninex.info/"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
#SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-cpp/yaml-cpp
	media-libs/libsdl
	>=media-libs/sdl-gfx-2.0.22
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

S=${WORKDIR}/trunk

src_prepare() {
#	epatch "${FILESDIR}"/Makefile.pkg-config.patch
	sed -i \
		-e "s:\(CXXFLAGS \)=:\1+=:" \
		-e "s:\(LDFLAGS \)=:\1+=:" \
		"${S}"/src/Makefile || die "sed failed"
	sed -i -e "s:\(#define DATA_FOLDER \)\"./DATA/\":\1\"${GAMES_DATADIR}/${PN}/DATA/\":" \
		"${S}"/src/Menu/StartState.cpp || die "sed failed"
}

src_compile() {
	mkdir obj
	cd src
	emake || die "make failed"
}

src_install() {
	dogamesbin bin/openxcom

	insinto "${GAMES_DATADIR}"/${PN}/DATA
	doins -r bin/DATA/*

	dodoc README.txt

	prepgamesdirs
}

pkg_postinst() {
	elog "Copy the data files from X-COM: Enemy Unknown to"
	elog "${GAMES_DATADIR}/${PN}/DATA/"
}
