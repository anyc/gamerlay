# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools games

DESCRIPTION="PipeWalker - is a clone of the NetWalk game."
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libsdl[opengl]
"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix path placement
	sed -i \
		-e "s:\$(datadir):${GAMES_DATADIR_BASE}:g" \
		extra/Makefile.am || die "Removing wrong path failed"
	sed -i \
		-e "s:\$(datadir):${GAMES_DATADIR_BASE}:g" \
		Makefile.am || die "Removing wrong path failed"
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--datadir=${GAMES_DATADIR_BASE}
}

src_install() {
	emake DESTDIR=${D} install || die "install failed"

	prepgamesdirs
}
