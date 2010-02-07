# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="sandbox physics game"
HOMEPAGE="http://sourceforge.net/projects/caphgame"
SRC_URI="mirror://sourceforge/caphgame/${PN}-091231/${PN}-src-091231.tar.bz2
	mirror://sourceforge/caphgame/${PN}-091231/${PN}-data-091231.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/libpng
	media-libs/libsdl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:../share/${PN}:${GAMES_DATADIR}/${PN}:" ${PN}-src/src/${PN}.c || die "sed failed"
	sed -i "s:return dir;:return SYS_DATA_DIR;:" ${PN}-src/src/${PN}.c || die "sed failed"
}

src_compile() {
	cd "${PN}-src/src"
	./build || die "build failed"
}

src_install() {
	dogamesbin "caph-src/bin/caph" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"
	doins -r "${PN}-data/share/${PN}" || die "install failed"
	dodoc "${PN}-src/doc/${PN}/README" || die "dodoc failed"
	prepgamesdirs
}
