# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
	inherit git-2
	SRC_URI=""
else
	SRC_URI="https://github.com/SupSuper/OpenXcom/tarball/v${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/SupSuper-OpenXcom-1603231 # Last digit - revision
fi

DESCRIPTION="Open-source reimplementation of the original X-Com"
HOMEPAGE="http://openxcom.ninex.info/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=dev-cpp/yaml-cpp-0.2.6
	media-libs/libsdl
	>=media-libs/sdl-gfx-2.0.22
	media-libs/sdl-mixer[timidity]"
DEPEND="${RDEPEND}"

src_compile() {
	cd src
	emake DATADIR="${GAMES_DATADIR}/${PN}/" || die "make failed"
}

src_install() {
	dogamesbin bin/openxcom

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r bin/DATA/*
	dodoc README.txt

	prepgamesdirs
}

pkg_postinst() {
	elog "Copy the data files from X-COM: Enemy Unknown to"
	elog "${GAMES_DATADIR}/${PN}/"
}
