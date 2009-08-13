# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools games

DESCRIPTION="PipeWalker - is a clone of the NetWalk game."
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X glut"

DEPEND="glut? ( media-libs/freeglut )"
RDEPEND="${DEPEND}"
src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix path placement
	sed -i \
		-e "s:\$(datadir):${GAMES_DATADIR_BASE}:g" \
		extra/Makefile.am || die "Removing wrong path failed"
	sed -i \
		-e "s:\$(datadir):${GAMES_DATADIR_BASE}:g" \
		Makefile.am || die "Removing wrong path failed"
}

src_compile() {
	eautomake
	egamesconf \
		--disable-dependency-tracking \
		--datadir=${GAMES_DATADIR_BASE} \
		$(use_with X) \
		$(use_with glut)
	emake || die "emake failed"
}
src_install() {
	emake DESTDIR=${D} install || die "install failed"

	prepgamesdirs
}
