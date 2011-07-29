# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/supertuxkart/supertuxkart-0.7.ebuild,v 1.5 2011/06/22 12:59:19 tupone Exp $

EAPI=2
inherit autotools flag-o-matic eutils games

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="http://supertuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/supertuxkart/SuperTuxKart/${PV}/${P}-src.tar.bz2"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-2.0 CCPL-Sampling-Plus-1.0 public-domain as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug unicode"

RDEPEND=">=dev-games/irrlicht-1.8
	virtual/opengl
	media-libs/freeglut
	virtual/glu
	net-libs/enet:1.3
	media-libs/libvorbis
	media-libs/openal
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/"${P}".patch
	rm -rf src/enet
	mkdir "${S}"/m4
	eautoreconf
}

src_configure() {
	append-libs -lpng -ljpeg -lbz2

	egamesconf \
		--disable-dependency-tracking \
		--disable-optimization \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
	doicon data/${PN}_64.xpm
	make_desktop_entry ${PN} SuperTuxKart ${PN}_64
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
